#!/usr/bin/env node

/**
 * Performance Monitoring and Bundle Analysis Tool
 * Monitors Core Web Vitals, bundle sizes, and application performance
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

class PerformanceMonitor {
    constructor() {
        this.buildPath = path.join(process.cwd(), 'public/build');
        this.manifestPath = path.join(this.buildPath, '.vite/manifest.json');
        this.reportPath = path.join(process.cwd(), 'storage/logs/performance');
        this.thresholds = {
            // Bundle size thresholds (KB)
            maxBundleSize: 2048, // 2MB
            maxChunkSize: 512,   // 512KB
            maxVendorSize: 1024, // 1MB
            
            // Performance thresholds
            maxLoadTime: 3000,   // 3 seconds
            maxTTFB: 800,       // 800ms
            maxFCP: 2000,       // 2 seconds
            maxLCP: 4000,       // 4 seconds
            maxFID: 100,        // 100ms
            maxCLS: 0.1,        // 0.1 score
        };
        
        this.ensureReportDirectory();
    }

    ensureReportDirectory() {
        if (!fs.existsSync(this.reportPath)) {
            fs.mkdirSync(this.reportPath, { recursive: true });
        }
    }

    /**
     * Analyze bundle sizes and composition
     */
    analyzeBundles() {
        console.log('📊 Analyzing bundle sizes...');
        
        if (!fs.existsSync(this.manifestPath)) {
            console.error('❌ Vite manifest not found. Run "npm run build" first.');
            return false;
        }

        const manifest = JSON.parse(fs.readFileSync(this.manifestPath, 'utf8'));
        const analysis = {
            timestamp: new Date().toISOString(),
            totalSize: 0,
            chunks: [],
            assets: [],
            warnings: [],
            errors: [],
        };

        // Analyze each entry in the manifest
        for (const [key, entry] of Object.entries(manifest)) {
            if (entry.file) {
                const filePath = path.join(this.buildPath, entry.file);
                
                if (fs.existsSync(filePath)) {
                    const stats = fs.statSync(filePath);
                    const sizeKB = Math.round(stats.size / 1024 * 100) / 100;
                    
                    const chunkInfo = {
                        name: key,
                        file: entry.file,
                        size: stats.size,
                        sizeKB: sizeKB,
                        compressed: this.getCompressedSize(filePath),
                        type: this.getAssetType(entry.file),
                    };

                    analysis.totalSize += stats.size;
                    
                    if (chunkInfo.type === 'js' || chunkInfo.type === 'css') {
                        analysis.chunks.push(chunkInfo);
                        
                        // Check size thresholds
                        if (sizeKB > this.thresholds.maxChunkSize) {
                            analysis.warnings.push({
                                type: 'large-chunk',
                                message: `Chunk ${key} (${sizeKB}KB) exceeds size threshold (${this.thresholds.maxChunkSize}KB)`,
                                chunk: chunkInfo,
                            });
                        }
                    } else {
                        analysis.assets.push(chunkInfo);
                    }
                }
            }
        }

        // Check total bundle size
        const totalSizeKB = Math.round(analysis.totalSize / 1024 * 100) / 100;
        if (totalSizeKB > this.thresholds.maxBundleSize) {
            analysis.errors.push({
                type: 'large-bundle',
                message: `Total bundle size (${totalSizeKB}KB) exceeds threshold (${this.thresholds.maxBundleSize}KB)`,
            });
        }

        // Generate bundle composition report
        this.generateBundleReport(analysis);
        
        // Display summary
        this.displayBundleAnalysis(analysis);
        
        return analysis.errors.length === 0;
    }

    getAssetType(filename) {
        const ext = path.extname(filename).toLowerCase();
        const typeMap = {
            '.js': 'js',
            '.css': 'css',
            '.png': 'image',
            '.jpg': 'image',
            '.jpeg': 'image',
            '.gif': 'image',
            '.svg': 'image',
            '.webp': 'image',
            '.woff': 'font',
            '.woff2': 'font',
            '.ttf': 'font',
            '.eot': 'font',
        };
        return typeMap[ext] || 'other';
    }

    getCompressedSize(filePath) {
        try {
            // Try to get gzipped size if available
            const gzipPath = filePath + '.gz';
            if (fs.existsSync(gzipPath)) {
                const stats = fs.statSync(gzipPath);
                return Math.round(stats.size / 1024 * 100) / 100;
            }
        } catch (error) {
            // Ignore errors, compressed size is optional
        }
        return null;
    }

    generateBundleReport(analysis) {
        const reportFile = path.join(this.reportPath, `bundle-analysis-${Date.now()}.json`);
        fs.writeFileSync(reportFile, JSON.stringify(analysis, null, 2));
        
        const summaryFile = path.join(this.reportPath, 'bundle-summary.md');
        const summary = this.createBundleSummary(analysis);
        fs.writeFileSync(summaryFile, summary);
        
        console.log(`📄 Bundle analysis saved to: ${reportFile}`);
        console.log(`📄 Bundle summary saved to: ${summaryFile}`);
    }

    createBundleSummary(analysis) {
        const totalSizeKB = Math.round(analysis.totalSize / 1024 * 100) / 100;
        const totalSizeMB = Math.round(analysis.totalSize / (1024 * 1024) * 100) / 100;
        
        let summary = `# Bundle Analysis Report\n\n`;
        summary += `**Generated:** ${new Date(analysis.timestamp).toLocaleString()}\n`;
        summary += `**Total Bundle Size:** ${totalSizeKB}KB (${totalSizeMB}MB)\n\n`;
        
        // Chunk breakdown
        summary += `## JavaScript Chunks\n\n`;
        summary += `| Chunk | Size (KB) | Compressed (KB) | File |\n`;
        summary += `|-------|-----------|-----------------|------|\n`;
        
        const jsChunks = analysis.chunks.filter(c => c.type === 'js').sort((a, b) => b.size - a.size);
        jsChunks.forEach(chunk => {
            const compressed = chunk.compressed ? `${chunk.compressed}KB` : 'N/A';
            summary += `| ${chunk.name} | ${chunk.sizeKB} | ${compressed} | ${chunk.file} |\n`;
        });
        
        // CSS breakdown
        const cssChunks = analysis.chunks.filter(c => c.type === 'css');
        if (cssChunks.length > 0) {
            summary += `\n## CSS Files\n\n`;
            summary += `| File | Size (KB) | Compressed (KB) |\n`;
            summary += `|------|-----------|----------------|\n`;
            
            cssChunks.forEach(chunk => {
                const compressed = chunk.compressed ? `${chunk.compressed}KB` : 'N/A';
                summary += `| ${chunk.file} | ${chunk.sizeKB} | ${compressed} |\n`;
            });
        }
        
        // Warnings and errors
        if (analysis.warnings.length > 0) {
            summary += `\n## ⚠️ Warnings\n\n`;
            analysis.warnings.forEach(warning => {
                summary += `- ${warning.message}\n`;
            });
        }
        
        if (analysis.errors.length > 0) {
            summary += `\n## ❌ Errors\n\n`;
            analysis.errors.forEach(error => {
                summary += `- ${error.message}\n`;
            });
        }
        
        // Recommendations
        summary += `\n## 📈 Recommendations\n\n`;
        
        if (jsChunks.length > 0) {
            const largestChunk = jsChunks[0];
            if (largestChunk.sizeKB > 300) {
                summary += `- Consider code splitting for the largest chunk (${largestChunk.name}: ${largestChunk.sizeKB}KB)\n`;
            }
        }
        
        const vendorChunks = jsChunks.filter(c => c.name.includes('vendor') || c.name.includes('node_modules'));
        if (vendorChunks.length > 0) {
            const totalVendorSize = vendorChunks.reduce((sum, chunk) => sum + chunk.sizeKB, 0);
            if (totalVendorSize > this.thresholds.maxVendorSize) {
                summary += `- Vendor chunks total ${totalVendorSize}KB. Consider splitting large vendor libraries.\n`;
            }
        }
        
        if (totalSizeKB > this.thresholds.maxBundleSize * 0.8) {
            summary += `- Total bundle size is approaching the threshold. Review dependencies and consider lazy loading.\n`;
        }
        
        return summary;
    }

    displayBundleAnalysis(analysis) {
        const totalSizeKB = Math.round(analysis.totalSize / 1024 * 100) / 100;
        
        console.log('\n📊 Bundle Analysis Summary');
        console.log('═'.repeat(50));
        console.log(`Total Bundle Size: ${totalSizeKB}KB`);
        console.log(`Number of Chunks: ${analysis.chunks.length}`);
        console.log(`Number of Assets: ${analysis.assets.length}`);
        
        if (analysis.warnings.length > 0) {
            console.log(`\n⚠️  Warnings: ${analysis.warnings.length}`);
            analysis.warnings.forEach(warning => {
                console.log(`   - ${warning.message}`);
            });
        }
        
        if (analysis.errors.length > 0) {
            console.log(`\n❌ Errors: ${analysis.errors.length}`);
            analysis.errors.forEach(error => {
                console.log(`   - ${error.message}`);
            });
        }
        
        // Display largest chunks
        const largestChunks = analysis.chunks
            .filter(c => c.type === 'js')
            .sort((a, b) => b.size - a.size)
            .slice(0, 5);
        
        if (largestChunks.length > 0) {
            console.log('\n📦 Largest JavaScript Chunks:');
            largestChunks.forEach((chunk, index) => {
                console.log(`   ${index + 1}. ${chunk.name}: ${chunk.sizeKB}KB`);
            });
        }
    }

    /**
     * Monitor Core Web Vitals using Lighthouse CI
     */
    async measureCoreWebVitals(url = 'http://localhost') {
        console.log('🚀 Measuring Core Web Vitals...');
        
        try {
            // Check if lighthouse is available
            execSync('which lighthouse', { stdio: 'ignore' });
        } catch (error) {
            console.log('📦 Installing Lighthouse...');
            execSync('npm install -g lighthouse', { stdio: 'inherit' });
        }
        
        const outputPath = path.join(this.reportPath, `lighthouse-${Date.now()}.json`);
        
        try {
            const command = `lighthouse ${url} --output=json --output-path=${outputPath} --chrome-flags="--headless --no-sandbox"`;
            execSync(command, { stdio: 'inherit' });
            
            const report = JSON.parse(fs.readFileSync(outputPath, 'utf8'));
            const metrics = this.extractCoreWebVitals(report);
            
            this.displayCoreWebVitals(metrics);
            this.saveCoreWebVitalsReport(metrics);
            
            return this.validateCoreWebVitals(metrics);
        } catch (error) {
            console.error('❌ Failed to run Lighthouse:', error.message);
            return false;
        }
    }

    extractCoreWebVitals(report) {
        const audits = report.audits;
        
        return {
            timestamp: new Date().toISOString(),
            url: report.finalUrl,
            performance: report.categories.performance.score * 100,
            metrics: {
                fcp: {
                    value: audits['first-contentful-paint'].numericValue,
                    score: audits['first-contentful-paint'].score,
                    displayValue: audits['first-contentful-paint'].displayValue,
                },
                lcp: {
                    value: audits['largest-contentful-paint'].numericValue,
                    score: audits['largest-contentful-paint'].score,
                    displayValue: audits['largest-contentful-paint'].displayValue,
                },
                fid: {
                    value: audits['max-potential-fid'].numericValue,
                    score: audits['max-potential-fid'].score,
                    displayValue: audits['max-potential-fid'].displayValue,
                },
                cls: {
                    value: audits['cumulative-layout-shift'].numericValue,
                    score: audits['cumulative-layout-shift'].score,
                    displayValue: audits['cumulative-layout-shift'].displayValue,
                },
                ttfb: {
                    value: audits['server-response-time'] ? audits['server-response-time'].numericValue : null,
                    score: audits['server-response-time'] ? audits['server-response-time'].score : null,
                    displayValue: audits['server-response-time'] ? audits['server-response-time'].displayValue : 'N/A',
                },
            },
            opportunities: audits ? Object.keys(audits)
                .filter(key => audits[key].details && audits[key].details.type === 'opportunity')
                .map(key => ({
                    title: audits[key].title,
                    description: audits[key].description,
                    savings: audits[key].details.overallSavingsMs,
                })) : [],
        };
    }

    displayCoreWebVitals(metrics) {
        console.log('\n🎯 Core Web Vitals Report');
        console.log('═'.repeat(50));
        console.log(`Performance Score: ${metrics.performance}%`);
        console.log(`URL: ${metrics.url}`);
        
        console.log('\n📊 Metrics:');
        console.log(`   FCP (First Contentful Paint): ${metrics.metrics.fcp.displayValue}`);
        console.log(`   LCP (Largest Contentful Paint): ${metrics.metrics.lcp.displayValue}`);
        console.log(`   FID (First Input Delay): ${metrics.metrics.fid.displayValue}`);
        console.log(`   CLS (Cumulative Layout Shift): ${metrics.metrics.cls.displayValue}`);
        if (metrics.metrics.ttfb.value) {
            console.log(`   TTFB (Time to First Byte): ${metrics.metrics.ttfb.displayValue}`);
        }
        
        // Show top opportunities
        if (metrics.opportunities.length > 0) {
            console.log('\n💡 Top Opportunities:');
            metrics.opportunities
                .sort((a, b) => b.savings - a.savings)
                .slice(0, 3)
                .forEach((opp, index) => {
                    console.log(`   ${index + 1}. ${opp.title} (${Math.round(opp.savings)}ms savings)`);
                });
        }
    }

    validateCoreWebVitals(metrics) {
        const issues = [];
        
        if (metrics.metrics.fcp.value > this.thresholds.maxFCP) {
            issues.push(`FCP (${metrics.metrics.fcp.displayValue}) exceeds threshold (${this.thresholds.maxFCP}ms)`);
        }
        
        if (metrics.metrics.lcp.value > this.thresholds.maxLCP) {
            issues.push(`LCP (${metrics.metrics.lcp.displayValue}) exceeds threshold (${this.thresholds.maxLCP}ms)`);
        }
        
        if (metrics.metrics.fid.value > this.thresholds.maxFID) {
            issues.push(`FID (${metrics.metrics.fid.displayValue}) exceeds threshold (${this.thresholds.maxFID}ms)`);
        }
        
        if (metrics.metrics.cls.value > this.thresholds.maxCLS) {
            issues.push(`CLS (${metrics.metrics.cls.displayValue}) exceeds threshold (${this.thresholds.maxCLS})`);
        }
        
        if (issues.length > 0) {
            console.log('\n❌ Performance Issues:');
            issues.forEach(issue => console.log(`   - ${issue}`));
            return false;
        }
        
        console.log('\n✅ All Core Web Vitals within acceptable thresholds!');
        return true;
    }

    saveCoreWebVitalsReport(metrics) {
        const reportFile = path.join(this.reportPath, 'core-web-vitals.json');
        const history = this.loadCoreWebVitalsHistory();
        
        history.push(metrics);
        
        // Keep only last 30 measurements
        if (history.length > 30) {
            history.splice(0, history.length - 30);
        }
        
        fs.writeFileSync(reportFile, JSON.stringify(history, null, 2));
        console.log(`📄 Core Web Vitals saved to: ${reportFile}`);
    }

    loadCoreWebVitalsHistory() {
        const reportFile = path.join(this.reportPath, 'core-web-vitals.json');
        
        try {
            if (fs.existsSync(reportFile)) {
                return JSON.parse(fs.readFileSync(reportFile, 'utf8'));
            }
        } catch (error) {
            console.warn('Warning: Could not load Core Web Vitals history');
        }
        
        return [];
    }

    /**
     * Generate performance trend report
     */
    generateTrendReport() {
        console.log('📈 Generating performance trend report...');
        
        const history = this.loadCoreWebVitalsHistory();
        
        if (history.length < 2) {
            console.log('⚠️  Not enough data for trend analysis. Run more performance tests.');
            return;
        }
        
        const trends = this.analyzeTrends(history);
        const reportFile = path.join(this.reportPath, 'performance-trends.md');
        
        fs.writeFileSync(reportFile, this.createTrendReport(trends));
        console.log(`📄 Trend report saved to: ${reportFile}`);
    }

    analyzeTrends(history) {
        const latest = history[history.length - 1];
        const previous = history[history.length - 2];
        
        const calculateTrend = (current, prev) => {
            const change = current - prev;
            const percentChange = ((change / prev) * 100).toFixed(1);
            return {
                current,
                previous: prev,
                change,
                percentChange: parseFloat(percentChange),
                trend: change > 0 ? 'worse' : change < 0 ? 'better' : 'stable',
            };
        };
        
        return {
            performance: calculateTrend(latest.performance, previous.performance),
            fcp: calculateTrend(latest.metrics.fcp.value, previous.metrics.fcp.value),
            lcp: calculateTrend(latest.metrics.lcp.value, previous.metrics.lcp.value),
            fid: calculateTrend(latest.metrics.fid.value, previous.metrics.fid.value),
            cls: calculateTrend(latest.metrics.cls.value, previous.metrics.cls.value),
            timestamp: {
                latest: latest.timestamp,
                previous: previous.timestamp,
            },
        };
    }

    createTrendReport(trends) {
        let report = `# Performance Trend Report\n\n`;
        report += `**Latest:** ${new Date(trends.timestamp.latest).toLocaleString()}\n`;
        report += `**Previous:** ${new Date(trends.timestamp.previous).toLocaleString()}\n\n`;
        
        const getTrendIcon = (trend) => {
            switch (trend) {
                case 'better': return '📈 ✅';
                case 'worse': return '📉 ❌';
                default: return '➡️ ';
            }
        };
        
        report += `## Performance Changes\n\n`;
        report += `| Metric | Current | Previous | Change | Trend |\n`;
        report += `|--------|---------|----------|-----------|-------|\n`;
        report += `| Performance Score | ${trends.performance.current}% | ${trends.performance.previous}% | ${trends.performance.percentChange}% | ${getTrendIcon(trends.performance.trend === 'better' ? 'better' : trends.performance.trend === 'worse' ? 'worse' : 'stable')} |\n`;
        report += `| FCP | ${trends.fcp.current.toFixed(0)}ms | ${trends.fcp.previous.toFixed(0)}ms | ${trends.fcp.percentChange}% | ${getTrendIcon(trends.fcp.trend === 'better' ? 'better' : 'worse')} |\n`;
        report += `| LCP | ${trends.lcp.current.toFixed(0)}ms | ${trends.lcp.previous.toFixed(0)}ms | ${trends.lcp.percentChange}% | ${getTrendIcon(trends.lcp.trend === 'better' ? 'better' : 'worse')} |\n`;
        report += `| FID | ${trends.fid.current.toFixed(0)}ms | ${trends.fid.previous.toFixed(0)}ms | ${trends.fid.percentChange}% | ${getTrendIcon(trends.fid.trend === 'better' ? 'better' : 'worse')} |\n`;
        report += `| CLS | ${trends.cls.current.toFixed(3)} | ${trends.cls.previous.toFixed(3)} | ${trends.cls.percentChange}% | ${getTrendIcon(trends.cls.trend === 'better' ? 'better' : 'worse')} |\n`;
        
        return report;
    }
}

// CLI Interface
async function main() {
    const monitor = new PerformanceMonitor();
    const args = process.argv.slice(2);
    
    if (args.length === 0) {
        console.log('🔍 Performance Monitor\n');
        console.log('Usage:');
        console.log('  node scripts/performance-monitor.js bundle        # Analyze bundle sizes');
        console.log('  node scripts/performance-monitor.js vitals [url]  # Measure Core Web Vitals');
        console.log('  node scripts/performance-monitor.js trend         # Generate trend report');
        console.log('  node scripts/performance-monitor.js all [url]     # Run all analyses');
        return;
    }
    
    const command = args[0];
    const url = args[1] || 'http://localhost:8000';
    
    let success = true;
    
    switch (command) {
        case 'bundle':
            success = monitor.analyzeBundles();
            break;
            
        case 'vitals':
            success = await monitor.measureCoreWebVitals(url);
            break;
            
        case 'trend':
            monitor.generateTrendReport();
            break;
            
        case 'all':
            console.log('🚀 Running comprehensive performance analysis...\n');
            success = monitor.analyzeBundles();
            if (success) {
                success = await monitor.measureCoreWebVitals(url);
            }
            monitor.generateTrendReport();
            break;
            
        default:
            console.error(`❌ Unknown command: ${command}`);
            success = false;
    }
    
    process.exit(success ? 0 : 1);
}

if (require.main === module) {
    main().catch(error => {
        console.error('❌ Error:', error.message);
        process.exit(1);
    });
}

module.exports = PerformanceMonitor;
