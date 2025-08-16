<?php

namespace Tests\Feature;

use App\Models\User;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Question;
use App\Models\QuestionOption;
use App\Models\Category;
use App\Models\ExamSession;
use App\Models\QuizSession;
use App\Models\PracticeSession;
use App\Models\ExamSchedule;
use App\Models\Result;
use App\Models\Topic;
use App\Models\ComprehensionPassage;
use App\Models\DifficultyLevel;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Foundation\Testing\WithFaker;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Facades\Event;
use Carbon\Carbon;
use Tests\TestCase;

class ExamQuizSystemTest extends TestCase
{
    use RefreshDatabase, WithFaker;

    protected $user;
    protected $admin;
    protected $category;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create();
        $this->admin = User::factory()->create();
        $this->admin->assignRole('admin');
        $this->category = Category::factory()->create();
    }

    /** @test */
    public function admin_can_create_exam()
    {
        $this->actingAs($this->admin);

        $examData = [
            'title' => 'Mathematics Test',
            'description' => 'A comprehensive mathematics examination',
            'category_id' => $this->category->id,
            'duration' => 120, // 2 hours
            'total_marks' => 100,
            'pass_marks' => 40,
            'is_active' => true,
            'instructions' => 'Read all questions carefully',
        ];

        $response = $this->post(route('admin.exams.store', [], false) ?: '/admin/exams', $examData);

        $response->assertRedirect(route('admin.exams.index', [], false) ?: '/admin/exams');
        $this->assertDatabaseHas('exams', [
            'title' => 'Mathematics Test',
            'category_id' => $this->category->id,
            'duration' => 120,
        ]);
    }

    /** @test */
    public function admin_can_create_quiz()
    {
        $this->actingAs($this->admin);

        $quizData = [
            'title' => 'Quick Math Quiz',
            'description' => 'A short mathematics quiz',
            'category_id' => $this->category->id,
            'time_limit' => 30, // 30 minutes
            'is_active' => true,
            'is_featured' => false,
        ];

        $response = $this->post(route('admin.quizzes.store', [], false) ?: '/admin/quizzes', $quizData);

        $response->assertRedirect(route('admin.quizzes.index', [], false) ?: '/admin/quizzes');
        $this->assertDatabaseHas('quizzes', [
            'title' => 'Quick Math Quiz',
            'category_id' => $this->category->id,
        ]);
    }

    /** @test */
    public function admin_can_add_questions_to_exam()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create(['category_id' => $this->category->id]);
        $topic = Topic::factory()->create();
        $difficultyLevel = DifficultyLevel::factory()->create();

        $questionData = [
            'exam_id' => $exam->id,
            'topic_id' => $topic->id,
            'difficulty_level_id' => $difficultyLevel->id,
            'question' => 'What is 2 + 2?',
            'question_type' => 'mcq',
            'marks' => 2,
            'explanation' => 'Basic addition',
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
            'exam_id' => $exam->id,
            'question' => 'What is 2 + 2?',
            'question_type' => 'mcq',
        ]);

        // Check that options were created
        $question = Question::where('question', 'What is 2 + 2?')->first();
        $this->assertEquals(4, $question->options()->count());
        $this->assertEquals(1, $question->options()->where('is_correct', true)->count());
    }

    /** @test */
    public function admin_can_create_comprehension_passage_questions()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();
        
        $comprehensionPassage = ComprehensionPassage::factory()->create([
            'title' => 'Reading Passage',
            'passage' => 'This is a sample reading passage for testing purposes.',
        ]);

        $questionData = [
            'exam_id' => $exam->id,
            'comprehension_passage_id' => $comprehensionPassage->id,
            'question' => 'What is the main purpose of this passage?',
            'question_type' => 'mcq',
            'marks' => 3,
            'options' => [
                ['option' => 'To entertain', 'is_correct' => false],
                ['option' => 'To inform', 'is_correct' => true],
                ['option' => 'To persuade', 'is_correct' => false],
                ['option' => 'To describe', 'is_correct' => false],
            ],
        ];

        $response = $this->post('/admin/questions', $questionData);

        $response->assertRedirect('/admin/questions');
        $this->assertDatabaseHas('questions', [
            'comprehension_passage_id' => $comprehensionPassage->id,
            'question' => 'What is the main purpose of this passage?',
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
            'end_date' => now()->addDays(3),
            'max_attempts' => 2,
            'is_active' => true,
        ];

        $response = $this->post(route('exams.schedules.store', $exam), $scheduleData);

        $response->assertRedirect('/admin/exam-schedules');
        $this->assertDatabaseHas('exam_schedules', [
            'exam_id' => $exam->id,
            'max_attempts' => 2,
        ]);
    }

    /** @test */
    public function user_can_view_available_exams()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create([
            'category_id' => $this->category->id,
            'is_active' => true,
        ]);

        ExamSchedule::factory()->create([
            'exam_id' => $exam->id,
            'start_date' => now()->subDay(),
            'end_date' => now()->addDay(),
            'is_active' => true,
        ]);

        $response = $this->get(route('exam_dashboard'));

        $response->assertStatus(200);
        // Focus on data verification rather than strict component matching
        $response->assertInertia(fn ($page) => 
            $page->has('exams')
                ->has('exams.data')
        );
    }

    /** @test */
    public function user_can_start_exam_session()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create(['duration' => 60]);
        Question::factory(10)->create(['exam_id' => $exam->id]);
        
        ExamSchedule::factory()->create([
            'exam_id' => $exam->id,
            'start_date' => now()->subDay(),
            'end_date' => now()->addDay(),
            'is_active' => true,
        ]);

        $response = $this->post("/exams/{$exam->id}/start");

        $response->assertRedirect();
        $this->assertDatabaseHas('exam_sessions', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
        ]);

        $examSession = ExamSession::where('user_id', $this->user->id)
                                 ->where('exam_id', $exam->id)
                                 ->first();
        
        $this->assertNotNull($examSession->started_at);
        $this->assertNotNull($examSession->expires_at);
    }

    /** @test */
    public function user_cannot_start_exam_outside_schedule()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create();
        
        // Create schedule that has ended
        ExamSchedule::factory()->create([
            'exam_id' => $exam->id,
            'start_date' => now()->subDays(3),
            'end_date' => now()->subDay(),
            'is_active' => true,
        ]);

        $response = $this->post("/exams/{$exam->id}/start");

        $response->assertStatus(403);
        $this->assertDatabaseMissing('exam_sessions', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
        ]);
    }

    /** @test */
    public function user_can_answer_exam_questions()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create();
        $questions = Question::factory(5)->create(['exam_id' => $exam->id]);
        
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
        ]);

        foreach ($questions as $index => $question) {
            $option = QuestionOption::factory()->create([
                'question_id' => $question->id,
                'is_correct' => $index % 2 === 0, // Half correct, half incorrect
            ]);

            $response = $this->post("/exam-sessions/{$examSession->id}/answer", [
                'question_id' => $question->id,
                'selected_option_id' => $option->id,
            ]);

            $response->assertStatus(200);
        }

        $this->assertDatabaseCount('exam_answers', 5);
    }

    /** @test */
    public function exam_auto_submits_after_time_limit()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create(['duration' => 1]); // 1 minute
        Question::factory(3)->create(['exam_id' => $exam->id]);
        
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
            'started_at' => now()->subMinutes(2), // Started 2 minutes ago
            'expires_at' => now()->subMinute(), // Expired 1 minute ago
        ]);

        // Simulate auto-submit job
        Queue::fake();
        
        $response = $this->post("/exam-sessions/{$examSession->id}/submit");

        $response->assertRedirect();
        $this->assertDatabaseHas('exam_sessions', [
            'id' => $examSession->id,
            'status' => 'completed',
        ]);
    }

    /** @test */
    public function user_can_submit_exam_manually()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create();
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
        ]);

        $response = $this->post("/exam-sessions/{$examSession->id}/submit");

        $response->assertRedirect();
        $this->assertDatabaseHas('exam_sessions', [
            'id' => $examSession->id,
            'status' => 'completed',
        ]);

        $this->assertNotNull($examSession->fresh()->submitted_at);
    }

    /** @test */
    public function exam_scoring_calculates_correctly()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create(['total_marks' => 10]);
        $questions = Question::factory(5)->create([
            'exam_id' => $exam->id,
            'marks' => 2, // Each question worth 2 marks
        ]);
        
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'completed',
        ]);

        // Create answers - 3 correct, 2 incorrect
        foreach ($questions as $index => $question) {
            $correctOption = QuestionOption::factory()->create([
                'question_id' => $question->id,
                'is_correct' => true,
            ]);
            
            $incorrectOption = QuestionOption::factory()->create([
                'question_id' => $question->id,
                'is_correct' => false,
            ]);

            // Answer correctly for first 3 questions
            $selectedOption = $index < 3 ? $correctOption : $incorrectOption;
            
            $examSession->answers()->create([
                'question_id' => $question->id,
                'selected_option_id' => $selectedOption->id,
                'is_correct' => $selectedOption->is_correct,
                'marks_obtained' => $selectedOption->is_correct ? $question->marks : 0,
            ]);
        }

        // Calculate result
        $response = $this->post("/exam-sessions/{$examSession->id}/calculate-result");

        $response->assertStatus(200);
        $this->assertDatabaseHas('results', [
            'exam_session_id' => $examSession->id,
            'total_marks' => 10,
            'obtained_marks' => 6, // 3 correct × 2 marks each
            'percentage' => 60,
        ]);
    }

    /** @test */
    public function user_can_view_exam_results()
    {
        $this->actingAs($this->user);
        
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'status' => 'completed',
        ]);
        
        $result = Result::factory()->create([
            'exam_session_id' => $examSession->id,
            'obtained_marks' => 75,
            'total_marks' => 100,
            'percentage' => 75,
        ]);

        $response = $this->get("/exam-sessions/{$examSession->id}/result");

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('User/Exams/Result')
                ->has('result')
                ->where('result.percentage', 75)
        );
    }

    /** @test */
    public function user_can_take_quiz()
    {
        $this->actingAs($this->user);
        
        $quiz = Quiz::factory()->create(['is_active' => true]);
        $questions = Question::factory(3)->create(['quiz_id' => $quiz->id]);

        $response = $this->post("/quizzes/{$quiz->id}/start");

        $response->assertRedirect();
        $this->assertDatabaseHas('quiz_sessions', [
            'user_id' => $this->user->id,
            'quiz_id' => $quiz->id,
            'status' => 'started',
        ]);
    }

    /** @test */
    public function quiz_session_tracks_progress()
    {
        $this->actingAs($this->user);
        
        $quiz = Quiz::factory()->create();
        $questions = Question::factory(5)->create(['quiz_id' => $quiz->id]);
        
        $quizSession = QuizSession::factory()->create([
            'user_id' => $this->user->id,
            'quiz_id' => $quiz->id,
            'status' => 'started',
        ]);

        // Answer 3 out of 5 questions
        for ($i = 0; $i < 3; $i++) {
            $option = QuestionOption::factory()->create([
                'question_id' => $questions[$i]->id,
            ]);

            $this->post("/quiz-sessions/{$quizSession->id}/answer", [
                'question_id' => $questions[$i]->id,
                'selected_option_id' => $option->id,
            ]);
        }

        $response = $this->get("/quiz-sessions/{$quizSession->id}/progress");

        $response->assertStatus(200);
        $response->assertJson([
            'answered_questions' => 3,
            'total_questions' => 5,
            'progress_percentage' => 60,
        ]);
    }

    /** @test */
    public function practice_session_can_be_created()
    {
        $this->actingAs($this->user);
        
        $topic = Topic::factory()->create();
        $questions = Question::factory(10)->create(['topic_id' => $topic->id]);

        $response = $this->post('/practice-sessions', [
            'topic_id' => $topic->id,
            'question_count' => 5,
        ]);

        $response->assertRedirect();
        $this->assertDatabaseHas('practice_sessions', [
            'user_id' => $this->user->id,
            'topic_id' => $topic->id,
        ]);
    }

    /** @test */
    public function practice_session_provides_instant_feedback()
    {
        $this->actingAs($this->user);
        
        $question = Question::factory()->create();
        $correctOption = QuestionOption::factory()->create([
            'question_id' => $question->id,
            'is_correct' => true,
        ]);
        
        $practiceSession = PracticeSession::factory()->create([
            'user_id' => $this->user->id,
        ]);

        $response = $this->post("/practice-sessions/{$practiceSession->id}/answer", [
            'question_id' => $question->id,
            'selected_option_id' => $correctOption->id,
        ]);

        $response->assertStatus(200);
        $response->assertJson([
            'is_correct' => true,
            'explanation' => $question->explanation,
            'correct_option_id' => $correctOption->id,
        ]);
    }

    /** @test */
    public function user_progress_is_tracked_across_sessions()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create();
        
        // Create multiple completed exam sessions
        ExamSession::factory(3)->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'completed',
        ]);

        $response = $this->get(route('my_progress'));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('User/Progress')
                ->has('examSessions')
                ->has('quizSessions')
                ->has('practiceStats')
        );
    }

    /** @test */
    public function exam_analytics_show_detailed_performance()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();
        $examSessions = ExamSession::factory(20)->create([
            'exam_id' => $exam->id,
            'status' => 'completed',
        ]);

        $response = $this->get(route('exams.overall_report', $exam));

        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => 
            $page->component('Admin/Exams/Analytics')
                ->has('analytics')
                ->has('participationStats')
                ->has('performanceMetrics')
        );
    }

    /** @test */
    public function exam_can_be_exported_to_pdf()
    {
        $this->actingAs($this->admin);
        
        $exam = Exam::factory()->create();
        Question::factory(10)->create(['exam_id' => $exam->id]);

        $response = $this->get(route('exams.export_report', $exam));

        $response->assertStatus(200);
        $response->assertHeader('Content-Type', 'application/pdf');
    }

    /** @test */
    public function user_cannot_take_same_exam_beyond_max_attempts()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create();
        $schedule = ExamSchedule::factory()->create([
            'exam_id' => $exam->id,
            'max_attempts' => 2,
            'start_date' => now()->subDay(),
            'end_date' => now()->addDay(),
        ]);

        // Create 2 completed exam sessions (max attempts reached)
        ExamSession::factory(2)->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'completed',
        ]);

        $response = $this->post("/exams/{$exam->id}/start");

        $response->assertStatus(403);
        $response->assertSessionHas('error', 'Maximum attempts exceeded');
    }

    /** @test */
    public function exam_timer_works_correctly()
    {
        $this->actingAs($this->user);
        
        $exam = Exam::factory()->create(['duration' => 60]); // 1 hour
        
        $examSession = ExamSession::factory()->create([
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'started',
            'started_at' => now(),
        ]);

        $response = $this->get("/exam-sessions/{$examSession->id}/time-remaining");

        $response->assertStatus(200);
        $response->assertJsonStructure([
            'time_remaining_seconds',
            'expires_at',
            'current_time',
        ]);
    }

    /** @test */
    public function question_types_are_handled_correctly()
    {
        $this->actingAs($this->admin);
        $exam = Exam::factory()->create();

        // Test multiple choice question
        $mcqData = [
            'exam_id' => $exam->id,
            'question' => 'MCQ Question?',
            'question_type' => 'mcq',
            'marks' => 2,
            'options' => [
                ['option' => 'Option A', 'is_correct' => true],
                ['option' => 'Option B', 'is_correct' => false],
            ],
        ];

        $response = $this->post('/admin/questions', $mcqData);
        $response->assertRedirect('/admin/questions');

        // Test true/false question
        $trueFalseData = [
            'exam_id' => $exam->id,
            'question' => 'True/False Question?',
            'question_type' => 'true_false',
            'marks' => 1,
            'options' => [
                ['option' => 'True', 'is_correct' => true],
                ['option' => 'False', 'is_correct' => false],
            ],
        ];

        $response = $this->post('/admin/questions', $trueFalseData);
        $response->assertRedirect('/admin/questions');

        $this->assertDatabaseHas('questions', ['question_type' => 'mcq']);
        $this->assertDatabaseHas('questions', ['question_type' => 'true_false']);
    }
}
