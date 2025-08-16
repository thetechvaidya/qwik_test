<?php

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\DB;

echo "Checking for wallet-related tables...\n\n";

$tables = ['wallets', 'transfers', 'transactions'];

foreach ($tables as $table) {
    if (Schema::hasTable($table)) {
        echo "✓ Table '$table' exists\n";
        $count = DB::table($table)->count();
        echo "  Records: $count\n";
    } else {
        echo "✗ Table '$table' does not exist\n";
    }
}

echo "\nChecking available migrations...\n";
$migrations = DB::table('migrations')->where('migration', 'like', '%wallet%')->get();
foreach ($migrations as $migration) {
    echo "Found migration: " . $migration->migration . "\n";
}

echo "\nChecking all tables in database...\n";
$allTables = DB::select('SHOW TABLES');
foreach ($allTables as $table) {
    $tableName = array_values((array) $table)[0];
    if (stripos($tableName, 'wallet') !== false || stripos($tableName, 'transfer') !== false || stripos($tableName, 'transaction') !== false) {
        echo "Found table: $tableName\n";
    }
}
