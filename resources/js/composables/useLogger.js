/**
 * Logger composable for Vue components
 * Production-safe replacement for console statements
 */

import logger from '../services/logger'

export function useLogger() {
    const logError = (message, context = {}) => {
        logger.error(message, { 
            ...context, 
            component: getCurrentInstance()?.type.__name || 'Unknown',
            timestamp: new Date().toISOString()
        })
    }

    const logWarn = (message, context = {}) => {
        logger.warn(message, {
            ...context,
            component: getCurrentInstance()?.type.__name || 'Unknown',
            timestamp: new Date().toISOString()
        })
    }

    const logInfo = (message, context = {}) => {
        logger.info(message, {
            ...context,
            component: getCurrentInstance()?.type.__name || 'Unknown',
            timestamp: new Date().toISOString()
        })
    }

    const logDebug = (message, context = {}) => {
        logger.debug(message, {
            ...context,
            component: getCurrentInstance()?.type.__name || 'Unknown',
            timestamp: new Date().toISOString()
        })
    }

    const logUserAction = (action, context = {}) => {
        logger.logUserAction(action, {
            ...context,
            component: getCurrentInstance()?.type.__name || 'Unknown'
        })
    }

    const logApiCall = (method, url, status, duration, requestData = {}, responseData = {}) => {
        logger.logApiCall(method, url, status, duration, requestData, responseData)
    }

    const startTimer = (label) => {
        const component = getCurrentInstance()?.type.__name || 'Unknown'
        logger.startPerformanceTimer(`${component}-${label}`)
    }

    const endTimer = (label) => {
        const component = getCurrentInstance()?.type.__name || 'Unknown'
        return logger.endPerformanceTimer(`${component}-${label}`)
    }

    return {
        logError,
        logWarn,
        logInfo,
        logDebug,
        logUserAction,
        logApiCall,
        startTimer,
        endTimer
    }
}

// Import getCurrentInstance from Vue
import { getCurrentInstance } from 'vue'
