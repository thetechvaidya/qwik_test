<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;

class AdminAdditionalPagesTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsAdmin();
    }

    #[Test]
    public function test_user_groups_crud_operations()
    {
        // Test listing user groups
        $response = $this->get(route('admin.user-groups.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/UserGroups'));

        // Test creating user group
        $groupData = [
            'name' => 'Test Group',
            'description' => 'Test group description',
            'is_active' => true
        ];

        $response = $this->post(route('admin.user-groups.store'), $groupData);
        $response->assertRedirect();
        $this->assertDatabaseHas('user_groups', ['name' => 'Test Group']);
    }

    #[Test]
    public function test_sessions_crud_operations()
    {
        // Test listing sessions
        $response = $this->get(route('admin.sessions.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/Sessions'));

        // Test session management
        $session = \App\Models\Session::factory()->create();
        $response = $this->delete(route('admin.sessions.destroy', $session));
        $response->assertRedirect();
    }

    /**
     * Helper method to act as an admin user
     */
    private function actingAsAdmin()
    {
        $admin = \App\Models\User::factory()->create([
            'role' => 'admin',
            'email_verified_at' => now()
        ]);
        
        return $this->actingAs($admin);
    }
}
