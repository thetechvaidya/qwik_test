<?php

use Bavix\Wallet\Models\Transfer;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\MySqlConnection;
use Illuminate\Database\PostgresConnection;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class UpdateStatusTransfersTable extends Migration
{
    /**
     * @return string
     */
    protected function table(): string
    {
        return (new Transfer())->getTable();
    }

    public function up(): void
    {
        $enums = [
            Transfer::STATUS_TRANSFER,
            Transfer::STATUS_PAID,
            Transfer::STATUS_REFUND,
            Transfer::STATUS_GIFT,
        ];

        try {
            $connection = DB::connection();
            $driverName = $connection->getDriverName();

            switch ($driverName) {
                case 'mysql':
                    $this->updateMysqlEnums($enums);
                    break;
                    
                case 'pgsql':
                    $this->updatePostgresEnums($enums);
                    break;
                    
                default:
                    $this->updateGenericEnums();
                    break;
            }
        } catch (\Throwable $e) {
            // Fallback to generic string columns if ENUM operations fail
            $this->updateGenericEnums();
        }
    }

    private function updateMysqlEnums(array $enums): void
    {
        $table = DB::getTablePrefix().$this->table();
        $enumString = implode('\', \'', $enums);
        $default = Transfer::STATUS_TRANSFER;
        
        DB::statement("ALTER TABLE `$table` CHANGE COLUMN `status` `status` ENUM('$enumString') NOT NULL DEFAULT '$default'");
        DB::statement("ALTER TABLE `$table` CHANGE COLUMN `status_last` `status_last` ENUM('$enumString') NULL");
    }

    private function updatePostgresEnums(array $enums): void
    {
        $this->alterEnum(DB::getTablePrefix().$this->table(), 'status', $enums);
        $this->alterEnum(DB::getTablePrefix().$this->table(), 'status_last', $enums);
    }

    private function updateGenericEnums(): void
    {
        Schema::table($this->table(), function (Blueprint $table) {
            $table->string('status')
                ->default(Transfer::STATUS_TRANSFER)
                ->change();

            $table->string('status_last')
                ->nullable()
                ->change();
        });
    }

    public function down(): void
    {
        // Update existing records first
        DB::table($this->table())
            ->where('status', Transfer::STATUS_TRANSFER)
            ->update(['status' => Transfer::STATUS_PAID]);

        DB::table($this->table())
            ->where('status_last', Transfer::STATUS_TRANSFER)
            ->update(['status_last' => Transfer::STATUS_PAID]);

        $enums = [
            Transfer::STATUS_PAID,
            Transfer::STATUS_REFUND,
            Transfer::STATUS_GIFT,
        ];

        try {
            $connection = DB::connection();
            $driverName = $connection->getDriverName();

            switch ($driverName) {
                case 'mysql':
                    $this->rollbackMysqlEnums($enums);
                    break;
                    
                case 'pgsql':
                    $this->rollbackPostgresEnums($enums);
                    break;
                    
                default:
                    $this->rollbackGenericEnums();
                    break;
            }
        } catch (\Throwable $e) {
            // Fallback to generic string columns if ENUM operations fail
            $this->rollbackGenericEnums();
        }
    }

    private function rollbackMysqlEnums(array $enums): void
    {
        $table = DB::getTablePrefix().$this->table();
        $enumString = implode('\', \'', $enums);
        $default = Transfer::STATUS_PAID;
        
        DB::statement("ALTER TABLE `$table` CHANGE COLUMN `status` `status` ENUM('$enumString') NOT NULL DEFAULT '$default'");
        DB::statement("ALTER TABLE `$table` CHANGE COLUMN `status_last` `status_last` ENUM('$enumString') NULL");
    }

    private function rollbackPostgresEnums(array $enums): void
    {
        $this->alterEnum(DB::getTablePrefix().$this->table(), 'status', $enums);
        $this->alterEnum(DB::getTablePrefix().$this->table(), 'status_last', $enums);
    }

    private function rollbackGenericEnums(): void
    {
        Schema::table($this->table(), function (Blueprint $table) {
            $table->string('status')
                ->default(Transfer::STATUS_PAID)
                ->change();

            $table->string('status_last')
                ->nullable()
                ->change();
        });
    }

    /**
     * Alter an enum field constraints for PostgreSQL.
     */
    protected function alterEnum(string $table, string $field, array $options): void
    {
        $check = "${table}_${field}_check";

        $enumList = [];
        foreach ($options as $option) {
            $enumList[] = sprintf("'%s'::CHARACTER VARYING", $option);
        }

        $enumString = implode(', ', $enumList);

        try {
            DB::transaction(function () use ($table, $field, $check, $enumString) {
                // Check if constraint exists before trying to drop it
                $constraintExists = DB::select("
                    SELECT 1 FROM information_schema.table_constraints 
                    WHERE constraint_name = ? AND table_name = ?
                ", [$check, $table]);

                if (!empty($constraintExists)) {
                    DB::statement(sprintf('ALTER TABLE "%s" DROP CONSTRAINT "%s"', $table, $check));
                }

                DB::statement(sprintf(
                    'ALTER TABLE "%s" ADD CONSTRAINT "%s" CHECK ("%s"::TEXT = ANY (ARRAY[%s]::TEXT[]))', 
                    $table, 
                    $check, 
                    $field, 
                    $enumString
                ));
            });
        } catch (\Throwable $e) {
            // If constraint operations fail, log the error but don't break the migration
            logger()->warning("Failed to alter enum constraint for {$table}.{$field}: " . $e->getMessage());
            throw $e;
        }
    }
}
