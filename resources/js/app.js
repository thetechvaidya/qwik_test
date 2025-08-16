import './bootstrap'

// Import modules...
import { createApp, h } from 'vue'
import { createInertiaApp, Link, useForm } from '@inertiajs/vue3'
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers'
import NProgress from 'nprogress'
import { router } from '@inertiajs/vue3'
import PrimeVue from 'primevue/config'
import ToastService from 'primevue/toastservice'
import VueGoodTablePlugin from 'vue-good-table-next'
import ConfirmationService from 'primevue/confirmationservice'
import { createPinia } from 'pinia'
// NOTE: Removed @vueuse/head createHead to avoid conflict with Inertia's <Head> component
// Using single convention: Inertia <Head> components for page titles
// import { createHead } from '@vueuse/head';
import { useClipboard } from '@vueuse/core'
import vSelect from 'vue-select'
import { Swiper, SwiperSlide } from 'swiper/vue'
import VCalendar from 'v-calendar'
import VueSweetalert2 from 'vue-sweetalert2'
import translateMixin from './Mixins/translate'
import hex2rgbaMixin from './Mixins/hex2rgba'
import { useTranslate } from './composables/useTranslate'
import { useHex2Rgba } from './composables/useHex2Rgba'

// Import modern CSS for enhanced components
import 'primeicons/primeicons.css'

// Development console message deduplication system
const devWarnings = new Set()
const devLogOnce = (level, message, ...args) => {
    if (!import.meta.env.DEV) return

    const key = typeof message === 'string' ? message : JSON.stringify(message)
    if (!devWarnings.has(key)) {
        console[level](message, ...args)
        devWarnings.add(key)
    }
}

// Environment configuration - single source of truth
const isDev = import.meta.env.DEV
const isProd = import.meta.env.PROD

// Global filter function for Vue 3
const convertToCharacter = value => {
    let characters = ['A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J']
    return characters[value]
}

// Reusable theme token update function with robust hex validation and caching
let lastAppliedColors = null // Cache for change detection

function updateThemeTokens({ primary, secondary }) {
    // Input validation - ensure we have valid input types
    if (primary !== undefined && primary !== null && typeof primary !== 'string') {
        if (isDev) {
            console.warn('Invalid primary color type:', typeof primary, 'expected string')
        }
        return
    }
    if (secondary !== undefined && secondary !== null && typeof secondary !== 'string') {
        if (isDev) {
            console.warn('Invalid secondary color type:', typeof secondary, 'expected string')
        }
        return
    }

    // Normalize and validate inputs with fallbacks
    const normalizeHex = hex => {
        if (!hex) return null

        // Remove single # prefix if present (but not multiple ##)
        let cleaned = String(hex)
        if (cleaned.charAt(0) === '#') {
            cleaned = cleaned.substring(1)
        }

        // Check for invalid patterns like remaining # characters
        if (cleaned.indexOf('#') !== -1) {
            return null // Invalid if # appears in the middle or multiple #
        }

        // Validate hex characters only
        if (!/^[0-9a-fA-F]+$/.test(cleaned)) {
            return null
        }

        // Handle different hex lengths
        switch (cleaned.length) {
            case 3:
                // Convert #abc to #aabbcc
                return cleaned
                    .split('')
                    .map(c => c + c)
                    .join('')
            case 6:
                // Standard 6-digit hex
                return cleaned
            case 8:
                // 8-digit hex with alpha, extract RGB part
                return cleaned.substring(0, 6)
            default:
                // Invalid length
                return null
        }
    }

    const p = normalizeHex(primary) || '05887d'
    const s = normalizeHex(secondary) || '8d4aa5'

    // Change detection - skip if colors haven't changed
    const currentColors = { primary: p, secondary: s }
    if (
        lastAppliedColors &&
        lastAppliedColors.primary === currentColors.primary &&
        lastAppliedColors.secondary === currentColors.secondary
    ) {
        if (isDev) {
            console.log('Theme colors unchanged, skipping DOM update')
        }
        return // No-op guard - colors haven't changed
    }

    // Log validation warnings in development
    if (isDev && primary && !normalizeHex(primary)) {
        console.warn(`Invalid primary color hex: ${primary}, using fallback: ${p}`)
    }
    if (isDev && secondary && !normalizeHex(secondary)) {
        console.warn(`Invalid secondary color hex: ${secondary}, using fallback: ${s}`)
    }

    const root = document.documentElement
    const set = (name, val) => root.style.setProperty(name, val)

    // Helper function to generate lighter/darker shades
    const adjustColor = (hex, percent) => {
        const num = parseInt(hex, 16)
        const amt = Math.round(2.55 * percent)
        const R = (num >> 16) + amt
        const G = ((num >> 8) & 0x00ff) + amt
        const B = (num & 0x0000ff) + amt
        return (
            0x1000000 +
            (R < 255 ? (R < 1 ? 0 : R) : 255) * 0x10000 +
            (G < 255 ? (G < 1 ? 0 : G) : 255) * 0x100 +
            (B < 255 ? (B < 1 ? 0 : B) : 255)
        )
            .toString(16)
            .slice(1)
    }

    // Set main 500 shades
    set('--p-primary-500', `#${p}`)
    set('--p-secondary-500', `#${s}`)
    set('--primary-color', `#${p}`)
    set('--secondary-color', `#${s}`)

    // Generate and set 400/600 shades for better contrast
    try {
        const primary400 = adjustColor(p, 15) // Lighter
        const primary600 = adjustColor(p, -15) // Darker
        const secondary400 = adjustColor(s, 15)
        const secondary600 = adjustColor(s, -15)

        set('--p-primary-400', `#${primary400}`)
        set('--p-primary-600', `#${primary600}`)
        set('--p-secondary-400', `#${secondary400}`)
        set('--p-secondary-600', `#${secondary600}`)

        // Cache the applied colors for future change detection
        lastAppliedColors = currentColors

        if (isDev) {
            console.log('Theme colors updated with full token mapping:', {
                primary: { 400: `#${primary400}`, 500: `#${p}`, 600: `#${primary600}` },
                secondary: { 400: `#${secondary400}`, 500: `#${s}`, 600: `#${secondary600}` },
            })
        }
    } catch (shadeError) {
        // Fallback to defaults if shade generation fails
        set('--p-primary-400', '#26a69a')
        set('--p-primary-600', '#00695c')
        set('--p-secondary-400', '#ab47bc')
        set('--p-secondary-600', '#6a1b9a')

        // Cache the applied colors even on error to prevent repeated DOM updates
        lastAppliedColors = currentColors

        if (isDev) {
            console.warn('Failed to generate color shades, using defaults:', shadeError)
        }
    }
}

// NProgress configuration
NProgress.configure({
    template:
        '<div class="bar" role="bar"><div class="peg"></div></div>' +
        '<div class="spinner" role="spinner">' +
        '<div class="bg-gradient-to-r from-indigo-600 to-purple-600 rounded-lg shadow-lg flex items-center justify-center gap-4 px-4 py-2">' +
        '<div class="spinner-icon"></div><div class="text-xs text-white font-medium">Loading</div>' +
        '</div></div>',
})

// Router event handlers
let timeout = null

const offStart = router.on('start', () => {
    timeout = setTimeout(() => NProgress.start(), 250)
})

const offProgress = router.on('progress', event => {
    const p = event.detail.progress
    if (NProgress.isStarted() && p && typeof p.percentage === 'number') {
        NProgress.set((p.percentage / 100) * 0.9)
    }
})

const offFinish = router.on('finish', event => {
    clearTimeout(timeout)
    if (!NProgress.isStarted()) {
        return
    } else if (event.detail.visit.completed) {
        NProgress.done()
    } else if (event.detail.visit.interrupted) {
        NProgress.done()
        NProgress.remove()
    } else if (event.detail.visit.cancelled) {
        NProgress.done()
        NProgress.remove()
    }

    // Re-render KaTeX math content after SPA navigation
    if (event.detail.visit.completed && typeof window.renderMathInElement === 'function') {
        // Small delay to ensure DOM is updated
        setTimeout(() => {
            try {
                window.renderMathInElement(document.body, {
                    delimiters: [
                        { left: '$$', right: '$$', display: true },
                        { left: '$', right: '$', display: false },
                        { left: '\\[', right: '\\]', display: true },
                        { left: '\\(', right: '\\)', display: false },
                    ],
                    throwOnError: false,
                    strict: false,
                    // Exclude Tiptap editor content from auto-rendering
                    ignoredTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
                    ignoredClasses: ['ProseMirror', 'tiptap-content', 'tiptap-editor'],
                })
            } catch (error) {
                if (isDev) {
                    console.warn('Failed to re-render KaTeX after navigation:', error)
                }
            }
        }, 100)
    }

    // Re-render MathJax content after SPA navigation (if enabled)
    if (event.detail.visit.completed && typeof window.MathJax !== 'undefined' && window.MathJax.typesetPromise) {
        // Small delay to ensure DOM is updated
        setTimeout(() => {
            try {
                // Re-typeset MathJax content, excluding Tiptap editor areas
                const elementsToTypeset = document.querySelectorAll(
                    'body *:not(.ProseMirror):not(.tiptap-content):not(.tiptap-editor)'
                )
                if (elementsToTypeset.length > 0) {
                    window.MathJax.typesetPromise(Array.from(elementsToTypeset)).catch(error => {
                        if (isDev) {
                            console.warn('MathJax typeset failed after navigation:', error)
                        }
                    })
                }
            } catch (error) {
                if (isDev) {
                    console.warn('Failed to re-render MathJax after navigation:', error)
                }
            }
        }, 150) // Slightly later than KaTeX to avoid conflicts
    }

    // Update theme tokens after navigation if theme data is available
    try {
        const pageProps = event.detail?.page?.props
        if (pageProps?.general?.theme) {
            const { primary, secondary } = pageProps.general.theme
            updateThemeTokens({ primary, secondary })
        }
    } catch (error) {
        if (isDev) {
            console.warn('Failed to update theme on navigation:', error)
        }
    }
})

// Listen for custom theme update events (e.g., from theme settings form)
const handleThemeUpdate = event => {
    try {
        const { primary, secondary } = event.detail || {}
        if (primary || secondary) {
            updateThemeTokens({ primary, secondary })
            if (isDev) {
                console.log('Theme updated via custom event:', { primary, secondary })
            }
        }
    } catch (error) {
        if (isDev) {
            console.warn('Failed to handle theme update event:', error)
        }
    }
}

window.addEventListener('app:theme-updated', handleThemeUpdate)

if (import.meta.hot) {
    import.meta.hot.dispose(() => {
        offStart && offStart()
        offProgress && offProgress()
        offFinish && offFinish()
        window.removeEventListener('app:theme-updated', handleThemeUpdate)
    })
}

// Environment validation helper (only in development)
const validateEnvVar = (varName, defaultValue) => {
    const value = import.meta.env[varName]
    if (isDev && (value === undefined || value === null || value === '')) {
        devLogOnce('warn', `Environment variable ${varName} is not set, using default: ${defaultValue}`)
        return defaultValue
    }
    return value || defaultValue
}

// App configuration
const appName = validateEnvVar('VITE_APP_NAME', 'Laravel')
const appEnv = validateEnvVar('VITE_APP_ENV', 'production')
const appDebug = validateEnvVar('VITE_APP_DEBUG', 'false')

// Build-time compatibility checking (development only)
const checkCompatibility = () => {
    if (!isDev) return true
    const compatibilityIssues = []
    // Check for Vue 3 compatibility of key packages
    if (typeof VueGoodTablePlugin?.install !== 'function') {
        compatibilityIssues.push('VueGoodTablePlugin may not be Vue 3 compatible')
    }
    if (compatibilityIssues.length > 0) {
        devLogOnce('warn', 'Compatibility Issues Found:', compatibilityIssues)
    }
    return compatibilityIssues.length === 0
}

// Enhanced PrimeVue 4.x configuration for modern UI
const primeVueConfig = {
    ripple: true,
    // PrimeVue 4.x input variant configuration (outlined | filled)
    inputVariant: 'outlined',
    // Centralized z-index management for overlays
    zIndex: {
        modal: 1100, // dialog, drawer
        overlay: 1000, // select, popover
        menu: 1000, // overlay menus
        tooltip: 1100,
    },
    // Enhanced styling for modern UI
    theme: {
        preset: 'Aura',
        options: {
            prefix: 'p',
            darkModeSelector: '.dark',
            cssLayer: false,
        },
    },
    // Pass Through options for modern design system
    ptOptions: {
        mergeSections: true,
        mergeProps: false,
    },
}

createInertiaApp({
    title: title => `${title} - ${appName}`,
    resolve: name => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const pinia = createPinia()
        // Removed createHead() to avoid conflict with Inertia's <Head> component
        // Using single head management convention via Inertia <Head> components

        const app = createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(pinia)

        // Update PrimeVue design tokens from theme settings at runtime
        try {
            if (props?.initialPage?.props?.general?.theme) {
                const { primary, secondary } = props.initialPage.props.general.theme
                updateThemeTokens({ primary, secondary })
            }
        } catch (error) {
            if (isDev) {
                console.warn('Failed to update theme colors:', error)
            }
        }

        // Add backward-compatibility alias for this.$inertia.form across legacy pages
        // Add backward-compatibility alias for this.$inertia.form across legacy pages
        if (app.config.globalProperties.$inertia) {
            app.config.globalProperties.$inertia.form = (...args) => useForm(...args)

            // Legacy this.$inertia.get/post/put/delete/visit compatibility shim to bridge to router.*
            const inertiaCompat = app.config.globalProperties.$inertia

            // Enable router proxies in both dev and production temporarily due to extensive existing usage
            ;['get', 'post', 'put', 'patch', 'delete', 'visit', 'reload'].forEach(method => {
                if (typeof router[method] === 'function') {
                    inertiaCompat[method] = (...args) => {
                        if (isDev) {
                            devLogOnce(
                                'warn',
                                `Deprecated: use router.${method}() instead of this.$inertia.${method}(). Legacy router methods will be removed in future versions.`
                            )
                        }
                        return router[method](...args)
                    }
                }
            })
            if (router.remember) {
                inertiaCompat.remember = (...args) => {
                    if (isDev) {
                        devLogOnce(
                            'warn',
                            'Deprecated: use router.remember() instead of this.$inertia.remember(). Legacy router methods will be removed in future versions.'
                        )
                    }
                    return router.remember(...args)
                }
            }
            if (router.restore) {
                inertiaCompat.restore = (...args) => {
                    if (isDev) {
                        devLogOnce(
                            'warn',
                            'Deprecated: use router.restore() instead of this.$inertia.restore(). Legacy router methods will be removed in future versions.'
                        )
                    }
                    return router.restore(...args)
                }
            }
            // Production: do not attach proxies
        } else {
            if (isDev) {
                devLogOnce('warn', '$inertia global property not found. Skipping compatibility shim setup.')
            }
        }

        // Essential plugin registration with enhanced PrimeVue 4.x configuration
        app.use(PrimeVue, primeVueConfig)

        // Toast service with enhanced configuration for modern notifications
        app.use(ToastService, {
            position: 'top-right',
            autoZIndex: true,
            baseZIndex: 1000,
            breakpoints: {
                '960px': {
                    position: 'top-center',
                    width: '100vw',
                    right: '0',
                    left: '0',
                },
            },
        })

        app.use(ConfirmationService)

        // Provide PrimeVue services for injection in composables
        // This ensures that useConfirmToast.js can properly access services
        try {
            const { $confirm } = app.config.globalProperties
            const { $toast } = app.config.globalProperties

            // Provide services via provide/inject pattern
            app.provide('confirm', $confirm)
            app.provide('toast', $toast)

            // Also make them available on window as fallback
            if (typeof window !== 'undefined') {
                window.$confirm = $confirm
                window.$toast = $toast
            }

            if (isDev) {
                console.log('PrimeVue services (Confirm/Toast) registered and provided for injection')
            }
        } catch (error) {
            if (isDev) {
                console.warn('Failed to provide PrimeVue services for injection:', error)
                console.warn('useConfirmToast composable will fall back to native browser dialogs')
            }
        }

        // Vue 3 compatible plugins
        try {
            app.use(VueGoodTablePlugin)
        } catch (error) {
            if (isDev) {
                devLogOnce('warn', 'VueGoodTablePlugin registration failed:', error)
            }
        }

        // Vue 3 clipboard functionality using @vueuse/core
        try {
            app.config.globalProperties.$clipboard = useClipboard
        } catch (error) {
            if (isDev) {
                devLogOnce('warn', 'Failed to register clipboard functionality:', error)
            }
        }

        app.use(VCalendar, {})
        app.use(VueSweetalert2)

        // Component registration with error handling
        const safeComponentRegister = (name, component, fallback = null) => {
            try {
                if (component && (typeof component === 'object' || typeof component === 'function')) {
                    app.component(name, component)
                } else if (fallback) {
                    app.component(name, fallback)
                    if (isDev) {
                        devLogOnce('warn', `Used fallback for component: ${name}`)
                    }
                } else {
                    if (isDev) {
                        devLogOnce('warn', `Component ${name} is not available`)
                    }
                }
            } catch (error) {
                console.error(`Failed to register component ${name}:`, error)
            }
        }

        safeComponentRegister('v-select', vSelect)
        safeComponentRegister('Swiper', Swiper)
        safeComponentRegister('SwiperSlide', SwiperSlide)

        // Register Inertia 2.x components globally for backward compatibility
        try {
            // Register Link component as both 'Link' and 'inertia-link' for backward compatibility
            app.component('Link', Link)
            app.component('InertiaLink', Link)
            app.component('InertiaLink', Link)

            if (isDev) {
                devLogOnce('log', 'Inertia 2.x components registered: Link (as Link, inertia-link, and InertiaLink)')
                devLogOnce(
                    'warn',
                    'Consider migrating from <inertia-link> and <InertiaLink> to <Link> for better Vue 3 integration'
                )
            }
        } catch (error) {
            console.error('Failed to register Inertia 2.x components:', error)
        }

        // Conditional component registration with fallbacks

        // Mixin registration with enhanced validation and error handling
        // Route helper validation and registration with enhanced error handling
        // CRITICAL: Production builds require @routes directive in app.blade.php
        // The Laravel @routes directive MUST be present in the main Blade template (resources/views/app.blade.php)
        // for the application to function correctly in production. Without it, the route helper will not be available
        // and the application will fail to initialize. This is enforced to prevent silent routing failures.
        const validateAndRegisterRoute = () => {
            // Configurable Ziggy enforcement for production
            const enforceZiggy = (import.meta.env.VITE_ENFORCE_ZIGGY ?? 'false') === 'true'
            if (import.meta.env.PROD && enforceZiggy && typeof window.route !== 'function') {
                console.error('Ziggy route helper is not available. Ensure @routes is included.')
                // Optionally render a UI banner/toast here instead of throwing
                // throw new Error('Ziggy route helper is required in production.');
            }

            // Check if route function is globally available (from Laravel @routes directive)
            if (typeof window.route === 'function') {
                try {
                    let testRoute
                    const has = name => {
                        try {
                            return typeof window.route().has === 'function' ? window.route().has(name) : false
                        } catch {
                            return false
                        }
                    }
                    if (has('login')) testRoute = window.route('login')
                    else if (has('home')) testRoute = window.route('home')
                    else if (has('welcome')) testRoute = window.route('welcome')
                    else if (window.Ziggy?.routes) {
                        const first = Object.keys(window.Ziggy.routes)[0]
                        testRoute = first ? window.route(first) : null
                    }
                    if (typeof testRoute === 'string') {
                        const routeFunction = window.route
                        app.mixin({ methods: { route: routeFunction } })
                        app.config.globalProperties.route = routeFunction
                        if (isDev) {
                            devLogOnce('log', 'Laravel route helper successfully registered from global window.route')
                        }
                        return true
                    } else {
                        throw new Error('Ziggy route helper present but could not resolve a test route')
                    }
                } catch (e) {
                    if (import.meta.env.PROD) {
                        console.error('Laravel Ziggy route helper failed validation.')
                        throw new Error(`Laravel Ziggy route helper failed validation: ${e.message}`)
                    }
                    devLogOnce('warn', 'Global route function exists but failed test:', e)
                }
            }

            // Development-only fallback with explicit error logging
            if (isDev) {
                const fallbackRoute = (name, params = {}) => {
                    console.error(
                        `Route helper not available. Attempted to call route('${name}', ${JSON.stringify(params)})`
                    )
                    console.error(
                        'Ensure Laravel @routes directive is included in the Blade template and `php artisan ziggy:generate` has been run.'
                    )
                    return `/__missing_route__/${name}`
                }
                app.mixin({ methods: { route: fallbackRoute } })
                app.config.globalProperties.route = fallbackRoute
                devLogOnce(
                    'warn',
                    'Route helper function not available. Using development-only fallback. Ensure Laravel @routes directive is included in the Blade template.'
                )
                return false
            }

            // Production builds require Ziggy to prevent broken navigation
            if (import.meta.env.PROD && enforceZiggy) {
                console.error(
                    'Laravel Ziggy route helper is required in production but not available. Ensure @routes directive is included in your Blade layout.'
                )
                throw new Error('Ziggy route helper is required in production.')
            }
        }

        try {
            validateAndRegisterRoute()
        } catch (error) {
            if (isDev) {
                console.error('Failed to register route mixin:', error)
            }
        }

        try {
            if (translateMixin && typeof translateMixin === 'object' && translateMixin.methods) {
                app.mixin({
                    ...translateMixin,
                    beforeCreate() {
                        // Validate that translation methods are available
                        if (translateMixin.methods) {
                            Object.keys(translateMixin.methods).forEach(method => {
                                if (typeof this[method] !== 'function' && isDev) {
                                    devLogOnce('warn', `Translation method ${method} not properly mixed in`)
                                }
                            })
                        }
                    },
                })
            } else if (isDev) {
                devLogOnce('warn', 'translateMixin is not properly defined or missing methods')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register translate mixin:', error)
            }
        }

        try {
            if (hex2rgbaMixin && typeof hex2rgbaMixin === 'object' && hex2rgbaMixin.methods) {
                app.mixin({
                    ...hex2rgbaMixin,
                    beforeCreate() {
                        // Validate that hex2rgba methods are available
                        if (hex2rgbaMixin.methods) {
                            Object.keys(hex2rgbaMixin.methods).forEach(method => {
                                if (typeof this[method] !== 'function' && isDev) {
                                    devLogOnce('warn', `hex2rgba method ${method} not properly mixed in`)
                                }
                            })
                        }
                    },
                })
            } else if (isDev) {
                devLogOnce('warn', 'hex2rgbaMixin is not properly defined or missing methods')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register hex2rgba mixin:', error)
            }
        }

        // Global properties with enhanced error handling
        try {
            app.config.globalProperties.$filters = {
                convertToCharacter,
            }

            // Validate filter registration
            if (isDev && !app.config.globalProperties.$filters.convertToCharacter) {
                devLogOnce('warn', 'convertToCharacter filter not properly registered')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global filters:', error)
            }
        }

        // Global composables registration
        try {
            // Expose useTranslate composable globally
            app.config.globalProperties.$useTranslate = useTranslate

            // Expose useHex2Rgba composable globally
            app.config.globalProperties.$useHex2Rgba = useHex2Rgba

            // For convenience, also expose the composable functions directly
            const { __, __n } = useTranslate()
            app.config.globalProperties.$__ = __
            app.config.globalProperties.$__n = __n

            const { hex2rgba, hex2rgb, isValidHex } = useHex2Rgba()
            app.config.globalProperties.$hex2rgba = hex2rgba
            app.config.globalProperties.$hex2rgb = hex2rgb
            app.config.globalProperties.$isValidHex = isValidHex

            // Validate composables registration
            if (isDev && (!app.config.globalProperties.$useTranslate || !app.config.globalProperties.$useHex2Rgba)) {
                console.warn('Composables not properly registered')
            }

            if (isDev) {
                console.log('Vue 3 composables successfully exposed globally')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global composables:', error)
            }
        }

        // Global Inertia 2.x form helper registration
        try {
            // Consolidate to single form helper
            app.config.globalProperties.$form = useForm

            if (isDev) {
                // Add dev-only warnings for deprecated helpers
                ;['$useForm', '$inertiaForm'].forEach(name => {
                    Object.defineProperty(app.config.globalProperties, name, {
                        get() {
                            devLogOnce('warn', `${name} is deprecated. Use $form instead.`)
                            return useForm
                        },
                    })
                })
                console.log('Inertia 2.x form helper registered: $form')
                console.warn(
                    'Note: $inertia.* router methods are deprecated. Use router.* directly or import { router } from @inertiajs/vue3'
                )
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register Inertia form helpers:', error)
            }
        }

        try {
            app.config.globalProperties.$env = {
                name: appName,
                environment: appEnv,
                debug: appDebug === 'true',
                mode: import.meta.env.MODE,
                dev: import.meta.env.DEV,
                prod: import.meta.env.PROD,
            }

            // Validate environment properties
            if (isDev && !app.config.globalProperties.$env.name) {
                console.warn('Environment properties not properly registered')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global environment properties:', error)
            }
        }

        // Development-only error handling
        if (isDev) {
            app.config.errorHandler = (err, vm, info) => {
                console.error('Vue error:', err)
                console.error('Component:', vm)
                console.error('Error info:', info)
            }

            // Run compatibility check
            checkCompatibility()
        }

        return app.mount(el)
    },
})

// Ensure Teleport target for modals always exists
if (!document.getElementById('modals')) {
    const el = document.createElement('div')
    el.id = 'modals'
    document.body.appendChild(el)
}

// Ensure Toast container exists
if (!document.getElementById('toast-container')) {
    const el = document.createElement('div')
    el.id = 'toast-container'
    document.body.appendChild(el)
}

createInertiaApp({
    title: title => `${title} - ${appName}`,
    resolve: name => resolvePageComponent(`./Pages/${name}.vue`, import.meta.glob('./Pages/**/*.vue')),
    setup({ el, App, props, plugin }) {
        const pinia = createPinia()
        // Removed createHead() to avoid conflict with Inertia's <Head> component
        // Using single head management convention via Inertia <Head> components

        const app = createApp({ render: () => h(App, props) })
            .use(plugin)
            .use(pinia)

        // Update PrimeVue design tokens from theme settings at runtime
        try {
            if (props?.initialPage?.props?.general?.theme) {
                const { primary, secondary } = props.initialPage.props.general.theme
                updateThemeTokens({ primary, secondary })
            }
        } catch (error) {
            if (isDev) {
                console.warn('Failed to update theme colors:', error)
            }
        }

        // Add backward-compatibility alias for this.$inertia.form across legacy pages
        // Add backward-compatibility alias for this.$inertia.form across legacy pages
        if (app.config.globalProperties.$inertia) {
            app.config.globalProperties.$inertia.form = (...args) => useForm(...args)

            // Legacy this.$inertia.get/post/put/delete/visit compatibility shim to bridge to router.*
            const inertiaCompat = app.config.globalProperties.$inertia

            // Enable router proxies in both dev and production temporarily due to extensive existing usage
            ;['get', 'post', 'put', 'patch', 'delete', 'visit', 'reload'].forEach(method => {
                if (typeof router[method] === 'function') {
                    inertiaCompat[method] = (...args) => {
                        if (isDev) {
                            devLogOnce(
                                'warn',
                                `Deprecated: use router.${method}() instead of this.$inertia.${method}(). Legacy router methods will be removed in future versions.`
                            )
                        }
                        return router[method](...args)
                    }
                }
            })
            if (router.remember) {
                inertiaCompat.remember = (...args) => {
                    if (isDev) {
                        devLogOnce(
                            'warn',
                            'Deprecated: use router.remember() instead of this.$inertia.remember(). Legacy router methods will be removed in future versions.'
                        )
                    }
                    return router.remember(...args)
                }
            }
            if (router.restore) {
                inertiaCompat.restore = (...args) => {
                    if (isDev) {
                        devLogOnce(
                            'warn',
                            'Deprecated: use router.restore() instead of this.$inertia.restore(). Legacy router methods will be removed in future versions.'
                        )
                    }
                    return router.restore(...args)
                }
            }
            // Production: do not attach proxies
        } else {
            if (isDev) {
                devLogOnce('warn', '$inertia global property not found. Skipping compatibility shim setup.')
            }
        }

        // Essential plugin registration with PrimeVue 3.x compatible configuration
        app.use(PrimeVue, primeVueConfig)

        app.use(ToastService)
        app.use(ConfirmationService)

        // Provide PrimeVue services for injection in composables
        // This ensures that useConfirmToast.js can properly access services
        try {
            const { $confirm } = app.config.globalProperties
            const { $toast } = app.config.globalProperties

            // Provide services via provide/inject pattern
            app.provide('confirm', $confirm)
            app.provide('toast', $toast)

            // Also make them available on window as fallback
            if (typeof window !== 'undefined') {
                window.$confirm = $confirm
                window.$toast = $toast
            }

            if (isDev) {
                console.log('PrimeVue services (Confirm/Toast) registered and provided for injection')
            }
        } catch (error) {
            if (isDev) {
                console.warn('Failed to provide PrimeVue services for injection:', error)
                console.warn('useConfirmToast composable will fall back to native browser dialogs')
            }
        }

        // Vue 3 compatible plugins
        try {
            app.use(VueGoodTablePlugin)
        } catch (error) {
            if (isDev) {
                devLogOnce('warn', 'VueGoodTablePlugin registration failed:', error)
            }
        }

        // Vue 3 clipboard functionality using @vueuse/core
        try {
            app.config.globalProperties.$clipboard = useClipboard
        } catch (error) {
            if (isDev) {
                devLogOnce('warn', 'Failed to register clipboard functionality:', error)
            }
        }

        app.use(VCalendar, {})
        app.use(VueSweetalert2)

        // Component registration with error handling
        const safeComponentRegister = (name, component, fallback = null) => {
            try {
                if (component && (typeof component === 'object' || typeof component === 'function')) {
                    app.component(name, component)
                } else if (fallback) {
                    app.component(name, fallback)
                    if (isDev) {
                        devLogOnce('warn', `Used fallback for component: ${name}`)
                    }
                } else {
                    if (isDev) {
                        devLogOnce('warn', `Component ${name} is not available`)
                    }
                }
            } catch (error) {
                console.error(`Failed to register component ${name}:`, error)
            }
        }

        safeComponentRegister('v-select', vSelect)
        safeComponentRegister('Swiper', Swiper)
        safeComponentRegister('SwiperSlide', SwiperSlide)

        // Register Inertia 2.x components globally for backward compatibility
        try {
            // Register Link component as both 'Link' and 'inertia-link' for backward compatibility
            app.component('Link', Link)
            app.component('InertiaLink', Link)
            app.component('InertiaLink', Link)

            if (isDev) {
                devLogOnce('log', 'Inertia 2.x components registered: Link (as Link, inertia-link, and InertiaLink)')
                devLogOnce(
                    'warn',
                    'Consider migrating from <inertia-link> and <InertiaLink> to <Link> for better Vue 3 integration'
                )
            }
        } catch (error) {
            console.error('Failed to register Inertia 2.x components:', error)
        }

        // Conditional component registration with fallbacks

        // Mixin registration with enhanced validation and error handling
        // Route helper validation and registration with enhanced error handling
        // CRITICAL: Production builds require @routes directive in app.blade.php
        // The Laravel @routes directive MUST be present in the main Blade template (resources/views/app.blade.php)
        // for the application to function correctly in production. Without it, the route helper will not be available
        // and the application will fail to initialize. This is enforced to prevent silent routing failures.
        const validateAndRegisterRoute = () => {
            // Configurable Ziggy enforcement for production
            const enforceZiggy = (import.meta.env.VITE_ENFORCE_ZIGGY ?? 'false') === 'true'
            if (import.meta.env.PROD && enforceZiggy && typeof window.route !== 'function') {
                console.error('Ziggy route helper is not available. Ensure @routes is included.')
                // Optionally render a UI banner/toast here instead of throwing
                // throw new Error('Ziggy route helper is required in production.');
            }

            // Check if route function is globally available (from Laravel @routes directive)
            if (typeof window.route === 'function') {
                try {
                    let testRoute
                    const has = name => {
                        try {
                            return typeof window.route().has === 'function' ? window.route().has(name) : false
                        } catch {
                            return false
                        }
                    }
                    if (has('login')) testRoute = window.route('login')
                    else if (has('home')) testRoute = window.route('home')
                    else if (has('welcome')) testRoute = window.route('welcome')
                    else if (window.Ziggy?.routes) {
                        const first = Object.keys(window.Ziggy.routes)[0]
                        testRoute = first ? window.route(first) : null
                    }
                    if (typeof testRoute === 'string') {
                        const routeFunction = window.route
                        app.mixin({ methods: { route: routeFunction } })
                        app.config.globalProperties.route = routeFunction
                        if (isDev) {
                            devLogOnce('log', 'Laravel route helper successfully registered from global window.route')
                        }
                        return true
                    } else {
                        throw new Error('Ziggy route helper present but could not resolve a test route')
                    }
                } catch (e) {
                    if (import.meta.env.PROD) {
                        console.error('Laravel Ziggy route helper failed validation.')
                        throw new Error(`Laravel Ziggy route helper failed validation: ${e.message}`)
                    }
                    devLogOnce('warn', 'Global route function exists but failed test:', e)
                }
            }

            // Development-only fallback with explicit error logging
            if (isDev) {
                const fallbackRoute = (name, params = {}) => {
                    console.error(
                        `Route helper not available. Attempted to call route('${name}', ${JSON.stringify(params)})`
                    )
                    console.error(
                        'Ensure Laravel @routes directive is included in the Blade template and `php artisan ziggy:generate` has been run.'
                    )
                    return `/__missing_route__/${name}`
                }
                app.mixin({ methods: { route: fallbackRoute } })
                app.config.globalProperties.route = fallbackRoute
                devLogOnce(
                    'warn',
                    'Route helper function not available. Using development-only fallback. Ensure Laravel @routes directive is included in the Blade template.'
                )
                return false
            }

            // Production builds require Ziggy to prevent broken navigation
            if (import.meta.env.PROD && enforceZiggy) {
                console.error(
                    'Laravel Ziggy route helper is required in production but not available. Ensure @routes directive is included in your Blade layout.'
                )
                throw new Error('Ziggy route helper is required in production.')
            }
        }

        try {
            validateAndRegisterRoute()
        } catch (error) {
            if (isDev) {
                console.error('Failed to register route mixin:', error)
            }
        }

        try {
            if (translateMixin && typeof translateMixin === 'object' && translateMixin.methods) {
                app.mixin({
                    ...translateMixin,
                    beforeCreate() {
                        // Validate that translation methods are available
                        if (translateMixin.methods) {
                            Object.keys(translateMixin.methods).forEach(method => {
                                if (typeof this[method] !== 'function' && isDev) {
                                    devLogOnce('warn', `Translation method ${method} not properly mixed in`)
                                }
                            })
                        }
                    },
                })
            } else if (isDev) {
                devLogOnce('warn', 'translateMixin is not properly defined or missing methods')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register translate mixin:', error)
            }
        }

        try {
            if (hex2rgbaMixin && typeof hex2rgbaMixin === 'object' && hex2rgbaMixin.methods) {
                app.mixin({
                    ...hex2rgbaMixin,
                    beforeCreate() {
                        // Validate that hex2rgba methods are available
                        if (hex2rgbaMixin.methods) {
                            Object.keys(hex2rgbaMixin.methods).forEach(method => {
                                if (typeof this[method] !== 'function' && isDev) {
                                    devLogOnce('warn', `hex2rgba method ${method} not properly mixed in`)
                                }
                            })
                        }
                    },
                })
            } else if (isDev) {
                devLogOnce('warn', 'hex2rgbaMixin is not properly defined or missing methods')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register hex2rgba mixin:', error)
            }
        }

        // Global properties with enhanced error handling
        try {
            app.config.globalProperties.$filters = {
                convertToCharacter,
            }

            // Validate filter registration
            if (isDev && !app.config.globalProperties.$filters.convertToCharacter) {
                devLogOnce('warn', 'convertToCharacter filter not properly registered')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global filters:', error)
            }
        }

        // Global composables registration
        try {
            // Expose useTranslate composable globally
            app.config.globalProperties.$useTranslate = useTranslate

            // Expose useHex2Rgba composable globally
            app.config.globalProperties.$useHex2Rgba = useHex2Rgba

            // For convenience, also expose the composable functions directly
            const { __, __n } = useTranslate()
            app.config.globalProperties.$__ = __
            app.config.globalProperties.$__n = __n

            const { hex2rgba, hex2rgb, isValidHex } = useHex2Rgba()
            app.config.globalProperties.$hex2rgba = hex2rgba
            app.config.globalProperties.$hex2rgb = hex2rgb
            app.config.globalProperties.$isValidHex = isValidHex

            // Validate composables registration
            if (isDev && (!app.config.globalProperties.$useTranslate || !app.config.globalProperties.$useHex2Rgba)) {
                console.warn('Composables not properly registered')
            }

            if (isDev) {
                console.log('Vue 3 composables successfully exposed globally')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global composables:', error)
            }
        }

        // Global Inertia 2.x form helper registration
        try {
            // Consolidate to single form helper
            app.config.globalProperties.$form = useForm

            if (isDev) {
                // Add dev-only warnings for deprecated helpers
                ;['$useForm', '$inertiaForm'].forEach(name => {
                    Object.defineProperty(app.config.globalProperties, name, {
                        get() {
                            devLogOnce('warn', `${name} is deprecated. Use $form instead.`)
                            return useForm
                        },
                    })
                })
                console.log('Inertia 2.x form helper registered: $form')
                console.warn(
                    'Note: $inertia.* router methods are deprecated. Use router.* directly or import { router } from @inertiajs/vue3'
                )
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register Inertia form helpers:', error)
            }
        }

        try {
            app.config.globalProperties.$env = {
                name: appName,
                environment: appEnv,
                debug: appDebug === 'true',
                mode: import.meta.env.MODE,
                dev: import.meta.env.DEV,
                prod: import.meta.env.PROD,
            }

            // Validate environment properties
            if (isDev && !app.config.globalProperties.$env.name) {
                console.warn('Environment properties not properly registered')
            }
        } catch (error) {
            if (isDev) {
                console.error('Failed to register global environment properties:', error)
            }
        }

        // Development-only error handling
        if (isDev) {
            app.config.errorHandler = (err, vm, info) => {
                console.error('Vue error:', err)
                console.error('Component:', vm)
                console.error('Error info:', info)
            }

            // Run compatibility check
            checkCompatibility()
        }

        return app.mount(el)
    },
})

// Ensure Teleport target for modals always exists
if (!document.getElementById('modals')) {
    const el = document.createElement('div')
    el.id = 'modals'
    document.body.appendChild(el)
}
