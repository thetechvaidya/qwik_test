<?php

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Session;

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Find admin user
$admin = User::where('email', 'admin@qwiktest.com')->first();

if ($admin) {
    echo "Admin user found: " . $admin->email . "\n";
    echo "Admin roles: " . $admin->roles->pluck('name')->implode(', ') . "\n";
    echo "Admin permissions: " . $admin->getAllPermissions()->pluck('name')->implode(', ') . "\n";
    
    // Test wallet access without the problematic appends
    try {
        $wallet = $admin->wallet;
        echo "Wallet Balance: " . ($wallet ? $wallet->balance : 0) . "\n";
    } catch (Exception $e) {
        echo "Wallet error: " . $e->getMessage() . "\n";
    }
    
    echo "\nUser is properly seeded and ready for testing.\n";
    echo "Frontend issues are preventing normal login flow.\n";
    echo "\nTo manually test admin functionality:\n";
    echo "1. Fix Vue.js template errors in the components\n";
    echo "2. Or access admin routes directly via API/backend\n";
    
} else {
    echo "Admin user not found!\n";
}
