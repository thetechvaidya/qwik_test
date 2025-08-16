<?php

namespace Tests\Feature;

use Illuminate\Foundation\Testing\RefreshDatabase;
use Tests\TestCase;

class UserCompositionMigrationTest extends TestCase
{
    // Remove RefreshDatabase since we're just testing file contents
    // use RefreshDatabase;

    /**
     * Test that composables are properly imported and used in Vue components
     */
    public function test_composables_are_properly_imported()
    {
        // Test files exist and have correct imports
        $examScreenPath = resource_path('js/Pages/User/ExamScreen.vue');
        $quizScreenPath = resource_path('js/Pages/User/QuizScreen.vue');
        $practiceScreenPath = resource_path('js/Pages/User/PracticeScreen.vue');
        
        $this->assertFileExists($examScreenPath);
        $this->assertFileExists($quizScreenPath);
        $this->assertFileExists($practiceScreenPath);
        
        // Check that composables are imported
        $examContent = file_get_contents($examScreenPath);
        $this->assertStringContainsString('useSessionManager', $examContent);
        $this->assertStringContainsString('useQuestionNavigation', $examContent);
        $this->assertStringContainsString('useTimer', $examContent);
        
        $quizContent = file_get_contents($quizScreenPath);
        $this->assertStringContainsString('useSessionManager', $quizContent);
        $this->assertStringContainsString('useQuestionNavigation', $quizContent);
        $this->assertStringContainsString('useTimer', $quizContent);
        
        $practiceContent = file_get_contents($practiceScreenPath);
        $this->assertStringContainsString('useSessionManager', $practiceContent);
        $this->assertStringContainsString('useQuestionNavigation', $practiceContent);
    }

    /**
     * Test that composable files exist and have correct structure
     */
    public function test_composable_files_exist_and_have_correct_structure()
    {
        $timerPath = resource_path('js/composables/useTimer.js');
        $sessionManagerPath = resource_path('js/composables/useSessionManager.js');
        $navigationPath = resource_path('js/composables/useQuestionNavigation.js');
        
        $this->assertFileExists($timerPath);
        $this->assertFileExists($sessionManagerPath);
        $this->assertFileExists($navigationPath);
        
        // Check basic structure
        $timerContent = file_get_contents($timerPath);
        $this->assertStringContainsString('export function useTimer', $timerContent);
        $this->assertStringContainsString('import { ref, reactive, computed, onMounted, onUnmounted, readonly }', $timerContent);
        
        $sessionContent = file_get_contents($sessionManagerPath);
        $this->assertStringContainsString('export function useSessionManager', $sessionContent);
        $this->assertStringContainsString('answeredCount', $sessionContent);
        
        $navigationContent = file_get_contents($navigationPath);
        $this->assertStringContainsString('export function useQuestionNavigation', $navigationContent);
        $this->assertStringContainsString('answeredMarkForReviewQuestions', $navigationContent);
        $this->assertStringContainsString('notVisitedQuestions', $navigationContent);
    }

    /**
     * Test timer composable fixes
     */
    public function test_timer_composable_fixes()
    {
        $timerPath = resource_path('js/composables/useTimer.js');
        $content = file_get_contents($timerPath);
        
        // Test that readonly is imported
        $this->assertStringContainsString('readonly', $content);
        
        // Test that startTimer has guard clause
        $this->assertStringContainsString('if (state.isCompleted || state.isExpired || state.isActive || state.intervalId) return false', $content);
        
        // Test that readonly is used in return statement
        $this->assertStringContainsString('state: readonly(state)', $content);
    }

    /**
     * Test question navigation composable has required computed properties
     */
    public function test_question_navigation_has_required_computed()
    {
        $navigationPath = resource_path('js/composables/useQuestionNavigation.js');
        $content = file_get_contents($navigationPath);
        
        // Test computed properties exist
        $this->assertStringContainsString('answeredMarkForReviewQuestions', $content);
        $this->assertStringContainsString('notVisitedQuestions', $content);
        $this->assertStringContainsString('answered_mark_for_review', $content);
        $this->assertStringContainsString('not_visited', $content);
        
        // Test they are exported
        $this->assertStringContainsString('answeredMarkForReviewQuestions,', $content);
        $this->assertStringContainsString('notVisitedQuestions,', $content);
    }

    /**
     * Test session manager composable improvements
     */
    public function test_session_manager_improvements()
    {
        $sessionPath = resource_path('js/composables/useSessionManager.js');
        $content = file_get_contents($sessionPath);
        
        // Test answered count includes answered_mark_for_review
        $this->assertStringContainsString('answered_mark_for_review', $content);
        
        // Test updateQuestionStatus method exists
        $this->assertStringContainsString('updateQuestionStatus', $content);
        
        // Test notVisitedCount computed exists
        $this->assertStringContainsString('notVisitedCount', $content);
    }

    /**
     * Test QuizScreen uses correct timer API
     */
    public function test_quiz_screen_uses_correct_timer_api()
    {
        $quizPath = resource_path('js/Pages/User/QuizScreen.vue');
        $content = file_get_contents($quizPath);
        
        // Should use formattedCurrentTime instead of hours/minutes/seconds
        $this->assertStringContainsString('quizTimer.formattedCurrentTime', $content);
        $this->assertStringNotContainsString('quizTimer.hours', $content);
        $this->assertStringNotContainsString('quizTimer.minutes', $content);
        $this->assertStringNotContainsString('quizTimer.seconds', $content);
    }

    /**
     * Test PracticeScreen uses correct session properties
     */
    public function test_practice_screen_uses_correct_session_properties()
    {
        $practicePath = resource_path('js/Pages/User/PracticeScreen.vue');
        $content = file_get_contents($practicePath);
        
        // Should use session.total_points_earned instead of totalPointsEarned
        $this->assertStringContainsString('sessionManager.session.total_points_earned', $content);
        $this->assertStringNotContainsString('sessionManager.totalPointsEarned', $content);
        
        // Should use Link instead of inertia-link
        $this->assertStringContainsString('<Link', $content);
        $this->assertStringNotContainsString('<inertia-link', $content);
        $this->assertStringNotContainsString('</inertia-link', $content);
    }

    /**
     * Test tooltip directive standardization
     */
    public function test_tooltip_directive_standardization()
    {
        $examPath = resource_path('js/Pages/User/ExamScreen.vue');
        $quizPath = resource_path('js/Pages/User/QuizScreen.vue');
        
        $examContent = file_get_contents($examPath);
        $quizContent = file_get_contents($quizPath);
        
        // Both should use defineOptions for directive registration
        $this->assertStringContainsString('defineOptions({', $examContent);
        $this->assertStringContainsString('defineOptions({', $quizContent);
        $this->assertStringContainsString('directives:', $examContent);
        $this->assertStringContainsString('directives:', $quizContent);
        $this->assertStringContainsString('tooltip: Tooltip', $examContent);
        $this->assertStringContainsString('tooltip: Tooltip', $quizContent);
    }

    /**
     * Test that migration maintains backward compatibility
     */
    public function test_backward_compatibility_maintained()
    {
        // Test that essential methods still exist
        $sessionPath = resource_path('js/composables/useSessionManager.js');
        $content = file_get_contents($sessionPath);
        
        $this->assertStringContainsString('nextQuestion', $content);
        $this->assertStringContainsString('prevQuestion', $content);
        $this->assertStringContainsString('jumpToQuestion', $content);
        $this->assertStringContainsString('updateAnswer', $content);
        $this->assertStringContainsString('submitAnswer', $content);
    }

    /**
     * Test component integration flows work correctly
     */
    public function test_component_integration_flows()
    {
        // This would normally involve browser testing, but we can at least check
        // that the components are structured correctly for integration
        
        $examPath = resource_path('js/Pages/User/ExamScreen.vue');
        $content = file_get_contents($examPath);
        
        // Check that section timers are initialized
        $this->assertStringContainsString('sectionTimers.value[currentSectionIndex] = useTimer', $content);
        
        // Check sessionManager integration
        $this->assertStringContainsString('sessionManager.session', $content);
    }

    /**
     * Additional functional static checks per migration plan
     */
    public function test_elapsed_timer_autosave_and_status_sync_present()
    {
        $base = resource_path('js/Pages/User');

        // ExamScreen: elapsedTimer, auto-save, status sync
        $exam = file_get_contents($base . '/ExamScreen.vue');
        $this->assertStringContainsString('const elapsedTimer = useTimer', $exam);
        $this->assertStringContainsString('elapsedTimer.startTimer()', $exam);
        $this->assertStringContainsString('sessionManager.startAutoSave()', $exam);
        $this->assertStringContainsString('sessionManager.session.question_status = { ...statuses }', $exam);

        // QuizScreen: auto-save and status sync
        $quiz = file_get_contents($base . '/QuizScreen.vue');
        $this->assertStringContainsString('sessionManager.startAutoSave()', $quiz);
        $this->assertStringContainsString('sessionManager.session.question_status = { ...statuses }', $quiz);

        // PracticeScreen: auto-save and status sync
        $practice = file_get_contents($base . '/PracticeScreen.vue');
        $this->assertStringContainsString('sessionManager.startAutoSave()', $practice);
        $this->assertStringContainsString('sessionManager.session.question_status = { ...statuses }', $practice);
    }
}
