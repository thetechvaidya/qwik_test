<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class AuthDebugController extends Controller
{
    /**
     * Ensure this controller only works in demo mode
     */
    public function __construct()
    {
        if (!config('qwiktest.demo_mode')) {
            abort(404, 'Debug routes only available in demo mode');
        }
    }

    /**
     * List all demo users with their credentials info
     */
    public function listUsers()
    {
        try {
            $users = User::select('id', 'first_name', 'last_name', 'user_name', 'email', 'is_active', 'email_verified_at', 'created_at')
                ->with('roles:name')
                ->get()
                ->map(function ($user) {
                    return [
                        'id' => $user->id,
                        'name' => $user->first_name . ' ' . $user->last_name,
                        'user_name' => $user->user_name,
                        'email' => $user->email,
                        'is_active' => $user->is_active,
                        'email_verified' => $user->email_verified_at ? true : false,
                        'roles' => $user->roles->pluck('name')->toArray(),
                        'created_at' => $user->created_at->format('Y-m-d H:i:s')
                    ];
                });

            return response()->json([
                'success' => true,
                'message' => 'Demo users retrieved successfully',
                'data' => [
                    'users' => $users,
                    'total_count' => $users->count(),
                    'demo_credentials' => [
                        'admin' => 'admin@qwiktest.com / password',
                        'instructor' => 'instructor@qwiktest.com / password',
                        'student' => 'student@qwiktest.com / password'
                    ]
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error listing demo users', [
                'error' => $e->getMessage(),
                'trace' => $e->getTraceAsString()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to retrieve users: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Check demo credentials availability
     */
    public function checkCredentials()
    {
        try {
            $credentials = [
                'admin' => ['email' => 'admin@qwiktest.com', 'username' => 'admin'],
                'instructor' => ['email' => 'instructor@qwiktest.com', 'username' => 'instructor'],
                'student' => ['email' => 'student@qwiktest.com', 'username' => 'student']
            ];

            $results = [];
            foreach ($credentials as $role => $creds) {
                $userByEmail = User::where('email', $creds['email'])->first();
                $userByUsername = User::where('user_name', $creds['username'])->first();

                $results[$role] = [
                    'email_exists' => $userByEmail ? true : false,
                    'username_exists' => $userByUsername ? true : false,
                    'user_active' => $userByEmail ? $userByEmail->is_active : false,
                    'email_verified' => $userByEmail ? ($userByEmail->email_verified_at ? true : false) : false,
                    'password_test' => $userByEmail ? Hash::check('password', $userByEmail->password) : false,
                    'roles' => $userByEmail ? $userByEmail->roles->pluck('name')->toArray() : []
                ];
            }

            return response()->json([
                'success' => true,
                'message' => 'Credential check completed',
                'data' => $results
            ]);
        } catch (\Exception $e) {
            Log::error('Error checking credentials', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to check credentials: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Check specific user status by email
     */
    public function checkUserStatus($email)
    {
        try {
            $user = User::where('email', $email)
                ->orWhere('user_name', $email)
                ->with('roles')
                ->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User not found',
                    'data' => [
                        'exists' => false,
                        'input' => $email
                    ]
                ]);
            }

            return response()->json([
                'success' => true,
                'message' => 'User found',
                'data' => [
                    'exists' => true,
                    'id' => $user->id,
                    'name' => $user->first_name . ' ' . $user->last_name,
                    'email' => $user->email,
                    'user_name' => $user->user_name,
                    'is_active' => $user->is_active,
                    'email_verified' => $user->email_verified_at ? true : false,
                    'email_verified_at' => $user->email_verified_at,
                    'roles' => $user->roles->pluck('name')->toArray(),
                    'created_at' => $user->created_at->format('Y-m-d H:i:s'),
                    'updated_at' => $user->updated_at->format('Y-m-d H:i:s')
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error checking user status', [
                'email' => $email,
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to check user status: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Test password hash verification
     */
    public function testPassword(Request $request)
    {
        $request->validate([
            'email' => 'required|string',
            'password' => 'required|string'
        ]);

        try {
            $user = User::where('email', $request->email)
                ->orWhere('user_name', $request->email)
                ->first();

            if (!$user) {
                return response()->json([
                    'success' => false,
                    'message' => 'User not found',
                    'data' => [
                        'user_exists' => false,
                        'password_match' => false
                    ]
                ]);
            }

            $passwordMatch = Hash::check($request->password, $user->password);

            return response()->json([
                'success' => true,
                'message' => 'Password test completed',
                'data' => [
                    'user_exists' => true,
                    'user_active' => $user->is_active,
                    'password_match' => $passwordMatch,
                    'user_info' => [
                        'id' => $user->id,
                        'email' => $user->email,
                        'user_name' => $user->user_name,
                        'roles' => $user->roles->pluck('name')->toArray()
                    ]
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error testing password', [
                'email' => $request->email,
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to test password: ' . $e->getMessage()
            ], 500);
        }
    }

    /**
     * Reset all demo user passwords to 'password'
     */
    public function resetDemoPasswords()
    {
        try {
            $demoEmails = [
                'admin@qwiktest.com',
                'instructor@qwiktest.com',
                'student@qwiktest.com',
                'admin_legacy@qwiktest.com'
            ];

            $updated = 0;
            $results = [];

            foreach ($demoEmails as $email) {
                $user = User::where('email', $email)->first();
                if ($user) {
                    $user->password = Hash::make('password');
                    $user->is_active = true;
                    $user->email_verified_at = Carbon::now();
                    $user->save();
                    $updated++;
                    
                    $results[] = [
                        'email' => $email,
                        'updated' => true,
                        'user_name' => $user->user_name
                    ];
                } else {
                    $results[] = [
                        'email' => $email,
                        'updated' => false,
                        'reason' => 'User not found'
                    ];
                }
            }

            Log::info('Demo passwords reset', [
                'updated_count' => $updated,
                'results' => $results
            ]);

            return response()->json([
                'success' => true,
                'message' => "Successfully reset passwords for {$updated} demo users",
                'data' => [
                    'updated_count' => $updated,
                    'results' => $results,
                    'new_password' => 'password'
                ]
            ]);
        } catch (\Exception $e) {
            Log::error('Error resetting demo passwords', [
                'error' => $e->getMessage()
            ]);

            return response()->json([
                'success' => false,
                'message' => 'Failed to reset demo passwords: ' . $e->getMessage()
            ], 500);
        }
    }
}
