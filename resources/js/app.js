import './bootstrap'

// Core application modules
import { createInertiaApplication, APP_CONFIG } from './core/app-core'
import logger from './services/logger'
import { performanceMonitor } from './utils/performance-monitor'

// Import essential modules for enhanced functionality
import { Link, useForm } from '@inertiajs/vue3'
import NProgress from 'nprogress'
import { router } from '@inertiajs/vue3'
import PrimeVue from 'primevue/config'
import ToastService from 'primevue/toastservice'

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
import hex2rgbaMixin from './Mixins/hex2rgba'
import { useTranslate } from './composables/useTranslate'
import { useHex2Rgba } from './composables/useHex2Rgba'
import { sanctumAuth } from './composables/useSanctumAuth'

// Import modern CSS for enhanced components
import 'primeicons/primeicons.css'

// Production-safe logging system
const logOnce = (level, message, ...args) => {
    logger[level](message, { args, source: 'app.js' })
}

// Environment configuration - single source of truth
const isDev = import.meta.env.DEV
const isProd = import.meta.env.PROD

const devLogOnce = (() => {
    const seen = new Set()
    return (level, message, ...args) => {
        if (!isDev) return
        const key = `${level}:${message}`
        if (seen.has(key)) return
        seen.add(key)

        if (typeof logger?.[level] === 'function') {
            logger[level](message, { args, source: 'app.js', once: true })
        } else {
            // Fallback to console in case logger is unavailable
            console[level] ? console[level](message, ...args) : console.log(message, ...args)
        }
    }
})()

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

// Force HTTP protocol for localhost development to prevent HTTPS redirects
if (window.location.hostname === 'localhost' && window.location.protocol === 'https:') {
    window.location.protocol = 'http:'
}

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

// Initialize Sanctum authentication state
if (typeof window !== 'undefined') {
    // Make Sanctum auth globally available
    window.sanctumAuth = sanctumAuth
    
    // Initialize authentication state on app load
    router.on('start', () => {
        // Update auth state from page props when navigating
        const currentPage = router.page
        if (currentPage?.props) {
            sanctumAuth.updateAuthState(currentPage.props)
        }
    })
}

// Initialize the application using the optimized core function
// Wrap in DOMContentLoaded to prevent DOM timing issues
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', () => {
        createInertiaApplication()
    })
} else {
    // DOM is already loaded
    createInertiaApplication()
}

// Initialize performance monitoring and utilities
logger.startPerformanceTimer('app-post-initialization')

// Make performance monitor globally available
if (typeof window !== 'undefined') {
    window.logger = logger
    window.performanceMonitor = performanceMonitor
}

logger.endPerformanceTimer('app-post-initialization')

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
