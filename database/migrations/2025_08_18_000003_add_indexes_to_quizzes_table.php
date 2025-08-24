<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class AddIndexesToQuizzesTable extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('quizzes', function (Blueprint $table) {
            if (Schema::hasColumn('quizzes', 'quiz_type_id') && !$this->indexExists('quizzes', 'quizzes_quiz_type_id_index')) {
                $table->index('quiz_type_id');
            }
            if (Schema::hasColumn('quizzes', 'sub_category_id') && !$this->indexExists('quizzes', 'quizzes_sub_category_id_index')) {
                $table->index('sub_category_id');
            }
            if (Schema::hasColumn('quizzes', 'difficulty_level_id') && !$this->indexExists('quizzes', 'quizzes_difficulty_level_id_index')) {
                $table->index('difficulty_level_id');
            }
            if (Schema::hasColumn('quizzes', 'is_paid') && !$this->indexExists('quizzes', 'quizzes_is_paid_index')) {
                $table->index('is_paid');
            }
            if (Schema::hasColumn('quizzes', 'is_active') && !$this->indexExists('quizzes', 'quizzes_is_active_index')) {
                $table->index('is_active');
            }
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('quizzes', function (Blueprint $table) {
            $table->dropIndex(['quiz_type_id']);
            $table->dropIndex(['sub_category_id']);
            $table->dropIndex(['difficulty_level_id']);
            $table->dropIndex(['is_paid']);
            $table->dropIndex(['is_active']);
        });
    }

    private function indexExists(string $table, string $indexName): bool
    {
        try {
            // For MySQL/MariaDB
            $connection = Schema::getConnection();
            $database = $connection->getDatabaseName();
            
            $indexes = $connection->select("
                SELECT INDEX_NAME 
                FROM INFORMATION_SCHEMA.STATISTICS 
                WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND INDEX_NAME = ?
            ", [$database, $table, $indexName]);

            return count($indexes) > 0;
        } catch (\Exception $e) {
            // If we can't check, assume it doesn't exist
            return false;
        }
    }
}