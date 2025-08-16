<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Foundation\Testing\RefreshDatabase;
use PHPUnit\Framework\Attributes\Test;

class AdminPagesIntegrationTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        $this->actingAsAdmin();
    }

    #[Test]
    public function test_practice_sets_crud_operations()
    {
        // Test listing practice sets
        $response = $this->get(route('admin.practice-sets.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/PracticeSets'));

        // Test creating practice set
        $practiceSetData = [
            'title' => 'Test Practice Set',
            'description' => 'Test Description',
            'is_active' => true
        ];

        $response = $this->post(route('admin.practice-sets.store'), $practiceSetData);
        $response->assertRedirect();
        $this->assertDatabaseHas('practice_sets', ['title' => 'Test Practice Set']);

        // Test updating practice set
        $practiceSet = \App\Models\PracticeSet::first();
        $updateData = ['title' => 'Updated Practice Set'];
        
        $response = $this->put(route('admin.practice-sets.update', $practiceSet), $updateData);
        $response->assertRedirect();
        $this->assertDatabaseHas('practice_sets', ['title' => 'Updated Practice Set']);

        // Test deleting practice set
        $response = $this->delete(route('admin.practice-sets.destroy', $practiceSet));
        $response->assertRedirect();
        $this->assertDatabaseMissing('practice_sets', ['id' => $practiceSet->id]);
    }

    #[Test]
    public function test_quiz_schedules_crud_operations()
    {
        // Test listing quiz schedules
        $response = $this->get(route('admin.quiz-schedules.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/QuizSchedules'));

        // Test creating quiz schedule
        $quiz = \App\Models\Quiz::factory()->create();
        $scheduleData = [
            'quiz_id' => $quiz->id,
            'start_date' => now()->format('Y-m-d'),
            'start_time' => '10:00:00',
            'end_date' => now()->addDays(1)->format('Y-m-d'), 
            'end_time' => '12:00:00',
            'status' => 'active'
        ];

        $response = $this->post(route('admin.quiz-schedules.store'), $scheduleData);
        $response->assertRedirect();
        $this->assertDatabaseHas('quiz_schedules', ['quiz_id' => $quiz->id]);
    }

    #[Test]
    public function test_exam_schedules_crud_operations()
    {
        // Test listing exam schedules
        $response = $this->get(route('admin.exam-schedules.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/ExamSchedules'));

        // Test creating exam schedule
        $exam = \App\Models\Exam::factory()->create();
        $scheduleData = [
            'exam_id' => $exam->id,
            'start_date' => now()->format('Y-m-d'),
            'start_time' => '10:00:00',
            'end_date' => now()->addDays(1)->format('Y-m-d'),
            'end_time' => '12:00:00',
            'status' => 'active'
        ];

        $response = $this->post(route('admin.exam-schedules.store'), $scheduleData);
        $response->assertRedirect();
        $this->assertDatabaseHas('exam_schedules', ['exam_id' => $exam->id]);
    }

    #[Test]
    public function test_subscriptions_crud_operations()
    {
        // Test listing subscriptions
        $response = $this->get(route('admin.subscriptions.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/Subscriptions'));

        // Test creating subscription
        $user = \App\Models\User::factory()->create();
        $plan = \App\Models\Plan::factory()->create();
        $subscriptionData = [
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => 'active'
        ];

        $response = $this->post(route('admin.subscriptions.store'), $subscriptionData);
        $response->assertRedirect();
        $this->assertDatabaseHas('subscriptions', [
            'user_id' => $user->id,
            'plan_id' => $plan->id
        ]);
    }

    #[Test]
    public function test_payments_crud_operations()
    {
        // Test listing payments
        $response = $this->get(route('admin.payments.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/Payments'));

        // Test payment details view
        $payment = \App\Models\Payment::factory()->create();
        $response = $this->get(route('admin.payments.show', $payment));
        $response->assertSuccessful();
    }

    #[Test]
    public function test_quiz_types_crud_operations()
    {
        // Test listing quiz types
        $response = $this->get(route('admin.quiz-types.index'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/QuizTypes'));

        // Test creating quiz type
        $quizTypeData = [
            'name' => 'Multiple Choice',
            'description' => 'Multiple choice questions',
            'color' => '#3B82F6',
            'is_active' => true
        ];

        $response = $this->post(route('admin.quiz-types.store'), $quizTypeData);
        $response->assertRedirect();
        $this->assertDatabaseHas('quiz_types', ['name' => 'Multiple Choice']);
    }

    #[Test]
    public function test_import_questions_functionality()
    {
        // Test import questions page
        $response = $this->get(route('admin.import-questions'));
        $response->assertSuccessful();
        $response->assertInertia(fn ($page) => $page->component('Admin/ImportQuestions'));

        // Test skills search
        $skill = \App\Models\Skill::factory()->create(['name' => 'PHP']);
        $response = $this->get(route('admin.skills.search', ['query' => 'PHP']));
        $response->assertSuccessful();
        $response->assertJsonFragment(['name' => 'PHP']);
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
