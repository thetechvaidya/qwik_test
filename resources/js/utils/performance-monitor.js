/**
 * Performance Monitoring Utilities
 * Tracks component performance and provides optimization insights
 */

import logger from '../services/logger'

/**
 * Component Performance Monitor
 */
export class ComponentPerformanceMonitor {
    constructor() {
        this.metrics = new Map()
        this.thresholds = {
            render: 16, // 60fps target
            mount: 100,
            update: 50,
            interaction: 100
        }
        
        // Setup global performance observer if available
        this.setupPerformanceObserver()
    }

    /**
     * Setup Performance Observer for automatic tracking
     */
    setupPerformanceObserver() {
        if (typeof PerformanceObserver === 'undefined') {
            return
        }

        try {
            const observer = new PerformanceObserver((list) => {
                list.getEntries().forEach(entry => {
                    if (entry.name.startsWith('vue-component-')) {
                        this.recordMetric(entry.name, entry.duration, 'performance-observer')
                    }
                })
            })
            observer.observe({ entryTypes: ['measure'] })
        } catch (error) {
            logger.warn('Failed to setup performance observer', { error: error.message })
        }
    }

    /**
     * Start tracking a component operation
     */
    startTracking(componentName, operation = 'render') {
        const key = `${componentName}-${operation}`
        const startTime = performance.now()
        
        this.metrics.set(key, {
            componentName,
            operation,
            startTime,
            endTime: null,
            duration: null
        })
        
        return key
    }

    /**
     * End tracking and record the metric
     */
    endTracking(trackingKey) {
        const metric = this.metrics.get(trackingKey)
        if (!metric) {
            logger.warn('Tracking key not found', { trackingKey })
            return null
        }

        metric.endTime = performance.now()
        metric.duration = metric.endTime - metric.startTime

        this.recordMetric(metric.componentName, metric.duration, metric.operation)
        this.metrics.delete(trackingKey)
        
        return metric.duration
    }

    /**
     * Record a performance metric
     */
    recordMetric(componentName, duration, operation = 'render') {
        const threshold = this.thresholds[operation] || this.thresholds.render
        
        const metricData = {
            component: componentName,
            operation,
            duration: Math.round(duration * 100) / 100,
            threshold,
            isSlowRender: duration > threshold,
            timestamp: new Date().toISOString()
        }

        // Log slow operations
        if (metricData.isSlowRender) {
            logger.warn(`Slow ${operation} detected`, metricData)
        } else if (import.meta.env.DEV) {
            logger.debug(`Component ${operation} performance`, metricData)
        }

        // Store metric for analysis
        this.storeMetric(metricData)
        
        return metricData
    }

    /**
     * Store metric for later analysis
     */
    storeMetric(metricData) {
        const storageKey = 'component-performance-metrics'
        
        try {
            const stored = JSON.parse(localStorage.getItem(storageKey) || '[]')
            stored.push(metricData)
            
            // Keep only last 100 metrics to prevent storage bloat
            if (stored.length > 100) {
                stored.splice(0, stored.length - 100)
            }
            
            localStorage.setItem(storageKey, JSON.stringify(stored))
        } catch (error) {
            logger.warn('Failed to store performance metric', { error: error.message })
        }
    }

    /**
     * Get performance metrics for analysis
     */
    getMetrics(componentName = null, operation = null) {
        try {
            const stored = JSON.parse(localStorage.getItem('component-performance-metrics') || '[]')
            
            return stored.filter(metric => {
                const matchesComponent = !componentName || metric.component === componentName
                const matchesOperation = !operation || metric.operation === operation
                return matchesComponent && matchesOperation
            })
        } catch (error) {
            logger.warn('Failed to retrieve performance metrics', { error: error.message })
            return []
        }
    }

    /**
     * Get performance summary
     */
    getPerformanceSummary() {
        const metrics = this.getMetrics()
        
        if (metrics.length === 0) {
            return { message: 'No performance data available' }
        }

        const summary = {
            totalMeasurements: metrics.length,
            slowRenders: metrics.filter(m => m.isSlowRender).length,
            averageRenderTime: this.calculateAverage(metrics, 'duration'),
            slowestComponent: this.findSlowest(metrics),
            renderTimesByComponent: this.groupByComponent(metrics)
        }

        summary.performanceScore = this.calculatePerformanceScore(summary)
        
        return summary
    }

    /**
     * Calculate average duration
     */
    calculateAverage(metrics, field) {
        if (metrics.length === 0) return 0
        const sum = metrics.reduce((acc, metric) => acc + metric[field], 0)
        return Math.round((sum / metrics.length) * 100) / 100
    }

    /**
     * Find slowest component
     */
    findSlowest(metrics) {
        if (metrics.length === 0) return null
        return metrics.reduce((slowest, current) => 
            current.duration > slowest.duration ? current : slowest
        )
    }

    /**
     * Group metrics by component
     */
    groupByComponent(metrics) {
        const grouped = {}
        
        metrics.forEach(metric => {
            if (!grouped[metric.component]) {
                grouped[metric.component] = {
                    count: 0,
                    totalDuration: 0,
                    slowRenders: 0
                }
            }
            
            grouped[metric.component].count++
            grouped[metric.component].totalDuration += metric.duration
            if (metric.isSlowRender) {
                grouped[metric.component].slowRenders++
            }
        })

        // Calculate averages
        Object.keys(grouped).forEach(component => {
            const data = grouped[component]
            data.averageDuration = Math.round((data.totalDuration / data.count) * 100) / 100
            data.slowRenderPercentage = Math.round((data.slowRenders / data.count) * 10000) / 100
        })

        return grouped
    }

    /**
     * Calculate overall performance score (0-100)
     */
    calculatePerformanceScore(summary) {
        const slowRenderRatio = summary.slowRenders / summary.totalMeasurements
        const avgRenderTime = summary.averageRenderTime
        
        // Score based on slow render ratio and average time
        let score = 100
        score -= slowRenderRatio * 50 // Penalize slow renders heavily
        score -= Math.min(avgRenderTime / 2, 25) // Penalize slow average times
        
        return Math.max(0, Math.round(score))
    }

    /**
     * Clear stored metrics
     */
    clearMetrics() {
        try {
            localStorage.removeItem('component-performance-metrics')
            logger.info('Performance metrics cleared')
        } catch (error) {
            logger.warn('Failed to clear performance metrics', { error: error.message })
        }
    }

    /**
     * Export metrics for analysis
     */
    exportMetrics() {
        const metrics = this.getMetrics()
        const summary = this.getPerformanceSummary()
        
        return {
            summary,
            metrics,
            exportedAt: new Date().toISOString(),
            userAgent: navigator.userAgent,
            viewport: {
                width: window.innerWidth,
                height: window.innerHeight
            }
        }
    }
}

// Create singleton instance
export const performanceMonitor = new ComponentPerformanceMonitor()

/**
 * Vue directive for automatic performance tracking
 */
export const vPerformance = {
    mounted(el, binding) {
        const componentName = binding.value || el.tagName.toLowerCase()
        const trackingKey = performanceMonitor.startTracking(componentName, 'mount')
        
        // Store tracking key for cleanup
        el._performanceTrackingKey = trackingKey
        
        // End tracking on next tick
        Vue.nextTick(() => {
            performanceMonitor.endTracking(trackingKey)
        })
    },
    
    updated(el, binding) {
        const componentName = binding.value || el.tagName.toLowerCase()
        const trackingKey = performanceMonitor.startTracking(componentName, 'update')
        
        Vue.nextTick(() => {
            performanceMonitor.endTracking(trackingKey)
        })
    },
    
    beforeUnmount(el) {
        if (el._performanceTrackingKey) {
            performanceMonitor.endTracking(el._performanceTrackingKey)
        }
    }
}

/**
 * Simple performance tracking function for Vue 3 components
 * Use this in components that need performance monitoring
 */
export function usePerformanceTracking(componentName) {
    const name = componentName || 'Unknown'

    const startTracking = (operation = 'render') => {
        return performanceMonitor.startTracking(name, operation)
    }

    const endTracking = (trackingKey) => {
        return performanceMonitor.endTracking(trackingKey)
    }

    return {
        startTracking,
        endTracking,
        monitor: performanceMonitor
    }
}

// Make it available globally for easier access
if (typeof window !== 'undefined') {
    window.performanceMonitor = performanceMonitor
}

export default performanceMonitor
