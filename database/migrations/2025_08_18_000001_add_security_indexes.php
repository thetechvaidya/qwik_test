<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        // 1. Add Security Indexes
        Schema::table('users', function (Blueprint $table) {
            if (!$this->indexExists('users', 'users_remember_token_index')) {
                $table->index('remember_token');
            }
        });

        Schema::table('sessions', function (Blueprint $table) {
            if (!$this->indexExists('sessions', 'sessions_user_id_index')) {
                $table->index('user_id');
            }
        });

        // 2. Add Performance Indexes
        Schema::table('payments', function (Blueprint $table) {
            if (!$this->indexExists('payments', 'payments_status_index')) {
                $table->index('status');
            }
            if (!$this->indexExists('payments', 'payments_created_at_index')) {
                $table->index('created_at');
            }
        });

        Schema::table('questions', function (Blueprint $table) {
            if (Schema::hasColumn('questions', 'published_at')) {
                if (!$this->indexExists('questions', 'questions_published_at_index')) {
                    $table->index('published_at');
                }
            }
        });

        // 3. Add Composite Indexes
        Schema::table('model_has_permissions', function (Blueprint $table) {
            if (!$this->indexExists('model_has_permissions', 'model_has_permissions_model_id_model_type_index')) {
                $table->index(['model_id', 'model_type']);
            }
        });

        Schema::table('payments', function (Blueprint $table) {
            if (!$this->indexExists('payments', 'payments_user_id_status_index')) {
                $table->index(['user_id', 'status']);
            }
        });

        // 4. Add Foreign Key Indexes (only if they don't exist)
        Schema::table('payments', function (Blueprint $table) {
            if (!$this->foreignKeyExists('payments', 'payments_user_id_foreign')) {
                $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
            }
        });

        Schema::table('questions', function (Blueprint $table) {
            if (Schema::hasColumn('questions', 'user_id') && !$this->foreignKeyExists('questions', 'questions_user_id_foreign')) {
                $table->foreign('user_id')->references('id')->on('users')->onDelete('set null');
            }
        });

        // 5. Add Unique Constraints
        Schema::table('users', function (Blueprint $table) {
            if (!$this->indexExists('users', 'users_email_unique')) {
                $table->unique('email');
            }
        });

        Schema::table('categories', function (Blueprint $table) {
            if (!$this->indexExists('categories', 'categories_slug_unique')) {
                $table->unique('slug');
            }
        });

        // 6. Add Audit Indexes
        if (Schema::hasTable('audits')) {
            Schema::table('audits', function (Blueprint $table) {
                $table->index(['user_id', 'user_type']);
                $table->index(['auditable_id', 'auditable_type']);
            });
        }
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropIndex(['remember_token']);
            $table->dropUnique(['email']);
        });

        Schema::table('sessions', function (Blueprint $table) {
            $table->dropIndex(['user_id']);
        });

        Schema::table('payments', function (Blueprint $table) {
            $table->dropIndex(['status']);
            $table->dropIndex(['created_at']);
            $table->dropIndex(['user_id', 'status']);
            $table->dropForeign(['user_id']);
        });

        Schema::table('questions', function (Blueprint $table) {
            $table->dropIndex(['published_at']);
             if (Schema::hasColumn('questions', 'user_id')) {
                $table->dropForeign(['user_id']);
            }
        });

        Schema::table('model_has_permissions', function (Blueprint $table) {
            $table->dropIndex(['model_id', 'model_type']);
        });

        Schema::table('categories', function (Blueprint $table) {
            $table->dropUnique(['slug']);
        });

        Schema::table('audits', function (Blueprint $table) {
            $table->dropIndex(['user_id', 'user_type']);
            $table->dropIndex(['auditable_id', 'auditable_type']);
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

    private function foreignKeyExists(string $table, string $foreignKey): bool
    {
        try {
            $connection = Schema::getConnection();
            $database = $connection->getDatabaseName();
            
            $constraints = $connection->select("
                SELECT CONSTRAINT_NAME 
                FROM INFORMATION_SCHEMA.KEY_COLUMN_USAGE 
                WHERE TABLE_SCHEMA = ? AND TABLE_NAME = ? AND CONSTRAINT_NAME = ?
            ", [$database, $table, $foreignKey]);

            return count($constraints) > 0;
        } catch (\Exception $e) {
            // If we can't check, assume it doesn't exist
            return false;
        }
    }
};