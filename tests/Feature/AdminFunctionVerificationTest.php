<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\Admin;
use App\Models\User;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Practice;
use App\Models\Question;
use App\Models\Category;
use App\Models\Lesson;
use App\Models\Setting;
use App\Models\Role;
use App\Models\Permission;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Mail;
use App\Mail\UserWelcome;

class AdminFunctionVerificationTest extends TestCase
{
    use RefreshDatabase;

    protected $admin;
    protected $superAdmin;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->admin = Admin::factory()->create([
            'role' => 'admin',
        ]);
        
        $this->superAdmin = Admin::factory()->create([
            'role' => 'super_admin',
        ]);
    }

    /** @test */
    public function test_admin_dashboard_and_analytics()
    {
        $this->actingAs($this->admin, 'admin');
        
        // Create test data for dashboard statistics
        $users = User::factory(50)->create();
        $exams = Exam::factory(10)->create(['status' => 'published']);
        $quizzes = Quiz::factory(15)->create(['status' => 'published']);
        $practices = Practice::factory(20)->create(['status' => 'published']);
        
        // Create submissions for analytics
        foreach ($users->take(30) as $user) {
            $user->examSubmissions()->create([
                'exam_id' => $exams->random()->id,
                'score' => rand(60, 100),
                'total_marks' => 100,
                'status' => 'submitted',
            ]);
        }

        // Test admin dashboard access
        $response = $this->get('/admin/dashboard');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Dashboard')
            ->has('stats')
            ->has('recentActivities')
            ->has('chartData')
        );

        // Test real-time statistics
        $response = $this->get('/admin/api/stats');
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'users_count',
            'exams_count',
            'submissions_today',
            'active_sessions',
        ]);

        // Test analytics charts data
        $response = $this->get('/admin/api/analytics/chart-data');
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'user_registrations',
            'exam_submissions',
            'performance_trends',
        ]);

        // Test data export functionality
        $response = $this->post('/admin/export/users', [
            'format' => 'excel',
            'filters' => ['status' => 'active'],
        ]);
        $response->assertStatus(200);
        $response->assertHeader('content-type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        // Test PDF report generation
        $response = $this->post('/admin/reports/performance', [
            'date_range' => '30',
            'format' => 'pdf',
        ]);
        $response->assertStatus(200);
        $response->assertHeader('content-type', 'application/pdf');
    }

    /** @test */
    public function test_user_management_crud_operations()
    {
        $this->actingAs($this->admin, 'admin');
        
        // Test user listing with pagination and search
        $users = User::factory(25)->create();
        
        $response = $this->get('/admin/users');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Users/Index')
            ->has('users.data')
            ->has('users.links')
        );

        // Test user search
        $searchUser = $users->first();
        $response = $this->get('/admin/users?search=' . $searchUser->name);
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Users/Index')
            ->has('users.data')
        );

        // Test user creation
        Mail::fake();
        
        $response = $this->get('/admin/users/create');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Users/Create')
        );

        $userData = [
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'phone' => '+1234567890',
            'date_of_birth' => '1990-01-01',
            'gender' => 'male',
            'send_welcome_email' => true,
        ];

        $response = $this->post('/admin/users', $userData);
        $response->assertRedirect('/admin/users');
        
        $this->assertDatabaseHas('users', [
            'name' => 'John Doe',
            'email' => 'john.doe@example.com',
        ]);
        
        Mail::assertSent(UserWelcome::class);

        // Test user editing
        $user = User::where('email', 'john.doe@example.com')->first();
        
        $response = $this->get("/admin/users/{$user->id}/edit");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Users/Edit')
            ->where('user.id', $user->id)
        );

        $response = $this->put("/admin/users/{$user->id}", [
            'name' => 'John Smith',
            'email' => 'john.smith@example.com',
            'phone' => '+1234567891',
        ]);
        $response->assertRedirect('/admin/users');
        
        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'name' => 'John Smith',
            'email' => 'john.smith@example.com',
        ]);

        // Test bulk user operations
        $selectedUsers = User::take(5)->pluck('id')->toArray();
        
        $response = $this->post('/admin/users/bulk-action', [
            'action' => 'activate',
            'user_ids' => $selectedUsers,
        ]);
        $response->assertStatus(200);

        // Test user import from CSV
        Storage::fake('local');
        
        $csvContent = "name,email,password\n";
        $csvContent .= "Alice Johnson,alice@example.com,password123\n";
        $csvContent .= "Bob Wilson,bob@example.com,password123\n";
        
        $csvFile = UploadedFile::fake()->createWithContent('users.csv', $csvContent);
        
        $response = $this->post('/admin/users/import', [
            'csv_file' => $csvFile,
            'send_welcome_emails' => false,
        ]);
        $response->assertStatus(200);
        
        $this->assertDatabaseHas('users', ['email' => 'alice@example.com']);
        $this->assertDatabaseHas('users', ['email' => 'bob@example.com']);

        // Test user deletion with soft delete
        $response = $this->delete("/admin/users/{$user->id}");
        $response->assertRedirect('/admin/users');
        
        $this->assertSoftDeleted('users', ['id' => $user->id]);
    }

    /** @test */
    public function test_content_management_operations()
    {
        $this->actingAs($this->admin, 'admin');
        
        $category = Category::factory()->create(['name' => 'Mathematics']);
        
        // Test exam creation and management
        $response = $this->get('/admin/exams/create');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Exams/Create')
            ->has('categories')
        );

        $examData = [
            'title' => 'Advanced Calculus Exam',
            'description' => 'Comprehensive exam on calculus topics',
            'category_id' => $category->id,
            'duration' => 180,
            'total_marks' => 150,
            'passing_marks' => 90,
            'start_date' => now()->addDays(7)->format('Y-m-d H:i'),
            'end_date' => now()->addDays(14)->format('Y-m-d H:i'),
            'instructions' => 'Read all questions carefully. Show your work for partial credit.',
            'negative_marking' => true,
            'negative_marks' => 0.25,
            'is_public' => true,
            'status' => 'draft',
        ];

        $response = $this->post('/admin/exams', $examData);
        $response->assertRedirect();
        
        $exam = Exam::where('title', 'Advanced Calculus Exam')->first();
        $this->assertNotNull($exam);

        // Test question bank management with different question types
        $response = $this->get("/admin/exams/{$exam->id}/questions/create");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Questions/Create')
            ->where('exam.id', $exam->id)
        );

        // Create MSA question with rich text
        $msaQuestionData = [
            'type' => 'msa',
            'question_text' => json_encode([
                'type' => 'doc',
                'content' => [
                    [
                        'type' => 'paragraph',
                        'content' => [
                            ['type' => 'text', 'text' => 'Find the integral of '],
                            ['type' => 'text', 'marks' => [['type' => 'math']], 'text' => '∫x²dx'],
                        ],
                    ],
                ],
            ]),
            'options' => [
                'A' => 'x³/3 + C',
                'B' => '2x + C',
                'C' => 'x³ + C',
                'D' => '3x² + C',
            ],
            'correct_answer' => 'A',
            'marks' => 5,
            'explanation' => 'Using the power rule for integration: ∫x²dx = x³/3 + C',
            'difficulty' => 'medium',
        ];

        $response = $this->post("/admin/exams/{$exam->id}/questions", $msaQuestionData);
        $response->assertRedirect();
        
        $this->assertDatabaseHas('questions', [
            'exam_id' => $exam->id,
            'type' => 'msa',
            'correct_answer' => 'A',
        ]);

        // Create MMA question
        $mmaQuestionData = [
            'type' => 'mma',
            'question_text' => 'Which of the following are properties of continuous functions? (Select all that apply)',
            'options' => [
                'A' => 'Intermediate Value Theorem applies',
                'B' => 'Must be differentiable everywhere',
                'C' => 'Can be integrated over closed intervals',
                'D' => 'Must be bounded on closed intervals',
                'E' => 'Limit exists at every point in domain',
            ],
            'correct_answer' => ['A', 'C', 'D', 'E'],
            'marks' => 8,
            'partial_marking' => true,
            'explanation' => 'Continuous functions satisfy IVT, are integrable, bounded on closed intervals, and have limits at every point.',
        ];

        $response = $this->post("/admin/exams/{$exam->id}/questions", $mmaQuestionData);
        $response->assertRedirect();

        // Create Fill in the Blanks question
        $fibQuestionData = [
            'type' => 'fib',
            'question_text' => 'The fundamental theorem of calculus states that if F\'(x) = f(x), then ∫[a to b] f(x)dx = ___ - ___',
            'blanks_count' => 2,
            'correct_answer' => ['F(b)', 'F(a)'],
            'marks' => 4,
            'case_sensitive' => false,
        ];

        $response = $this->post("/admin/exams/{$exam->id}/questions", $fibQuestionData);
        $response->assertRedirect();

        // Test question editing
        $question = Question::where('exam_id', $exam->id)->first();
        
        $response = $this->get("/admin/questions/{$question->id}/edit");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Questions/Edit')
            ->where('question.id', $question->id)
        );

        $response = $this->put("/admin/questions/{$question->id}", [
            'question_text' => 'Updated question text',
            'marks' => 6,
        ]);
        $response->assertRedirect();

        // Test bulk question import
        $questionsData = [
            [
                'type' => 'msa',
                'question_text' => 'What is the derivative of sin(x)?',
                'options' => ['A' => 'cos(x)', 'B' => '-cos(x)', 'C' => 'sin(x)', 'D' => '-sin(x)'],
                'correct_answer' => 'A',
                'marks' => 3,
            ],
            [
                'type' => 'msa',
                'question_text' => 'What is the derivative of cos(x)?',
                'options' => ['A' => 'sin(x)', 'B' => '-sin(x)', 'C' => 'cos(x)', 'D' => '-cos(x)'],
                'correct_answer' => 'B',
                'marks' => 3,
            ],
        ];

        $response = $this->post("/admin/exams/{$exam->id}/questions/bulk-import", [
            'questions' => $questionsData,
        ]);
        $response->assertStatus(200);
        
        $this->assertDatabaseHas('questions', [
            'exam_id' => $exam->id,
            'question_text' => 'What is the derivative of sin(x)?',
        ]);

        // Test quiz management
        $quizData = [
            'title' => 'Quick Math Quiz',
            'description' => 'Test your basic math skills',
            'category_id' => $category->id,
            'time_limit' => 15,
            'questions_count' => 10,
            'show_correct_answer' => true,
            'allow_review' => true,
            'is_public' => true,
            'status' => 'published',
        ];

        $response = $this->post('/admin/quizzes', $quizData);
        $response->assertRedirect();
        
        $quiz = Quiz::where('title', 'Quick Math Quiz')->first();
        $this->assertNotNull($quiz);

        // Test practice set management
        $lesson = Lesson::factory()->create(['title' => 'Differentiation Basics']);
        
        $practiceData = [
            'title' => 'Derivatives Practice',
            'description' => 'Practice problems on finding derivatives',
            'lesson_id' => $lesson->id,
            'difficulty' => 'beginner',
            'estimated_time' => 45,
            'is_public' => true,
            'status' => 'published',
        ];

        $response = $this->post('/admin/practices', $practiceData);
        $response->assertRedirect();
        
        $practice = Practice::where('title', 'Derivatives Practice')->first();
        $this->assertNotNull($practice);
    }

    /** @test */
    public function test_rich_text_editing_with_tiptap()
    {
        Storage::fake('public');
        $this->actingAs($this->admin, 'admin');

        // Test image upload for rich text content
        $image = UploadedFile::fake()->image('formula-diagram.png', 800, 600);
        
        $response = $this->post('/admin/editor/upload-image', [
            'image' => $image,
        ]);
        
        $response->assertStatus(200);
        $response->assertJsonStructure(['url']);
        Storage::disk('public')->assertExists('editor/' . $image->hashName());

        // Test creating question with rich text content using Tiptap format
        $exam = Exam::factory()->create();
        
        $richTextQuestion = [
            'type' => 'saq',
            'question_text' => json_encode([
                'type' => 'doc',
                'content' => [
                    [
                        'type' => 'heading',
                        'attrs' => ['level' => 2],
                        'content' => [['type' => 'text', 'text' => 'Problem 1: Integration by Parts']],
                    ],
                    [
                        'type' => 'paragraph',
                        'content' => [
                            ['type' => 'text', 'text' => 'Evaluate the integral '],
                            ['type' => 'text', 'marks' => [['type' => 'math']], 'text' => '∫x·e^x dx'],
                            ['type' => 'text', 'text' => ' using integration by parts.'],
                        ],
                    ],
                    [
                        'type' => 'paragraph',
                        'content' => [
                            ['type' => 'text', 'text' => 'Hint: Use the formula '],
                            ['type' => 'text', 'marks' => [['type' => 'bold']], 'text' => '∫u dv = uv - ∫v du'],
                        ],
                    ],
                    [
                        'type' => 'image',
                        'attrs' => [
                            'src' => Storage::url('editor/' . $image->hashName()),
                            'alt' => 'Integration by parts diagram',
                        ],
                    ],
                ],
            ]),
            'marks' => 10,
            'word_limit' => 200,
        ];

        $response = $this->post("/admin/exams/{$exam->id}/questions", $richTextQuestion);
        $response->assertRedirect();
        
        // Verify rich text content is stored correctly
        $question = Question::where('exam_id', $exam->id)->latest()->first();
        $questionData = json_decode($question->question_text, true);
        $this->assertEquals('doc', $questionData['type']);
        $this->assertIsArray($questionData['content']);
    }

    /** @test */
    public function test_file_upload_and_media_management()
    {
        Storage::fake('public');
        $this->actingAs($this->admin, 'admin');

        // Test media library access
        $response = $this->get('/admin/media');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Media/Index')
        );

        // Test file upload
        $documents = [
            UploadedFile::fake()->create('syllabus.pdf', 2048, 'application/pdf'),
            UploadedFile::fake()->image('question-diagram.png', 1024, 768),
            UploadedFile::fake()->create('reference-sheet.docx', 1024, 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'),
        ];

        foreach ($documents as $file) {
            $response = $this->post('/admin/media/upload', [
                'file' => $file,
                'category' => 'documents',
                'description' => 'Test file upload',
            ]);
            
            $response->assertStatus(200);
            $response->assertJsonStructure(['id', 'url', 'filename']);
            
            $expectedPath = 'media/documents/' . $file->hashName();
            Storage::disk('public')->assertExists($expectedPath);
        }

        // Test bulk file upload
        $bulkFiles = [
            UploadedFile::fake()->image('image1.jpg', 800, 600),
            UploadedFile::fake()->image('image2.jpg', 800, 600),
            UploadedFile::fake()->image('image3.jpg', 800, 600),
        ];

        $response = $this->post('/admin/media/bulk-upload', [
            'files' => $bulkFiles,
            'category' => 'images',
        ]);
        
        $response->assertStatus(200);
        $response->assertJsonStructure(['uploaded', 'failed']);

        // Test media search and filtering
        $response = $this->get('/admin/media?search=syllabus&type=pdf');
        $response->assertStatus(200);

        // Test media deletion
        $mediaFile = \App\Models\MediaFile::first();
        
        $response = $this->delete("/admin/media/{$mediaFile->id}");
        $response->assertStatus(200);
        
        $this->assertSoftDeleted('media_files', ['id' => $mediaFile->id]);
    }

    /** @test */
    public function test_settings_management()
    {
        $this->actingAs($this->superAdmin, 'admin');

        // Test general settings
        $response = $this->get('/admin/settings');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Settings/Index')
            ->has('settings')
        );

        $generalSettings = [
            'site_name' => 'QuizTime Pro',
            'site_description' => 'Advanced learning and assessment platform',
            'site_url' => 'https://quiztime.example.com',
            'admin_email' => 'admin@quiztime.example.com',
            'timezone' => 'UTC',
            'date_format' => 'Y-m-d',
            'time_format' => 'H:i',
        ];

        $response = $this->post('/admin/settings/general', $generalSettings);
        $response->assertRedirect();
        
        foreach ($generalSettings as $key => $value) {
            $this->assertDatabaseHas('settings', [
                'key' => $key,
                'value' => $value,
            ]);
        }

        // Test theme customization with color picker
        $themeSettings = [
            'primary_color' => '#3B82F6',
            'secondary_color' => '#10B981',
            'success_color' => '#22C55E',
            'warning_color' => '#F59E0B',
            'error_color' => '#EF4444',
            'surface_color' => '#FFFFFF',
            'text_color' => '#1F2937',
            'font_family' => 'Inter',
            'border_radius' => '8',
        ];

        $response = $this->post('/admin/settings/theme', $themeSettings);
        $response->assertRedirect();

        // Test email settings
        $emailSettings = [
            'mail_driver' => 'smtp',
            'mail_host' => 'smtp.mailtrap.io',
            'mail_port' => '587',
            'mail_username' => 'test_user',
            'mail_password' => 'test_password',
            'mail_encryption' => 'tls',
            'mail_from_address' => 'noreply@quiztime.example.com',
            'mail_from_name' => 'QuizTime Pro',
        ];

        $response = $this->post('/admin/settings/email', $emailSettings);
        $response->assertRedirect();

        // Test payment settings
        $paymentSettings = [
            'stripe_public_key' => 'pk_test_example',
            'stripe_secret_key' => 'sk_test_example',
            'paypal_client_id' => 'paypal_client_example',
            'paypal_secret' => 'paypal_secret_example',
            'payment_currency' => 'USD',
            'enable_stripe' => true,
            'enable_paypal' => true,
        ];

        $response = $this->post('/admin/settings/payment', $paymentSettings);
        $response->assertRedirect();

        // Test feature toggles
        $featureSettings = [
            'enable_user_registration' => true,
            'enable_email_verification' => true,
            'enable_social_login' => false,
            'enable_exam_timer' => true,
            'enable_negative_marking' => true,
            'enable_auto_save' => true,
            'enable_dark_mode' => true,
            'enable_rtl_support' => false,
        ];

        $response = $this->post('/admin/settings/features', $featureSettings);
        $response->assertRedirect();
    }

    /** @test */
    public function test_system_administration()
    {
        $this->actingAs($this->superAdmin, 'admin');

        // Test system information
        $response = $this->get('/admin/system');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/System/Index')
            ->has('systemInfo')
            ->has('diskUsage')
        );

        // Test backup management
        $response = $this->post('/admin/system/backup', [
            'include_database' => true,
            'include_files' => true,
            'compression' => 'zip',
        ]);
        $response->assertStatus(200);

        // Test cache management
        $response = $this->post('/admin/system/cache/clear', [
            'cache_types' => ['application', 'config', 'route', 'view'],
        ]);
        $response->assertStatus(200);

        // Test log viewer
        $response = $this->get('/admin/logs');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Admin/Logs/Index')
            ->has('logs')
        );

        // Test maintenance mode
        $response = $this->post('/admin/system/maintenance', [
            'enable' => true,
            'message' => 'System under maintenance. Please check back later.',
        ]);
        $response->assertStatus(200);

        // Disable maintenance mode
        $response = $this->post('/admin/system/maintenance', [
            'enable' => false,
        ]);
        $response->assertStatus(200);
    }

    /** @test */
    public function test_role_and_permission_management()
    {
        $this->actingAs($this->superAdmin, 'admin');

        // Test role creation
        $roleData = [
            'name' => 'Content Manager',
            'description' => 'Can manage exams, quizzes, and questions',
            'permissions' => [
                'view_dashboard',
                'manage_exams',
                'manage_quizzes',
                'manage_questions',
                'view_reports',
            ],
        ];

        $response = $this->post('/admin/roles', $roleData);
        $response->assertRedirect();
        
        $role = Role::where('name', 'Content Manager')->first();
        $this->assertNotNull($role);

        // Test permission assignment
        $response = $this->post("/admin/roles/{$role->id}/permissions", [
            'permissions' => ['manage_users', 'manage_settings'],
        ]);
        $response->assertStatus(200);

        // Test admin user creation with role
        $adminData = [
            'name' => 'Content Manager User',
            'email' => 'content@example.com',
            'password' => 'password123',
            'password_confirmation' => 'password123',
            'role_id' => $role->id,
        ];

        $response = $this->post('/admin/administrators', $adminData);
        $response->assertRedirect();
        
        $this->assertDatabaseHas('admins', [
            'email' => 'content@example.com',
            'role_id' => $role->id,
        ]);

        // Test permission checking
        $contentManager = Admin::where('email', 'content@example.com')->first();
        $this->actingAs($contentManager, 'admin');
        
        // Should have access to exam management
        $response = $this->get('/admin/exams');
        $response->assertStatus(200);
        
        // Should not have access to user management (not in permissions)
        $response = $this->get('/admin/users');
        $response->assertStatus(403);
    }

    /** @test */
    public function test_bulk_operations_and_imports()
    {
        Storage::fake('local');
        $this->actingAs($this->admin, 'admin');

        // Test bulk user creation from CSV
        $usersCsv = "name,email,password,phone,date_of_birth\n";
        $usersCsv .= "Alice Johnson,alice@example.com,password123,+1234567890,1995-01-15\n";
        $usersCsv .= "Bob Smith,bob@example.com,password123,+1234567891,1992-03-20\n";
        $usersCsv .= "Carol Davis,carol@example.com,password123,+1234567892,1988-07-10\n";

        $csvFile = UploadedFile::fake()->createWithContent('users.csv', $usersCsv);

        $response = $this->post('/admin/users/bulk-import', [
            'csv_file' => $csvFile,
            'send_welcome_emails' => false,
            'default_role' => 'student',
        ]);
        
        $response->assertStatus(200);
        $response->assertJson(['imported' => 3, 'failed' => 0]);

        // Test bulk question import from JSON
        $questionsData = [
            [
                'type' => 'msa',
                'question_text' => 'What is 2 + 2?',
                'options' => ['A' => '3', 'B' => '4', 'C' => '5', 'D' => '6'],
                'correct_answer' => 'B',
                'marks' => 1,
                'difficulty' => 'easy',
            ],
            [
                'type' => 'msa',
                'question_text' => 'What is 3 * 4?',
                'options' => ['A' => '12', 'B' => '10', 'C' => '14', 'D' => '16'],
                'correct_answer' => 'A',
                'marks' => 2,
                'difficulty' => 'easy',
            ],
        ];

        $exam = Exam::factory()->create();
        
        $response = $this->post("/admin/exams/{$exam->id}/questions/bulk-import", [
            'questions' => $questionsData,
        ]);
        
        $response->assertStatus(200);
        $response->assertJson(['imported' => 2, 'failed' => 0]);

        // Test bulk operations on existing records
        $users = User::take(5)->get();
        $userIds = $users->pluck('id')->toArray();

        $response = $this->post('/admin/users/bulk-action', [
            'action' => 'suspend',
            'user_ids' => $userIds,
            'reason' => 'Bulk suspension test',
        ]);
        
        $response->assertStatus(200);
        
        foreach ($userIds as $userId) {
            $this->assertDatabaseHas('users', [
                'id' => $userId,
                'status' => 'suspended',
            ]);
        }
    }
}
