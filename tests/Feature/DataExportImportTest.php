<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Exam;
use App\Models\Question;
use App\Models\Category;
use App\Models\ExamSession;
use App\Models\QuizSession;
use App\Models\PracticeSession;
use App\Exports\ExamSessionsExport;
use App\Exports\QuizSessionsExport;
use App\Exports\PracticeSessionsExport;
use App\Imports\QuestionsImport;
use App\Imports\UsersImport;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\Queue;
use Maatwebsite\Excel\Facades\Excel;
use Tests\TestCase;

class DataExportImportTest extends TestCase
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
        
        Storage::fake('public');
        Storage::fake('exports');
        Storage::fake('imports');
    }

    /** @test */
    public function admin_can_export_exam_sessions_to_excel()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();
        ExamSession::factory(25)->create(['exam_id' => $exam->id]);

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'exam_id' => $exam->id,
            'date_from' => now()->subDays(30)->format('Y-m-d'),
            'date_to' => now()->format('Y-m-d'),
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.xlsx', function (ExamSessionsExport $export) {
            return true;
        });
    }

    /** @test */
    public function admin_can_export_quiz_sessions_to_excel()
    {
        $this->actingAs($this->admin);
        
        QuizSession::factory(30)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/quiz-sessions', [
            'format' => 'excel',
            'date_from' => now()->subDays(30)->format('Y-m-d'),
            'date_to' => now()->format('Y-m-d'),
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('quiz-sessions-' . now()->format('Y-m-d') . '.xlsx', function (QuizSessionsExport $export) {
            return true;
        });
    }

    /** @test */
    public function admin_can_export_practice_sessions_to_excel()
    {
        $this->actingAs($this->admin);
        
        PracticeSession::factory(20)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/practice-sessions', [
            'format' => 'excel',
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('practice-sessions-' . now()->format('Y-m-d') . '.xlsx', function (PracticeSessionsExport $export) {
            return true;
        });
    }

    /** @test */
    public function admin_can_export_users_to_excel()
    {
        $this->actingAs($this->admin);
        
        User::factory(50)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/users', [
            'format' => 'excel',
            'include_exam_stats' => true,
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('users-' . now()->format('Y-m-d') . '.xlsx');
    }

    /** @test */
    public function admin_can_export_questions_to_excel()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();
        Question::factory(100)->create(['exam_id' => $exam->id]);

        Excel::fake();

        $response = $this->post('/admin/exports/questions', [
            'format' => 'excel',
            'exam_id' => $exam->id,
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('questions-' . now()->format('Y-m-d') . '.xlsx');
    }

    /** @test */
    public function admin_can_export_data_to_csv()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(15)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'csv',
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.csv');
    }

    /** @test */
    public function admin_can_generate_pdf_reports()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();
        $examSessions = ExamSession::factory(10)->create(['exam_id' => $exam->id]);

        $response = $this->get("/admin/reports/exam/{$exam->id}/pdf");

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/pdf');
        $this->assertStringContainsString('attachment; filename=', $response->headers->get('Content-Disposition'));
    }

    /** @test */
    public function admin_can_generate_exam_session_pdf_report()
    {
        $this->actingAs($this->admin);
        
        $examSession = ExamSession::factory()->create();

        $response = $this->get("/admin/exam-sessions/{$examSession->id}/pdf");

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/pdf');
    }

    /** @test */
    public function admin_can_import_users_from_excel()
    {
        $this->actingAs($this->admin);

        Excel::fake();

        // Create a fake Excel file for import
        $file = UploadedFile::fake()->create('users.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'has_headers' => true,
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('success');

        Excel::assertImported('users.xlsx', function (UsersImport $import) {
            return true;
        });
    }

    /** @test */
    public function admin_can_import_questions_from_excel()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();

        Excel::fake();

        $file = UploadedFile::fake()->create('questions.xlsx', 200, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/questions', [
            'file' => $file,
            'exam_id' => $exam->id,
            'has_headers' => true,
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('success');

        Excel::assertImported('questions.xlsx', function (QuestionsImport $import) {
            return $import->getExamId() !== null;
        });
    }

    /** @test */
    public function import_validates_file_format()
    {
        $this->actingAs($this->admin);

        // Try to import a non-Excel file
        $file = UploadedFile::fake()->create('invalid.txt', 100, 'text/plain');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
        ]);

        $response->assertSessionHasErrors(['file']);
    }

    /** @test */
    public function import_validates_required_columns()
    {
        $this->actingAs($this->admin);

        // Mock Excel import to simulate missing required columns
        Excel::fake();
        Excel::shouldReceive('import')
            ->andThrow(new \Exception('Missing required columns: name, email'));

        $file = UploadedFile::fake()->create('users-invalid.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
        ]);

        $response->assertSessionHasErrors();
    }

    /** @test */
    public function import_handles_duplicate_data()
    {
        $this->actingAs($this->admin);

        // Create existing user
        $existingUser = User::factory()->create(['email' => 'existing@example.com']);

        Excel::fake();

        $file = UploadedFile::fake()->create('users-with-duplicates.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'handle_duplicates' => 'skip',
        ]);

        $response->assertRedirect();
        Excel::assertImported('users-with-duplicates.xlsx');
    }

    /** @test */
    public function import_can_update_existing_records()
    {
        $this->actingAs($this->admin);

        $existingUser = User::factory()->create(['email' => 'update@example.com']);

        Excel::fake();

        $file = UploadedFile::fake()->create('users-update.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'handle_duplicates' => 'update',
        ]);

        $response->assertRedirect();
        Excel::assertImported('users-update.xlsx');
    }

    /** @test */
    public function bulk_import_processes_large_files()
    {
        $this->actingAs($this->admin);

        Queue::fake();

        // Create a large file simulation
        $file = UploadedFile::fake()->create('large-users.xlsx', 5000, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'process_in_background' => true,
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('success', 'Import queued for background processing');

        Queue::assertPushed(\App\Jobs\ProcessUsersImport::class);
    }

    /** @test */
    public function export_filters_data_correctly()
    {
        $this->actingAs($this->admin);
        
        $category1 = Category::factory()->create(['name' => 'Mathematics']);
        $category2 = Category::factory()->create(['name' => 'Science']);
        
        $exam1 = Exam::factory()->create(['category_id' => $category1->id]);
        $exam2 = Exam::factory()->create(['category_id' => $category2->id]);
        
        ExamSession::factory(10)->create(['exam_id' => $exam1->id]);
        ExamSession::factory(15)->create(['exam_id' => $exam2->id]);

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'category_id' => $category1->id,
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.xlsx', function (ExamSessionsExport $export) use ($category1) {
            return $export->getCategoryId() === $category1->id;
        });
    }

    /** @test */
    public function export_handles_date_range_filters()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(5)->create(['created_at' => now()->subDays(10)]);
        ExamSession::factory(8)->create(['created_at' => now()->subDays(5)]);
        ExamSession::factory(3)->create(['created_at' => now()]);

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'date_from' => now()->subDays(7)->format('Y-m-d'),
            'date_to' => now()->format('Y-m-d'),
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.xlsx');
    }

    /** @test */
    public function export_includes_custom_columns()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(10)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'columns' => ['user_name', 'exam_title', 'score', 'completion_time'],
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.xlsx');
    }

    /** @test */
    public function scheduled_exports_work()
    {
        $this->actingAs($this->admin);

        Queue::fake();

        $response = $this->post('/admin/exports/schedule', [
            'export_type' => 'exam_sessions',
            'frequency' => 'weekly',
            'format' => 'excel',
            'email_recipients' => ['admin@example.com'],
        ]);

        $response->assertRedirect();
        $response->assertSessionHas('success');

        Queue::assertPushed(\App\Jobs\ScheduledExport::class);
    }

    /** @test */
    public function export_progress_is_tracked()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(1000)->create();

        Queue::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'process_in_background' => true,
        ]);

        $response->assertRedirect();
        Queue::assertPushed(\App\Jobs\ProcessExport::class);

        // Check export status
        $exportId = $response->getSession()->get('export_id');
        $statusResponse = $this->get("/admin/exports/{$exportId}/status");
        
        $statusResponse->assertStatus(200);
        $statusResponse->assertJsonStructure([
            'status',
            'progress',
            'estimated_completion',
        ]);
    }

    /** @test */
    public function import_provides_validation_summary()
    {
        $this->actingAs($this->admin);

        Excel::fake();

        $file = UploadedFile::fake()->create('users-with-errors.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'validate_only' => true,
        ]);

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'valid_rows',
            'invalid_rows',
            'errors' => [
                '*' => [
                    'row',
                    'field',
                    'message',
                ]
            ],
            'summary' => [
                'total_rows',
                'valid_count',
                'invalid_count',
            ]
        ]);
    }

    /** @test */
    public function export_templates_are_available()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/exports/users/template');

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
        $this->assertStringContainsString('template', $response->headers->get('Content-Disposition'));
    }

    /** @test */
    public function import_template_for_questions_includes_proper_format()
    {
        $this->actingAs($this->admin);

        $response = $this->get('/admin/exports/questions/template');

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
    }

    /** @test */
    public function data_export_permissions_are_enforced()
    {
        $this->actingAs($this->user); // Regular user

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function data_import_permissions_are_enforced()
    {
        $this->actingAs($this->user); // Regular user

        $file = UploadedFile::fake()->create('users.xlsx', 100, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
        ]);

        $response->assertStatus(403);
    }

    /** @test */
    public function export_files_are_cleaned_up_after_download()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(5)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'auto_cleanup' => true,
        ]);

        $response->assertStatus(200);
        
        // Simulate file cleanup job
        Queue::fake();
        Queue::assertPushed(\App\Jobs\CleanupExportFiles::class);
    }

    /** @test */
    public function import_batch_processing_works()
    {
        $this->actingAs($this->admin);

        Excel::fake();

        $file = UploadedFile::fake()->create('large-import.xlsx', 2000, 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');

        $response = $this->post('/admin/imports/users', [
            'file' => $file,
            'batch_size' => 100,
        ]);

        $response->assertRedirect();
        Excel::assertImported('large-import.xlsx');
    }

    /** @test */
    public function export_includes_data_transformations()
    {
        $this->actingAs($this->admin);
        
        $user = User::factory()->create();
        $examSession = ExamSession::factory()->create([
            'user_id' => $user->id,
            'score' => 85.5,
            'total_questions' => 20,
            'correct_answers' => 17,
        ]);

        Excel::fake();

        $response = $this->post('/admin/exports/exam-sessions', [
            'format' => 'excel',
            'include_calculated_fields' => true,
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('exam-sessions-' . now()->format('Y-m-d') . '.xlsx', function (ExamSessionsExport $export) {
            return $export->includeCalculatedFields();
        });
    }

    /** @test */
    public function multi_sheet_excel_exports_work()
    {
        $this->actingAs($this->admin);
        
        ExamSession::factory(10)->create();
        QuizSession::factory(15)->create();

        Excel::fake();

        $response = $this->post('/admin/exports/comprehensive-report', [
            'format' => 'excel',
            'include_sheets' => ['exam_sessions', 'quiz_sessions', 'summary'],
        ]);

        $response->assertStatus(200);
        Excel::assertDownloaded('comprehensive-report-' . now()->format('Y-m-d') . '.xlsx');
    }
}
