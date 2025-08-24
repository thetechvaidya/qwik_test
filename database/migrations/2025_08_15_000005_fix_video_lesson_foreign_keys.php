<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Fix missing foreign keys in videos table
        if (Schema::hasTable('videos') && !$this->foreignKeyExists('videos', 'videos_difficulty_level_id_foreign')) {
            Schema::table('videos', function (Blueprint $table) {
                $table->foreign('difficulty_level_id')->references('id')->on('difficulty_levels')->onDelete('restrict');
            });
        }

        // Fix missing foreign keys in lessons table
        if (Schema::hasTable('lessons') && !$this->foreignKeyExists('lessons', 'lessons_difficulty_level_id_foreign')) {
            Schema::table('lessons', function (Blueprint $table) {
                $table->foreign('difficulty_level_id')->references('id')->on('difficulty_levels')->onDelete('restrict');
            });
        }

        // Create user progress tracking table for videos if it doesn't exist
        if (!Schema::hasTable('user_video_progress')) {
            Schema::create('user_video_progress', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('user_id');
                $table->unsignedBigInteger('video_id');
                $table->integer('watch_time')->default(0); // in seconds
                $table->integer('total_duration')->default(0); // in seconds
                $table->decimal('progress_percentage', 5, 2)->default(0.00); // 0.00 to 100.00
                $table->boolean('is_completed')->default(false);
                $table->timestamp('last_watched_at')->nullable();
                $table->timestamps();

                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
                $table->foreign('video_id')->references('id')->on('videos')->onDelete('cascade');
                $table->unique(['user_id', 'video_id']);
                $table->index(['user_id', 'is_completed']);
                $table->index(['video_id', 'is_completed']);
            });
        }

        // Create user progress tracking table for lessons if it doesn't exist
        if (!Schema::hasTable('user_lesson_progress')) {
            Schema::create('user_lesson_progress', function (Blueprint $table) {
                $table->id();
                $table->unsignedBigInteger('user_id');
                $table->unsignedBigInteger('lesson_id');
                $table->integer('read_time')->default(0); // in seconds
                $table->decimal('progress_percentage', 5, 2)->default(0.00); // 0.00 to 100.00
                $table->boolean('is_completed')->default(false);
                $table->timestamp('last_read_at')->nullable();
                $table->timestamps();

                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
                $table->foreign('lesson_id')->references('id')->on('lessons')->onDelete('cascade');
                $table->unique(['user_id', 'lesson_id']);
                $table->index(['user_id', 'is_completed']);
                $table->index(['lesson_id', 'is_completed']);
            });
        }

        // Add performance indexes for video and lesson tables
        $this->addIndexIfNotExists('videos', 'is_paid');
        $this->addIndexIfNotExists('videos', 'skill_id');
        $this->addIndexIfNotExists('videos', 'topic_id');
        $this->addIndexIfNotExists('lessons', 'is_paid');
        $this->addIndexIfNotExists('lessons', 'skill_id');
        $this->addIndexIfNotExists('lessons', 'topic_id');
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop progress tracking tables
        Schema::dropIfExists('user_video_progress');
        Schema::dropIfExists('user_lesson_progress');

        // Drop foreign keys
        $this->dropForeignKeyIfExists('videos', 'videos_difficulty_level_id_foreign');
        $this->dropForeignKeyIfExists('lessons', 'lessons_difficulty_level_id_foreign');

        // Drop indexes
        $this->dropIndexIfExists('videos', 'videos_is_paid_index');
        $this->dropIndexIfExists('videos', 'videos_skill_id_index');
        $this->dropIndexIfExists('videos', 'videos_topic_id_index');
        $this->dropIndexIfExists('lessons', 'lessons_is_paid_index');
        $this->dropIndexIfExists('lessons', 'lessons_skill_id_index');
        $this->dropIndexIfExists('lessons', 'lessons_topic_id_index');
    }

    /**
     * Check if foreign key exists
     */
    private function foreignKeyExists(string $table, string $foreignKey): bool
    {
        try {
            $foreignKeys = Schema::getConnection()
                ->getDoctrineSchemaManager()
                ->listTableForeignKeys($table);

            foreach ($foreignKeys as $key) {
                if ($key->getName() === $foreignKey) {
                    return true;
                }
            }
        } catch (\Exception $e) {
            return false;
        }

        return false;
    }

    /**
     * Add index if it doesn't exist
     */
    private function addIndexIfNotExists(string $table, string $column): void
    {
        if (Schema::hasTable($table) && Schema::hasColumn($table, $column)) {
            $indexName = $table . '_' . $column . '_index';
            
            if (!$this->indexExists($table, $indexName)) {
                Schema::table($table, function (Blueprint $table) use ($column) {
                    $table->index($column);
                });
            }
        }
    }

    /**
     * Drop index if it exists
     */
    private function dropIndexIfExists(string $table, string $indexName): void
    {
        if (Schema::hasTable($table) && $this->indexExists($table, $indexName)) {
            Schema::table($table, function (Blueprint $table) use ($indexName) {
                $table->dropIndex($indexName);
            });
        }
    }

    /**
     * Drop foreign key if it exists
     */
    private function dropForeignKeyIfExists(string $table, string $foreignKey): void
    {
        if (Schema::hasTable($table) && $this->foreignKeyExists($table, $foreignKey)) {
            Schema::table($table, function (Blueprint $table) use ($foreignKey) {
                $table->dropForeign($foreignKey);
            });
        }
    }

    /**
     * Check if index exists
     */
    private function indexExists(string $table, string $indexName): bool
    {
        try {
            $indexes = Schema::getConnection()
                ->getDoctrineSchemaManager()
                ->listTableIndexes($table);

            return array_key_exists($indexName, $indexes);
        } catch (\Exception $e) {
            return false;
        }
    }
};