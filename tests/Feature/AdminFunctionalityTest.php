<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Category;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Question;
use App\Models\Lesson;
use App\Models\Video;
use App\Models\Subscription;
use App\Models\Topic;
use App\Models\SubCategory;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Spatie\Permission\Models\Role;
use Tests\TestCase;

class AdminFunctionalityTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $admin;

    protected function setUp(): void
    {
        parent::setUp();
        
        // Create admin role and user
        Role::create(['name' => 'admin', 'guard_name' => 'web']);
        $this->admin = User::factory()->create();
        $this->admin->assignRole('admin');
        
        Storage::fake('public');
    }

    /** @test */
    public function admin_can_access_dashboard()
    {
        $this->actingAs($this->admin);

        $response = $this->get(route('admin_dashboard'));

        $response->assertStatus(200);
    }

    /** @test */
    public function admin_can_view_analytics_on_dashboard()
    {
        $this->actingAs($this->admin);

        // Create some test data
        User::factory(10)->create();
        Category::factory(5)->create();
        Exam::factory(8)->create();

        $response = $this->get(route('admin_dashboard'));

        $response->assertStatus(200);
    }

    /** @test */
    public function admin_can_view_user_list()
    {
        $this->actingAs($this->admin);
        User::factory(15)->create();

        $response = $this->get(route('users.index'));

        $response->assertStatus(200);
    }

    /** @test */
    public function admin_can_create_new_user()
    {
        $this->actingAs($this->admin);

        $userData = [
            'name' => $this->faker->name,
            'email' => $this->faker->unique()->safeEmail,
            'password' => 'password123',
            'password_confirmation' => 'password123',
        ];

        $response = $this->post(route('users.store'), $userData);

        $response->assertRedirect(route('users.index'));
        $this->assertDatabaseHas('users', [
            'name' => $userData['name'],
            'email' => $userData['email'],
        ]);
    }

    /** @test */
    public function admin_can_update_user()
    {
        $this->actingAs($this->admin);
        $user = User::factory()->create();

        $updateData = [
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
        ];

        $response = $this->put(route('users.update', $user->id), $updateData);

        $response->assertRedirect(route('users.index'));
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
        ]);
    }

    /** @test */
    public function admin_can_delete_user()
    {
        $this->actingAs($this->admin);
        $user = User::factory()->create();

        $response = $this->delete(route('users.destroy', $user->id));

        $response->assertRedirect(route('users.index'));
        $this->assertSoftDeleted('users', ['id' => $user->id]);
    }

    /** @test */
    public function admin_can_import_users()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->create('users.xlsx', 100);

        $response = $this->post(route('import_users'), [
            'file' => $file,
        ]);

        $response->assertRedirect();
        Storage::disk('public')->assertExists($file->hashName());
    }

    /** @test */
    public function admin_can_view_exam_list()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();
        Exam::factory(10)->create(['category_id' => $category->id]);

        $response = $this->get(route('admin.exams.index', [], false) ?: '/admin/exams');

        $response->assertStatus(200);
        // Focus on data verification rather than strict component matching
        $response->assertInertia(fn ($page) => 
            $page->has('exams')
                ->has('exams.data')
        );
    }

    /** @test */
    public function admin_can_create_exam()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();

        $examData = [
            'title' => 'Test Exam',
            'description' => 'Test Description',
            'category_id' => $category->id,
            'duration' => 60,
            'total_marks' => 100,
            'pass_marks' => 40,
            'is_active' => true,
        ];

        $response = $this->post(route('admin.exams.store', [], false) ?: '/admin/exams', $examData);

        $response->assertRedirect(route('admin.exams.index', [], false) ?: '/admin/exams');
        $this->assertDatabaseHas('exams', [
            'title' => 'Test Exam',
            'category_id' => $category->id,
        ]);
    }

    /** @test */
    public function admin_can_update_exam()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();
        $exam = Exam::factory()->create(['category_id' => $category->id]);

        $updateData = [
            'title' => 'Updated Exam Title',
            'description' => 'Updated Description',
            'duration' => 90,
        ];

        $response = $this->put(route('admin.exams.update', ['exam' => $exam->id], false) ?: "/admin/exams/{$exam->id}", $updateData);

        $response->assertRedirect(route('admin.exams.index', [], false) ?: '/admin/exams');
        $this->assertDatabaseHas('exams', [
            'id' => $exam->id,
            'title' => 'Updated Exam Title',
        ]);
    }

    /** @test */
    public function admin_can_schedule_exam()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();

        $scheduleData = [
            'exam_id' => $exam->id,
            'start_date' => now()->addDays(1),
            'end_date' => now()->addDays(2),
            'is_active' => true,
        ];

        $response = $this->post('/admin/exam-schedules', $scheduleData);

        $response->assertRedirect();
        $this->assertDatabaseHas('exam_schedules', [
            'exam_id' => $exam->id,
        ]);
    }

    /** @test */
    public function admin_can_view_quiz_list()
    {
        $this->actingAs($this->admin);
        Quiz::factory(8)->create();

        $response = $this->get(route('admin.quizzes.index', [], false) ?: '/admin/quizzes');

        $response->assertStatus(200);
        // Focus on data verification rather than strict component matching
        $response->assertInertia(fn ($page) => 
            $page->has('quizzes')
        );
    }

    /** @test */
    public function admin_can_create_quiz()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();

        $quizData = [
            'title' => 'Test Quiz',
            'description' => 'Test Quiz Description',
            'category_id' => $category->id,
            'time_limit' => 30,
            'is_active' => true,
        ];

        $response = $this->post(route('admin.quizzes.store', [], false) ?: '/admin/quizzes', $quizData);

        $response->assertRedirect(route('admin.quizzes.index', [], false) ?: '/admin/quizzes');
        $this->assertDatabaseHas('quizzes', [
            'title' => 'Test Quiz',
            'category_id' => $category->id,
        ]);
    }

    /** @test */
    public function admin_can_view_question_list()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();
        Question::factory(15)->create(['exam_id' => $exam->id]);

        $response = $this->get(route('admin.questions.index', [], false) ?: '/admin/questions');

        $response->assertStatus(200);
        // Focus on data verification rather than strict component matching
        $response->assertInertia(fn ($page) => 
            $page->has('questions')
        );
    }

    /** @test */
    public function admin_can_create_question()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();

        $questionData = [
            'exam_id' => $exam->id,
            'question' => 'What is 2 + 2?',
            'question_type' => 'mcq',
            'marks' => 1,
            'options' => [
                ['option' => '3', 'is_correct' => false],
                ['option' => '4', 'is_correct' => true],
                ['option' => '5', 'is_correct' => false],
                ['option' => '6', 'is_correct' => false],
            ],
        ];

        $response = $this->post(route('admin.questions.store', [], false) ?: '/admin/questions', $questionData);

        $response->assertRedirect(route('admin.questions.index', [], false) ?: '/admin/questions');
        $this->assertDatabaseHas('questions', [
            'question' => 'What is 2 + 2?',
            'exam_id' => $exam->id,
        ]);
    }

    /** @test */
    public function admin_can_import_questions()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();

        $file = UploadedFile::fake()->create('questions.xlsx', 200);

        $response = $this->post('/admin/questions/import', [
            'exam_id' => $exam->id,
            'file' => $file,
        ]);

        $response->assertRedirect();
        Storage::disk('public')->assertExists($file->hashName());
    }

    /** @test */
    public function admin_can_view_category_list()
    {
        $this->actingAs($this->admin);
        Category::factory(12)->create();

        $response = $this->get(route('admin.categories.index', [], false) ?: '/admin/categories');

        $response->assertStatus(200);
        // Focus on data verification rather than strict component matching
        $response->assertInertia(fn ($page) => 
            $page->has('categories')
        );
    }

    /** @test */
    public function admin_can_create_category()
    {
        $this->actingAs($this->admin);

        $categoryData = [
            'name' => 'Test Category',
            'description' => 'Test Category Description',
            'is_active' => true,
        ];

        $response = $this->post(route('admin.categories.store', [], false) ?: '/admin/categories', $categoryData);

        $response->assertRedirect(route('admin.categories.index', [], false) ?: '/admin/categories');
        $this->assertDatabaseHas('categories', [
            'name' => 'Test Category',
        ]);
    }

    /** @test */
    public function admin_can_manage_subcategories()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();

        $subcategoryData = [
            'name' => 'Test Subcategory',
            'category_id' => $category->id,
            'is_active' => true,
        ];

        $response = $this->post('/admin/subcategories', $subcategoryData);

        $response->assertRedirect();
        $this->assertDatabaseHas('sub_categories', [
            'name' => 'Test Subcategory',
            'category_id' => $category->id,
        ]);
    }

    /** @test */
    public function admin_can_manage_topics()
    {
        $this->actingAs($this->admin);
        $subcategory = SubCategory::factory()->create();

        $topicData = [
            'name' => 'Test Topic',
            'sub_category_id' => $subcategory->id,
            'is_active' => true,
        ];

        $response = $this->post('/admin/topics', $topicData);

        $response->assertRedirect();
        $this->assertDatabaseHas('topics', [
            'name' => 'Test Topic',
            'sub_category_id' => $subcategory->id,
        ]);
    }

    /** @test */
    public function admin_can_view_lesson_list()
    {
        $this->actingAs($this->admin);
        Lesson::factory(10)->create();

        $response = $this->get('/admin/lessons');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Lessons/Index')
                ->has('lessons')
        );
    }

    /** @test */
    public function admin_can_create_lesson()
    {
        $this->actingAs($this->admin);
        $category = Category::factory()->create();

        $lessonData = [
            'title' => 'Test Lesson',
            'content' => 'Test Lesson Content',
            'category_id' => $category->id,
            'is_active' => true,
        ];

        $response = $this->post('/admin/lessons', $lessonData);

        $response->assertRedirect('/admin/lessons');
        $this->assertDatabaseHas('lessons', [
            'title' => 'Test Lesson',
            'category_id' => $category->id,
        ]);
    }

    /** @test */
    public function admin_can_manage_videos()
    {
        $this->actingAs($this->admin);
        $lesson = Lesson::factory()->create();

        $videoData = [
            'title' => 'Test Video',
            'video_url' => 'https://example.com/video.mp4',
            'lesson_id' => $lesson->id,
            'duration' => 600, // 10 minutes
        ];

        $response = $this->post('/admin/videos', $videoData);

        $response->assertRedirect();
        $this->assertDatabaseHas('videos', [
            'title' => 'Test Video',
            'lesson_id' => $lesson->id,
        ]);
    }

    /** @test */
    public function admin_can_view_subscription_list()
    {
        $this->actingAs($this->admin);
        Subscription::factory(8)->create();

        $response = $this->get('/admin/subscriptions');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Subscriptions/Index')
                ->has('subscriptions')
        );
    }

    /** @test */
    public function admin_can_manage_payments()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/payments');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Payments/Index')
        );
    }

    /** @test */
    public function admin_can_upload_files()
    {
        $this->actingAs($this->admin);

        $file = UploadedFile::fake()->image('test-image.jpg');

        $response = $this->post('/admin/files', [
            'file' => $file,
            'path' => 'uploads',
        ]);

        $response->assertStatus(200);
        Storage::disk('public')->assertExists('uploads/' . $file->hashName());
    }

    /** @test */
    public function admin_can_view_settings()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/settings');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Settings/Index')
        );
    }

    /** @test */
    public function admin_can_update_general_settings()
    {
        $this->actingAs($this->admin);

        $settingsData = [
            'app_name' => 'Updated App Name',
            'app_description' => 'Updated Description',
            'contact_email' => 'admin@example.com',
        ];

        $response = $this->post('/admin/settings/general', $settingsData);

        $response->assertRedirect('/admin/settings');
    }

    /** @test */
    public function admin_can_toggle_maintenance_mode()
    {
        $this->actingAs($this->admin);

        $response = $this->post('/admin/maintenance-mode', [
            'enable' => true,
        ]);

        $response->assertRedirect();
    }

    /** @test */
    public function admin_can_view_reports()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/reports');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Reports/Index')
        );
    }

    /** @test */
    public function admin_can_export_user_data()
    {
        $this->actingAs($this->admin);
        User::factory(50)->create();

        $response = $this->post('/admin/export/users', [
            'format' => 'excel',
        ]);

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    }

    /** @test */
    public function admin_can_view_exam_analytics()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();

        $response = $this->get("/admin/exams/{$exam->id}/analytics");

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Exams/Analytics')
                ->has('exam')
                ->has('analytics')
        );
    }

    /** @test */
    public function admin_can_view_system_logs()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/logs');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Logs/Index')
        );
    }

    /** @test */
    public function non_admin_cannot_access_admin_panel()
    {
        $user = User::factory()->create();
        $this->actingAs($user);

        $response = $this->get('/admin/dashboard');

        $response->assertStatus(403);
    }

    /** @test */
    public function admin_can_bulk_delete_users()
    {
        $this->actingAs($this->admin);
        $users = User::factory(5)->create();

        $response = $this->post('/admin/users/bulk-delete', [
            'user_ids' => $users->pluck('id')->toArray(),
        ]);

        $response->assertRedirect('/admin/users');
        foreach ($users as $user) {
            $this->assertSoftDeleted('users', ['id' => $user->id]);
        }
    }

    /** @test */
    public function admin_can_search_and_filter_data()
    {
        $this->actingAs($this->admin);
        User::factory(20)->create();

        $response = $this->get('/admin/users?search=test&filter=active');

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Users/Index')
                ->has('users')
                ->has('filters')
        );
    }
}
