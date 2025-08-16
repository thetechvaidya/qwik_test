<?php

use App\Models\User;
use Illuminate\Support\Facades\Auth;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Session;

require_once __DIR__ . '/vendor/autoload.php';

$app = require_once __DIR__ . '/bootstrap/app.php';
$kernel = $app->make(Illuminate\Contracts\Console\Kernel::class);
$kernel->bootstrap();

// Find admin user
$admin = User::where('email', 'admin@qwiktest.com')->first();

if ($admin) {
    // Start session
    Session::start();
    
    // Login the user
    Auth::login($admin);
    
    echo "Admin user logged in successfully!\n";
    echo "Session ID: " . Session::getId() . "\n";
    echo "Authenticated: " . (Auth::check() ? 'YES' : 'NO') . "\n";
    echo "User ID: " . Auth::id() . "\n";
    echo "You can now navigate to: http://localhost:8000/admin/dashboard\n";
    
    // Try to output the session cookie for browser usage
    echo "\nSession Cookie Info:\n";
    echo "Cookie Name: " . config('session.cookie') . "\n";
    echo "Session ID for Cookie: " . Session::getId() . "\n";
    
} else {
    echo "Admin user not found!\n";
}
