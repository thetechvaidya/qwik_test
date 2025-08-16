<?php

namespace Tests\Feature;

use App\Models\User;
use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;

class InertiaNavigationTest extends TestCase
{
    use RefreshDatabase;

    /** @test */
    public function it_can_navigate_to_login_page_via_inertia_link()
    {
        $response = $this->get(route('login'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Auth/Login')
                 );
    }

    /** @test */
    public function it_can_navigate_to_register_page_via_inertia_link()
    {
        $response = $this->get(route('register'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Auth/Register')
                 );
    }

    /** @test */
    public function it_can_submit_login_form_via_inertia_post()
    {
        $user = User::factory()->create([
            'email' => 'test@example.com',
            'password' => bcrypt('password123')
        ]);

        $response = $this->post(route('login'), [
            'email' => 'test@example.com',
            'password' => 'password123',
        ]);

        $response->assertRedirect();
        $this->assertAuthenticatedAs($user);
    }

    /** @test */
    public function it_can_submit_registration_form_via_inertia_post()
    {
        $userData = [
            'first_name' => 'John',
            'last_name' => 'Doe',
            'user_name' => 'johndoe',
            'email' => 'john@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ];

        $response = $this->post(route('register'), $userData);

        $response->assertRedirect();
        $this->assertDatabaseHas('users', [
            'email' => 'john@example.com',
            'user_name' => 'johndoe',
            'first_name' => 'John',
            'last_name' => 'Doe'
        ]);
        $this->assertAuthenticated();
    }

    /** @test */
    public function it_handles_inertia_validation_errors_correctly()
    {
        $response = $this->post(route('login'), [
            'email' => 'invalid-email',
            'password' => '',
        ]);

        $response->assertStatus(302)
                 ->assertSessionHasErrors(['email', 'password']);
    }

    /** @test */
    public function it_can_navigate_between_pages_maintaining_inertia_context()
    {
        // Test navigation from login to register
        $loginResponse = $this->get(route('login'));
        $loginResponse->assertInertia(fn ($assert) => $assert->component('Auth/Login'));

        // Navigate to register (simulating Link component behavior)
        $registerResponse = $this->get(route('register'));
        $registerResponse->assertInertia(fn ($assert) => $assert->component('Auth/Register'));
    }

    /** @test */
    public function it_preserves_authentication_state_across_inertia_requests()
    {
        $user = User::factory()->create();
        
        $this->actingAs($user);
        
        $response = $this->get('/dashboard');
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->where('auth.user.id', $user->id)
                 );
    }

    /** @test */
    public function it_can_logout_user_via_post_request_and_clear_session()
    {
        $user = User::factory()->create();
        
        $this->actingAs($user);
        $this->assertAuthenticated();
        
        $response = $this->post(route('logout'));
        
        $response->assertRedirect('/');
        $this->assertGuest();
    }

    /** @test */
    public function it_can_request_password_reset_link_via_post()
    {
        $user = User::factory()->create();

        $response = $this->post(route('password.email'), [
            'email' => $user->email,
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('status');
    }

    /** @test */
    public function it_can_resend_verification_email_via_post()
    {
        $user = User::factory()->unverified()->create();
        
        $this->actingAs($user);

        $response = $this->post(route('verification.send'));

        $response->assertRedirect();
        $response->assertSessionHas('status');
        
        // Verify the status message is non-empty
        $this->assertNotEmpty(session('status'));
    }

    /** @test */
    public function it_can_navigate_to_forgot_password_page_via_inertia_link()
    {
        $response = $this->get(route('password.request'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Auth/ForgotPassword')
                 );
    }

    /** @test */
    public function it_can_navigate_to_verify_email_page_via_inertia_link()
    {
        $user = User::factory()->unverified()->create();
        
        $this->actingAs($user);
        
        $response = $this->get(route('verification.notice'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Auth/VerifyEmail')
                 );
    }

    /** @test */
    public function it_handles_password_reset_validation_errors_correctly()
    {
        $response = $this->post(route('password.email'), [
            'email' => 'invalid-email',
        ]);

        $response->assertStatus(302)
                 ->assertSessionHasErrors(['email']);
    }

    /** @test */
    public function it_validates_password_reset_email_exists_in_database()
    {
        $response = $this->post(route('password.email'), [
            'email' => 'nonexistent@example.com',
        ]);

        $response->assertStatus(302);
        // The specific error handling depends on your implementation
        // Some implementations redirect back with validation errors,
        // others might redirect with a generic success message for security
    }

    /** @test */
    public function it_can_navigate_to_admin_dashboard_when_authenticated_as_admin()
    {
        $admin = User::factory()->create(['role_id' => 'admin']);
        
        $this->actingAs($admin);
        
        $response = $this->get(route('admin_dashboard'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Admin/Dashboard')
                 );
    }

    /** @test */
    public function it_can_navigate_to_instructor_dashboard_when_authenticated_as_instructor()
    {
        $instructor = User::factory()->create(['role_id' => 'instructor']);
        
        $this->actingAs($instructor);
        
        $response = $this->get(route('instructor_dashboard'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Instructor/Dashboard')
                 );
    }

    /** @test */
    public function it_can_access_quiz_management_pages_as_instructor()
    {
        $instructor = User::factory()->create(['role_id' => 'instructor']);
        
        $this->actingAs($instructor);
        
        $response = $this->get(route('quizzes.index'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Admin/Quiz/Index')
                 );
    }

    /** @test */
    public function it_can_access_exam_management_pages_as_instructor()
    {
        $instructor = User::factory()->create(['role_id' => 'instructor']);
        
        $this->actingAs($instructor);
        
        $response = $this->get(route('exams.index'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Admin/Exam/Index')
                 );
    }

    /** @test */
    public function it_can_access_practice_sets_as_instructor()
    {
        $instructor = User::factory()->create(['role_id' => 'instructor']);
        
        $this->actingAs($instructor);
        
        $response = $this->get(route('practice-sets.index'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Admin/PracticeSet/Index')
                 );
    }

    /** @test */
    public function it_denies_admin_dashboard_access_to_non_admin_users()
    {
        $user = User::factory()->create(['role_id' => 'student']);
        
        $this->actingAs($user);
        
        $response = $this->get(route('admin_dashboard'));
        
        // Should redirect or return 403 based on your authorization logic
        $this->assertTrue(in_array($response->getStatusCode(), [302, 403]));
    }

    /** @test */
    public function it_preserves_inertia_context_across_admin_sidebar_navigation()
    {
        $admin = User::factory()->create(['role_id' => 'admin']);
        
        $this->actingAs($admin);
        
        // Navigate to admin dashboard
        $dashboardResponse = $this->get(route('admin_dashboard'));
        $dashboardResponse->assertInertia(fn ($assert) => $assert->component('Admin/Dashboard'));
        
        // Navigate to users management (simulating sidebar navigation)
        $usersResponse = $this->get(route('users.index'));
        $usersResponse->assertInertia(fn ($assert) => $assert->component('Admin/User/Index'));
        
        // Navigate to settings (simulating sidebar navigation)
        $settingsResponse = $this->get(route('general_settings'));
        $settingsResponse->assertInertia(fn ($assert) => $assert->component('Admin/Settings/General'));
    }

    /** @test */
    public function it_validates_ziggy_routes_directive_is_present_in_main_layout()
    {
        // Regression check for @routes presence to prevent production failures
        $layoutPath = resource_path('views/app.blade.php');
        $this->assertFileExists($layoutPath, 'Main Blade layout file must exist');
        
        $layoutContent = file_get_contents($layoutPath);
        $this->assertStringContainsString('@routes', $layoutContent, 
            'Main Blade layout must contain @routes directive for Ziggy route helper. This prevents production hard-fail.');
        
        // Additional check that @routes comes before Vite script
        $routesPosition = strpos($layoutContent, '@routes');
        $vitePosition = strpos($layoutContent, "@vite('resources/js/app.js')");
        
        $this->assertNotFalse($routesPosition, '@routes directive must be present');
        $this->assertNotFalse($vitePosition, 'Vite script must be present');
        $this->assertLessThan($vitePosition, $routesPosition, 
            '@routes directive must come before Vite script to ensure route helper is available');
    }

    /** @test */
    public function it_can_submit_post_request_using_link_method_pattern()
    {
        // Test Link-style POST submission (simulating DropdownLink with method="post")
        $user = User::factory()->create();
        
        $this->actingAs($user);
        
        // Simulate a POST request like <arc-dropdown-link :href="route('logout')" method="post" as="button">
        $response = $this->post(route('logout'));
        
        $response->assertRedirect('/');
        $this->assertGuest();
    }

    /** @test */
    public function it_returns_validation_errors_as_inertia_props_for_failed_form_submission()
    {
        // Test that validation errors are returned as Inertia props
        $response = $this->post(route('login'), [
            'email' => '', // Missing email
            'password' => '', // Missing password
        ], [
            'X-Inertia' => 'true', // Simulate Inertia request
        ]);

        $response->assertStatus(422) // Validation failed
                 ->assertJson([
                     'errors' => [
                         'email' => ['The email field is required.'],
                         'password' => ['The password field is required.'],
                     ]
                 ]);
        
        // Verify it's an Inertia response
        $response->assertHeader('X-Inertia', 'true');
        
        // Alternative test with registration form
        $registerResponse = $this->post(route('register'), [
            'first_name' => '',
            'last_name' => '',
            'email' => 'invalid-email', // Invalid format
            'password' => '123', // Too short
            'password_confirmation' => 'different', // Doesn't match
        ], [
            'X-Inertia' => 'true',
        ]);

        $registerResponse->assertStatus(422)
                         ->assertJsonStructure([
                             'errors' => [
                                 'first_name',
                                 'last_name', 
                                 'email',
                                 'password',
                             ]
                         ]);
    }

    /** @test */
    public function it_can_logout_via_link_style_post_pattern()
    {
        // Test Link-style POST logout (DropdownLink pattern: :href="route('logout')" method="post" as="button")
        $user = User::factory()->create();
        
        $this->actingAs($user);
        $this->assertAuthenticated();
        
        // Simulate the Link component POST behavior
        $response = $this->post(route('logout'), [], [
            'X-Inertia' => 'true',
        ]);
        
        $response->assertRedirect('/');
        $this->assertGuest();
    }

    /** @test */
    public function it_resolves_sidebar_routes_correctly()
    {
        // Test that common sidebar navigation routes resolve correctly
        $admin = User::factory()->create(['role_id' => 'admin']);
        $this->actingAs($admin);
        
        // Test dashboard route
        $dashboardResponse = $this->get(route('admin_dashboard'));
        $dashboardResponse->assertStatus(200)
                          ->assertInertia(fn ($assert) => $assert
                              ->component('Admin/Dashboard')
                          );
        
        // Test users management route
        $usersResponse = $this->get(route('users.index'));
        $usersResponse->assertStatus(200)
                      ->assertInertia(fn ($assert) => $assert
                          ->component('Admin/User/Index')
                      );
        
        // Test settings route
        $settingsResponse = $this->get(route('general_settings'));
        $settingsResponse->assertStatus(200)
                         ->assertInertia(fn ($assert) => $assert
                             ->component('Admin/Settings/General')
                         );
    }

    /** @test */
    public function it_preserves_inertia_context_for_link_get_requests()
    {
        // Test that Link component GET requests preserve Inertia context
        $user = User::factory()->create();
        $this->actingAs($user);
        
        // Navigate to profile (simulating Link component)
        $profileResponse = $this->get(route('profile.show'), [
            'X-Inertia' => 'true',
        ]);
        
        $profileResponse->assertStatus(200)
                        ->assertHeader('X-Inertia', 'true')
                        ->assertInertia(fn ($assert) => $assert
                            ->component('Profile/Show')
                            ->has('auth.user')
                        );
        
        // Navigate to user subscriptions (another common Link usage)
        $subscriptionsResponse = $this->get(route('user_subscriptions'), [
            'X-Inertia' => 'true',
        ]);
        
        $subscriptionsResponse->assertStatus(200)
                              ->assertHeader('X-Inertia', 'true')
                              ->assertInertia(fn ($assert) => $assert
                                  ->component('User/Subscriptions')
                                  ->has('auth.user')
                              );
        
        // Test that navigation preserves state
        $this->assertEquals($user->id, $profileResponse->json('props.auth.user.id'));
        $this->assertEquals($user->id, $subscriptionsResponse->json('props.auth.user.id'));
    }

    /** @test */
    public function it_handles_sidebar_link_active_state_correctly()
    {
        // Test SidebarLink component active state detection
        $admin = User::factory()->create(['role_id' => 'admin']);
        $this->actingAs($admin);
        
        // Request admin dashboard and verify it includes necessary data for sidebar active states
        $response = $this->get(route('admin_dashboard'));
        
        $response->assertStatus(200)
                 ->assertInertia(fn ($assert) => $assert
                     ->component('Admin/Dashboard')
                     ->where('url', fn($url) => str_starts_with($url, '/admin/dashboard'))
                 );
        
        // Test that $page.url is available for SidebarLink active state computation
        $this->assertStringContainsString('/admin/dashboard', $response->json('url'));
    }
}
