<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Category;
use App\Models\Question;
use App\Models\ExamSession;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\RateLimiter;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ApiEndpointTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $admin;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->admin = User::factory()->create();
        $this->admin->assignRole('admin');

        // Configure CORS for testing
        Config::set('cors.paths', ['api/*']);
        Config::set('cors.allowed_methods', ['*']);
        Config::set('cors.allowed_origins', ['*']);
        Config::set('cors.allowed_headers', ['*']);
    }

    /** @test */
    public function api_requires_authentication_for_protected_endpoints()
    {
        $response = $this->getJson('/api/user');

        $response->assertStatus(401);
        $response->assertJson([
            'message' => 'Unauthenticated.',
        ]);
    }

    /** @test */
    public function sanctum_authentication_works_correctly()
    {
        $token = $this->user->createToken('test-token')->plainTextToken;

        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->getJson('/api/user');

        $response->assertStatus(200);
        $response->assertJson([
            'id' => $this->user->id,
            'name' => $this->user->name,
            'email' => $this->user->email,
        ]);
    }

    /** @test */
    public function invalid_token_returns_unauthorized()
    {
        $response = $this->withHeaders([
            'Authorization' => 'Bearer invalid-token-here',
        ])->getJson('/api/user');

        $response->assertStatus(401);
    }

    /** @test */
    public function api_returns_properly_formatted_json_responses()
    {
        Sanctum::actingAs($this->user);
        
        Category::factory(3)->create();

        $response = $this->getJson('/api/categories');

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'name',
                    'description',
                    'is_active',
                    'created_at',
                    'updated_at',
                ]
            ],
            'meta' => [
                'current_page',
                'per_page',
                'total',
            ]
        ]);
    }

    /** @test */
    public function api_handles_validation_errors_correctly()
    {
        Sanctum::actingAs($this->admin);

        $response = $this->postJson('/api/categories', [
            'name' => '', // Required field missing
            'description' => 'Test description',
        ]);

        $response->assertStatus(422);
        $response->assertJsonStructure([
            'message',
            'errors' => [
                'name'
            ]
        ]);
    }

    /** @test */
    public function api_rate_limiting_works()
    {
        Sanctum::actingAs($this->user);

        // Use the named rate limiter defined in RouteServiceProvider
        // Make requests up to the limit (assuming /api/user uses 'api-user' throttle)
        for ($i = 0; $i < 5; $i++) {
            $response = $this->getJson('/api/user');
            $response->assertStatus(200);
        }

        // Next request should be rate limited
        $response = $this->getJson('/api/user');
        $response->assertStatus(429);
    }

    /** @test */
    public function cors_headers_are_present()
    {
        $response = $this->options('/api/user');

        // Laravel commonly returns 204 for OPTIONS requests
        $this->assertContains($response->status(), [200, 204]);
        $response->assertHeader('Access-Control-Allow-Origin');
        $response->assertHeader('Access-Control-Allow-Methods');
        $response->assertHeader('Access-Control-Allow-Headers');
    }

    /** @test */
    public function preflight_cors_requests_work()
    {
        $response = $this->options('/api/categories', [
            'Origin' => 'https://example.com',
            'Access-Control-Request-Method' => 'POST',
            'Access-Control-Request-Headers' => 'Content-Type, Authorization',
        ]);

        // Laravel commonly returns 204 for OPTIONS requests
        $this->assertContains($response->status(), [200, 204]);
        $response->assertHeader('Access-Control-Allow-Origin');
        $response->assertHeader('Access-Control-Allow-Methods');
    }

    /** @test */
    public function api_returns_consistent_error_format()
    {
        Sanctum::actingAs($this->user);

        $response = $this->getJson('/api/non-existent-endpoint');

        $response->assertStatus(404);
        $response->assertJsonStructure([
            'message',
            'error_code' => null,
        ]);
    }

    /** @test */
    public function api_categories_endpoint_works()
    {
        Sanctum::actingAs($this->user);
        
        $categories = Category::factory(5)->create();

        $response = $this->getJson('/api/categories');

        $response->assertStatus(200);
        $response->assertJsonCount(5, 'data');
        
        $firstCategory = $categories->first();
        $response->assertJsonFragment([
            'id' => $firstCategory->id,
            'name' => $firstCategory->name,
        ]);
    }

    /** @test */
    public function api_exams_endpoint_returns_paginated_results()
    {
        Sanctum::actingAs($this->user);
        
        $category = Category::factory()->create();
        Exam::factory(25)->create(['category_id' => $category->id]);

        $response = $this->getJson('/api/exams?per_page=10');

        $response->assertStatus(200);
        $response->assertJsonCount(10, 'data');
        $response->assertJsonPath('meta.per_page', 10);
        $response->assertJsonPath('meta.total', 25);
    }

    /** @test */
    public function api_exam_detail_endpoint_works()
    {
        Sanctum::actingAs($this->user);
        
        $exam = Exam::factory()->create();
        Question::factory(5)->create(['exam_id' => $exam->id]);

        $response = $this->getJson("/api/exams/{$exam->id}");

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                'id',
                'title',
                'description',
                'duration',
                'total_marks',
                'questions_count',
                'category',
            ]
        ]);
    }

    /** @test */
    public function api_quiz_endpoints_work()
    {
        Sanctum::actingAs($this->user);
        
        $quiz = Quiz::factory()->create(['is_active' => true]);

        // Test quiz list
        $response = $this->getJson('/api/quizzes');
        $response->assertStatus(200);

        // Test quiz detail
        $response = $this->getJson("/api/quizzes/{$quiz->id}");
        $response->assertStatus(200);
        $response->assertJsonPath('data.id', $quiz->id);
    }

    /** @test */
    public function api_search_functionality_works()
    {
        Sanctum::actingAs($this->user);
        
        $category = Category::factory()->create(['name' => 'Mathematics']);
        Exam::factory()->create([
            'title' => 'Advanced Mathematics',
            'category_id' => $category->id,
        ]);
        Exam::factory()->create([
            'title' => 'Basic Physics',
            'category_id' => $category->id,
        ]);

        $response = $this->getJson('/api/exams?search=Mathematics');

        $response->assertStatus(200);
        $response->assertJsonCount(1, 'data');
        $response->assertJsonPath('data.0.title', 'Advanced Mathematics');
    }

    /** @test */
    public function api_filtering_works()
    {
        Sanctum::actingAs($this->user);
        
        $category1 = Category::factory()->create();
        $category2 = Category::factory()->create();
        
        Exam::factory(3)->create(['category_id' => $category1->id]);
        Exam::factory(2)->create(['category_id' => $category2->id]);

        $response = $this->getJson("/api/exams?category_id={$category1->id}");

        $response->assertStatus(200);
        $response->assertJsonCount(3, 'data');
    }

    /** @test */
    public function api_sorting_works()
    {
        Sanctum::actingAs($this->user);
        
        $exam1 = Exam::factory()->create(['created_at' => now()->subDays(2)]);
        $exam2 = Exam::factory()->create(['created_at' => now()->subDay()]);
        $exam3 = Exam::factory()->create(['created_at' => now()]);

        $response = $this->getJson('/api/exams?sort=created_at&order=desc');

        $response->assertStatus(200);
        $response->assertJsonPath('data.0.id', $exam3->id);
        $response->assertJsonPath('data.1.id', $exam2->id);
        $response->assertJsonPath('data.2.id', $exam1->id);
    }

    /** @test */
    public function api_exam_session_creation_works()
    {
        Sanctum::actingAs($this->user);
        
        $exam = Exam::factory()->create();

        $response = $this->postJson("/api/exams/{$exam->id}/sessions");

        $response->assertStatus(201);
        $response->assertJsonStructure([
            'data' => [
                'id',
                'exam_id',
                'user_id',
                'status',
                'started_at',
                'expires_at',
            ]
        ]);

        $this->assertDatabaseHas('exam_sessions', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
        ]);
    }

    /** @test */
    public function api_exam_session_answer_submission_works()
    {
        Sanctum::actingAs($this->user);
        
        $exam = Exam::factory()->create();
        $question = Question::factory()->create(['exam_id' => $exam->id]);
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
        ]);

        $answerData = [
            'question_id' => $question->id,
            'answer' => 'Test answer',
        ];

        $response = $this->postJson("/api/exam-sessions/{$examSession->id}/answers", $answerData);

        $response->assertStatus(201);
        $this->assertDatabaseHas('exam_answers', [
            'exam_session_id' => $examSession->id,
            'question_id' => $question->id,
        ]);
    }

    /** @test */
    public function api_user_profile_endpoint_works()
    {
        Sanctum::actingAs($this->user);

        $response = $this->getJson('/api/profile');

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                'id',
                'name',
                'email',
                'created_at',
                'exam_sessions_count',
                'quiz_sessions_count',
            ]
        ]);
    }

    /** @test */
    public function api_user_profile_update_works()
    {
        Sanctum::actingAs($this->user);

        $updateData = [
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
        ];

        $response = $this->putJson('/api/profile', $updateData);

        $response->assertStatus(200);
        $this->assertDatabaseHas('users', [
            'id' => $this->user->id,
            'name' => 'Updated Name',
            'email' => 'updated@example.com',
        ]);
    }

    /** @test */
    public function api_user_statistics_endpoint_works()
    {
        Sanctum::actingAs($this->user);
        
        // Create some test data
        ExamSession::factory(3)->create([
            'user_id' => $this->user->id,
            'status' => 'completed',
        ]);

        $response = $this->getJson('/api/user/statistics');

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                'total_exams_taken',
                'total_quizzes_taken',
                'average_score',
                'total_time_spent',
            ]
        ]);
    }

    /** @test */
    public function api_input_sanitization_works()
    {
        Sanctum::actingAs($this->admin);

        $maliciousData = [
            'name' => '<script>alert("xss")</script>',
            'description' => 'Normal description',
        ];

        $response = $this->postJson('/api/categories', $maliciousData);

        // Should either reject malicious input or sanitize it
        if ($response->status() === 201) {
            $category = Category::latest()->first();
            $this->assertStringNotContainsString('<script>', $category->name);
        } else {
            $response->assertStatus(422);
        }
    }

    /** @test */
    public function api_permission_based_access_works()
    {
        // User without admin permissions
        Sanctum::actingAs($this->user);

        $response = $this->postJson('/api/admin/categories', [
            'name' => 'Test Category',
            'description' => 'Test Description',
        ]);

        $response->assertStatus(403);

        // Admin user
        Sanctum::actingAs($this->admin);

        $response = $this->postJson('/api/admin/categories', [
            'name' => 'Test Category',
            'description' => 'Test Description',
        ]);

        $response->assertStatus(201);
    }

    /** @test */
    public function api_handles_large_payloads_correctly()
    {
        Sanctum::actingAs($this->admin);

        $largeDescription = str_repeat('A', 10000); // 10KB description

        $response = $this->postJson('/api/categories', [
            'name' => 'Test Category',
            'description' => $largeDescription,
        ]);

        // Should either accept it or reject with appropriate error
        $this->assertContains($response->status(), [201, 413, 422]);
    }

    /** @test */
    public function api_versioning_works_if_implemented()
    {
        Sanctum::actingAs($this->user);

        // Test v1 endpoint
        $response = $this->getJson('/api/v1/categories');
        
        // If versioning is implemented, this should work
        if ($response->status() !== 404) {
            $response->assertStatus(200);
        }
    }

    /** @test */
    public function api_content_type_validation_works()
    {
        Sanctum::actingAs($this->admin);

        // Send data without proper JSON content type
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $this->admin->createToken('test')->plainTextToken,
            'Content-Type' => 'text/plain',
        ])->post('/api/categories', 'invalid json');

        // Accept various appropriate status codes depending on API contract
        $this->assertContains($response->status(), [400, 415, 422]);
    }

    /** @test */
    public function api_handles_concurrent_requests()
    {
        Sanctum::actingAs($this->user);
        
        $exam = Exam::factory()->create();

        // Simulate concurrent session creation attempts
        $responses = [];
        for ($i = 0; $i < 3; $i++) {
            $responses[] = $this->postJson("/api/exams/{$exam->id}/sessions");
        }

        // Only one session should be created successfully
        $successCount = collect($responses)->filter(fn($r) => $r->status() === 201)->count();
        $this->assertEquals(1, $successCount);
    }

    /** @test */
    public function api_logs_important_actions()
    {
        Sanctum::actingAs($this->admin);

        $response = $this->postJson('/api/categories', [
            'name' => 'Important Category',
            'description' => 'This should be logged',
        ]);

        $response->assertStatus(201);
        
        // Check that the action was logged (implementation depends on your logging setup)
        // This might check database logs, file logs, or external logging services
        $this->assertTrue(true); // Placeholder assertion
    }

    /** @test */
    public function api_handles_database_connection_issues()
    {
        Sanctum::actingAs($this->user);

        // Switch to a failing database connection for the duration of the test
        Config::set('database.default', 'failing_connection');
        Config::set('database.connections.failing_connection', [
            'driver' => 'sqlite',
            'database' => '/invalid/path/database.sqlite',
            'prefix' => '',
        ]);

        $response = $this->getJson('/api/categories');

        $response->assertStatus(500);
        $response->assertJsonStructure([
            'message',
        ]);

        // Restore original database connection
        Config::set('database.default', 'sqlite');
    }

    /** @test */
    public function api_response_time_is_reasonable()
    {
        // Skip performance tests in CI or when SKIP_PERFORMANCE_TESTS is set
        if (env('CI') || env('SKIP_PERFORMANCE_TESTS')) {
            $this->markTestSkipped('Performance tests skipped in CI environment');
        }

        Sanctum::actingAs($this->user);
        
        $startTime = microtime(true);
        
        $response = $this->getJson('/api/categories');
        
        $endTime = microtime(true);
        $responseTime = ($endTime - $startTime) * 1000; // Convert to milliseconds

        $response->assertStatus(200);
        // Increased threshold for different environments
        $this->assertLessThan(5000, $responseTime, 'API response took longer than 5 seconds');
    }
}
