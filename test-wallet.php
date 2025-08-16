<?php

use App\Models\User;
use Illuminate\Support\Facades\Auth;

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Find admin user
$admin = User::where('email', 'admin@qwiktest.com')->first();

if ($admin) {
    echo "Admin user found: " . $admin->email . "\n";
    echo "Checking wallet...\n";
    
    try {
        // Try to access the wallet directly
        $wallet = $admin->wallet;
        echo "Wallet created/accessed successfully\n";
        echo "Wallet ID: " . $wallet->id . "\n";
        echo "Balance: " . $wallet->balance . "\n";
        
        // Check the wallet_balance attribute
        $balance = $admin->wallet_balance;
        echo "Wallet balance attribute: $balance\n";
        
    } catch (Exception $e) {
        echo "Error accessing wallet: " . $e->getMessage() . "\n";
        echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
    }
    
} else {
    echo "Admin user not found!\n";
}
