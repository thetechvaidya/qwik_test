<?php

use App\Models\User;

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Find admin user
$admin = User::where('email', 'admin@qwiktest.com')->first();

if ($admin) {
    echo "Admin user found: " . $admin->email . "\n";
    echo "Testing serialization...\n";
    
    try {
        // This is what Inertia does - convert the model to array
        $userArray = $admin->toArray();
        echo "User successfully converted to array\n";
        echo "Keys: " . implode(', ', array_keys($userArray)) . "\n";
        
        if (isset($userArray['wallet_balance'])) {
            echo "Wallet balance in array: " . $userArray['wallet_balance'] . "\n";
        }
        
    } catch (Exception $e) {
        echo "Error converting user to array: " . $e->getMessage() . "\n";
        echo "Stack trace:\n" . $e->getTraceAsString() . "\n";
    }
    
} else {
    echo "Admin user not found!\n";
}
