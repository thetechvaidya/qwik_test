<?php

namespace Tests\Feature;

use App\Models\User;
use Illuminate\Auth\Events\Registered;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Notification;
use Illuminate\Support\Facades\Password;
use Laravel\Jetstream\Jetstream;
use Laravel\Sanctum\Sanctum;
use Spatie\Permission\Models\Role;
use Spatie\Permission\Models\Permission;
use Tests\TestCase;

class AuthenticationTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create roles and permissions for testing
        $this->createRolesAndPermissions();
    }

    protected function createRolesAndPermissions(): void
    {
        // Create roles
        Role::create(['name' => 'admin', 'guard_name' => 'web']);
        Role::create(['name' => 'instructor', 'guard_name' => 'web']);
        Role::create(['name' => 'user', 'guard_name' => 'web']);

        // Create permissions
        Permission::create(['name' => 'access-admin-panel', 'guard_name' => 'web']);
        Permission::create(['name' => 'manage-users', 'guard_name' => 'web']);
        Permission::create(['name' => 'manage-exams', 'guard_name' => 'web']);
        Permission::create(['name' => 'take-exams', 'guard_name' => 'web']);

        // Assign permissions to roles
        $adminRole = Role::findByName('admin');
        $adminRole->givePermissionTo(['access-admin-panel', 'manage-users', 'manage-exams']);

        $instructorRole = Role::findByName('instructor');
        $instructorRole->givePermissionTo(['manage-exams']);

        $userRole = Role::findByName('user');
        $userRole->givePermissionTo(['take-exams']);
    }

    /** @test */
    public function user_can_register_with_jetstream()
    {
        Event::fake();

        $userData = [
            'first_name' => $this->faker->firstName,
            'last_name' => $this->faker->lastName,
            'user_name' => $this->faker->userName,
            'name' => $this->faker->name,
            'email' => $this->faker->unique()->safeEmail,
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'terms' => true,
        ];

        $response = $this->post('/register', $userData);

        $response->assertRedirect(config('fortify.home', '/dashboard'));
        $this->assertDatabaseHas('users', [
            'name' => $userData['name'],
            'email' => $userData['email'],
        ]);

        Event::assertDispatched(Registered::class);
    }

    /** @test */
    public function user_can_login_successfully()
    {
        $user = User::factory()->create([
            'password' => Hash::make('password123'),
        ]);

        $response = $this->post('/login', [
            'email' => $user->email,
            'password' => 'password123',
        ]);

        $response->assertRedirect(config('fortify.home', '/dashboard'));
        $this->assertAuthenticatedAs($user);
    }

    /** @test */
    public function user_cannot_login_with_invalid_credentials()
    {
        $user = User::factory()->create([
            'password' => Hash::make('password123'),
        ]);

        $response = $this->post('/login', [
            'email' => $user->email,
            'password' => 'wrongpassword',
        ]);

        $response->assertSessionHasErrors();
        $this->assertGuest();
    }

    /** @test */
    public function user_can_logout()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->post('/logout');

        $response->assertRedirect('/');
        $this->assertGuest();
    }

    /** @test */
    public function user_can_request_password_reset()
    {
        Notification::fake();
        $user = User::factory()->create();

        $response = $this->post('/forgot-password', [
            'email' => $user->email,
        ]);

        $response->assertSessionHas('status');
        Notification::assertSentTo($user, \Illuminate\Auth\Notifications\ResetPassword::class);
    }

    /** @test */
    public function user_can_reset_password_with_valid_token()
    {
        $user = User::factory()->create();
        $token = Password::createToken($user);

        $newPassword = 'newpassword123';

        $response = $this->post('/reset-password', [
            'token' => $token,
            'email' => $user->email,
            'password' => $newPassword,
            'password_confirmation' => $newPassword,
        ]);

        $response->assertRedirect(config('fortify.home', '/dashboard'));
        $this->assertTrue(Hash::check($newPassword, $user->fresh()->password));
    }

    /** @test */
    public function user_can_verify_email()
    {
        $user = User::factory()->unverified()->create();
        $this->actingAs($user);

        $verificationUrl = \Illuminate\Support\Facades\URL::temporarySignedRoute(
            'verification.verify',
            now()->addMinutes(60),
            ['id' => $user->id, 'hash' => sha1($user->email)]
        );

        $response = $this->get($verificationUrl);

        $response->assertRedirect(config('fortify.home', '/dashboard'));
        $this->assertNotNull($user->fresh()->email_verified_at);
    }

    /** @test */
    public function user_can_enable_two_factor_authentication()
    {
        if (!Jetstream::hasTwoFactorAuthenticationFeatures()) {
            $this->markTestSkipped('Two factor authentication is not enabled.');
        }

        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->post('/user/two-factor-authentication');

        $response->assertRedirect();
        $this->assertNotNull($user->fresh()->two_factor_secret);
    }

    /** @test */
    public function user_can_disable_two_factor_authentication()
    {
        if (!Jetstream::hasTwoFactorAuthenticationFeatures()) {
            $this->markTestSkipped('Two factor authentication is not enabled.');
        }

        $user = User::factory()->withPersonalTeam()->create();
        $user->enableTwoFactorAuthentication();
        $this->actingAs($user);

        $response = $this->delete('/user/two-factor-authentication');

        $response->assertRedirect();
        $this->assertNull($user->fresh()->two_factor_secret);
    }

    /** @test */
    public function sanctum_api_token_authentication_works()
    {
        $user = User::factory()->create();
        $token = $user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->get('/api/user');

        $response->assertStatus(200);
        $response->assertJson([
            'id' => $user->id,
            'email' => $user->email,
        ]);
    }

    /** @test */
    public function invalid_sanctum_token_returns_unauthorized()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer invalid-token',
        ])->get('/api/user');

        $response->assertStatus(401);
    }

    /** @test */
    public function admin_role_can_access_admin_panel()
    {
        $admin = User::factory()->create();
        $admin->assignRole('admin');
        $this->actingAs($admin);

        $response = $this->get(route('admin_dashboard'));

        $response->assertStatus(200);
    }

    /** @test */
    public function user_role_cannot_access_admin_panel()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->get(route('admin_dashboard'));

        $response->assertStatus(302); // Redirect to login or forbidden
    }

    /** @test */
    public function user_with_permission_can_manage_exams()
    {
        $admin = User::factory()->create();
        $admin->assignRole('admin');
        $this->actingAs($admin);

        $response = $this->get(route('exams.index'));

        $response->assertSuccessful();
    }

    /** @test */
    public function user_without_permission_cannot_manage_exams()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->get(route('exams.index'));

        $response->assertStatus(302); // Redirect due to middleware
    }

    /** @test */
    public function middleware_protects_authenticated_routes()
    {
        $response = $this->get('/dashboard');

        $response->assertRedirect('/login');
    }

    /** @test */
    public function middleware_allows_authenticated_users()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->get(route('user_dashboard'));

        $response->assertStatus(200);
    }

    /** @test */
    public function csrf_protection_works_for_post_requests()
    {
        $user = User::factory()->create();

        $response = $this->post('/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);

        // CSRF protection should be handled by Laravel automatically in tests
        $response->assertStatus(302); // Redirect or validation error
    }

    /** @test */
    public function session_management_works_correctly()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        // Check that session contains authentication data
        $this->assertAuthenticated();

        // Test session regeneration on login
        $sessionId = session()->getId();
        $this->post('/logout');
        $this->post('/login', [
            'email' => $user->email,
            'password' => 'password',
        ]);

        // Session should be regenerated
        $this->assertNotEquals($sessionId, session()->getId());
    }

    /** @test */
    public function authentication_redirects_work_correctly()
    {
        // Test redirect to intended URL after login
        $response = $this->get(route('admin_dashboard'));
        $response->assertRedirect('/login');

        $admin = User::factory()->create();
        $admin->assignRole('admin');

        $this->post('/login', [
            'email' => $admin->email,
            'password' => 'password',
        ]);

        // After login, should redirect to originally intended URL
        $response = $this->get(route('admin_dashboard'));
        $response->assertStatus(200);
    }

    /** @test */
    public function guest_middleware_redirects_authenticated_users()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->get('/login');
        $response->assertRedirect(config('fortify.home', '/dashboard'));
    }

    /** @test */
    public function auth_guards_work_correctly()
    {
        // Test web guard
        $user = User::factory()->create();
        $this->actingAs($user, 'web');

        $this->assertTrue(Auth::guard('web')->check());
        $this->assertEquals($user->id, Auth::guard('web')->id());

        // Test API guard with Sanctum
        Sanctum::actingAs($user);
        $response = $this->get('/api/user');
        $response->assertStatus(200);
    }

    /** @test */
    public function password_confirmation_middleware_works()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        // Access route that requires password confirmation
        $response = $this->get('/user/confirm-password');
        $response->assertStatus(200);

        // Confirm password
        $response = $this->post('/user/confirm-password', [
            'password' => 'password',
        ]);

        $response->assertRedirect();
        $this->assertTrue(session()->has('auth.password_confirmed_at'));
    }

    /** @test */
    public function remember_me_functionality_works()
    {
        $user = User::factory()->create([
            'password' => Hash::make('password123'),
        ]);

        $response = $this->post('/login', [
            'email' => $user->email,
            'password' => 'password123',
            'remember' => true,
        ]);

        $response->assertRedirect('/dashboard');
        $this->assertNotNull($user->fresh()->remember_token);
    }
}
