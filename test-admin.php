<?php

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Find admin user
$admin = User::where('email', 'admin@qwiktest.com')->first();

if ($admin) {
    echo "Admin user found:\n";
    echo "Name: " . $admin->first_name . " " . $admin->last_name . "\n";
    echo "Email: " . $admin->email . "\n";
    echo "Username: " . $admin->user_name . "\n";
    echo "Roles: " . $admin->getRoleNames()->implode(', ') . "\n";
    echo "Password verification: " . (Hash::check('password', $admin->password) ? 'PASS' : 'FAIL') . "\n";
} else {
    echo "Admin user not found!\n";
}
