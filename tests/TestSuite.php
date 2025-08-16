<?php

namespace Tests;

use PHPUnit\Framework\TestSuite as PHPUnitTestSuite;
use Tests\Feature\AuthenticationTest;
use Tests\Feature\AdminFunctionalityTest;
use Tests\Feature\PaymentProcessingTest;
use Tests\Feature\ExamQuizSystemTest;
use Tests\Feature\ApiEndpointTest;
use Tests\Feature\FileManagementTest;
use Tests\Feature\DataExportImportTest;
use Tests\Feature\DatabaseIntegrityTest;
use Tests\Feature\HelperFunctionsTest;

class ComprehensiveBackendTestSuite extends PHPUnitTestSuite
{
    /**
     * Test execution order - ordered by dependencies and importance
     */
    protected static array $testOrder = [
        'Database and Core Infrastructure' => [
            DatabaseIntegrityTest::class,
            HelperFunctionsTest::class,
        ],
        'Authentication and Security' => [
            AuthenticationTest::class,
        ],
        'Core Business Logic' => [
            ExamQuizSystemTest::class,
            PaymentProcessingTest::class,
        ],
        'Admin and Management' => [
            AdminFunctionalityTest::class,
            FileManagementTest::class,
            DataExportImportTest::class,
        ],
        'API and Integration' => [
            ApiEndpointTest::class,
        ],
    ];

    /**
     * Create the test suite
     */
    public static function suite(): self
    {
        $suite = new self('Comprehensive Backend Test Suite');
        
        // Add tests in the defined order
        foreach (self::$testOrder as $category => $testClasses) {
            foreach ($testClasses as $testClass) {
                $suite->addTestSuite($testClass);
            }
        }

        return $suite;
    }

    /**
     * Get test categories for reporting
     */
    public static function getTestCategories(): array
    {
        return self::$testOrder;
    }

    /**
     * Count total number of test classes
     */
    public function getTestClassCount(): int
    {
        $count = 0;
        foreach (self::$testOrder as $testClasses) {
            $count += count($testClasses);
        }
        return $count;
    }

    /**
     * Get performance thresholds for monitoring
     */
    public static function getPerformanceThresholds(): array
    {
        return [
            'database_query_time' => 100, // milliseconds
            'api_response_time' => 500,   // milliseconds
            'file_upload_time' => 2000,   // milliseconds
            'export_generation_time' => 5000, // milliseconds
            'memory_usage_limit' => 128,  // MB
        ];
    }

    /**
     * Get coverage requirements
     */
    public static function getCoverageRequirements(): array
    {
        return [
            'minimum_overall' => 80,      // 80% overall coverage
            'minimum_controller' => 85,   // 85% controller coverage
            'minimum_model' => 90,        // 90% model coverage
            'minimum_helper' => 95,       // 95% helper coverage
        ];
    }

    /**
     * Generate a detailed test report
     */
    public function generateReport(): array
    {
        $testClasses = [];
        foreach (self::$testOrder as $category => $classes) {
            $testClasses[$category] = $classes;
        }

        return [
            'suite_name' => 'Comprehensive Backend Test Suite',
            'categories' => $testClasses,
            'total_test_classes' => $this->getTestClassCount(),
            'performance_thresholds' => self::getPerformanceThresholds(),
            'coverage_requirements' => self::getCoverageRequirements(),
            'execution_order' => array_keys(self::$testOrder),
        ];
    }
}