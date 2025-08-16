<?php

namespace Tests\Unit;

use Tests\TestCase;
use PHPUnit\Framework\Attributes\Test;

class AdminPagesFunctionalityTest extends TestCase
{
    private function getAllAdminPageFiles()
    {
        $adminPagesDir = resource_path('js/Pages/Admin/');
        $files = glob($adminPagesDir . '*.vue');
        return array_map(function($file) {
            return str_replace(resource_path('js/'), '', $file);
        }, $files);
    }

    #[Test]
    public function test_critical_admin_pages_have_complete_functionality()
    {
        $criticalPages = [
            'Pages/Admin/PracticeSets.vue',
            'Pages/Admin/QuizSchedules.vue', 
            'Pages/Admin/ExamSchedules.vue',
            'Pages/Admin/ImportQuestions.vue'
        ];

        foreach ($criticalPages as $pageFile) {
            $fullPath = resource_path('js/' . $pageFile);
            $this->assertFileExists($fullPath, "Critical admin page {$pageFile} should exist");

            $content = file_get_contents($fullPath);
            
            // Should have proper Vue template structure
            $this->assertStringContainsString('<template>', $content, "{$pageFile} should have template section");
            $this->assertStringContainsString('<script setup>', $content, "{$pageFile} should use Composition API");
            
            // Check for any obvious template syntax issues by examining template sections
            $templateCount = substr_count($content, '<template');
            $templateCloseCount = substr_count($content, '</template>');
            if ($templateCount > 0) {
                $this->assertEquals($templateCount, $templateCloseCount, 
                    "{$pageFile} has mismatched template tags - should have equal opening and closing template tags");
            }
            
            // Should have proper error handling
            $this->assertStringContainsString('onError:', $content,
                "{$pageFile} should have proper error handling");
            $this->assertTrue(
                str_contains($content, 'toast({') || str_contains($content, 'toast.add'),
                "{$pageFile} should provide user feedback on errors using composable toast pattern"
            );
                
            // Should have CRUD operations
            if (str_contains($pageFile, 'PracticeSets')) {
                $this->assertStringContainsString('deletePracticeSet', $content, 
                    "PracticeSets should have delete functionality");
                $this->assertStringContainsString('editPracticeSet', $content,
                    "PracticeSets should have edit functionality"); 
            }
            
            if (str_contains($pageFile, 'Schedule')) {
                $this->assertStringContainsString('deleteSchedule', $content,
                    "Schedule pages should have delete functionality");
                $this->assertStringContainsString('createForm = true', $content,
                    "Schedule pages should have create functionality");
            }
        }
    }

    #[Test] 
    public function test_admin_pages_have_proper_import_paths()
    {
        $schedulePages = [
            'Pages/Admin/QuizSchedules.vue',
            'Pages/Admin/ExamSchedules.vue'
        ];

        foreach ($schedulePages as $pageFile) {
            $fullPath = resource_path('js/' . $pageFile);
            $content = file_get_contents($fullPath);
            
            // Should import form components from correct path
            if (str_contains($pageFile, 'Quiz')) {
                $this->assertStringContainsString("from '@/Components/Forms/QuizScheduleForm.vue'", $content,
                    "QuizSchedules should import QuizScheduleForm from correct path");
            }
            
            if (str_contains($pageFile, 'Exam')) {
                $this->assertStringContainsString("from '@/Components/Forms/ExamScheduleForm.vue'", $content, 
                    "ExamSchedules should import ExamScheduleForm from correct path");
            }
        }
    }

    #[Test]
    public function test_form_components_exist_and_are_accessible()
    {
        $formComponents = [
            'resources/js/Components/Forms/QuizScheduleForm.vue',
            'resources/js/Components/Forms/ExamScheduleForm.vue',
            'resources/js/Components/Admin/SubscriptionDetails.vue',
            'resources/js/Components/Admin/PaymentDetails.vue'
        ];

        foreach ($formComponents as $component) {
            $fullPath = base_path($component);
            $this->assertFileExists($fullPath, "Form component {$component} should exist");
            
            $content = file_get_contents($fullPath);
            $this->assertStringContainsString('<template>', $content, "{$component} should be a valid Vue component");
        }
    }

    #[Test]
    public function test_admin_pages_have_proper_error_feedback()
    {
        $adminPages = $this->getAllAdminPageFiles();
        
        foreach ($adminPages as $pageFile) {
            $fullPath = resource_path('js/' . $pageFile);
            $content = file_get_contents($fullPath);
            
            // Skip non-Vue files
            if (!str_ends_with($pageFile, '.vue')) {
                continue;
            }
            
            // If the page has async operations, it should have proper error handling
            if (str_contains($content, 'axios') || str_contains($content, 'router.delete') || str_contains($content, 'router.post')) {
                $this->assertTrue(
                    str_contains($content, 'toast({') || str_contains($content, 'toast.add') || str_contains($content, 'onError'),
                    "Page {$pageFile} with async operations should have user error feedback using composable toast pattern"
                );
            }
        }
    }

    #[Test]
    public function test_import_questions_has_complete_implementation()
    {
        $fullPath = resource_path('js/Pages/Admin/ImportQuestions.vue');
        $content = file_get_contents($fullPath);
        
        // Should have skills search functionality
        $this->assertStringContainsString('searchSkills', $content,
            "ImportQuestions should have skills search functionality");
            
        // Should have proper validation error handling
        $this->assertStringContainsString('ValidationErrors', $content,
            "ImportQuestions should display validation errors");
            
        // Should have file upload handling
        $this->assertStringContainsString('handleFileUpload', $content, 
            "ImportQuestions should handle file uploads");
            
        // Should have proper form submission
        $this->assertStringContainsString('form.post', $content,
            "ImportQuestions should submit form data");
            
        // Should provide user feedback on success/failure
        $this->assertStringContainsString('onSuccess', $content,
            "ImportQuestions should handle success feedback");
        $this->assertStringContainsString('onError', $content, 
            "ImportQuestions should handle error feedback");
    }

    #[Test]
    public function test_no_deprecated_components_in_admin_pages()
    {
        $adminPages = $this->getAllAdminPageFiles();
        
        foreach ($adminPages as $pageFile) {
            $fullPath = resource_path('js/' . $pageFile);
            $content = file_get_contents($fullPath);
            
            // Should not use deprecated components
            $this->assertStringNotContainsString('<v-select', $content,
                "Admin page {$pageFile} should not use deprecated v-select");
            $this->assertStringNotContainsString('arc-validation-errors', $content,
                "Admin page {$pageFile} should not use deprecated arc-validation-errors");
                
            // Check for deprecated PrimeVue Dropdown component usage (specific to PrimeVue imports)
            $hasPrimeVueDropdown = str_contains($content, 'from \'primevue/dropdown\'') || 
                                   str_contains($content, 'import Dropdown from \'primevue') ||
                                   preg_match('/<Dropdown[^>]*(?:v-model|:options|optionLabel)/', $content);
            
            // Files using deprecated PrimeVue Dropdown should migrate to Select
            if ($hasPrimeVueDropdown) {
                $this->assertTrue(
                    str_contains($content, '<Select') || str_contains($content, 'import Select from \'primevue/select\''),
                    "Admin page {$pageFile} should migrate from deprecated PrimeVue Dropdown to modern Select component"
                );
            }
        }
    }

    #[Test]
    public function test_admin_pages_have_consistent_composable_usage()
    {
        $criticalPages = [
            'Pages/Admin/PracticeSets.vue',
            'Pages/Admin/QuizSchedules.vue',
            'Pages/Admin/ExamSchedules.vue' 
        ];

        foreach ($criticalPages as $pageFile) {
            $fullPath = resource_path('js/' . $pageFile);
            $content = file_get_contents($fullPath);
            
            // Should use standard composables
            $this->assertStringContainsString('useTranslate', $content,
                "{$pageFile} should use translation composable");
            $this->assertStringContainsString('useConfirmToast', $content,
                "{$pageFile} should use confirmation/toast composable");
                
            // Table pages should use server table composable
            if (str_contains($content, 'vue-good-table')) {
                $this->assertStringContainsString('useServerTable', $content,
                    "{$pageFile} should use server table composable");
            }
        }
    }
}
