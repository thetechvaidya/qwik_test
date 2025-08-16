<?php

namespace App\Services;

use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Spatie\MediaLibrary\MediaCollections\Models\Media;
use Spatie\MediaLibrary\HasMedia;

/**
 * Backward compatibility service for transitioning from alexusmai/laravel-file-manager
 * to spatie/laravel-medialibrary
 */
class FileManagerCompatibilityService
{
    /**
     * Upload file using old file manager API pattern
     * Provides backward compatibility during transition
     */
    public function uploadFile(UploadedFile $file, string $folder = 'uploads', ?HasMedia $model = null): array
    {
        try {
            if ($model) {
                // Use Media Library for model-attached files
                $media = $model->addMediaFromRequest('file')
                    ->toMediaCollection($folder);

                return [
                    'success' => true,
                    'file' => [
                        'id' => $media->id,
                        'name' => $media->name,
                        'url' => $media->getUrl(),
                        'size' => $media->size,
                        'type' => $media->mime_type,
                        'path' => $media->getPath(),
                        'collection' => $media->collection_name,
                    ]
                ];
            } else {
                // Fallback to direct storage for non-model files
                $path = $file->store($folder, 'public');

                return [
                    'success' => true,
                    'file' => [
                        'name' => $file->getClientOriginalName(),
                        'url' => Storage::disk('public')->url($path),
                        'size' => $file->getSize(),
                        'type' => $file->getMimeType(),
                        'path' => $path,
                        'collection' => $folder,
                    ]
                ];
            }
        } catch (\Exception $e) {
            return [
                'success' => false,
                'error' => $e->getMessage(),
            ];
        }
    }

    /**
     * Delete file using old file manager API pattern
     */
    public function deleteFile(string $path): array
    {
        try {
            // Try to find and delete from Media Library first
            $media = Media::where('file_name', basename($path))
                ->orWhere('id', $path)
                ->first();

            if ($media) {
                $media->delete();
                return ['success' => true, 'message' => 'File deleted from media library'];
            }

            // Fallback to direct storage deletion
            if (Storage::disk('public')->exists($path)) {
                Storage::disk('public')->delete($path);
                return ['success' => true, 'message' => 'File deleted from storage'];
            }

            return ['success' => false, 'error' => 'File not found'];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Create directory using old file manager API pattern
     */
    public function createDirectory(string $path, string $name): array
    {
        try {
            $fullPath = $path . '/' . $name;
            Storage::disk('public')->makeDirectory($fullPath);

            return [
                'success' => true,
                'directory' => [
                    'name' => $name,
                    'path' => $fullPath,
                    'type' => 'directory',
                    'created_at' => now()->toISOString(),
                ]
            ];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Rename file using old file manager API pattern
     */
    public function renameFile(string $oldPath, string $newName): array
    {
        try {
            $directory = dirname($oldPath);
            $extension = pathinfo($oldPath, PATHINFO_EXTENSION);
            $newPath = $directory . '/' . $newName . ($extension ? '.' . $extension : '');

            // Try Media Library first
            $media = Media::where('file_name', basename($oldPath))->first();
            if ($media) {
                $media->update(['name' => $newName, 'file_name' => basename($newPath)]);
                return ['success' => true, 'new_path' => $newPath];
            }

            // Fallback to storage
            if (Storage::disk('public')->exists($oldPath)) {
                Storage::disk('public')->move($oldPath, $newPath);
                return ['success' => true, 'new_path' => $newPath];
            }

            return ['success' => false, 'error' => 'File not found'];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Move file using old file manager API pattern
     */
    public function moveFile(string $sourcePath, string $destinationPath): array
    {
        try {
            // Try Media Library first
            $media = Media::where('file_name', basename($sourcePath))->first();
            if ($media) {
                // Update media record with new path information
                $media->update([
                    'custom_properties' => array_merge(
                        $media->custom_properties ?? [],
                        ['moved_to' => $destinationPath, 'moved_at' => now()->toISOString()]
                    )
                ]);
                return ['success' => true, 'new_path' => $destinationPath];
            }

            // Fallback to storage
            if (Storage::disk('public')->exists($sourcePath)) {
                Storage::disk('public')->move($sourcePath, $destinationPath);
                return ['success' => true, 'new_path' => $destinationPath];
            }

            return ['success' => false, 'error' => 'File not found'];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Copy file using old file manager API pattern
     */
    public function copyFile(string $sourcePath, string $destinationPath): array
    {
        try {
            // Try Media Library first
            $media = Media::where('file_name', basename($sourcePath))->first();
            if ($media) {
                // Create a copy of the media record
                $newMedia = $media->replicate();
                $newMedia->file_name = basename($destinationPath);
                $newMedia->custom_properties = array_merge(
                    $media->custom_properties ?? [],
                    ['copied_from' => $sourcePath, 'copied_at' => now()->toISOString()]
                );
                $newMedia->save();

                return ['success' => true, 'new_path' => $destinationPath];
            }

            // Fallback to storage
            if (Storage::disk('public')->exists($sourcePath)) {
                Storage::disk('public')->copy($sourcePath, $destinationPath);
                return ['success' => true, 'new_path' => $destinationPath];
            }

            return ['success' => false, 'error' => 'File not found'];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Browse directory using old file manager API pattern
     */
    public function browseDirectory(string $path = ''): array
    {
        try {
            $directories = [];
            $files = [];

            // Get directories from storage
            $storageDirs = Storage::disk('public')->directories($path);
            foreach ($storageDirs as $dir) {
                $directories[] = [
                    'name' => basename($dir),
                    'path' => $dir,
                    'type' => 'directory',
                    'created_at' => Storage::disk('public')->lastModified($dir),
                ];
            }

            // Get files from storage
            $storageFiles = Storage::disk('public')->files($path);
            foreach ($storageFiles as $file) {
                $files[] = [
                    'name' => basename($file),
                    'path' => $file,
                    'size' => Storage::disk('public')->size($file),
                    'type' => Storage::disk('public')->mimeType($file) ?? 'application/octet-stream',
                    'modified_at' => Storage::disk('public')->lastModified($file),
                    'url' => Storage::disk('public')->url($file),
                ];
            }

            // Also include media library files that match the path
            $mediaFiles = Media::where('collection_name', 'like', '%' . basename($path) . '%')
                ->orWhere('file_name', 'like', $path . '%')
                ->get();

            foreach ($mediaFiles as $media) {
                $files[] = [
                    'id' => $media->id,
                    'name' => $media->file_name,
                    'path' => $media->getPath(),
                    'size' => $media->size,
                    'type' => $media->mime_type,
                    'modified_at' => $media->updated_at->timestamp,
                    'url' => $media->getUrl(),
                    'collection' => $media->collection_name,
                ];
            }

            return [
                'success' => true,
                'directories' => $directories,
                'files' => $files,
            ];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Search files using old file manager API pattern
     */
    public function searchFiles(string $query): array
    {
        try {
            $files = [];

            // Search in Media Library
            $mediaFiles = Media::where('name', 'like', '%' . $query . '%')
                ->orWhere('file_name', 'like', '%' . $query . '%')
                ->get();

            foreach ($mediaFiles as $media) {
                $files[] = [
                    'id' => $media->id,
                    'name' => $media->file_name,
                    'path' => $media->getPath(),
                    'size' => $media->size,
                    'type' => $media->mime_type,
                    'url' => $media->getUrl(),
                    'collection' => $media->collection_name,
                ];
            }

            return [
                'success' => true,
                'files' => $files,
            ];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }

    /**
     * Get file info using old file manager API pattern
     */
    public function getFileInfo(string $path): array
    {
        try {
            // Try Media Library first
            $media = Media::where('file_name', basename($path))
                ->orWhere('id', $path)
                ->first();

            if ($media) {
                return [
                    'success' => true,
                    'file' => [
                        'id' => $media->id,
                        'name' => $media->file_name,
                        'path' => $media->getPath(),
                        'size' => $media->size,
                        'type' => $media->mime_type,
                        'url' => $media->getUrl(),
                        'collection' => $media->collection_name,
                        'created_at' => $media->created_at->toISOString(),
                        'updated_at' => $media->updated_at->toISOString(),
                    ]
                ];
            }

            // Fallback to storage
            if (Storage::disk('public')->exists($path)) {
                return [
                    'success' => true,
                    'file' => [
                        'name' => basename($path),
                        'path' => $path,
                        'size' => Storage::disk('public')->size($path),
                        'type' => Storage::disk('public')->mimeType($path),
                        'url' => Storage::disk('public')->url($path),
                        'modified_at' => Storage::disk('public')->lastModified($path),
                    ]
                ];
            }

            return ['success' => false, 'error' => 'File not found'];
        } catch (\Exception $e) {
            return ['success' => false, 'error' => $e->getMessage()];
        }
    }
}
