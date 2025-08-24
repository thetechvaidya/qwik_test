#!/usr/bin/env node

/**
 * Application Health Check and Optimization Script
 * Validates the optimization implementation and provides insights
 */

import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

class OptimizationValidator {
    constructor() {
        this.results = {
            security: [],
            performance: [],
            codeQuality: [],
            production: []
        };
        this.basePath = path.resolve(__dirname, '..');
    }

    /**
     * Run all validation checks
     */
    async runAllChecks() {
        console.log('🔍 Running Laravel E-Learning Platform Optimization Validation...\n');
        
        await this.checkSecurityOptimizations();
        await this.checkPerformanceOptimizations();
        await this.checkCodeQuality();
        await this.checkProductionReadiness();
        
        this.generateReport();
    }

    /**
     * Check security optimizations
     */
    async checkSecurityOptimizations() {
        console.log('🔒 Checking Security Optimizations...');
        
        // Check Docker configuration
        this.checkFile('docker-compose.yml', 'Docker security hardening', (content) => {
            const checks = [
                { test: content.includes('8.2') && (content.includes('sail-8.2') || content.includes('php:8.2')), message: 'PHP 8.2 upgrade' },
                { test: content.includes('mysql:8.1'), message: 'MySQL 8.1 upgrade' },
                { test: !content.includes('MYSQL_ALLOW_EMPTY_PASSWORD'), message: 'Empty password removed' },
                { test: content.includes('memory:') && content.includes('cpus:'), message: 'Resource limits configured' }
            ];
            return checks;
        }, 'security');

        // Check TrustHosts middleware
        this.checkFile('app/Http/Kernel.php', 'TrustHosts middleware activation', (content) => {
            return [
                { test: content.includes('TrustHosts::class'), message: 'TrustHosts middleware enabled' }
            ];
        }, 'security');

        // Check TrustHosts configuration
        this.checkFile('app/Http/Middleware/TrustHosts.php', 'TrustHosts configuration', (content) => {
            return [
                { test: content.includes('APP_URL'), message: 'Environment-specific host patterns' },
                { test: content.includes('FRONTEND_URL'), message: 'Frontend URL support' }
            ];
        }, 'security');
    }

    /**
     * Check performance optimizations
     */
    async checkPerformanceOptimizations() {
        console.log('⚡ Checking Performance Optimizations...');
        
        // Check Vite configuration
        this.checkFile('vite.config.js', 'Vite optimization', (content) => {
            return [
                { test: !content.includes("vue: '@vue/compat'"), message: 'Vue compatibility mode removed' },
                { test: !content.includes('__VUE_OPTIONS_API__'), message: 'Vue Options API flag removed' },
                { test: content.includes('chunkSizeWarningLimit: 400'), message: 'Chunk size optimized' },
                { test: content.includes('reportCompressedSize: false'), message: 'Build reporting optimized' }
            ];
        }, 'performance');

        // Check modular structure
        this.checkFile('resources/js/core/app-core.js', 'App modularization', (content) => {
            return [
                { test: content.includes('createInertiaApplication'), message: 'Core app module created' }
            ];
        }, 'performance');

        this.checkFile('resources/js/core/component-registry.js', 'Component registry', (content) => {
            return [
                { test: content.includes('registerComponents'), message: 'Component registry created' }
            ];
        }, 'performance');

        // Check production logger
        this.checkFile('resources/js/services/logger.js', 'Production logger', (content) => {
            return [
                { test: content.includes('ProductionLogger'), message: 'Production logger service created' },
                { test: content.includes('performanceMetrics'), message: 'Performance tracking included' },
                { test: content.includes('sendToMonitoring'), message: 'External monitoring support' }
            ];
        }, 'performance');

        // Check package.json cleanup
        this.checkFile('package.json', 'Package optimization', (content) => {
            return [
                { test: !content.includes('"@vue/compat"'), message: 'Vue compatibility dependency removed' },
                { test: content.includes('security:audit'), message: 'Security audit script added' }
            ];
        }, 'performance');
    }

    /**
     * Check code quality improvements
     */
    async checkCodeQuality() {
        console.log('📝 Checking Code Quality Improvements...');
        
        // Check useLogger composable
        this.checkFile('resources/js/composables/useLogger.js', 'Logger composable', (content) => {
            return [
                { test: content.includes('useLogger'), message: 'Logger composable created' },
                { test: content.includes('getCurrentInstance'), message: 'Component context tracking' }
            ];
        }, 'codeQuality');

        // Check lazy loading utilities
        this.checkFile('resources/js/utils/lazy-loading.js', 'Lazy loading utilities', (content) => {
            return [
                { test: content.includes('LAZY_COMPONENT_GROUPS'), message: 'Component lazy loading configured' },
                { test: content.includes('preloadComponentsForRoute'), message: 'Route-based preloading' }
            ];
        }, 'codeQuality');

        // Check performance monitoring
        this.checkFile('resources/js/utils/performance-monitor.js', 'Performance monitoring', (content) => {
            return [
                { test: content.includes('ComponentPerformanceMonitor'), message: 'Performance monitor created' },
                { test: content.includes('usePerformanceTracking'), message: 'Performance tracking composable' }
            ];
        }, 'codeQuality');

        // Sample check for console.log cleanup (check a few key files)
        const vuFiles = [
            'resources/js/Pages/User/PracticeScreen.vue',
            'resources/js/Pages/User/QuizSolutions.vue',
            'resources/js/Pages/User/QuizScreen.vue'
        ];

        vuFiles.forEach(file => {
            this.checkFile(file, 'Console cleanup', (content) => {
                const hasOldConsole = content.includes('console.error(') || content.includes('console.warn(') || content.includes('console.log(');
                const hasLogger = content.includes('useLogger') || content.includes('logError') || content.includes('logWarn');
                return [
                    { test: !hasOldConsole || hasLogger, message: `Console statements cleaned up in ${path.basename(file)}` }
                ];
            }, 'codeQuality');
        });
    }

    /**
     * Check production readiness
     */
    async checkProductionReadiness() {
        console.log('🚀 Checking Production Readiness...');
        
        // Check production environment template
        this.checkFile('.env.production.template', 'Production environment template', (content) => {
            return [
                { test: content.includes('APP_ENV=production'), message: 'Production environment configured' },
                { test: content.includes('VITE_ENABLE_CONSOLE_LOGS=false'), message: 'Console logs disabled in production' },
                { test: content.includes('CONTENT_SECURITY_POLICY'), message: 'Security headers configured' }
            ];
        }, 'production');

        // Check app.js optimization
        this.checkFile('resources/js/app.js', 'Main app optimization', (content) => {
            return [
                { test: content.includes("import logger from './services/logger'"), message: 'Logger service integrated' },
                { test: content.includes("import { registerComponents }"), message: 'Component registry integrated' },
                { test: content.includes('logger.startPerformanceTimer'), message: 'Performance tracking active' }
            ];
        }, 'production');
    }

    /**
     * Check if file exists and validate content
     */
    checkFile(filePath, description, validator, category) {
        const fullPath = path.join(this.basePath, filePath);
        
        if (!fs.existsSync(fullPath)) {
            this.results[category].push({
                status: '❌',
                description,
                message: `File not found: ${filePath}`
            });
            return;
        }

        try {
            const content = fs.readFileSync(fullPath, 'utf8');
            const checks = validator(content);
            
            checks.forEach(check => {
                this.results[category].push({
                    status: check.test ? '✅' : '❌',
                    description,
                    message: check.message
                });
            });
        } catch (error) {
            this.results[category].push({
                status: '⚠️',
                description,
                message: `Error reading file: ${error.message}`
            });
        }
    }

    /**
     * Generate final report
     */
    generateReport() {
        console.log('\n📊 OPTIMIZATION VALIDATION REPORT');
        console.log('=====================================\n');

        const categories = [
            { key: 'security', title: '🔒 Security Optimizations', icon: '🔒' },
            { key: 'performance', title: '⚡ Performance Optimizations', icon: '⚡' },
            { key: 'codeQuality', title: '📝 Code Quality Improvements', icon: '📝' },
            { key: 'production', title: '🚀 Production Readiness', icon: '🚀' }
        ];

        let totalChecks = 0;
        let passedChecks = 0;

        categories.forEach(category => {
            console.log(`${category.icon} ${category.title}`);
            console.log('-'.repeat(40));
            
            const results = this.results[category.key];
            if (results.length === 0) {
                console.log('  No checks defined for this category\n');
                return;
            }

            results.forEach(result => {
                console.log(`  ${result.status} ${result.message}`);
                totalChecks++;
                if (result.status === '✅') passedChecks++;
            });
            console.log('');
        });

        // Overall score
        const score = totalChecks > 0 ? Math.round((passedChecks / totalChecks) * 100) : 0;
        console.log('🎯 OVERALL OPTIMIZATION SCORE');
        console.log('===============================');
        console.log(`${score}% (${passedChecks}/${totalChecks} checks passed)\n`);

        // Recommendations
        if (score < 100) {
            console.log('🔧 RECOMMENDATIONS');
            console.log('===================');
            categories.forEach(category => {
                const failedChecks = this.results[category.key].filter(r => r.status === '❌');
                if (failedChecks.length > 0) {
                    console.log(`\n${category.icon} ${category.title}:`);
                    failedChecks.forEach(check => {
                        console.log(`  • ${check.message}`);
                    });
                }
            });
        } else {
            console.log('🎉 CONGRATULATIONS!');
            console.log('===================');
            console.log('All optimization checks passed! Your Laravel e-learning platform');
            console.log('is fully optimized and ready for production deployment.');
        }

        console.log('\n💡 Additional Performance Tips:');
        console.log('• Run `npm run build:production` for optimized builds');
        console.log('• Enable Redis caching in production');
        console.log('• Consider implementing a CDN for static assets');
        console.log('• Monitor application performance with the built-in logger');
        console.log('• Regularly run `npm run security:audit` for dependency checks\n');
    }
}

// Run the validation
const validator = new OptimizationValidator();
validator.runAllChecks().catch(error => {
    console.error('❌ Validation failed:', error.message);
    process.exit(1);
});
