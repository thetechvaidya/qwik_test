<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Symfony\Component\Process\Process;
use Tests\ComprehensiveBackendTestSuite;

class RunComprehensiveTestSuite extends Command
{
    /**
     * The name and signature of the console command.
     */
    protected $signature = 'test:comprehensive 
                            {--coverage : Generate code coverage report}
                            {--performance : Run performance benchmarks}
                            {--report : Generate detailed test report}
                            {--filter= : Filter tests by name}';

    /**
     * The console command description.
     */
    protected $description = 'Run the comprehensive backend test suite with detailed reporting';

    /**
     * Execute the console command.
     */
    public function handle(): int
    {
        $this->info('🚀 Starting Comprehensive Backend Test Suite');
        $this->newLine();

        $startTime = microtime(true);

        // Build PHPUnit command
        $command = ['vendor/bin/phpunit'];
        
        // Add test suite filter
        $command[] = '--testsuite=ComprehensiveBackend';

        // Add coverage if requested
        if ($this->option('coverage')) {
            $command[] = '--coverage-html=storage/app/test-coverage';
            $command[] = '--coverage-text';
            $this->info('📊 Code coverage analysis enabled');
        }

        // Add performance monitoring
        if ($this->option('performance')) {
            $command[] = '--log-junit=storage/app/test-results.xml';
            $this->info('⚡ Performance monitoring enabled');
        }

        // Add filter if specified
        if ($filter = $this->option('filter')) {
            $command[] = "--filter={$filter}";
            $this->info("🔍 Filtering tests by: {$filter}");
        }

        // Run the test suite
        $this->newLine();
        $this->info('🧪 Executing test suite...');

        $process = new Process($command);
        $process->setTimeout(600); // 10 minutes timeout
        $process->setTty(true);

        $exitCode = $process->run(function ($type, $buffer) {
            echo $buffer;
        });

        $endTime = microtime(true);
        $totalTime = round(($endTime - $startTime), 2);

        $this->newLine();

        if ($exitCode === 0) {
            $this->info("✅ Test suite completed successfully in {$totalTime} seconds");
            
            if ($this->option('report')) {
                $this->generateDetailedReport();
            }

            if ($this->option('performance')) {
                $this->analyzePerformance();
            }

            if ($this->option('coverage')) {
                $this->info('📈 Coverage report generated: storage/app/test-coverage/index.html');
            }

        } else {
            $this->error("❌ Test suite failed with exit code: {$exitCode}");
            $this->info('Please review the test output above for details.');
        }

        return $exitCode;
    }

    /**
     * Generate detailed test report
     */
    protected function generateDetailedReport(): void
    {
        $this->info('📄 Generating detailed test report...');

        $suite = ComprehensiveBackendTestSuite::suite();
        $report = $suite->generateReport();

        $this->newLine();
        $this->info('📋 Test Suite Report:');
        $this->table(
            ['Metric', 'Value'],
            [
                ['Suite Name', $report['suite_name']],
                ['Total Test Classes', $report['total_test_classes']],
                ['Categories', count($report['categories'])],
                ['Execution Order', implode(' → ', $report['execution_order'])],
            ]
        );

        $this->newLine();
        $this->info('🎯 Performance Thresholds:');
        foreach ($report['performance_thresholds'] as $metric => $threshold) {
            $this->line("  • {$metric}: {$threshold}ms");
        }

        $this->newLine();
        $this->info('📊 Coverage Requirements:');
        foreach ($report['coverage_requirements'] as $type => $requirement) {
            $this->line("  • {$type}: {$requirement}%");
        }

        $this->newLine();
        $this->info('🏗️ Test Categories:');
        foreach ($report['categories'] as $category => $classes) {
            $this->line("  📂 {$category}:");
            foreach ($classes as $class) {
                $className = class_basename($class);
                $this->line("    • {$className}");
            }
        }
    }

    /**
     * Analyze performance metrics
     */
    protected function analyzePerformance(): void
    {
        $this->info('⚡ Analyzing performance metrics...');

        $xmlPath = storage_path('app/test-results.xml');
        if (file_exists($xmlPath)) {
            $xml = simplexml_load_file($xmlPath);
            
            if ($xml && isset($xml->testsuite)) {
                $totalTime = (float) $xml->testsuite['time'];
                $totalTests = (int) $xml->testsuite['tests'];
                $failures = (int) $xml->testsuite['failures'];
                $errors = (int) $xml->testsuite['errors'];

                $this->newLine();
                $this->info('📈 Performance Summary:');
                $this->table(
                    ['Metric', 'Value'],
                    [
                        ['Total Execution Time', round($totalTime, 2) . 's'],
                        ['Average Test Time', round($totalTime / $totalTests, 3) . 's'],
                        ['Total Tests', $totalTests],
                        ['Failures', $failures],
                        ['Errors', $errors],
                        ['Success Rate', round((($totalTests - $failures - $errors) / $totalTests) * 100, 2) . '%'],
                    ]
                );

                // Check performance thresholds
                $thresholds = ComprehensiveBackendTestSuite::getPerformanceThresholds();
                $avgTimeMs = ($totalTime / $totalTests) * 1000;

                if ($avgTimeMs > $thresholds['api_response_time']) {
                    $this->warn("⚠️  Average test time ({$avgTimeMs}ms) exceeds API response threshold");
                }

                $memoryUsage = memory_get_peak_usage(true) / 1024 / 1024;
                if ($memoryUsage > $thresholds['memory_usage_limit']) {
                    $this->warn("⚠️  Memory usage ({$memoryUsage}MB) exceeds limit");
                }
            }
        } else {
            $this->warn('Performance data not available. Run with --performance flag.');
        }
    }
}
