<?php

namespace App\Http\Responses;

use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;
use Laravel\Fortify\Contracts\LoginResponse as LoginResponseContract;

class LoginResponse implements LoginResponseContract
{

    public function toResponse($request)
    {
        $user = Auth::user();
        
        // Log successful login for debugging
        Log::info('User successfully authenticated', [
            'user_id' => $user->id,
            'email' => $user->email,
            'user_name' => $user->user_name,
            'roles' => $user->getRoleNames()->toArray(),
            'demo_mode' => config('qwiktest.demo_mode'),
            'intended_url' => url()->previous()
        ]);

        // Check if user data is complete
        if (!$user->email_verified_at && !config('qwiktest.demo_mode')) {
            Log::warning('User login with unverified email', [
                'user_id' => $user->id,
                'email' => $user->email
            ]);
        }

        // Redirect to dashboard based on role
        if($user->hasRole("admin")) {
            return redirect()->route('admin_dashboard');
        }
        
        if($user->hasRole("instructor")) {
            return redirect()->route('instructor_dashboard');
        }
        
        if($user->hasRole("student")) {
            return redirect()->route('user_dashboard');
        }
        
        // Default fallback
        return redirect()->intended(config('fortify.home'));
    }

}
