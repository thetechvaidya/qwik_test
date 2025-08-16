<?php

namespace Tests\Unit;

use Tests\TestCase;

/**
 * Test admin form validation feedback mechanisms
 * Including submitStatus visual states, error handling, and UX improvements
 */
class AdminFormValidationFeedbackTest extends TestCase
{
    public function test_admin_forms_have_proper_submit_button_states()
    {
        $adminFormPaths = [
            'resources/js/Pages/Admin/Video/Form.vue',
            'resources/js/Pages/Admin/Lesson/Form.vue', 
            'resources/js/Pages/Admin/Quiz/Details.vue',
            'resources/js/Pages/Admin/Exam/Details.vue',
            'resources/js/Pages/Admin/PracticeSet/Details.vue',
            'resources/js/Pages/Admin/Question/Details.vue'
        ];
        
        foreach ($adminFormPaths as $formPath) {
            $fullPath = base_path($formPath);
            
            if (!file_exists($fullPath)) {
                $this->fail("Form file does not exist: {$formPath}");
            }
            
            $content = file_get_contents($fullPath);
            
            // Check for submitStatus reactive variable
            $this->assertStringContainsString(
                'submitStatus = ref(',
                $content,
                "Form {$formPath} should have submitStatus reactive variable"
            );
            
            // Check for validation error state handling
            $this->assertTrue(
                str_contains($content, "submitStatus.value = 'ERROR'") ||
                str_contains($content, 'submitStatus = \'ERROR\''),
                "Form {$formPath} should set submitStatus to ERROR on validation failure"
            );
            
            // Check for pending state handling  
            $this->assertTrue(
                str_contains($content, "submitStatus.value = 'PENDING'") ||
                str_contains($content, 'submitStatus = \'PENDING\''),
                "Form {$formPath} should set submitStatus to PENDING during submission"
            );
        }
    }
    
    public function test_button_components_support_validation_states()
    {
        $buttonComponentPath = base_path('resources/js/Components/Buttons/SubmitButton.vue');
        
        if (file_exists($buttonComponentPath)) {
            $content = file_get_contents($buttonComponentPath);
            
            // Basic button should exist and be functional
            $this->assertStringContainsString('<template>', $content);
            $this->assertStringContainsString('Submit', $content);
        }
        
        // Check if modern button implementations handle loading/disabled states
        $modernButtonPaths = [
            'resources/js/Components/Admin/PaymentDetails.vue',
            'resources/js/Components/Admin/SubscriptionDetails.vue'
        ];
        
        foreach ($modernButtonPaths as $componentPath) {
            $fullPath = base_path($componentPath);
            if (file_exists($fullPath)) {
                $content = file_get_contents($fullPath);
                
                // Should have proper button state handling
                $this->assertTrue(
                    str_contains($content, ':disabled="form.processing"') ||
                    str_contains($content, ':loading="form.processing"'),
                    "Component {$componentPath} should handle form processing states"
                );
                
                // Should have visual feedback for disabled state
                $this->assertStringContainsString(
                    'opacity-25',
                    $content,
                    "Component {$componentPath} should provide visual feedback for disabled state"
                );
            }
        }
    }

    public function test_memory_leak_prevention_patterns()
    {
        $componentsWithEventListeners = [
            'resources/js/Pages/User/QuizScreen.vue',
            'resources/js/Pages/User/ExamScreen.vue', 
            'resources/js/Pages/User/PracticeScreen.vue'
        ];
        
        foreach ($componentsWithEventListeners as $componentPath) {
            $fullPath = base_path($componentPath);
            
            if (file_exists($fullPath)) {
                $content = file_get_contents($fullPath);
                
                // Should have onUnmounted cleanup
                $this->assertStringContainsString(
                    'onUnmounted(',
                    $content,
                    "Component {$componentPath} should have onUnmounted lifecycle cleanup"
                );
                
                // Should clean up event listeners
                if (str_contains($content, 'addEventListener')) {
                    $this->assertStringContainsString(
                        'removeEventListener',
                        $content,
                        "Component {$componentPath} should remove event listeners in cleanup"
                    );
                }
                
                // Should clean up timers/intervals
                if (str_contains($content, 'setTimeout') || str_contains($content, 'setInterval')) {
                    $this->assertTrue(
                        str_contains($content, 'clearTimeout') || str_contains($content, 'clearInterval'),
                        "Component {$componentPath} should clear timers in cleanup"
                    );
                }
                
                // Should handle AbortController cleanup
                if (str_contains($content, 'AbortController')) {
                    $this->assertTrue(
                        str_contains($content, 'abort()') || str_contains($content, '.abort'),
                        "Component {$componentPath} should abort pending requests in cleanup"
                    );
                }
            }
        }
    }
    
    public function test_toast_error_feedback_consistency()
    {
        $adminFormPaths = [
            'resources/js/Pages/Admin/ImportQuestions.vue',
            'resources/js/Components/Admin/PaymentDetails.vue',
            'resources/js/Components/Admin/SubscriptionDetails.vue'
        ];
        
        foreach ($adminFormPaths as $formPath) {
            $fullPath = base_path($formPath);
            
            if (file_exists($fullPath)) {
                $content = file_get_contents($fullPath);
                
                // Should use toast for error feedback
                $this->assertTrue(
                    str_contains($content, 'toast.add') || 
                    str_contains($content, 'toast({') ||
                    str_contains($content, '$toast'),
                    "Form {$formPath} should use toast notifications for user feedback"
                );
                
                // Should handle both success and error states
                if (str_contains($content, "severity: 'success'")) {
                    $this->assertStringContainsString(
                        "severity: 'error'",
                        $content,
                        "Form {$formPath} should handle both success and error toast notifications"
                    );
                }
            }
        }
    }
    
    public function test_form_validation_integration()
    {
        $formsWithVuelidate = [
            'resources/js/Pages/Admin/Video/Form.vue',
            'resources/js/Pages/Admin/Lesson/Form.vue',
            'resources/js/Pages/Admin/Quiz/Details.vue'
        ];
        
        foreach ($formsWithVuelidate as $formPath) {
            $fullPath = base_path($formPath);
            
            if (file_exists($fullPath)) {
                $content = file_get_contents($fullPath);
                
                // Should use Vuelidate for validation
                $this->assertStringContainsString(
                    'useVuelidate',
                    $content,
                    "Form {$formPath} should use Vuelidate for validation"
                );
                
                // Should have proper validation triggering
                $this->assertStringContainsString(
                    'v$.$touch()',
                    $content,
                    "Form {$formPath} should trigger validation on form submission"
                );
                
                // Should check validation state
                $this->assertStringContainsString(
                    'v$.$invalid',
                    $content,
                    "Form {$formPath} should check validation state before submission"
                );
            }
        }
    }
}
