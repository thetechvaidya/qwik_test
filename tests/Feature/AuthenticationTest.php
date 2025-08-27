<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use Illuminate\Foundation\Testing\DatabaseTransactions;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Auth;

class AuthenticationTest extends TestCase
{
    use DatabaseTransactions;

    public function test_sanctum_csrf_cookie_endpoint_works()
    {
        $response = $this->get('/sanctum/csrf-cookie');
        
        $response->assertStatus(204);
    }

    public function test_user_can_login_with_valid_credentials()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123')
        ]);

        $response = $this->post('/login', [
            'email' => 'test@example.com',
            'password' => 'password123'
        ]);

        $this->assertTrue(Auth::check());
    }

    public function test_user_cannot_login_with_invalid_credentials()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => Hash::make('password123')
        ]);

        $response = $this->post('/login', [
            'email' => 'test@example.com',
            'password' => 'wrongpassword'
        ]);

        $this->assertFalse(Auth::check());
    }

    public function test_authenticated_user_can_access_dashboard()
    {
        $user = User::factory()->create();
        
        $response = $this->actingAs($user)->get('/dashboard');
        
        // Should not redirect to login
        $this->assertNotEquals(302, $response->getStatusCode());
    }

    public function test_guest_user_redirected_from_dashboard()
    {
        $response = $this->get('/dashboard');
        
        $response->assertRedirect();
    }
}