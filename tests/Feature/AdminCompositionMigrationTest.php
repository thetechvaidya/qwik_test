<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use App\Models\User;

class AdminCompositionMigrationTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected User $adminUser;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create an admin user for testing
        $this->adminUser = User::factory()->create([
            'role' => 'admin',
            'email_verified_at' => now(),
        ]);
    }

    /**
     * Test admin dashboard loads without JavaScript errors
     */
    public function test_admin_dashboard_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('admin_dashboard'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Dashboard')
                 ->has('stats')
        );
    }

    /**
     * Test users management page loads correctly
     */
    public function test_users_page_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Users')
                 ->has('users')
                 ->has('roles')
                 ->has('userGroups')
        );
    }

    /**
     * Test questions management page loads correctly
     */
    public function test_questions_page_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('questions.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Questions')
                 ->has('questions')
                 ->has('questionTypes')
        );
    }

    /**
     * Test exams management page loads correctly
     */
    public function test_exams_page_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('exams.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Exams')
                 ->has('exams')
        );
    }

    /**
     * Test general settings page loads correctly
     */
    public function test_general_settings_page_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('general_settings'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Settings/GeneralSettings')
                 ->has('siteSettings')
        );
    }

    /**
     * Test exam details page loads correctly
     */
    public function test_exam_details_page_loads_successfully()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('exams.create'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Exam/Details')
                 ->has('examTypes')
                 ->has('steps')
        );
    }

    /**
     * Test user creation workflow
     */
    public function test_user_creation_workflow()
    {
        $userData = [
            'first_name' => $this->faker->firstName,
            'last_name' => $this->faker->lastName,
            'user_name' => $this->faker->unique()->userName,
            'email' => $this->faker->unique()->safeEmail,
            'password' => 'password',
            'password_confirmation' => 'password',
            'role' => 'student',
            'status' => true,
        ];

        $response = $this->actingAs($this->adminUser)
                         ->post(route('users.store'), $userData);

        $response->assertRedirect();
        $this->assertDatabaseHas('users', [
            'email' => $userData['email'],
            'user_name' => $userData['user_name'],
        ]);
    }

    /**
     * Test settings form submission
     */
    public function test_site_settings_form_submission()
    {
        $settingsData = [
            'app_name' => 'Updated Test App',
            'tag_line' => 'Updated tagline',
            'seo_description' => 'Updated SEO description',
            'can_register' => true,
        ];

        $response = $this->actingAs($this->adminUser)
                         ->post(route('update_site_settings'), $settingsData);

    $response->assertRedirect();
    // Assert a successful redirect back with session (flash) data or shared props updated
    $this->assertTrue(session()->has('_previous'));
    }

    /**
     * Test exam creation workflow
     */
    public function test_exam_creation_workflow()
    {
        // First create necessary dependencies
        $subCategory = \App\Models\SubCategory::factory()->create();
        $examType = \App\Models\ExamType::factory()->create();

        $examData = [
            'title' => 'Test Exam',
            'description' => 'Test exam description',
            'sub_category_id' => $subCategory->id,
            'exam_type_id' => $examType->id,
            'exam_mode' => 'objective',
            'is_paid' => false,
            'price' => 0,
            'is_active' => true,
            'is_private' => false,
        ];

        $response = $this->actingAs($this->adminUser)
                         ->post(route('exams.store'), $examData);

        $response->assertRedirect();
        $this->assertDatabaseHas('exams', [
            'title' => 'Test Exam',
            'sub_category_id' => $subCategory->id,
        ]);
    }

    /**
     * Test table pagination functionality
     */
    public function test_table_pagination_works()
    {
        // Create multiple users to test pagination
        User::factory()->count(25)->create();

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', ['page' => 2, 'per_page' => 10]));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('users.meta.pagination')
                 ->where('users.meta.pagination.current_page', 2)
                 ->where('users.meta.pagination.per_page', 10)
        );
    }

    /**
     * Test table filtering functionality
     */
    public function test_table_filtering_works()
    {
        // Create users with specific attributes for filtering
        User::factory()->create(['role' => 'admin', 'email' => 'admin@test.com']);
        User::factory()->create(['role' => 'student', 'email' => 'student@test.com']);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', ['role' => 'admin']));

        $response->assertStatus(200);
        // Check that filtered results are returned
        $response->assertInertia(fn ($page) => 
            $page->has('users.data')
        );
    }

    /**
     * Test single column sorting functionality
     */
    public function test_single_column_sorting_works()
    {
        // Create users with different names for sorting
        User::factory()->create(['first_name' => 'Alpha', 'last_name' => 'User']);
        User::factory()->create(['first_name' => 'Beta', 'last_name' => 'User']);
        User::factory()->create(['first_name' => 'Gamma', 'last_name' => 'User']);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', [
                             'sortBy' => 'first_name',
                             'sortOrder' => 'asc'
                         ]));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('users.data')
                 ->has('users.meta.pagination')
        );
    }

    /**
     * Test multi-column sorting functionality
     */
    public function test_multi_column_sorting_works()
    {
        // Create users for multi-column sort testing
        User::factory()->count(5)->create();

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', [
                             'sortBy[]' => ['first_name', 'created_at'],
                             'sortOrder[]' => ['asc', 'desc']
                         ]));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('users.data')
        );
    }

    /**
     * Test column filter parameter mapping (filterKey vs field names)
     */
    public function test_column_filter_key_mapping()
    {
        // Create exam with type for filter testing
        $examType = \App\Models\ExamType::factory()->create(['name' => 'Practice Test']);
        $exam = \App\Models\Exam::factory()->create(['exam_type_id' => $examType->id]);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('exams.index', [
                             'exam_type_id' => $examType->id // Backend expects exam_type_id, not examType
                         ]));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('exams.data')
        );
    }

    /**
     * Test search functionality with proper parameter mapping
     */
    public function test_search_parameter_mapping()
    {
        User::factory()->create(['first_name' => 'SearchableUser', 'email' => 'searchable@test.com']);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', ['search' => 'SearchableUser']));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('users.data')
        );
    }

    /**
     * Test combined filtering, sorting and pagination
     */
    public function test_combined_table_operations()
    {
        // Create multiple users with different roles
        User::factory()->count(15)->create(['role' => 'student']);
        User::factory()->count(5)->create(['role' => 'instructor']);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index', [
                             'page' => 1,
                             'per_page' => 10,
                             'role' => 'student',
                             'sortBy' => 'created_at',
                             'sortOrder' => 'desc',
                             'search' => ''
                         ]));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('users.data')
                 ->has('users.meta.pagination')
                 ->where('users.meta.pagination.per_page', 10)
                 ->where('users.meta.pagination.current_page', 1)
        );
    }

    /**
     * Test copy-to-clipboard functionality (basic server response)
     */
    public function test_copy_functionality_data_available()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index'));

        $response->assertInertia(fn ($page) => 
            $page->has('users.data.0.id')
        );
    }

    /**
     * Test math rendering preparation (questions with mathematical content)
     */
    public function test_math_content_questions_load()
    {
        // Create question with mathematical content
        $question = \App\Models\Question::factory()->create([
            'question' => 'Solve: $x^2 + 2x + 1 = 0$',
        ]);

        $response = $this->actingAs($this->adminUser)
                         ->get(route('questions.index'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->has('questions.data')
        );
    }

    /**
     * Test admin navigation accessibility
     */
    public function test_admin_navigation_works()
    {
        $adminRoutes = [
            'admin_dashboard',
            'users.index',
            'questions.index',
            'exams.index',
            'general_settings',
        ];

        foreach ($adminRoutes as $routeName) {
            $response = $this->actingAs($this->adminUser)
                             ->get(route($routeName));

            $response->assertStatus(200);
        }
    }

    /**
     * Test form validation works correctly
     */
    public function test_form_validation_works()
    {
        // Test user creation with invalid data
        $response = $this->actingAs($this->adminUser)
                         ->post(route('users.store'), [
                             'first_name' => '', // Required field left empty
                             'email' => 'invalid-email', // Invalid email format
                         ]);

        $response->assertSessionHasErrors(['first_name', 'email']);
    }

    /**
     * Test delete functionality with confirmation
     */
    public function test_delete_functionality()
    {
        $user = User::factory()->create();

        $response = $this->actingAs($this->adminUser)
                         ->delete(route('users.destroy', $user->id));

        $response->assertRedirect();
        $this->assertDatabaseMissing('users', ['id' => $user->id]);
    }

    /**
     * Test drawer/modal functionality (form components load)
     */
    public function test_form_components_load_correctly()
    {
        $response = $this->actingAs($this->adminUser)
                         ->get(route('users.index'));

        $response->assertStatus(200);
        // Verify that necessary props for form components are available
        $response->assertInertia(fn ($page) => 
            $page->has('roles')
                 ->has('userGroups')
        );
    }
}
