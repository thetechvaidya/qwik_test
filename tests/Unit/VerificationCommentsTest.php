<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

class VerificationCommentsTest extends TestCase
{
    /**
     * Get the absolute path to the project root.
     */
    private function projectRoot(): string
    {
        // tests/Unit -> tests -> project root
        return dirname(__DIR__, 2);
    }

    /**
     * Resolve a path under the resources directory without relying on Laravel helpers.
     */
    private function resourcesPath(string $path = ''): string
    {
        $base = $this->projectRoot() . DIRECTORY_SEPARATOR . 'resources';
        return $path ? $base . DIRECTORY_SEPARATOR . ltrim($path, DIRECTORY_SEPARATOR) : $base;
    }

    /**
     * Test that all verification comments have been implemented.
     */
    public function test_verification_comments_implemented()
    {
        // Comment 1: Test ExamScreen.vue updateAnswer method includes composable sync
        $examScreenPath = $this->resourcesPath('js/Pages/User/ExamScreen.vue');
        $examScreenContent = file_get_contents($examScreenPath);
        
    $this->assertStringContainsString('sessionManager.updateAnswer(currentQuestion.code, value', $examScreenContent, 
            'Comment 1: ExamScreen updateAnswer should sync with composables');
        
        // Comment 2: Test QuizScreen.vue uses navigation.viewMode instead of chipView
    $quizScreenPath = $this->resourcesPath('js/Pages/User/QuizScreen.vue');
        $quizScreenContent = file_get_contents($quizScreenPath);
        
    $this->assertStringContainsString('questionNavigation.navigation.viewMode === \'chip\'', $quizScreenContent,
            'Comment 2: QuizScreen should use navigation.viewMode');
    $this->assertStringNotContainsString('questionNavigation.chipView', $quizScreenContent,
            'Comment 2: QuizScreen should not use chipView');
        
        // Comment 3: Test ExamScreen.vue has section timer management
    $this->assertStringContainsString('prevTimer.pauseTimer()', $examScreenContent,
            'Comment 3: ExamScreen should pause previous section timers');
        
        // Comment 4: Test QuizScreen.vue increments total time
    $this->assertStringContainsString('sessionManager.incrementTime(1)', $quizScreenContent,
            'Comment 4: QuizScreen should increment total time in elapsed timer');
        
        // Comment 6: Test ExamScreen.vue uses navigation composable for statistics
    $this->assertStringContainsString('questionNavigation.answeredMarkForReviewQuestions', $examScreenContent,
            'Comment 6: ExamScreen should use navigation composable for statistics');
    $this->assertStringNotContainsString('answeredMarkForReviewQuestions = computed', $examScreenContent,
            'Comment 6: ExamScreen should not have local computed statistics');
        
        // Comment 7: Test QuizResults.vue is converted to Composition API
    $quizResultsPath = $this->resourcesPath('js/Pages/User/QuizResults.vue');
        $quizResultsContent = file_get_contents($quizResultsPath);
        
    $this->assertStringContainsString('<script setup>', $quizResultsContent,
            'Comment 7: QuizResults should use script setup');
    $this->assertStringContainsString('import { Head }', $quizResultsContent,
            'Comment 7: QuizResults should import Head component');
        
        // Comment 8: Test card components are converted to Composition API
    $lightCardPath = $this->resourcesPath('js/Components/Cards/LightQuestionCard.vue');
        $lightCardContent = file_get_contents($lightCardPath);
        
    $this->assertStringContainsString('<script setup>', $lightCardContent,
            'Comment 8: LightQuestionCard should use script setup');
    $this->assertStringContainsString('onMounted(() => {', $lightCardContent,
            'Comment 8: LightQuestionCard should use onMounted instead of created');
        
        // Comment 9: Test context menu listeners are properly removed
    $this->assertStringContainsString('document.removeEventListener(\'contextmenu\'', $quizScreenContent,
            'Comment 9: QuizScreen should remove context menu listener');
        
    $practiceScreenPath = $this->resourcesPath('js/Pages/User/PracticeScreen.vue');
        $practiceScreenContent = file_get_contents($practiceScreenPath);
    $this->assertStringContainsString('document.removeEventListener(\'contextmenu\'', $practiceScreenContent,
            'Comment 9: PracticeScreen should remove context menu listener');
        
        // Comment 10: Test ExamScreen.vue uses section-specific answered count
    $this->assertStringContainsString('answeredInCurrentSection', $examScreenContent,
            'Comment 10: ExamScreen should use section-specific answered count');
    }
    
    /**
     * Test specific implementation details for composable synchronization.
     */
    public function test_composable_synchronization()
    {
    $examScreenPath = $this->resourcesPath('js/Pages/User/ExamScreen.vue');
        $examScreenContent = file_get_contents($examScreenPath);
        
        // Test that updateStatus method uses proper logic
    $this->assertStringContainsString('const wasMarked = questionNavigation.getQuestionStatus', $examScreenContent,
            'UpdateStatus should check previous marked state properly');
        
        // Test that both composables are updated in sync using unified API
        $this->assertTrue(
            str_contains($examScreenContent, 'sessionManager.setStatus(')
            || str_contains($examScreenContent, 'sessionManager.updateQuestionStatus'),
            'Should sync question status via sessionManager.setStatus or updateQuestionStatus'
        );
        // Ensure navigation is passed for synchronization
        $this->assertStringContainsString('navigation: questionNavigation', $examScreenContent,
            'Should pass navigation composable to setStatus for synchronization');
    }
    
    /**
     * Test that all chip view references are updated.
     */
    public function test_chip_view_migration()
    {
        $files = [
            $this->resourcesPath('js/Pages/User/QuizScreen.vue'),
            $this->resourcesPath('js/Pages/User/PracticeScreen.vue'),
        ];
        
        foreach ($files as $file) {
            $content = file_get_contents($file);
            $this->assertStringNotContainsString('questionNavigation.chipView', $content,
                "File $file should not contain chipView references");
            $this->assertStringContainsString('questionNavigation.setViewMode', $content,
                "File $file should use setViewMode method");
        }
    }
}
