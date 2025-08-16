<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Admin;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Question;
use App\Models\Practice;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;

class ComprehensiveIntegrationTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $admin;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create([
            'email_verified_at' => now(),
        ]);
        
        $this->admin = Admin::factory()->create();
    }

    /** @test */
    public function test_user_authentication_flows()
    {
        // Test user registration
        $response = $this->post('/register', [
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'password',
            'password_confirmation' => 'password',
        ]);
        
        $response->assertRedirect('/dashboard');
        $this->assertDatabaseHas('users', ['email' => 'test@example.com']);

        // Test user login
        $response = $this->post('/login', [
            'email' => 'test@example.com',
            'password' => 'password',
        ]);
        
        $response->assertRedirect('/dashboard');

        // Test password reset request
        $response = $this->post('/forgot-password', [
            'email' => 'test@example.com',
        ]);
        
        $response->assertStatus(200);

        // Test logout
        $response = $this->actingAs($this->user)->post('/logout');
        $response->assertRedirect('/');
    }

    /** @test */
    public function test_admin_panel_functionality()
    {
        $this->actingAs($this->admin, 'admin');

        // Test admin dashboard access
        $response = $this->get('/admin/dashboard');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Admin/Dashboard'));

        // Test user management CRUD
        $response = $this->get('/admin/users');
        $response->assertStatus(200);

        // Test user creation
        $response = $this->post('/admin/users', [
            'name' => 'Admin Created User',
            'email' => 'admin-user@example.com',
            'password' => 'password',
        ]);
        $response->assertRedirect();
        $this->assertDatabaseHas('users', ['email' => 'admin-user@example.com']);

        // Test settings management
        $response = $this->get('/admin/settings');
        $response->assertStatus(200);

        $response = $this->post('/admin/settings', [
            'site_name' => 'Updated Site Name',
            'site_description' => 'Updated description',
            'theme_primary_color' => '#3B82F6',
        ]);
        $response->assertRedirect();
    }

    /** @test */
    public function test_exam_workflow()
    {
        $this->actingAs($this->user);
        
        // Create exam with questions
        $exam = Exam::factory()->create([
            'status' => 'published',
            'start_date' => now()->subDay(),
            'end_date' => now()->addDay(),
        ]);

        // Create different question types
        $mcqQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'mcq',
            'question_text' => 'What is 2 + 2?',
            'options' => json_encode([
                'A' => '3',
                'B' => '4',
                'C' => '5',
                'D' => '6'
            ]),
            'correct_answer' => 'B',
            'marks' => 4,
        ]);

        $fillBlanksQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'fill_blanks',
            'question_text' => 'The capital of France is ____.',
            'correct_answer' => 'Paris',
            'marks' => 2,
        ]);

        // Test exam registration
        $response = $this->post("/exams/{$exam->id}/register");
        $response->assertRedirect();
        $this->assertDatabaseHas('exam_registrations', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
        ]);

        // Test exam taking
        $response = $this->get("/exams/{$exam->id}/take");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Exam/Take'));

        // Test question answering
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $mcqQuestion->id,
            'answer' => 'B',
        ]);
        $response->assertStatus(200);

        // Test exam submission
        $response = $this->post("/exams/{$exam->id}/submit", [
            'answers' => [
                $mcqQuestion->id => 'B',
                $fillBlanksQuestion->id => 'Paris',
            ],
        ]);
        $response->assertRedirect();
        $this->assertDatabaseHas('exam_submissions', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
        ]);

        // Test result viewing
        $response = $this->get("/exams/{$exam->id}/result");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Exam/Result'));
    }

    /** @test */
    public function test_quiz_workflow()
    {
        $this->actingAs($this->user);
        
        $quiz = Quiz::factory()->create([
            'status' => 'published',
            'is_public' => true,
        ]);

        $question = Question::factory()->create([
            'quiz_id' => $quiz->id,
            'type' => 'mcq',
            'question_text' => 'Which planet is closest to the sun?',
            'options' => json_encode([
                'A' => 'Venus',
                'B' => 'Mercury',
                'C' => 'Earth',
                'D' => 'Mars'
            ]),
            'correct_answer' => 'B',
            'marks' => 1,
        ]);

        // Test quiz taking
        $response = $this->get("/quiz/{$quiz->id}/take");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Quiz/Take'));

        // Test quiz submission
        $response = $this->post("/quiz/{$quiz->id}/submit", [
            'answers' => [
                $question->id => 'B',
            ],
        ]);
        $response->assertStatus(200);
        $this->assertDatabaseHas('quiz_submissions', [
            'user_id' => $this->user->id,
            'quiz_id' => $quiz->id,
        ]);

        // Test leaderboard access
        $response = $this->get("/quiz/{$quiz->id}/leaderboard");
        $response->assertStatus(200);
    }

    /** @test */
    public function test_practice_session_workflow()
    {
        $this->actingAs($this->user);
        
        $practice = Practice::factory()->create([
            'status' => 'published',
            'is_public' => true,
        ]);

        $question = Question::factory()->create([
            'practice_id' => $practice->id,
            'type' => 'mcq',
            'question_text' => 'What is the square root of 16?',
            'options' => json_encode([
                'A' => '2',
                'B' => '4',
                'C' => '6',
                'D' => '8'
            ]),
            'correct_answer' => 'B',
            'marks' => 1,
            'explanation' => 'The square root of 16 is 4 because 4 × 4 = 16',
        ]);

        // Test practice session start
        $response = $this->get("/practice/{$practice->id}/start");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Practice/Session'));

        // Test practice answer with immediate feedback
        $response = $this->post("/practice/{$practice->id}/answer", [
            'question_id' => $question->id,
            'answer' => 'B',
        ]);
        $response->assertStatus(200);
        $response->assertJson(['correct' => true]);

        // Test progress tracking
        $response = $this->get("/practice/{$practice->id}/progress");
        $response->assertStatus(200);
    }

    /** @test */
    public function test_rich_text_and_mathematical_content()
    {
        $this->actingAs($this->admin, 'admin');

        // Test creating question with mathematical content
        $response = $this->post('/admin/questions', [
            'type' => 'mcq',
            'question_text' => 'Solve: $\\frac{d}{dx}(x^2 + 3x) = ?$',
            'options' => json_encode([
                'A' => '$2x + 3$',
                'B' => '$x^2 + 3$',
                'C' => '$2x$',
                'D' => '$3x$'
            ]),
            'correct_answer' => 'A',
            'marks' => 5,
        ]);
        $response->assertRedirect();

        // Verify mathematical content is stored correctly
        $this->assertDatabaseHas('questions', [
            'question_text' => 'Solve: $\\frac{d}{dx}(x^2 + 3x) = ?$',
        ]);
    }

    /** @test */
    public function test_file_upload_and_media_management()
    {
        Storage::fake('public');
        $this->actingAs($this->admin, 'admin');

        // Test image upload for question
        $file = UploadedFile::fake()->image('question-image.jpg', 800, 600);
        
        $response = $this->post('/admin/upload/image', [
            'image' => $file,
            'type' => 'question',
        ]);
        
        $response->assertStatus(200);
        $response->assertJsonStructure(['url', 'path']);
        Storage::disk('public')->assertExists('uploads/questions/' . $file->hashName());

        // Test document upload
        $document = UploadedFile::fake()->create('test-document.pdf', 1024, 'application/pdf');
        
        $response = $this->post('/admin/upload/document', [
            'document' => $document,
        ]);
        
        $response->assertStatus(200);
        Storage::disk('public')->assertExists('uploads/documents/' . $document->hashName());
    }

    /** @test */
    public function test_theme_customization_and_settings()
    {
        $this->actingAs($this->admin, 'admin');

        // Test theme color customization
        $response = $this->post('/admin/settings/theme', [
            'primary_color' => '#3B82F6',
            'secondary_color' => '#10B981',
            'success_color' => '#22C55E',
            'warning_color' => '#F59E0B',
            'error_color' => '#EF4444',
            'surface_color' => '#FFFFFF',
            'text_color' => '#1F2937',
        ]);
        
        $response->assertRedirect();
        
        // Verify theme settings are saved
        $this->assertDatabaseHas('settings', [
            'key' => 'theme_primary_color',
            'value' => '#3B82F6',
        ]);

        // Test CSS variable generation
        $response = $this->get('/css/theme-variables.css');
        $response->assertStatus(200);
        $response->assertSee('--p-primary-color: #3B82F6');
    }

    /** @test */
    public function test_responsive_design_and_mobile_compatibility()
    {
        $this->actingAs($this->user);

        // Test mobile viewport responses
        $response = $this->get('/dashboard', [
            'User-Agent' => 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15',
        ]);
        
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page->component('Dashboard'));

        // Test exam taking on mobile
        $exam = Exam::factory()->create(['status' => 'published']);
        
        $response = $this->get("/exams/{$exam->id}/take", [
            'User-Agent' => 'Mozilla/5.0 (Android 11; Mobile; rv:91.0) Gecko/91.0 Firefox/91.0',
        ]);
        
        $response->assertStatus(200);
    }

    /** @test */
    public function test_api_endpoints_and_integrations()
    {
        $this->actingAs($this->user);

        // Test API authentication
        $token = $this->user->createToken('test-token')->plainTextToken;
        
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->get('/api/user/profile');
        
        $response->assertStatus(200);
        $response->assertJson(['name' => $this->user->name]);

        // Test exam API
        $exam = Exam::factory()->create(['status' => 'published']);
        
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->get('/api/exams');
        
        $response->assertStatus(200);
        $response->assertJsonStructure(['data']);

        // Test rate limiting
        for ($i = 0; $i < 70; $i++) {
            $response = $this->withHeaders([
                'Authorization' => 'Bearer ' . $token,
            ])->get('/api/user/profile');
        }
        
        $response->assertStatus(429); // Too Many Requests
    }

    /** @test */
    public function test_real_time_features()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create([
            'status' => 'published',
            'duration' => 60, // 60 minutes
        ]);

        // Test exam timer initialization
        $response = $this->get("/exams/{$exam->id}/take");
        $response->assertStatus(200);

        // Test auto-save functionality
        $question = Question::factory()->create(['exam_id' => $exam->id]);
        
        $response = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $question->id,
            'answer' => 'Test answer',
            'time_remaining' => 3500,
        ]);
        
        $response->assertStatus(200);
        $response->assertJson(['saved' => true]);

        // Verify auto-save data
        $this->assertDatabaseHas('exam_auto_saves', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
            'answer' => 'Test answer',
        ]);
    }

    /** @test */
    public function test_performance_under_load()
    {
        // Create realistic data set
        $exam = Exam::factory()->create(['status' => 'published']);
        $questions = Question::factory(50)->create(['exam_id' => $exam->id]);
        
        $users = User::factory(100)->create();
        
        $this->actingAs($this->user);
        
        // Measure response time for exam loading
        $startTime = microtime(true);
        
        $response = $this->get("/exams/{$exam->id}/take");
        
        $endTime = microtime(true);
        $responseTime = ($endTime - $startTime) * 1000; // Convert to milliseconds
        
        $response->assertStatus(200);
        $this->assertLessThan(2000, $responseTime, 'Exam loading should be under 2 seconds');

        // Test database query performance
        $startTime = microtime(true);
        
        $response = $this->get('/api/exams');
        
        $endTime = microtime(true);
        $queryTime = ($endTime - $startTime) * 1000;
        
        $response->assertStatus(200);
        $this->assertLessThan(1000, $queryTime, 'API response should be under 1 second');
    }

    /** @test */
    public function test_browser_compatibility()
    {
        $this->actingAs($this->user);

        // Test with different browser user agents
        $browsers = [
            'Chrome' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36',
            'Firefox' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:89.0) Gecko/20100101 Firefox/89.0',
            'Safari' => 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.1.1 Safari/605.1.15',
            'Edge' => 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36 Edg/91.0.864.59',
        ];

        foreach ($browsers as $name => $userAgent) {
            $response = $this->get('/dashboard', ['User-Agent' => $userAgent]);
            $response->assertStatus(200, "Dashboard should load correctly in {$name}");
        }
    }
}
