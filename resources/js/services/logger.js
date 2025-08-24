/**
 * Production Logger Service
 * Enhanced logging with environment awareness and performance monitoring
 */

class ProductionLogger {
    constructor() {
        this.isDevelopment = import.meta.env.DEV;
        this.isProduction = import.meta.env.PROD;
        this.logLevel = import.meta.env.VITE_LOG_LEVEL || 'info';
        this.enableConsoleInProduction = import.meta.env.VITE_ENABLE_CONSOLE_LOGS === 'true';
        
        // Performance tracking
        this.performanceMetrics = new Map();
        this.errorCounts = new Map();
        
        // Initialize production error reporting if needed
        if (this.isProduction && !this.enableConsoleInProduction) {
            this.initializeProductionReporting();
        }
    }

    /**
     * Initialize production error reporting
     */
    initializeProductionReporting() {
        // Override console methods in production if disabled
        if (!this.enableConsoleInProduction) {
            console.log = () => {};
            console.info = () => {};
            console.warn = (...args) => this.captureWarning(...args);
            console.error = (...args) => this.captureError(...args);
        }

        // Global error handler
        window.addEventListener('error', (event) => {
            this.logError('Global Error', {
                message: event.message,
                filename: event.filename,
                lineno: event.lineno,
                colno: event.colno,
                error: event.error?.stack
            });
        });

        // Unhandled promise rejection handler
        window.addEventListener('unhandledrejection', (event) => {
            this.logError('Unhandled Promise Rejection', {
                reason: event.reason,
                promise: event.promise
            });
        });
    }

    /**
     * Log levels: error, warn, info, debug
     */
    shouldLog(level) {
        const levels = { error: 0, warn: 1, info: 2, debug: 3 };
        const currentLevel = levels[this.logLevel] || 2;
        const messageLevel = levels[level] || 2;
        return messageLevel <= currentLevel;
    }

    /**
     * Enhanced error logging
     */
    error(message, context = {}) {
        if (!this.shouldLog('error')) return;
        
        this.logError(message, context);
    }

    logError(message, context = {}) {
        const errorData = {
            timestamp: new Date().toISOString(),
            level: 'error',
            message,
            context,
            url: window.location.href,
            userAgent: navigator.userAgent,
            stack: new Error().stack
        };

        // Count error occurrences
        const errorKey = `${message}-${JSON.stringify(context)}`;
        this.errorCounts.set(errorKey, (this.errorCounts.get(errorKey) || 0) + 1);

        if (this.isDevelopment || this.enableConsoleInProduction) {
            console.error('[Production Logger]', errorData);
        }

        // Send to monitoring service in production
        if (this.isProduction) {
            this.sendToMonitoring('error', errorData);
        }
    }

    /**
     * Warning logging
     */
    warn(message, context = {}) {
        if (!this.shouldLog('warn')) return;

        const warnData = {
            timestamp: new Date().toISOString(),
            level: 'warn',
            message,
            context,
            url: window.location.href
        };

        if (this.isDevelopment || this.enableConsoleInProduction) {
            console.warn('[Production Logger]', warnData);
        }
    }

    captureWarning(...args) {
        this.warn('Console Warning', { args });
    }

    captureError(...args) {
        this.error('Console Error', { args });
    }

    /**
     * Info logging
     */
    info(message, context = {}) {
        if (!this.shouldLog('info')) return;

        if (this.isDevelopment || this.enableConsoleInProduction) {
            console.info('[Production Logger]', message, context);
        }
    }

    /**
     * Debug logging
     */
    debug(message, context = {}) {
        if (!this.shouldLog('debug')) return;

        if (this.isDevelopment) {
            console.debug('[Production Logger]', message, context);
        }
    }

    /**
     * Performance monitoring
     */
    startPerformanceTimer(label) {
        this.performanceMetrics.set(label, {
            start: performance.now(),
            label
        });
    }

    endPerformanceTimer(label) {
        const metric = this.performanceMetrics.get(label);
        if (!metric) {
            this.warn(`Performance timer '${label}' not found`);
            return;
        }

        const duration = performance.now() - metric.start;
        this.performanceMetrics.delete(label);

        const perfData = {
            label,
            duration: Math.round(duration * 100) / 100,
            timestamp: new Date().toISOString()
        };

        this.info(`Performance: ${label}`, perfData);

        // Send performance data in production
        if (this.isProduction && duration > 1000) { // Log slow operations
            this.sendToMonitoring('performance', perfData);
        }

        return duration;
    }

    /**
     * User interaction logging
     */
    logUserAction(action, context = {}) {
        const actionData = {
            action,
            context,
            timestamp: new Date().toISOString(),
            url: window.location.href,
            userId: context.userId || 'anonymous'
        };

        this.debug('User Action', actionData);

        // Track critical user actions in production
        if (this.isProduction && this.isCriticalAction(action)) {
            this.sendToMonitoring('user_action', actionData);
        }
    }

    /**
     * API request/response logging
     */
    logApiCall(method, url, status, duration, requestData = {}, responseData = {}) {
        const apiData = {
            method,
            url,
            status,
            duration,
            timestamp: new Date().toISOString(),
            requestSize: JSON.stringify(requestData).length,
            responseSize: JSON.stringify(responseData).length
        };

        if (status >= 400) {
            this.error(`API Error: ${method} ${url}`, { ...apiData, requestData, responseData });
        } else if (duration > 5000) {
            this.warn(`Slow API Call: ${method} ${url}`, apiData);
        } else {
            this.debug(`API Call: ${method} ${url}`, apiData);
        }
    }

    /**
     * Component lifecycle logging
     */
    logComponentEvent(component, event, data = {}) {
        this.debug(`Component ${event}: ${component}`, data);
    }

    /**
     * Check if action is critical for production tracking
     */
    isCriticalAction(action) {
        const criticalActions = [
            'login',
            'logout',
            'purchase',
            'enrollment',
            'payment',
            'profile_update',
            'password_change',
            'course_completion'
        ];
        return criticalActions.includes(action);
    }

    /**
     * Send data to monitoring service
     */
    sendToMonitoring(type, data) {
        // In a real application, this would send data to a monitoring service
        // like Sentry, LogRocket, DataDog, etc.
        
        try {
            // Example implementation - replace with actual monitoring service
            if (window.gtag) {
                window.gtag('event', 'exception', {
                    description: data.message || type,
                    fatal: type === 'error'
                });
            }

            // Example: Send to custom monitoring endpoint
            if (import.meta.env.VITE_MONITORING_ENDPOINT) {
                fetch(import.meta.env.VITE_MONITORING_ENDPOINT, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify({
                        type,
                        data,
                        app: 'lara-courses',
                        environment: this.isProduction ? 'production' : 'development'
                    })
                }).catch(() => {
                    // Silently fail to avoid logging loops
                });
            }
        } catch (error) {
            // Silently fail to avoid logging loops
        }
    }

    /**
     * Get error statistics
     */
    getErrorStats() {
        return {
            totalErrors: Array.from(this.errorCounts.values()).reduce((sum, count) => sum + count, 0),
            uniqueErrors: this.errorCounts.size,
            topErrors: Array.from(this.errorCounts.entries())
                .sort(([,a], [,b]) => b - a)
                .slice(0, 5)
                .map(([error, count]) => ({ error, count }))
        };
    }

    /**
     * Clear metrics (useful for testing)
     */
    clearMetrics() {
        this.performanceMetrics.clear();
        this.errorCounts.clear();
    }
}

// Create singleton instance
export const logger = new ProductionLogger();

// Export for direct use
export default logger;
