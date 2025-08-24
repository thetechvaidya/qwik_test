/**
 * Dynamic component loading utility
 * Provides lazy loading and performance monitoring for Vue components
 */

import { loadComponentGroup, preloadComponentsForRoute, getComponentCacheStatus } from '../core/component-registry';

/**
 * Performance monitoring for component loading
 */
const loadingMetrics = {
    totalLoads: 0,
    averageLoadTime: 0,
    loadTimes: [],
    errors: []
};

/**
 * Component dependency map for ensuring required components are loaded together
 */
const COMPONENT_DEPENDENCIES = {
    'DataTable': ['Column', 'Row', 'ColumnGroup'],
    'TabView': ['TabPanel'],
    'Accordion': ['AccordionTab'],
    'Splitter': ['SplitterPanel'],
    'Menu': ['MenuItem'],
    'Menubar': ['MenuItem'],
    'PanelMenu': ['MenuItem']
};

/**
 * Load component group with performance monitoring
 */
export async function loadComponentGroup(app, groupName) {
    const startTime = performance.now();
    
    try {
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Loading component group: ${groupName}`);
        }

        // Load the main component group
        await import('../core/component-registry').then(module => 
            module.loadComponentGroup(app, groupName)
        );

        // Load dependencies if any
        await loadComponentDependencies(app, groupName);

        const endTime = performance.now();
        const loadTime = endTime - startTime;
        
        updateLoadingMetrics(loadTime);
        
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Group '${groupName}' loaded in ${loadTime.toFixed(2)}ms`);
        }

        return true;
    } catch (error) {
        const endTime = performance.now();
        const loadTime = endTime - startTime;
        
        recordLoadingError(groupName, error, loadTime);
        
        console.error(`[ComponentLoader] Failed to load component group '${groupName}':`, error);
        
        // Attempt fallback registration
        await registerFallbackGroup(app, groupName);
        
        return false;
    }
}

/**
 * Load component dependencies
 */
async function loadComponentDependencies(app, groupName) {
    const dependencies = getGroupDependencies(groupName);
    
    if (dependencies.length > 0) {
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Loading dependencies for '${groupName}':`, dependencies);
        }
        
        for (const depGroup of dependencies) {
            await loadComponentGroup(app, depGroup);
        }
    }
}

/**
 * Get dependencies for a component group
 */
function getGroupDependencies(groupName) {
    const dependencyMap = {
        'data': ['feedback'], // DataTable might need ProgressBar
        'navigation': ['overlay'], // Navigation might need overlays
        'forms': ['feedback'] // Forms might need validation feedback
    };
    
    return dependencyMap[groupName] || [];
}

/**
 * Preload components for critical routes
 */
export async function preloadComponents(app, routeName) {
    const startTime = performance.now();
    
    try {
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Preloading components for route: ${routeName}`);
        }

        await preloadComponentsForRoute(app, routeName);
        
        const endTime = performance.now();
        const loadTime = endTime - startTime;
        
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Route '${routeName}' components preloaded in ${loadTime.toFixed(2)}ms`);
        }

        return true;
    } catch (error) {
        console.error(`[ComponentLoader] Failed to preload components for route '${routeName}':`, error);
        return false;
    }
}

/**
 * Register component group with the Vue app
 */
export async function registerComponentGroup(app, groupName) {
    try {
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Registering component group: ${groupName}`);
        }

        const success = await loadComponentGroup(app, groupName);
        
        if (success) {
            if (import.meta.env.DEV) {
                console.log(`[ComponentLoader] Component group '${groupName}' registered successfully`);
            }
        }
        
        return success;
    } catch (error) {
        console.error(`[ComponentLoader] Failed to register component group '${groupName}':`, error);
        return false;
    }
}

/**
 * Update loading metrics
 */
function updateLoadingMetrics(loadTime) {
    loadingMetrics.totalLoads++;
    loadingMetrics.loadTimes.push(loadTime);
    
    // Calculate average (keep only last 100 measurements for rolling average)
    if (loadingMetrics.loadTimes.length > 100) {
        loadingMetrics.loadTimes.shift();
    }
    
    loadingMetrics.averageLoadTime = loadingMetrics.loadTimes.reduce((a, b) => a + b, 0) / loadingMetrics.loadTimes.length;
}

/**
 * Record loading error
 */
function recordLoadingError(groupName, error, loadTime) {
    loadingMetrics.errors.push({
        groupName,
        error: error.message,
        loadTime,
        timestamp: new Date().toISOString()
    });
    
    // Keep only last 50 errors
    if (loadingMetrics.errors.length > 50) {
        loadingMetrics.errors.shift();
    }
}

/**
 * Register fallback components for failed groups
 */
async function registerFallbackGroup(app, groupName) {
    if (import.meta.env.DEV) {
        console.log(`[ComponentLoader] Registering fallback components for group: ${groupName}`);
    }
    
    // Create placeholder components for critical functionality
    const fallbackComponents = {
        'forms': {
            'Password': { template: '<input type="password" :value="modelValue" @input="$emit(\'update:modelValue\', $event.target.value)" class="fallback-input" />' },
            'Checkbox': { template: '<input type="checkbox" :checked="modelValue" @change="$emit(\'update:modelValue\', $event.target.checked)" class="fallback-checkbox" />' }
        },
        'feedback': {
            'ProgressBar': { template: '<div class="fallback-progress"><div class="fallback-progress-bar" :style="{width: value + \'%\'}"></div></div>' },
            'Message': { template: '<div class="fallback-message" :class="severity">{{ text }}</div>' }
        }
    };
    
    const fallbacks = fallbackComponents[groupName];
    if (fallbacks) {
        for (const [name, component] of Object.entries(fallbacks)) {
            app.component(name, component);
            
            if (import.meta.env.DEV) {
                console.log(`[ComponentLoader] Registered fallback component: ${name}`);
            }
        }
    }
}

/**
 * Get component loading performance metrics
 */
export function getLoadingMetrics() {
    return {
        ...loadingMetrics,
        cacheStatus: getComponentCacheStatus()
    };
}

/**
 * Clear loading metrics (useful for testing)
 */
export function clearLoadingMetrics() {
    loadingMetrics.totalLoads = 0;
    loadingMetrics.averageLoadTime = 0;
    loadingMetrics.loadTimes = [];
    loadingMetrics.errors = [];
}

/**
 * Check if a component group is loaded
 */
export function isGroupLoaded(groupName) {
    const status = getComponentCacheStatus();
    return status.loadedGroups.includes(groupName);
}

/**
 * Get all available component groups
 */
export function getAvailableGroups() {
    return [
        'core',
        'forms', 
        'data', 
        'overlay', 
        'navigation', 
        'layout', 
        'feedback', 
        'media', 
        'misc'
    ];
}

/**
 * Batch load multiple component groups
 */
export async function loadMultipleGroups(app, groupNames) {
    const startTime = performance.now();
    const results = [];
    
    try {
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Batch loading groups:`, groupNames);
        }

        // Load groups in parallel for better performance
        const promises = groupNames.map(groupName => 
            loadComponentGroup(app, groupName).catch(error => {
                console.error(`[ComponentLoader] Failed to load group '${groupName}':`, error);
                return false;
            })
        );
        
        const loadResults = await Promise.all(promises);
        
        groupNames.forEach((groupName, index) => {
            results.push({
                groupName,
                success: loadResults[index],
                loaded: isGroupLoaded(groupName)
            });
        });
        
        const endTime = performance.now();
        const totalTime = endTime - startTime;
        
        if (import.meta.env.DEV) {
            console.log(`[ComponentLoader] Batch load completed in ${totalTime.toFixed(2)}ms:`, results);
        }
        
        return results;
    } catch (error) {
        console.error('[ComponentLoader] Batch loading failed:', error);
        return results;
    }
}

/**
 * Cleanup utility for component loader
 */
export function cleanup() {
    clearLoadingMetrics();
    
    if (import.meta.env.DEV) {
        console.log('[ComponentLoader] Cleanup completed');
    }
}
