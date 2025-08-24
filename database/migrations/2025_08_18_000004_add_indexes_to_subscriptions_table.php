<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('subscriptions', function (Blueprint $table) {
            if (Schema::hasColumn('subscriptions', 'user_id') && !$this->indexExists('subscriptions', 'subscriptions_user_id_index')) {
                $table->index('user_id');
            }
            if (Schema::hasColumn('subscriptions', 'plan_id') && !$this->indexExists('subscriptions', 'subscriptions_plan_id_index')) {
                $table->index('plan_id');
            }
            if (Schema::hasColumn('subscriptions', 'status') && !$this->indexExists('subscriptions', 'subscriptions_status_index')) {
                $table->index('status');
            }
            if (Schema::hasColumn('subscriptions', 'ends_at') && !$this->indexExists('subscriptions', 'subscriptions_ends_at_index')) {
                $table->index('ends_at');
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
        Schema::table('subscriptions', function (Blueprint $table) {
            $table->dropIndex(['user_id']);
            $table->dropIndex(['plan_id']);
            $table->dropIndex(['status']);
            $table->dropIndex(['ends_at']);
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
};