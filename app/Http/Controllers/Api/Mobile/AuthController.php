<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Requests\Api\Mobile\LoginRequest;
use App\Http\Requests\Api\Mobile\RegisterRequest;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;
use Illuminate\Validation\ValidationException;

class AuthController extends Controller
{
    /**
     * Mobile login endpoint - optimized for 200-byte response
     */
    public function login(LoginRequest $request): JsonResponse
    {
        $credentials = $request->validated();
        
        // Attempt authentication
        if (!Auth::attempt($credentials)) {
            throw ValidationException::withMessages([
                'email' => ['Invalid credentials']
            ]);
        }

        $user = Auth::user();
        
        // Create mobile-optimized token
        $token = $user->createToken('mobile-app', ['mobile:access'])->plainTextToken;
        
        return response()->json([
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role
            ]
        ]);
    }

    /**
     * Mobile registration endpoint - optimized response
     */
    public function register(RegisterRequest $request): JsonResponse
    {
        $data = $request->validated();
        
        // Create user
        $user = User::create([
            'first_name' => $data['first_name'],
            'last_name' => $data['last_name'],
            'email' => $data['email'],
            'password' => Hash::make($data['password']),
            'role' => 'student',
            'is_active' => true,
            'email_verified_at' => now()
        ]);
        
        // Create mobile token
        $token = $user->createToken('mobile-app', ['mobile:access'])->plainTextToken;
        
        return response()->json([
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role
            ]
        ], 201);
    }

    /**
     * Mobile logout endpoint
     */
    public function logout(Request $request): JsonResponse
    {
        // Revoke current token
        $request->user()->currentAccessToken()->delete();
        
        return response()->json([
            'message' => 'Logged out successfully'
        ]);
    }

    /**
     * Refresh token endpoint for mobile
     */
    public function refresh(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Revoke current token
        $request->user()->currentAccessToken()->delete();
        
        // Create new token
        $token = $user->createToken('mobile-app', ['mobile:access'])->plainTextToken;
        
        return response()->json([
            'token' => $token,
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role
            ]
        ]);
    }

    /**
     * Get current user profile (mobile optimized)
     */
    public function me(Request $request): JsonResponse
    {
        $user = $request->user();
        
        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
                'active' => $user->is_active
            ]
        ]);
    }

    /**
     * Logout from all devices
     */
    public function logoutAll(Request $request): JsonResponse
    {
        // Revoke all tokens for the user
        $request->user()->tokens()->delete();
        
        return response()->json([
            'message' => 'Logged out from all devices'
        ]);
    }
}