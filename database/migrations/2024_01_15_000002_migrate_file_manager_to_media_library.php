<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Spatie\MediaLibrary\MediaCollections\Models\Media;

return new class extends Migration
{
    public function up()
    {
        // Check if old file manager tables exist
        if (Schema::hasTable('file_manager_files')) {
            $this->migrateExistingFiles();
        }

        // Create backup table for rollback capability
        if (!Schema::hasTable('file_manager_backup')) {
            Schema::create('file_manager_backup', function (Blueprint $table) {
                $table->id();
                $table->string('original_path');
                $table->string('new_media_id')->nullable();
                $table->json('original_data');
                $table->timestamp('migrated_at');
                $table->timestamps();
            });
        }
    }

    public function down()
    {
        // Restore from backup if needed
        if (Schema::hasTable('file_manager_backup')) {
            $this->restoreFromBackup();
            Schema::dropIfExists('file_manager_backup');
        }
    }

    private function migrateExistingFiles()
    {
        $oldFiles = DB::table('file_manager_files')->get();

        foreach ($oldFiles as $oldFile) {
            try {
                // Create backup record
                DB::table('file_manager_backup')->insert([
                    'original_path' => $oldFile->path ?? '',
                    'original_data' => json_encode($oldFile),
                    'migrated_at' => now(),
                    'created_at' => now(),
                    'updated_at' => now(),
                ]);

                // Skip if file doesn't exist on storage
                if (!Storage::disk($oldFile->disk ?? 'public')->exists($oldFile->path ?? '')) {
                    continue;
                }

                // Determine the model type and ID from the file path or metadata
                $modelType = $this->determineModelType($oldFile);
                $modelId = $this->determineModelId($oldFile);

                if ($modelType && $modelId) {
                    // Create new media record
                    $media = new Media([
                        'model_type' => $modelType,
                        'model_id' => $modelId,
                        'uuid' => \Illuminate\Support\Str::uuid(),
                        'collection_name' => $this->determineCollectionName($oldFile),
                        'name' => $oldFile->name ?? pathinfo($oldFile->path ?? '', PATHINFO_FILENAME),
                        'file_name' => basename($oldFile->path ?? ''),
                        'mime_type' => $oldFile->mime_type ?? 'application/octet-stream',
                        'disk' => $oldFile->disk ?? 'public',
                        'size' => $oldFile->size ?? 0,
                        'manipulations' => '[]',
                        'custom_properties' => json_encode([
                            'original_file_manager_id' => $oldFile->id,
                            'migrated_from' => 'file_manager',
                            'migration_date' => now()->toISOString(),
                        ]),
                        'generated_conversions' => '[]',
                        'responsive_images' => '[]',
                        'order_column' => $oldFile->order ?? 1,
                    ]);

                    $media->save();

                    // Update backup with new media ID
                    DB::table('file_manager_backup')
                        ->where('original_path', $oldFile->path ?? '')
                        ->update(['new_media_id' => $media->id]);
                }
            } catch (\Exception $e) {
                // Log error but continue migration
                \Log::error('Failed to migrate file: ' . ($oldFile->path ?? 'unknown'), [
                    'error' => $e->getMessage(),
                    'file_data' => $oldFile,
                ]);
            }
        }
    }

    private function restoreFromBackup()
    {
        $backupRecords = DB::table('file_manager_backup')->get();

        foreach ($backupRecords as $backup) {
            try {
                if ($backup->new_media_id) {
                    // Remove the migrated media record
                    Media::find($backup->new_media_id)?->delete();
                }

                // Restore original file manager record if table exists
                if (Schema::hasTable('file_manager_files')) {
                    $originalData = json_decode($backup->original_data, true);
                    DB::table('file_manager_files')->insert($originalData);
                }
            } catch (\Exception $e) {
                \Log::error('Failed to restore backup: ' . $backup->original_path, [
                    'error' => $e->getMessage(),
                ]);
            }
        }
    }

    private function determineModelType($oldFile)
    {
        // Logic to determine model type based on file path or metadata
        $path = $oldFile->path ?? '';

        if (strpos($path, 'exams/') !== false) {
            return 'App\\Models\\Exam';
        }
        if (strpos($path, 'questions/') !== false) {
            return 'App\\Models\\Question';
        }
        if (strpos($path, 'users/') !== false) {
            return 'App\\Models\\User';
        }
        if (strpos($path, 'categories/') !== false) {
            return 'App\\Models\\Category';
        }

        // Default to a generic file model if no specific model is determined
        return 'App\\Models\\File';
    }

    private function determineModelId($oldFile)
    {
        // Logic to extract model ID from file path or metadata
        $path = $oldFile->path ?? '';
        
        // Try to extract ID from path pattern like 'exams/123/image.jpg'
        if (preg_match('/\/([\d]+)\//', $path, $matches)) {
            return (int) $matches[1];
        }

        // If no ID found in path, return 1 as default (could be a global file)
        return 1;
    }

    private function determineCollectionName($oldFile)
    {
        $path = $oldFile->path ?? '';
        $mimeType = $oldFile->mime_type ?? '';

        if (strpos($mimeType, 'image/') === 0) {
            return 'images';
        }
        if (strpos($mimeType, 'video/') === 0) {
            return 'videos';
        }
        if (strpos($mimeType, 'audio/') === 0) {
            return 'audio';
        }
        if (in_array($mimeType, ['application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'])) {
            return 'documents';
        }

        // Determine by path
        if (strpos($path, 'attachments/') !== false) {
            return 'attachments';
        }
        if (strpos($path, 'uploads/') !== false) {
            return 'uploads';
        }

        return 'default';
    }
};
