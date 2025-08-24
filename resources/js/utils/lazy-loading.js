/**
 * Lazy Loading Configuration for Vue Components
 * Optimizes bundle splitting and reduces initial load time
 */

// Core components that should be loaded immediately
export const CORE_COMPONENTS = [
    'Button', 'InputText', 'Password', 'Checkbox', 
    'Toast', 'ConfirmDialog', 'Dialog'
]

// Component groups for lazy loading
export const LAZY_COMPONENT_GROUPS = {
    // Data display components
    data: () => [
        import('primevue/datatable'),
        import('primevue/column'),
        import('primevue/tree'),
        import('primevue/treetable'),
        import('primevue/paginator')
    ],
    
    // Form components
    forms: () => [
        import('primevue/calendar'),
        import('primevue/textarea'),
        import('primevue/fileupload'),
        import('primevue/inputnumber'),
        import('primevue/dropdown'),
        import('primevue/multiselect'),
        import('primevue/autocomplete'),
        import('primevue/colorpicker')
    ],
    
    // Navigation components
    navigation: () => [
        import('primevue/menu'),
        import('primevue/menubar'),
        import('primevue/tabview'),
        import('primevue/steps'),
        import('primevue/breadcrumb'),
        import('primevue/panelmenu')
    ],
    
    // Media components
    media: () => [
        import('primevue/image'),
        import('primevue/carousel'),
        import('primevue/galleria')
    ],
    
    // Overlay components
    overlay: () => [
        import('primevue/sidebar'),
        import('primevue/overlaypanel'),
        import('primevue/tooltip')
    ],
    
    // Charts and visualization (heavy components)
    charts: () => [
        import('vue-chartjs'),
        import('chart.js')
    ],
    
    // Editor components (heaviest)
    editor: () => [
        import('@tiptap/vue-3'),
        import('@tiptap/starter-kit'),
        import('@tiptap/extension-color'),
        import('@tiptap/extension-highlight'),
        import('@tiptap/extension-image'),
        import('@tiptap/extension-link')
    ]
}

// Route-based component loading strategy
export const ROUTE_COMPONENT_MAPPING = {
    // Admin routes - load form and data components
    '/admin': ['forms', 'data', 'navigation', 'overlay'],
    '/admin/questions': ['forms', 'data', 'editor'],
    '/admin/lessons': ['forms', 'editor', 'media'],
    '/admin/videos': ['forms', 'media'],
    '/admin/analytics': ['charts', 'data'],
    
    // User routes - load interactive components
    '/quiz': ['navigation', 'overlay'],
    '/practice': ['navigation', 'overlay'],
    '/exam': ['navigation', 'overlay'],
    '/profile': ['forms', 'media'],
    
    // Landing page - minimal components
    '/': ['media'],
    '/welcome': ['media']
}

/**
 * Preload component groups based on current route
 */
export function preloadComponentsForRoute(currentRoute) {
    const routePath = currentRoute.replace(/\/\d+$/, '') // Remove ID params
    const requiredGroups = ROUTE_COMPONENT_MAPPING[routePath] || []
    
    const loadPromises = requiredGroups.map(group => {
        const loader = LAZY_COMPONENT_GROUPS[group]
        if (loader) {
            return Promise.all(loader()).catch(error => {
                if (window.logger) {
                    window.logger.warn(`Failed to preload component group: ${group}`, { error: error.message })
                }
                return []
            })
        }
        return Promise.resolve([])
    })
    
    return Promise.all(loadPromises)
}

/**
 * Intersection Observer for lazy loading components on scroll
 */
export function createComponentLazyLoader() {
    if (!window.IntersectionObserver) {
        return null
    }
    
    return new IntersectionObserver((entries) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const componentGroup = entry.target.dataset.lazyGroup
                if (componentGroup && LAZY_COMPONENT_GROUPS[componentGroup]) {
                    const loader = LAZY_COMPONENT_GROUPS[componentGroup]
                    Promise.all(loader()).catch(error => {
                        if (window.logger) {
                            window.logger.warn(`Failed to lazy load component group: ${componentGroup}`, { error: error.message })
                        }
                    })
                }
            }
        })
    }, {
        rootMargin: '50px',
        threshold: 0.1
    })
}

/**
 * Priority loading for critical user interactions
 */
export const INTERACTION_COMPONENT_PRIORITY = {
    // High priority - immediate user actions
    high: ['forms', 'overlay'],
    
    // Medium priority - secondary actions
    medium: ['navigation', 'data'],
    
    // Low priority - non-critical features
    low: ['media', 'charts', 'editor']
}

/**
 * Load components by interaction priority
 */
export function loadComponentsByPriority(priority = 'high') {
    const groups = INTERACTION_COMPONENT_PRIORITY[priority] || []
    return Promise.all(
        groups.map(group => {
            const loader = LAZY_COMPONENT_GROUPS[group]
            return loader ? Promise.all(loader()) : Promise.resolve([])
        })
    )
}

/**
 * Bundle size monitoring
 */
export function trackComponentBundleSize(componentName, loadTime) {
    if (window.logger) {
        window.logger.info('Component bundle loaded', {
            component: componentName,
            loadTime,
            timestamp: new Date().toISOString()
        })
        
        // Track slow loading components
        if (loadTime > 1000) {
            window.logger.warn('Slow component load detected', {
                component: componentName,
                loadTime
            })
        }
    }
}
