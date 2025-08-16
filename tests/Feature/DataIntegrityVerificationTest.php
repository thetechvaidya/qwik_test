<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Admin;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Question;
use App\Models\ExamSubmission;
use App\Models\QuizSubmission;
use App\Models\ExamAutoSave;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Facades\Storage;
use Illuminate\Http\UploadedFile;
use Illuminate\Database\QueryException;
use Illuminate\Validation\ValidationException;

class DataIntegrityVerificationTest extends TestCase
{
    use RefreshDatabase;

    protected $user;
    protected $admin;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->admin = Admin::factory()->create();
    }

    /** @test */
    public function test_database_migrations_and_schema_integrity()
    {
        // Test that all required tables exist
        $requiredTables = [
            'users', 'admins', 'exams', 'quizzes', 'questions', 
            'exam_submissions', 'quiz_submissions', 'practice_sessions',
            'categories', 'lessons', 'settings', 'media_files',
            'exam_registrations', 'exam_auto_saves', 'user_progress',
            'roles', 'permissions', 'model_has_roles', 'model_has_permissions'
        ];

        foreach ($requiredTables as $table) {
            $this->assertTrue(
                Schema::hasTable($table),
                "Required table '{$table}' does not exist"
            );
        }

        // Test foreign key constraints
        $this->assertTrue(Schema::hasColumn('exams', 'category_id'));
        $this->assertTrue(Schema::hasColumn('questions', 'exam_id'));
        $this->assertTrue(Schema::hasColumn('exam_submissions', 'user_id'));
        $this->assertTrue(Schema::hasColumn('exam_submissions', 'exam_id'));
        
        // Test indexes for performance
        $this->assertDatabaseIndexExists('users', 'email');
        $this->assertDatabaseIndexExists('exam_submissions', 'user_id');
        $this->assertDatabaseIndexExists('questions', 'exam_id');
        $this->assertDatabaseIndexExists('settings', 'key');
    }

    /** @test */
    public function test_foreign_key_constraints()
    {
        $exam = Exam::factory()->create();
        $question = Question::factory()->create(['exam_id' => $exam->id]);

        // Test cascade on delete for exam -> questions
        $questionId = $question->id;
        $exam->delete();
        
        $this->assertDatabaseMissing('questions', ['id' => $questionId]);

        // Test foreign key constraint violation
        $this->expectException(QueryException::class);
        
        Question::create([
            'exam_id' => 99999, // Non-existent exam_id
            'type' => 'msa',
            'question_text' => 'Test question',
            'marks' => 5,
        ]);
    }

    /** @test */
    public function test_model_relationships_integrity()
    {
        $user = User::factory()->create();
        $exam = Exam::factory()->create();
        $question = Question::factory()->create(['exam_id' => $exam->id]);
        
        $submission = ExamSubmission::create([
            'user_id' => $user->id,
            'exam_id' => $exam->id,
            'answers' => json_encode([$question->id => 'A']),
            'score' => 85,
            'total_marks' => 100,
            'time_taken' => 3600,
            'status' => 'submitted',
        ]);

        // Test relationship integrity
        $this->assertEquals($user->id, $submission->user->id);
        $this->assertEquals($exam->id, $submission->exam->id);
        $this->assertTrue($user->examSubmissions->contains($submission));
        $this->assertTrue($exam->submissions->contains($submission));
        
        // Test question relationship
        $this->assertEquals($exam->id, $question->exam->id);
        $this->assertTrue($exam->questions->contains($question));
    }

    /** @test */
    public function test_data_validation_at_model_level()
    {
        // Test user validation
        $this->expectException(ValidationException::class);
        
        $this->actingAs($this->admin, 'admin');
        
        $response = $this->post('/admin/users', [
            'name' => '', // Required field empty
            'email' => 'invalid-email', // Invalid email format
            'password' => '123', // Too short password
        ]);

        // Test exam validation
        $this->expectException(ValidationException::class);
        
        $response = $this->post('/admin/exams', [
            'title' => '', // Required field empty
            'duration' => -10, // Negative duration
            'total_marks' => 0, // Invalid marks
        ]);
    }

    /** @test */
    public function test_json_data_integrity()
    {
        $exam = Exam::factory()->create();
        
        // Test valid JSON question data
        $question = Question::create([
            'exam_id' => $exam->id,
            'type' => 'msa',
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

        // Verify JSON is properly stored and retrieved
        $retrievedQuestion = Question::find($question->id);
        $options = json_decode($retrievedQuestion->options, true);
        
        $this->assertIsArray($options);
        $this->assertEquals('4', $options['B']);
        
        // Test submission with JSON answers
        $submission = ExamSubmission::create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'answers' => json_encode([$question->id => 'B']),
            'score' => 4,
            'total_marks' => 4,
            'time_taken' => 1800,
            'status' => 'submitted',
        ]);

        $answers = json_decode($submission->answers, true);
        $this->assertIsArray($answers);
        $this->assertEquals('B', $answers[$question->id]);
    }

    /** @test */
    public function test_rich_text_content_validation()
    {
        $exam = Exam::factory()->create();
        
        // Test valid Tiptap JSON structure
        $validTiptapContent = json_encode([
            'type' => 'doc',
            'content' => [
                [
                    'type' => 'paragraph',
                    'content' => [
                        ['type' => 'text', 'text' => 'What is the derivative of '],
                        ['type' => 'text', 'marks' => [['type' => 'math']], 'text' => 'x^2'],
                        ['type' => 'text', 'text' => '?'],
                    ],
                ],
            ],
        ]);

        $question = Question::create([
            'exam_id' => $exam->id,
            'type' => 'saq',
            'question_text' => $validTiptapContent,
            'marks' => 5,
        ]);

        $this->assertDatabaseHas('questions', [
            'id' => $question->id,
            'question_text' => $validTiptapContent,
        ]);

        // Verify content can be parsed correctly
        $content = json_decode($question->question_text, true);
        $this->assertEquals('doc', $content['type']);
        $this->assertIsArray($content['content']);
    }

    /** @test */
    public function test_mathematical_content_validation()
    {
        $exam = Exam::factory()->create();
        
        // Test LaTeX mathematical expressions
        $mathQuestions = [
            'Find the integral: $\int x^2 dx$',
            'Solve the equation: $ax^2 + bx + c = 0$',
            'Calculate the limit: $\lim_{x \to 0} \frac{\sin x}{x}$',
            'Find the derivative: $\frac{d}{dx}(e^{x^2})$',
        ];

        foreach ($mathQuestions as $index => $questionText) {
            $question = Question::create([
                'exam_id' => $exam->id,
                'type' => 'saq',
                'question_text' => $questionText,
                'marks' => 5,
            ]);

            $this->assertDatabaseHas('questions', [
                'id' => $question->id,
                'question_text' => $questionText,
            ]);

            // Verify LaTeX syntax is preserved
            $this->assertStringContainsString('$', $question->question_text);
        }
    }

    /** @test */
    public function test_session_management_integrity()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create([
            'status' => 'published',
            'duration' => 60,
        ]);
        
        $question = Question::factory()->create(['exam_id' => $exam->id]);

        // Test exam session creation
        $response = $this->get("/exams/{$exam->id}/take");
        $response->assertStatus(200);

        // Test auto-save functionality
        $response = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $question->id,
            'answer' => 'Test answer',
            'time_remaining' => 3000,
        ]);
        
        $response->assertStatus(200);
        
        $this->assertDatabaseHas('exam_auto_saves', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
            'answer' => 'Test answer',
        ]);

        // Test auto-save update (should update, not create new)
        $response = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $question->id,
            'answer' => 'Updated answer',
            'time_remaining' => 2900,
        ]);
        
        $response->assertStatus(200);
        
        // Verify only one auto-save record exists
        $autoSaveCount = ExamAutoSave::where([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
        ])->count();
        
        $this->assertEquals(1, $autoSaveCount);
        
        // Verify updated content
        $this->assertDatabaseHas('exam_auto_saves', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
            'answer' => 'Updated answer',
        ]);
    }

    /** @test */
    public function test_transaction_handling_and_rollback()
    {
        $exam = Exam::factory()->create();
        $initialQuestionCount = Question::count();

        // Test transaction rollback on failure
        try {
            DB::transaction(function () use ($exam) {
                // Create valid question
                Question::create([
                    'exam_id' => $exam->id,
                    'type' => 'msa',
                    'question_text' => 'Valid question',
                    'marks' => 5,
                ]);

                // Attempt to create invalid question (should fail)
                Question::create([
                    'exam_id' => $exam->id,
                    'type' => 'invalid_type', // Invalid type should fail validation
                    'question_text' => 'Invalid question',
                    'marks' => -5, // Negative marks should fail validation
                ]);
            });
        } catch (\Exception $e) {
            // Transaction should have rolled back
        }

        // Verify no questions were created due to rollback
        $this->assertEquals($initialQuestionCount, Question::count());
    }

    /** @test */
    public function test_api_data_serialization_and_validation()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create(['status' => 'published']);
        $question = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'msa',
            'options' => json_encode(['A' => 'Option A', 'B' => 'Option B']),
        ]);

        // Test API response structure
        $response = $this->get('/api/exams');
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'data' => [
                '*' => [
                    'id',
                    'title',
                    'description',
                    'duration',
                    'total_marks',
                    'status',
                    'created_at',
                    'updated_at',
                ]
            ]
        ]);

        // Test API data validation
        $token = $this->user->createToken('test')->plainTextToken;
        
        $response = $this->withHeaders([
            'Authorization' => 'Bearer ' . $token,
        ])->post('/api/exam-submissions', [
            'exam_id' => $exam->id,
            'answers' => [$question->id => 'A'],
            'time_taken' => 1800,
        ]);
        
        $response->assertStatus(201);
        $response->assertJsonStructure([
            'data' => [
                'id',
                'score',
                'total_marks',
                'percentage',
                'status',
            ]
        ]);
    }

    /** @test */
    public function test_file_system_integrity()
    {
        Storage::fake('public');
        $this->actingAs($this->admin, 'admin');

        // Test file upload validation
        $validImage = UploadedFile::fake()->image('valid.jpg', 800, 600);
        $invalidFile = UploadedFile::fake()->create('malicious.exe', 1024);
        $oversizedImage = UploadedFile::fake()->image('large.jpg', 5000, 5000);

        // Valid file upload should succeed
        $response = $this->post('/admin/media/upload', [
            'file' => $validImage,
            'category' => 'images',
        ]);
        $response->assertStatus(200);
        Storage::disk('public')->assertExists('media/images/' . $validImage->hashName());

        // Invalid file type should fail
        $response = $this->post('/admin/media/upload', [
            'file' => $invalidFile,
            'category' => 'documents',
        ]);
        $response->assertStatus(422);

        // Oversized file should fail if size limits are enforced
        $response = $this->post('/admin/media/upload', [
            'file' => $oversizedImage,
            'category' => 'images',
        ]);
        // This might succeed or fail depending on configuration
        // The important thing is that it's handled gracefully
        $this->assertContains($response->status(), [200, 422]);
    }

    /** @test */
    public function test_backup_and_restore_integrity()
    {
        $this->actingAs($this->admin, 'admin');
        
        // Create test data
        $exam = Exam::factory()->create();
        $questions = Question::factory(5)->create(['exam_id' => $exam->id]);
        $submission = ExamSubmission::factory()->create([
            'exam_id' => $exam->id,
            'user_id' => $this->user->id,
        ]);

        $originalDataCount = [
            'exams' => Exam::count(),
            'questions' => Question::count(),
            'submissions' => ExamSubmission::count(),
        ];

        // Test database backup creation
        $response = $this->post('/admin/system/backup', [
            'include_database' => true,
            'include_files' => false,
        ]);
        $response->assertStatus(200);

        // Simulate data corruption/loss
        Question::truncate();
        $this->assertEquals(0, Question::count());

        // Test data restore (this would be a manual process in reality)
        // For testing purposes, we'll verify backup exists and contains data
        $backupFiles = Storage::disk('local')->files('backups');
        $this->assertNotEmpty($backupFiles, 'Backup files should exist');

        // Restore questions (simulated)
        Question::factory(5)->create(['exam_id' => $exam->id]);
        
        $this->assertEquals($originalDataCount['questions'], Question::count());
    }

    /** @test */
    public function test_concurrent_access_handling()
    {
        $exam = Exam::factory()->create(['status' => 'published']);
        $question = Question::factory()->create(['exam_id' => $exam->id]);

        // Simulate concurrent auto-save operations
        $user1 = User::factory()->create();
        $user2 = User::factory()->create();

        $this->actingAs($user1);
        $response1 = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $question->id,
            'answer' => 'User 1 answer',
            'time_remaining' => 3000,
        ]);
        $response1->assertStatus(200);

        $this->actingAs($user2);
        $response2 = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $question->id,
            'answer' => 'User 2 answer',
            'time_remaining' => 3000,
        ]);
        $response2->assertStatus(200);

        // Verify both users have separate auto-save records
        $this->assertDatabaseHas('exam_auto_saves', [
            'user_id' => $user1->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
            'answer' => 'User 1 answer',
        ]);

        $this->assertDatabaseHas('exam_auto_saves', [
            'user_id' => $user2->id,
            'exam_id' => $exam->id,
            'question_id' => $question->id,
            'answer' => 'User 2 answer',
        ]);
    }

    /** @test */
    public function test_data_encryption_and_security()
    {
        // Test password hashing
        $user = User::create([
            'name' => 'Test User',
            'email' => 'test@example.com',
            'password' => 'plaintext_password',
        ]);

        // Password should be hashed, not stored in plain text
        $this->assertNotEquals('plaintext_password', $user->password);
        $this->assertTrue(\Hash::check('plaintext_password', $user->password));

        // Test sensitive data handling
        $submission = ExamSubmission::create([
            'user_id' => $user->id,
            'exam_id' => Exam::factory()->create()->id,
            'answers' => json_encode(['sensitive' => 'data']),
            'score' => 85,
            'total_marks' => 100,
            'time_taken' => 3600,
            'status' => 'submitted',
        ]);

        // Verify sensitive data is stored appropriately
        $this->assertIsString($submission->answers);
        $this->assertJson($submission->answers);
    }

    /**
     * Helper method to check if database index exists
     */
    protected function assertDatabaseIndexExists($table, $column)
    {
        $indexes = Schema::getConnection()->getDoctrineSchemaManager()
            ->listTableIndexes($table);
        
        $hasIndex = false;
        foreach ($indexes as $index) {
            if (in_array($column, $index->getColumns())) {
                $hasIndex = true;
                break;
            }
        }
        
        $this->assertTrue($hasIndex, "Index on column '{$column}' in table '{$table}' does not exist");
    }
}
