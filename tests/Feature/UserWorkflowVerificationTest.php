<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Practice;
use App\Models\Question;
use App\Models\Lesson;
use App\Models\Category;
use App\Models\ExamRegistration;
use App\Models\QuizSubmission;
use App\Models\PracticeSession;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Storage;
use Carbon\Carbon;

class UserWorkflowVerificationTest extends TestCase
{
    use RefreshDatabase;

    protected $user;

    protected function setUp(): void
    {
        parent::setUp();
        
        $this->user = User::factory()->create([
            'email_verified_at' => now(),
        ]);
    }

    /** @test */
    public function test_complete_exam_workflow()
    {
        $this->actingAs($this->user);
        
        // Create exam with all question types
        $exam = Exam::factory()->create([
            'title' => 'Comprehensive Mathematics Exam',
            'description' => 'Test covering algebra, geometry, and calculus',
            'status' => 'published',
            'start_date' => now()->subHour(),
            'end_date' => now()->addHours(2),
            'duration' => 120, // 2 hours
            'total_marks' => 100,
            'passing_marks' => 60,
            'is_public' => true,
            'instructions' => 'Read all questions carefully. Mathematical formulas can be written using LaTeX syntax.',
        ]);

        // Create MSA (Multiple Single Answer) question
        $msaQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'msa',
            'question_text' => 'What is the derivative of $f(x) = x^2 + 3x + 2$?',
            'options' => json_encode([
                'A' => '$2x + 3$',
                'B' => '$x^2 + 3$',
                'C' => '$2x$',
                'D' => '$3x + 2$'
            ]),
            'correct_answer' => 'A',
            'marks' => 4,
            'difficulty' => 'medium',
            'explanation' => 'Using power rule: $\frac{d}{dx}(x^2) = 2x$ and $\frac{d}{dx}(3x) = 3$',
        ]);

        // Create MMA (Multiple Multiple Answer) question
        $mmaQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'mma',
            'question_text' => 'Which of the following are prime numbers? (Select all that apply)',
            'options' => json_encode([
                'A' => '17',
                'B' => '21',
                'C' => '23',
                'D' => '27',
                'E' => '29'
            ]),
            'correct_answer' => json_encode(['A', 'C', 'E']),
            'marks' => 6,
            'difficulty' => 'easy',
            'partial_marking' => true,
        ]);

        // Create MTF (Match The Following) question
        $mtfQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'mtf',
            'question_text' => 'Match the following mathematical constants with their approximate values:',
            'options' => json_encode([
                'left' => ['π (Pi)', 'e (Euler)', '√2', 'φ (Golden Ratio)'],
                'right' => ['2.718', '1.414', '3.142', '1.618']
            ]),
            'correct_answer' => json_encode([
                'π (Pi)' => '3.142',
                'e (Euler)' => '2.718',
                '√2' => '1.414',
                'φ (Golden Ratio)' => '1.618'
            ]),
            'marks' => 8,
            'difficulty' => 'medium',
        ]);

        // Create ORD (Ordering) question
        $ordQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'ord',
            'question_text' => 'Arrange the following numbers in ascending order: 0.5, 1/3, 2/5, 0.6',
            'options' => json_encode([
                'items' => ['0.5', '1/3', '2/5', '0.6']
            ]),
            'correct_answer' => json_encode(['1/3', '2/5', '0.5', '0.6']),
            'marks' => 5,
            'difficulty' => 'medium',
        ]);

        // Create FIB (Fill In The Blanks) question
        $fibQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'fib',
            'question_text' => 'The quadratic formula is: $x = \frac{-b \pm \sqrt{___^2 - 4ac}}{___}$',
            'blanks_count' => 2,
            'correct_answer' => json_encode(['b', '2a']),
            'marks' => 4,
            'difficulty' => 'easy',
        ]);

        // Create SAQ (Short Answer Question)
        $saqQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'saq',
            'question_text' => 'Explain the geometric interpretation of the derivative of a function.',
            'correct_answer' => 'The derivative represents the slope of the tangent line to the curve at any given point.',
            'marks' => 8,
            'difficulty' => 'hard',
            'word_limit' => 100,
        ]);

        // Create LAQ (Long Answer Question)
        $laqQuestion = Question::factory()->create([
            'exam_id' => $exam->id,
            'type' => 'laq',
            'question_text' => 'Prove that the sum of the first n natural numbers is $\frac{n(n+1)}{2}$ using mathematical induction.',
            'marks' => 15,
            'difficulty' => 'hard',
            'word_limit' => 500,
        ]);

        // Test exam discovery
        $response = $this->get('/exams');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Index')
            ->has('exams.data')
        );

        // Test exam details view
        $response = $this->get("/exams/{$exam->id}");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Show')
            ->where('exam.title', $exam->title)
            ->where('exam.duration', 120)
        );

        // Test exam registration
        $response = $this->post("/exams/{$exam->id}/register");
        $response->assertRedirect();
        
        $this->assertDatabaseHas('exam_registrations', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'registered',
        ]);

        // Test exam start
        $response = $this->get("/exams/{$exam->id}/take");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Take')
            ->has('exam')
            ->has('questions')
            ->where('exam.id', $exam->id)
        );

        // Test answering different question types
        
        // MSA Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $msaQuestion->id,
            'answer' => 'A',
        ]);
        $response->assertStatus(200);

        // MMA Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $mmaQuestion->id,
            'answer' => ['A', 'C', 'E'],
        ]);
        $response->assertStatus(200);

        // MTF Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $mtfQuestion->id,
            'answer' => [
                'π (Pi)' => '3.142',
                'e (Euler)' => '2.718',
                '√2' => '1.414',
                'φ (Golden Ratio)' => '1.618'
            ],
        ]);
        $response->assertStatus(200);

        // ORD Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $ordQuestion->id,
            'answer' => ['1/3', '2/5', '0.5', '0.6'],
        ]);
        $response->assertStatus(200);

        // FIB Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $fibQuestion->id,
            'answer' => ['b', '2a'],
        ]);
        $response->assertStatus(200);

        // SAQ Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $saqQuestion->id,
            'answer' => 'The derivative represents the slope of the tangent line to the curve at any given point.',
        ]);
        $response->assertStatus(200);

        // LAQ Question
        $response = $this->post("/exams/{$exam->id}/answer", [
            'question_id' => $laqQuestion->id,
            'answer' => 'Base case: For n=1, LHS = 1, RHS = 1(1+1)/2 = 1. True.\nInductive step: Assume true for n=k. For n=k+1...',
        ]);
        $response->assertStatus(200);

        // Test auto-save functionality
        $response = $this->post("/exams/{$exam->id}/auto-save", [
            'question_id' => $msaQuestion->id,
            'answer' => 'B', // Different answer for testing
            'time_remaining' => 6000,
        ]);
        $response->assertStatus(200);
        $response->assertJson(['saved' => true]);

        // Test exam navigation
        $response = $this->get("/exams/{$exam->id}/question/{$mmaQuestion->id}");
        $response->assertStatus(200);

        // Test exam submission
        $allAnswers = [
            $msaQuestion->id => 'A',
            $mmaQuestion->id => ['A', 'C', 'E'],
            $mtfQuestion->id => [
                'π (Pi)' => '3.142',
                'e (Euler)' => '2.718',
                '√2' => '1.414',
                'φ (Golden Ratio)' => '1.618'
            ],
            $ordQuestion->id => ['1/3', '2/5', '0.5', '0.6'],
            $fibQuestion->id => ['b', '2a'],
            $saqQuestion->id => 'The derivative represents the slope of the tangent line to the curve at any given point.',
            $laqQuestion->id => 'Mathematical induction proof showing base case and inductive step...',
        ];

        $response = $this->post("/exams/{$exam->id}/submit", [
            'answers' => $allAnswers,
            'time_taken' => 7200, // 2 hours in seconds
        ]);
        $response->assertRedirect();

        // Verify submission was recorded
        $this->assertDatabaseHas('exam_submissions', [
            'user_id' => $this->user->id,
            'exam_id' => $exam->id,
            'status' => 'submitted',
        ]);

        // Test result viewing
        $response = $this->get("/exams/{$exam->id}/result");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Result')
            ->has('submission')
            ->has('questions')
            ->where('exam.id', $exam->id)
        );

        // Test detailed analytics
        $response = $this->get("/exams/{$exam->id}/analytics");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Analytics')
            ->has('analytics')
        );
    }

    /** @test */
    public function test_complete_quiz_workflow()
    {
        $this->actingAs($this->user);
        
        $category = Category::factory()->create(['name' => 'Science']);
        
        $quiz = Quiz::factory()->create([
            'title' => 'Quick Science Quiz',
            'description' => 'Test your basic science knowledge',
            'category_id' => $category->id,
            'status' => 'published',
            'is_public' => true,
            'time_limit' => 10, // 10 minutes
            'questions_count' => 5,
            'show_correct_answer' => true,
            'allow_review' => true,
        ]);

        // Create quiz questions
        $questions = [];
        for ($i = 1; $i <= 5; $i++) {
            $questions[] = Question::factory()->create([
                'quiz_id' => $quiz->id,
                'type' => 'msa',
                'question_text' => "Science Question {$i}?",
                'options' => json_encode([
                    'A' => "Option A for question {$i}",
                    'B' => "Option B for question {$i}",
                    'C' => "Option C for question {$i}",
                    'D' => "Option D for question {$i}"
                ]),
                'correct_answer' => 'A',
                'marks' => 1,
                'explanation' => "Explanation for question {$i}",
            ]);
        }

        // Test quiz discovery
        $response = $this->get('/quiz');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Quiz/Index')
            ->has('quizzes.data')
        );

        // Test quiz details
        $response = $this->get("/quiz/{$quiz->id}");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Quiz/Show')
            ->where('quiz.title', $quiz->title)
        );

        // Test quiz start
        $response = $this->get("/quiz/{$quiz->id}/take");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Quiz/Take')
            ->has('quiz')
            ->has('questions')
        );

        // Test answering quiz questions with immediate feedback
        foreach ($questions as $index => $question) {
            $response = $this->post("/quiz/{$quiz->id}/answer", [
                'question_id' => $question->id,
                'answer' => 'A', // Correct answer
                'question_number' => $index + 1,
            ]);
            
            $response->assertStatus(200);
            $response->assertJson([
                'correct' => true,
                'explanation' => "Explanation for question " . ($index + 1),
            ]);
        }

        // Test quiz completion
        $answers = collect($questions)->mapWithKeys(function ($question) {
            return [$question->id => 'A'];
        })->toArray();

        $response = $this->post("/quiz/{$quiz->id}/submit", [
            'answers' => $answers,
            'time_taken' => 480, // 8 minutes
        ]);
        
        $response->assertStatus(200);
        $response->assertJson(['score' => 5, 'total' => 5]);

        // Verify submission
        $this->assertDatabaseHas('quiz_submissions', [
            'user_id' => $this->user->id,
            'quiz_id' => $quiz->id,
            'score' => 5,
            'total_questions' => 5,
        ]);

        // Test leaderboard
        $response = $this->get("/quiz/{$quiz->id}/leaderboard");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Quiz/Leaderboard')
            ->has('leaderboard')
        );

        // Test quiz review
        $response = $this->get("/quiz/{$quiz->id}/review");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Quiz/Review')
            ->has('submission')
            ->has('questions')
        );
    }

    /** @test */
    public function test_complete_practice_workflow()
    {
        $this->actingAs($this->user);
        
        $lesson = Lesson::factory()->create([
            'title' => 'Introduction to Calculus',
            'content' => 'Basic concepts of derivatives and integrals...',
        ]);
        
        $practice = Practice::factory()->create([
            'title' => 'Calculus Practice Set',
            'description' => 'Practice problems on derivatives and integrals',
            'lesson_id' => $lesson->id,
            'status' => 'published',
            'is_public' => true,
            'difficulty' => 'medium',
            'estimated_time' => 30,
        ]);

        // Create practice questions with solutions and hints
        $questions = [];
        for ($i = 1; $i <= 10; $i++) {
            $questions[] = Question::factory()->create([
                'practice_id' => $practice->id,
                'type' => 'msa',
                'question_text' => "Find the derivative of $f(x) = x^{$i}$",
                'options' => json_encode([
                    'A' => "{$i}x^" . ($i - 1),
                    'B' => "x^{$i}",
                    'C' => ($i + 1) . "x^{$i}",
                    'D' => "x^" . ($i + 1)
                ]),
                'correct_answer' => 'A',
                'marks' => 1,
                'explanation' => "Using the power rule: $\\frac{d}{dx}(x^{$i}) = {$i}x^" . ($i - 1) . "$",
                'hint' => "Remember the power rule: the derivative of $x^n$ is $nx^{n-1}$",
                'solution' => "Step-by-step solution for finding derivative of $x^{$i}$...",
                'difficulty' => $i <= 3 ? 'easy' : ($i <= 7 ? 'medium' : 'hard'),
            ]);
        }

        // Test practice discovery
        $response = $this->get('/practice');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Practice/Index')
            ->has('practices.data')
        );

        // Test lesson content access
        $response = $this->get("/lessons/{$lesson->id}");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Lesson/Show')
            ->where('lesson.title', $lesson->title)
        );

        // Test practice session start
        $response = $this->get("/practice/{$practice->id}/start");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Practice/Session')
            ->has('practice')
            ->has('questions')
        );

        // Test practice question interaction
        $question = $questions[0];
        
        // Test hint request
        $response = $this->post("/practice/{$practice->id}/hint", [
            'question_id' => $question->id,
        ]);
        $response->assertStatus(200);
        $response->assertJson([
            'hint' => $question->hint,
        ]);

        // Test wrong answer (should get feedback)
        $response = $this->post("/practice/{$practice->id}/answer", [
            'question_id' => $question->id,
            'answer' => 'B', // Wrong answer
        ]);
        $response->assertStatus(200);
        $response->assertJson([
            'correct' => false,
            'explanation' => $question->explanation,
        ]);

        // Test correct answer
        $response = $this->post("/practice/{$practice->id}/answer", [
            'question_id' => $question->id,
            'answer' => 'A', // Correct answer
        ]);
        $response->assertStatus(200);
        $response->assertJson([
            'correct' => true,
            'explanation' => $question->explanation,
            'points_earned' => 1,
        ]);

        // Test solution request
        $response = $this->post("/practice/{$practice->id}/solution", [
            'question_id' => $question->id,
        ]);
        $response->assertStatus(200);
        $response->assertJson([
            'solution' => $question->solution,
        ]);

        // Test practice session progress
        $response = $this->get("/practice/{$practice->id}/progress");
        $response->assertStatus(200);
        $response->assertJsonStructure([
            'session',
            'progress',
            'stats',
        ]);

        // Test practice session completion
        $answers = collect($questions)->take(5)->mapWithKeys(function ($question) {
            return [$question->id => 'A'];
        })->toArray();

        $response = $this->post("/practice/{$practice->id}/complete", [
            'answers' => $answers,
            'time_taken' => 1200, // 20 minutes
            'hints_used' => 2,
            'solutions_viewed' => 1,
        ]);
        
        $response->assertRedirect();
        
        $this->assertDatabaseHas('practice_sessions', [
            'user_id' => $this->user->id,
            'practice_id' => $practice->id,
            'status' => 'completed',
        ]);

        // Test practice analytics
        $response = $this->get("/practice/{$practice->id}/analytics");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Practice/Analytics')
            ->has('session')
            ->has('analytics')
        );

        // Test progress tracking across sessions
        $response = $this->get('/progress');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('User/Progress')
            ->has('progress')
        );
    }

    /** @test */
    public function test_rich_text_editing_workflow()
    {
        $this->actingAs($this->user);
        
        // Test creating content with rich text (simulating Tiptap editor)
        $richContent = [
            'type' => 'doc',
            'content' => [
                [
                    'type' => 'paragraph',
                    'content' => [
                        ['type' => 'text', 'text' => 'This is a mathematical equation: '],
                        ['type' => 'text', 'marks' => [['type' => 'math']], 'text' => 'E = mc^2'],
                    ],
                ],
                [
                    'type' => 'paragraph',
                    'content' => [
                        ['type' => 'text', 'text' => 'Here is a '],
                        ['type' => 'text', 'marks' => [['type' => 'bold']], 'text' => 'bold text'],
                        ['type' => 'text', 'text' => ' and '],
                        ['type' => 'text', 'marks' => [['type' => 'italic']], 'text' => 'italic text'],
                    ],
                ],
            ],
        ];

        // Test rich text saving (e.g., in a practice question)
        $practice = Practice::factory()->create(['status' => 'draft']);
        
        $response = $this->post('/admin/questions', [
            'practice_id' => $practice->id,
            'type' => 'saq',
            'question_text' => json_encode($richContent),
            'correct_answer' => 'Sample answer with mathematical notation',
            'marks' => 5,
        ]);
        
        $response->assertRedirect();
        $this->assertDatabaseHas('questions', [
            'practice_id' => $practice->id,
            'type' => 'saq',
        ]);
    }

    /** @test */
    public function test_file_upload_and_media_workflow()
    {
        Storage::fake('public');
        $this->actingAs($this->user);

        // Test profile image upload
        $profileImage = UploadedFile::fake()->image('profile.jpg', 400, 400);
        
        $response = $this->post('/profile/avatar', [
            'avatar' => $profileImage,
        ]);
        
        $response->assertStatus(200);
        Storage::disk('public')->assertExists('avatars/' . $profileImage->hashName());

        // Test document upload for assignments
        $document = UploadedFile::fake()->create('assignment.pdf', 2048, 'application/pdf');
        
        $response = $this->post('/assignments/upload', [
            'file' => $document,
            'title' => 'My Assignment',
        ]);
        
        $response->assertRedirect();
        Storage::disk('public')->assertExists('assignments/' . $document->hashName());

        // Test image upload for question content
        $questionImage = UploadedFile::fake()->image('diagram.png', 600, 400);
        
        $response = $this->post('/content/upload', [
            'image' => $questionImage,
            'context' => 'question',
        ]);
        
        $response->assertStatus(200);
        $response->assertJsonStructure(['url', 'path']);
        Storage::disk('public')->assertExists('content/' . $questionImage->hashName());
    }

    /** @test */
    public function test_content_search_and_filtering()
    {
        $this->actingAs($this->user);
        
        // Create test data
        $mathCategory = Category::factory()->create(['name' => 'Mathematics']);
        $physicsCategory = Category::factory()->create(['name' => 'Physics']);
        
        $algebraExam = Exam::factory()->create([
            'title' => 'Algebra Fundamentals',
            'category_id' => $mathCategory->id,
            'status' => 'published',
        ]);
        
        $calculusExam = Exam::factory()->create([
            'title' => 'Differential Calculus',
            'category_id' => $mathCategory->id,
            'status' => 'published',
        ]);
        
        $mechanicsExam = Exam::factory()->create([
            'title' => 'Classical Mechanics',
            'category_id' => $physicsCategory->id,
            'status' => 'published',
        ]);

        // Test search functionality
        $response = $this->get('/search?q=algebra');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Search/Results')
            ->has('results')
        );

        // Test category filtering
        $response = $this->get("/exams?category={$mathCategory->id}");
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Exam/Index')
            ->has('exams.data')
        );

        // Test difficulty filtering
        $response = $this->get('/exams?difficulty=medium');
        $response->assertStatus(200);

        // Test combined filtering
        $response = $this->get("/exams?category={$mathCategory->id}&difficulty=hard&status=published");
        $response->assertStatus(200);
    }

    /** @test */
    public function test_progress_tracking_and_analytics()
    {
        $this->actingAs($this->user);
        
        // Create completed activities
        $exam = Exam::factory()->create(['status' => 'published']);
        $quiz = Quiz::factory()->create(['status' => 'published']);
        $practice = Practice::factory()->create(['status' => 'published']);
        
        // Create submissions with different scores
        $examSubmission = $this->user->examSubmissions()->create([
            'exam_id' => $exam->id,
            'score' => 85,
            'total_marks' => 100,
            'time_taken' => 7200,
            'status' => 'submitted',
        ]);
        
        $quizSubmission = $this->user->quizSubmissions()->create([
            'quiz_id' => $quiz->id,
            'score' => 9,
            'total_questions' => 10,
            'time_taken' => 600,
        ]);
        
        $practiceSession = $this->user->practiceSessions()->create([
            'practice_id' => $practice->id,
            'score' => 78,
            'total_questions' => 15,
            'hints_used' => 3,
            'time_taken' => 1800,
            'status' => 'completed',
        ]);

        // Test personal dashboard
        $response = $this->get('/dashboard');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('Dashboard')
            ->has('stats')
            ->has('recentActivities')
            ->has('upcomingExams')
        );

        // Test detailed progress view
        $response = $this->get('/progress/detailed');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('User/DetailedProgress')
            ->has('examProgress')
            ->has('quizProgress')
            ->has('practiceProgress')
        );

        // Test performance analytics
        $response = $this->get('/analytics/performance');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('User/PerformanceAnalytics')
            ->has('performanceData')
            ->has('trendsData')
        );

        // Test achievements and badges
        $response = $this->get('/achievements');
        $response->assertStatus(200);
        $response->assertInertia(fn ($page) => $page
            ->component('User/Achievements')
            ->has('achievements')
            ->has('badges')
        );
    }
}
