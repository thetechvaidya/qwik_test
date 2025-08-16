<?php

namespace Tests\Feature;

use Tests\TestCase;
use Illuminate\Support\Facades\File;

class PrimeVue3ComponentRegressionTest extends TestCase
{
    /**
     * Test that no PrimeVue 3.x deprecated component imports remain in Vue files
     * This prevents regressions to v3 components that were migrated to v4
     */
    public function test_no_primevue_v3_component_imports_exist()
    {
        $forbiddenImports = [
            'inputswitch',
            'sidebar',
            'overlaypanel',
            // Note: 'dropdown' removed due to false positives with ArcDropdown/SidebarDropdown
        ];

        $vueFiles = $this->getVueFiles();
        $violations = [];

        foreach ($vueFiles as $file) {
            $content = strtolower(file_get_contents($file));
            
            foreach ($forbiddenImports as $component) {
                // Check for import statements - exact PrimeVue component matches only
                if (preg_match("/import\s+.*from\s+['\"]primevue\/{$component}['\"]/i", $content)) {
                    $violations[] = [
                        'file' => $file,
                        'component' => $component,
                        'type' => 'import'
                    ];
                }
                
                // Check for component registrations - exact component name with boundaries
                if (preg_match("/\bcomponents:\s*{[^}]*\b{$component}\s*[,}]/i", $content) || 
                    preg_match("/\.component\(\s*['\"].*\b{$component}\b.*['\"]|^\s*{$component}\s*:/i", $content)) {
                    $violations[] = [
                        'file' => $file,
                        'component' => $component,
                        'type' => 'registration'
                    ];
                }
                
                // Check for template usage - exact component tag matches only
                if (preg_match("/<{$component}[\s>\/]|<\/{$component}>/i", $content)) {
                    $violations[] = [
                        'file' => $file,
                        'component' => $component,
                        'type' => 'template'
                    ];
                }
            }
            
            // Specific checks for Dropdown to avoid false positives with ArcDropdown/SidebarDropdown
            // Check for actual PrimeVue Dropdown import
            if (preg_match("/import\s+.*dropdown.*from\s+['\"]primevue\/dropdown['\"]/i", $content)) {
                $violations[] = [
                    'file' => $file,
                    'component' => 'dropdown',
                    'type' => 'import'
                ];
            }
            
            // Check for exact Dropdown component registration (not ArcDropdown, SidebarDropdown, etc.)
            if (preg_match("/\bcomponents:\s*{[^}]*\bDropdown\s*[,}]/i", $content)) {
                // Verify it's not ArcDropdown, SidebarDropdown, etc.
                if (!preg_match("/\b(Arc|Sidebar|Custom|Nav)Dropdown\b/i", $content)) {
                    $violations[] = [
                        'file' => $file,
                        'component' => 'dropdown',
                        'type' => 'registration'
                    ];
                }
            }
            
            // Check for <Dropdown> template usage (not <arc-dropdown>, <sidebar-dropdown>, etc.)
            if (preg_match("/<Dropdown[\s>\/]|<\/Dropdown>/i", $content)) {
                $violations[] = [
                    'file' => $file,
                    'component' => 'dropdown',
                    'type' => 'template'
                ];
            }
        }

        if (!empty($violations)) {
            $errorMessage = "PrimeVue 3.x deprecated components found:\n";
            foreach ($violations as $violation) {
                $errorMessage .= "- {$violation['file']}: {$violation['component']} ({$violation['type']})\n";
            }
            $errorMessage .= "\nMigration guide:\n";
            $errorMessage .= "- InputSwitch → ToggleSwitch\n";
            $errorMessage .= "- Dropdown → Select\n";
            $errorMessage .= "- Sidebar → Drawer\n";
            $errorMessage .= "- OverlayPanel → Popover\n";
            
            $this->fail($errorMessage);
        }

        $this->assertTrue(true, 'No PrimeVue 3.x deprecated components found in Vue files');
    }

    /**
     * Test that no legacy template tags remain in Vue templates
     * Complementary test for import-level checks
     */
    public function test_no_legacy_template_tags_exist()
    {
        $forbiddenTags = [
            'InputSwitch',
            'Sidebar',
            'OverlayPanel',
            // Note: 'Dropdown' handled separately due to custom Arc/Sidebar dropdown components
        ];

        $vueFiles = $this->getVueFiles();
        $templateViolations = [];

        foreach ($vueFiles as $file) {
            $content = file_get_contents($file);
            
            // Extract template section
            if (preg_match('/<template[^>]*>(.*?)<\/template>/s', $content, $matches)) {
                $templateContent = $matches[1];
                
                foreach ($forbiddenTags as $tag) {
                    // Check for opening and closing tags - exact matches only
                    if (preg_match("/<{$tag}[\s>\/]|<\/{$tag}>/i", $templateContent)) {
                        $templateViolations[] = [
                            'file' => $file,
                            'tag' => $tag,
                            'type' => 'template_tag'
                        ];
                    }
                }
                
                // Special check for Dropdown template usage (exact PrimeVue Dropdown, not custom variants)
                if (preg_match("/<Dropdown[\s>\/]|<\/Dropdown>/i", $templateContent)) {
                    // Make sure it's not a custom dropdown variant
                    if (!preg_match("/<(arc-dropdown|sidebar-dropdown|nav-dropdown)/i", $templateContent)) {
                        $templateViolations[] = [
                            'file' => $file,
                            'tag' => 'Dropdown',
                            'type' => 'template_tag'
                        ];
                    }
                }
            }
        }

        if (!empty($templateViolations)) {
            $errorMessage = "Legacy PrimeVue template tags found:\n";
            foreach ($templateViolations as $violation) {
                $errorMessage .= "- {$violation['file']}: <{$violation['tag']}> template tag\n";
            }
            $errorMessage .= "\nMigration required:\n";
            $errorMessage .= "- <InputSwitch> → <ToggleSwitch>\n";
            $errorMessage .= "- <Dropdown> → <Select>\n";
            $errorMessage .= "- <Sidebar> → <Drawer>\n";
            $errorMessage .= "- <OverlayPanel> → <Popover>\n";
            
            $this->fail($errorMessage);
        }

        $this->assertTrue(true, 'No legacy PrimeVue template tags found in Vue files');
    }

    /**
     * Get all Vue files in the resources/js directory
     */
    private function getVueFiles(): array
    {
        $vueFiles = [];
        $resourcesPath = resource_path('js');
        
        if (!is_dir($resourcesPath)) {
            return $vueFiles;
        }

        $files = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($resourcesPath),
            \RecursiveIteratorIterator::LEAVES_ONLY
        );

        foreach ($files as $file) {
            if ($file->isFile() && $file->getExtension() === 'vue') {
                $vueFiles[] = $file->getPathname();
            }
        }

        return $vueFiles;
    }

    /**
     * Test specific migration mappings to ensure correct v4 usage
     */
    public function test_correct_primevue_v4_component_usage()
    {
        $vueFiles = $this->getVueFiles();
        $correctUsage = [];
        $suggestions = [];

        foreach ($vueFiles as $file) {
            $content = file_get_contents($file);
            
            // Check for correct v4 component usage
            if (preg_match('/import\s+.*ToggleSwitch.*from\s+[\'"]primevue\/toggleswitch[\'"]|<ToggleSwitch/i', $content)) {
                $correctUsage[] = ['file' => basename($file), 'component' => 'ToggleSwitch'];
            }
            
            if (preg_match('/import\s+.*Select.*from\s+[\'"]primevue\/select[\'"]|<Select/i', $content)) {
                $correctUsage[] = ['file' => basename($file), 'component' => 'Select'];
            }
            
            if (preg_match('/import\s+.*Drawer.*from\s+[\'"]primevue\/drawer[\'"]|<Drawer/i', $content)) {
                $correctUsage[] = ['file' => basename($file), 'component' => 'Drawer'];
            }
            
            if (preg_match('/import\s+.*DatePicker.*from\s+[\'"]primevue\/datepicker[\'"]|<DatePicker/i', $content)) {
                $correctUsage[] = ['file' => basename($file), 'component' => 'DatePicker'];
            }
        }

        // This test passes if we find correct usage (positive reinforcement)
        // and fails only if regression is detected in the main test above
        $this->assertGreaterThan(0, count($correctUsage), 'Should find at least some PrimeVue 4.x component usage');
        
        // Log successful migrations for reference
        if (!empty($correctUsage)) {
            echo "\n✅ PrimeVue 4.x components successfully in use:\n";
            foreach ($correctUsage as $usage) {
                echo "   {$usage['component']} in {$usage['file']}\n";
            }
        }
    }
}
