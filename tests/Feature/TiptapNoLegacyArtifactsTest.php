<?php

namespace Tests\Feature;

use Tests\TestCase;
use RecursiveDirectoryIterator;
use RecursiveIteratorIterator;
use RegexIterator;

/**
 * TiptapNoLegacyArtifactsTest - Prevent CKEditor Reintroduction
 * 
 * This test prevents the reintroduction of CKEditor legacy artifacts
 * after the comprehensive Tiptap migration. It scans the JavaScript
 * source directory for forbidden imports and references.
 * 
 * @package Tests\Feature
 * @since Tiptap Migration (August 2025)
 */
class TiptapNoLegacyArtifactsTest extends TestCase
{
    /**
     * Test that no CKEditor imports exist in JavaScript source files
     * 
     * Scans all .js and .vue files in resources/js for:
     * - ckeditor4-vue imports
     * - window.CKEditorURL references
     * 
     * Excludes migration documentation that may reference these intentionally.
     */
    public function test_no_ckeditor_imports_in_javascript_source()
    {
        $resourcesJsPath = resource_path('js');
        $violations = [];
        
        if (!is_dir($resourcesJsPath)) {
            $this->markTestSkipped('JavaScript source directory not found: ' . $resourcesJsPath);
        }
        
        // Get all .js and .vue files recursively
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($resourcesJsPath, RecursiveDirectoryIterator::SKIP_DOTS)
        );
        $jsFiles = new RegexIterator($iterator, '/\.(js|vue)$/i');
        
        foreach ($jsFiles as $file) {
            $filePath = $file->getRealPath();
            $relativePath = str_replace($resourcesJsPath . DIRECTORY_SEPARATOR, '', $filePath);
            $content = file_get_contents($filePath);
            
            // Skip files that are explicitly allowed to reference CKEditor (migration docs, etc.)
            if ($this->isExcludedFile($relativePath)) {
                continue;
            }
            
            // Check for forbidden CKEditor patterns
            $forbiddenPatterns = [
                'ckeditor4-vue' => '/(?:import.*from.*[\'"]ckeditor4-vue[\'"]|require\([\'"]ckeditor4-vue[\'"]\))/i',
                'window.CKEditorURL' => '/window\.CKEditorURL/i',
                'CKEDITOR' => '/(?:window\.CKEDITOR|global\.CKEDITOR)/i',
            ];
            
            foreach ($forbiddenPatterns as $name => $pattern) {
                if (preg_match($pattern, $content, $matches)) {
                    $violations[] = [
                        'file' => $relativePath,
                        'pattern' => $name,
                        'match' => trim($matches[0])
                    ];
                }
            }
        }
        
        // Assert no violations found
        if (!empty($violations)) {
            $violationDetails = [];
            foreach ($violations as $violation) {
                $violationDetails[] = "{$violation['file']}: {$violation['pattern']} -> '{$violation['match']}'";
            }
            
            $this->fail(
                "Found " . count($violations) . " CKEditor legacy artifact(s) in JavaScript source:\n" .
                implode("\n", $violationDetails) . "\n\n" .
                "These artifacts should be removed as part of the Tiptap migration. " .
                "If you need to reference CKEditor in documentation, add the file to the exclusion list."
            );
        }
        
        // Test passes - no legacy artifacts found
        $this->assertTrue(true, 'No CKEditor legacy artifacts found in JavaScript source');
    }
    
    /**
     * Test that no <ckeditor> HTML tags remain in Vue templates
     * 
     * Scans all .vue files for <ckeditor> tags (case-insensitive) that should
     * have been replaced with <TiptapEditor> during migration.
     * 
     * Excludes documentation files that may reference these intentionally.
     */
    public function test_no_ckeditor_html_tags_in_vue_templates()
    {
        $resourcesJsPath = resource_path('js');
        $violations = [];
        
        if (!is_dir($resourcesJsPath)) {
            $this->markTestSkipped('JavaScript source directory not found: ' . $resourcesJsPath);
        }
        
        // Get all .vue files recursively
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($resourcesJsPath, RecursiveDirectoryIterator::SKIP_DOTS)
        );
        $vueFiles = new RegexIterator($iterator, '/\.vue$/i');
        
        foreach ($vueFiles as $file) {
            $filePath = $file->getRealPath();
            $relativePath = str_replace($resourcesJsPath . DIRECTORY_SEPARATOR, '', $filePath);
            $content = file_get_contents($filePath);
            
            // Skip documentation files
            if ($this->isExcludedFile($relativePath)) {
                continue;
            }
            
            // Check for <ckeditor> tags (case-insensitive)
            if (preg_match('/<ckeditor/i', $content, $matches)) {
                $violations[] = [
                    'file' => $relativePath,
                    'match' => trim($matches[0])
                ];
            }
        }
        
        // Assert no violations found
        if (!empty($violations)) {
            $violationDetails = [];
            foreach ($violations as $violation) {
                $violationDetails[] = "{$violation['file']}: Found '{$violation['match']}'";
            }
            
            $this->fail(
                "Found " . count($violations) . " <ckeditor> HTML tag(s) in Vue templates:\n" .
                implode("\n", $violationDetails) . "\n\n" .
                "These tags should be replaced with <TiptapEditor> or <TextEditor> components. " .
                "If you need to reference CKEditor in documentation, add the file to the exclusion list."
            );
        }
        
        // Test passes - no CKEditor HTML tags found
        $this->assertTrue(true, 'No <ckeditor> HTML tags found in Vue templates');
    }
    
    /**
     * Test that Tiptap components are properly used in Vue templates
     * 
     * Ensures that components are using TiptapEditor instead of deprecated TextEditor
     * where direct usage is preferred.
     */
    public function test_tiptap_components_preferred_over_legacy_wrappers()
    {
        $resourcesJsPath = resource_path('js');
        $warnings = [];
        
        if (!is_dir($resourcesJsPath)) {
            $this->markTestSkipped('JavaScript source directory not found: ' . $resourcesJsPath);
        }
        
        // Get all .vue files recursively
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($resourcesJsPath, RecursiveDirectoryIterator::SKIP_DOTS)
        );
        $vueFiles = new RegexIterator($iterator, '/\.vue$/i');
        
        foreach ($vueFiles as $file) {
            $filePath = $file->getRealPath();
            $relativePath = str_replace($resourcesJsPath . DIRECTORY_SEPARATOR, '', $filePath);
            $content = file_get_contents($filePath);
            
            // Skip the TextEditor wrapper itself and excluded files
            if ($this->isExcludedFile($relativePath) || basename($relativePath) === 'TextEditor.vue') {
                continue;
            }
            
            // Check for TextEditor imports (should prefer TiptapEditor for new development)
            if (preg_match('/import.*TextEditor.*from.*[\'"].*TextEditor[\'"]/', $content)) {
                $warnings[] = $relativePath . ': Uses TextEditor (consider TiptapEditor for new development)';
            }
        }
        
        // This is informational - we don't fail the test for TextEditor usage
        // as it's maintained for backward compatibility
        if (!empty($warnings)) {
            echo "\nINFO: Found " . count($warnings) . " component(s) using TextEditor wrapper:\n";
            foreach ($warnings as $warning) {
                echo "  - $warning\n";
            }
            echo "Consider migrating to TiptapEditor directly for better performance.\n";
        }
        
        $this->assertTrue(true, 'Legacy wrapper usage check completed');
    }
    
    /**
     * Test that no CKEditor configuration objects remain in JavaScript
     * 
     * Looks for typical CKEditor config patterns that should have been
     * converted to Tiptap configurations.
     */
    public function test_no_ckeditor_config_objects_remain()
    {
        $resourcesJsPath = resource_path('js');
        $violations = [];
        
        if (!is_dir($resourcesJsPath)) {
            $this->markTestSkipped('JavaScript source directory not found: ' . $resourcesJsPath);
        }
        
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator($resourcesJsPath, RecursiveDirectoryIterator::SKIP_DOTS)
        );
        $jsFiles = new RegexIterator($iterator, '/\.(js|vue)$/i');
        
        foreach ($jsFiles as $file) {
            $filePath = $file->getRealPath();
            $relativePath = str_replace($resourcesJsPath . DIRECTORY_SEPARATOR, '', $filePath);
            $content = file_get_contents($filePath);
            
            if ($this->isExcludedFile($relativePath)) {
                continue;
            }
            
            // Check for CKEditor configuration patterns
            $ckConfigPatterns = [
                'editorConfig' => '/editorConfig\s*:\s*\{[^}]*(?:toolbar|extraPlugins|contentsLangDirection)/i',
                'CKEDITOR.config' => '/CKEDITOR\.config\./i',
                'extraPlugins' => '/extraPlugins\s*:\s*\[[^\]]*(?:mathjax|katex)/i',
            ];
            
            foreach ($ckConfigPatterns as $name => $pattern) {
                if (preg_match($pattern, $content, $matches)) {
                    $violations[] = [
                        'file' => $relativePath,
                        'pattern' => $name,
                        'match' => substr(trim($matches[0]), 0, 100) . (strlen($matches[0]) > 100 ? '...' : '')
                    ];
                }
            }
        }
        
        if (!empty($violations)) {
            $violationDetails = [];
            foreach ($violations as $violation) {
                $violationDetails[] = "{$violation['file']}: {$violation['pattern']} -> '{$violation['match']}'";
            }
            
            $this->fail(
                "Found " . count($violations) . " CKEditor configuration artifact(s):\n" .
                implode("\n", $violationDetails) . "\n\n" .
                "These configurations should be converted to Tiptap format."
            );
        }
        
        $this->assertTrue(true, 'No CKEditor configuration artifacts found');
    }
    
    /**
     * Check if a file should be excluded from legacy artifact scanning
     * 
     * Files that may legitimately reference CKEditor for documentation
     * or migration purposes should be added here.
     * 
     * @param string $relativePath
     * @return bool
     */
    private function isExcludedFile(string $relativePath): bool
    {
        $excludedPatterns = [
            // Migration documentation files
            '/migration/i',
            '/Migration/i',
            // Test files that may reference legacy patterns
            '/test/i',
            '/Test/i',
            // README or documentation files
            '/readme/i',
            '/README/i',
            '/\.md$/i',
        ];
        
        foreach ($excludedPatterns as $pattern) {
            if (preg_match($pattern, $relativePath)) {
                return true;
            }
        }
        
        return false;
    }
}
