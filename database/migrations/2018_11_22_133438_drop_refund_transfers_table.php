<?php

use Bavix\Wallet\Models\Transfer;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Database\SQLiteConnection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class DropRefundTransfersTable extends Migration
{
    /**
     * @return string
     */
    protected function table(): string
    {
        return (new Transfer())->getTable();
    }

    /**
     * @return void
     */
    public function up(): void
    {
        // Drop indexes that reference the `refund` column across drivers before dropping the column itself.
        $driver = DB::getDriverName();
        if ($driver === 'sqlite') {
            // SQLite requires explicit DROP INDEX statements and supports IF EXISTS.
            DB::statement('DROP INDEX IF EXISTS from_to_refund_ind');
            DB::statement('DROP INDEX IF EXISTS from_refund_ind');
            DB::statement('DROP INDEX IF EXISTS to_refund_ind');
        } else {
            // For MySQL/Postgres, use schema builder to drop named indexes safely.
            Schema::table($this->table(), function (Blueprint $table) {
                $table->dropIndex('from_to_refund_ind');
                $table->dropIndex('from_refund_ind');
                $table->dropIndex('to_refund_ind');
            });
        }

        // Now drop the `refund` column if it exists (guards repeated migrations / cross-DB variance).
        $tbl = $this->table();
        if (Schema::hasColumn($tbl, 'refund')) {
            Schema::table($tbl, function (Blueprint $table) {
                $table->dropColumn('refund');
            });
        }
    }

    /**
     * @return void
     */
    public function down(): void
    {
        Schema::table($this->table(), function (Blueprint $table) {
            $table->boolean('refund')
                ->after('withdraw_id')
                ->default(0);

            $table->index(['from_type', 'from_id', 'to_type', 'to_id', 'refund'], 'from_to_refund_ind');
            $table->index(['from_type', 'from_id', 'refund'], 'from_refund_ind');
            $table->index(['to_type', 'to_id', 'refund'], 'to_refund_ind');
        });
    }
}
