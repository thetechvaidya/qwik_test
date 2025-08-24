<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        // Fix missing foreign keys in payments table
        // if (Schema::hasTable('payments') && !$this->foreignKeyExists('payments', 'payments_plan_id_foreign')) {
        //     Schema::table('payments', function (Blueprint $table) {
        //         $table->foreign('plan_id')->references('id')->on('plans')->onDelete('restrict');
        //     });
        // }

        // Fix missing foreign keys in subscriptions table
        if (Schema::hasTable('subscriptions')) {
            // if (!$this->foreignKeyExists('subscriptions', 'subscriptions_plan_id_foreign')) {
            //     Schema::table('subscriptions', function (Blueprint $table) {
            //         $table->foreign('plan_id')->references('id')->on('plans')->onDelete('restrict');
            //     });
            // }

            // if (!$this->foreignKeyExists('subscriptions', 'subscriptions_payment_id_foreign')) {
            //     Schema::table('subscriptions', function (Blueprint $table) {
            //         $table->foreign('payment_id')->references('id')->on('payments')->onDelete('set null');
            //     });
            // }
        }

        // Add missing indexes for better performance
        $this->addIndexIfNotExists('payments', 'payment_date');
        $this->addIndexIfNotExists('payments', 'payment_processor');
        $this->addIndexIfNotExists('subscriptions', 'starts_at');
        $this->addIndexIfNotExists('subscriptions', 'ends_at');
        $this->addIndexIfNotExists('subscriptions', ['category_type', 'category_id']);
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        // Drop foreign keys
        $this->dropForeignKeyIfExists('payments', 'payments_plan_id_foreign');
        $this->dropForeignKeyIfExists('subscriptions', 'subscriptions_plan_id_foreign');
        $this->dropForeignKeyIfExists('subscriptions', 'subscriptions_payment_id_foreign');

        // Drop indexes
        $this->dropIndexIfExists('payments', 'payments_payment_date_index');
        $this->dropIndexIfExists('payments', 'payments_payment_processor_index');
        $this->dropIndexIfExists('subscriptions', 'subscriptions_starts_at_index');
        $this->dropIndexIfExists('subscriptions', 'subscriptions_ends_at_index');
        $this->dropIndexIfExists('subscriptions', 'subscriptions_category_type_category_id_index');
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
            // If we can't check, assume it doesn't exist
            return false;
        }

        return false;
    }

    /**
     * Add index if it doesn't exist
     */
    private function addIndexIfNotExists(string $table, $columns): void
    {
        if (!Schema::hasTable($table)) {
            return;
        }

        $columnArray = is_array($columns) ? $columns : [$columns];
        
        // Check if all columns exist
        foreach ($columnArray as $column) {
            if (!Schema::hasColumn($table, $column)) {
                return;
            }
        }

        $indexName = $table . '_' . implode('_', $columnArray) . '_index';
        
        if (!$this->indexExists($table, $indexName)) {
            Schema::table($table, function (Blueprint $table) use ($columns) {
                $table->index($columns);
            });
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