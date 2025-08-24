/**
 * Modern Design Helpers for QwikTest E-Learning Platform
 * Utility functions for modern design patterns including animations, themes, 
 * responsive design, and contemporary UI interactions
 */

/**
 * Animation and Transition Utilities
 */
export const animations = {
    // Easing functions for smooth animations
    easing: {
        easeInOut: 'cubic-bezier(0.4, 0, 0.2, 1)',
        easeOut: 'cubic-bezier(0, 0, 0.2, 1)',
        easeIn: 'cubic-bezier(0.4, 0, 1, 1)',
        bounce: 'cubic-bezier(0.68, -0.55, 0.265, 1.55)',
        elastic: 'cubic-bezier(0.175, 0.885, 0.32, 1.275)'
    },

    // Duration constants
    duration: {
        fast: '150ms',
        normal: '300ms',
        slow: '500ms',
        slower: '750ms'
    },

    // Common animation classes
    classes: {
        fadeIn: 'animate-fade-in',
        fadeOut: 'animate-fade-out',
        slideUp: 'animate-slide-up',
        slideDown: 'animate-slide-down',
        scaleIn: 'animate-scale-in',
        bounce: 'animate-bounce-in',
        pulse: 'animate-pulse-gentle'
    },

    // Create custom animation styles
    createTransition: (property = 'all', duration = '300ms', easing = 'cubic-bezier(0.4, 0, 0.2, 1)') => {
        return `transition: ${property} ${duration} ${easing};`
    },

    // Stagger animation delays for lists
    getStaggerDelay: (index, baseDelay = 100) => {
        return `${index * baseDelay}ms`
    }
}

/**
 * Theme and Color Utilities
 */
export const theme = {
    // Modern color palette
    colors: {
        primary: {
            50: '#f0f9ff',
            100: '#e0f2fe',
            200: '#bae6fd',
            300: '#7dd3fc',
            400: '#38bdf8',
            500: '#0ea5e9',
            600: '#0284c7',
            700: '#0369a1',
            800: '#075985',
            900: '#0c4a6e'
        },
        secondary: {
            50: '#fdf4ff',
            100: '#fae8ff',
            200: '#f5d0fe',
            300: '#f0abfc',
            400: '#e879f9',
            500: '#d946ef',
            600: '#c026d3',
            700: '#a21caf',
            800: '#86198f',
            900: '#701a75'
        },
        success: {
            50: '#f0fdf4',
            500: '#22c55e',
            600: '#16a34a'
        },
        warning: {
            50: '#fffbeb',
            500: '#f59e0b',
            600: '#d97706'
        },
        error: {
            50: '#fef2f2',
            500: '#ef4444',
            600: '#dc2626'
        }
    },

    // Generate gradient backgrounds
    gradients: {
        primary: 'bg-gradient-to-br from-indigo-600 to-purple-600',
        secondary: 'bg-gradient-to-br from-purple-600 to-pink-600',
        success: 'bg-gradient-to-br from-green-500 to-emerald-600',
        warning: 'bg-gradient-to-br from-yellow-500 to-orange-600',
        error: 'bg-gradient-to-br from-red-500 to-rose-600',
        neutral: 'bg-gradient-to-br from-gray-100 to-gray-200',
        glass: 'bg-gradient-to-br from-white/20 to-white/10'
    },

    // Generate CSS custom properties for dynamic theming
    generateCSSVariables: (colors) => {
        let cssVars = ':root {\n'
        Object.entries(colors).forEach(([colorName, shades]) => {
            if (typeof shades === 'object') {
                Object.entries(shades).forEach(([shade, value]) => {
                    cssVars += `  --color-${colorName}-${shade}: ${value};\n`
                })
            } else {
                cssVars += `  --color-${colorName}: ${shades};\n`
            }
        })
        cssVars += '}'
        return cssVars
    },

    // Convert hex to RGB for transparency
    hexToRgb: (hex) => {
        const result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex)
        return result ? {
            r: parseInt(result[1], 16),
            g: parseInt(result[2], 16),
            b: parseInt(result[3], 16)
        } : null
    },

    // Create rgba color with opacity
    withOpacity: (hex, opacity) => {
        const rgb = theme.hexToRgb(hex)
        return rgb ? `rgba(${rgb.r}, ${rgb.g}, ${rgb.b}, ${opacity})` : hex
    }
}

/**
 * Responsive Design Utilities
 */
export const responsive = {
    // Breakpoints matching Tailwind CSS
    breakpoints: {
        sm: '640px',
        md: '768px',
        lg: '1024px',
        xl: '1280px',
        '2xl': '1536px'
    },

    // Media query helpers
    mediaQueries: {
        mobile: '(max-width: 767px)',
        tablet: '(min-width: 768px) and (max-width: 1023px)',
        desktop: '(min-width: 1024px)',
        touch: '(hover: none) and (pointer: coarse)',
        mouse: '(hover: hover) and (pointer: fine)'
    },

    // Check if device is mobile
    isMobile: () => {
        return window.matchMedia(responsive.mediaQueries.mobile).matches
    },

    // Check if device supports touch
    isTouch: () => {
        return window.matchMedia(responsive.mediaQueries.touch).matches
    },

    // Get current breakpoint
    getCurrentBreakpoint: () => {
        const width = window.innerWidth
        if (width < 640) return 'xs'
        if (width < 768) return 'sm'
        if (width < 1024) return 'md'
        if (width < 1280) return 'lg'
        if (width < 1536) return 'xl'
        return '2xl'
    }
}

/**
 * Modern UI Component Helpers
 */
export const components = {
    // Card component classes
    card: {
        base: 'bg-white rounded-2xl shadow-xl border border-gray-100',
        hover: 'hover:shadow-2xl hover:-translate-y-1 transition-all duration-300',
        glass: 'backdrop-blur-lg bg-white/80 border border-white/20',
        gradient: 'bg-gradient-to-br from-white to-gray-50'
    },

    // Button component classes
    button: {
        base: 'inline-flex items-center justify-center rounded-lg font-medium transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-offset-2',
        sizes: {
            sm: 'px-3 py-2 text-sm',
            md: 'px-4 py-2.5 text-sm',
            lg: 'px-6 py-3 text-base',
            xl: 'px-8 py-4 text-lg'
        },
        variants: {
            primary: 'bg-gradient-to-r from-indigo-600 to-purple-600 text-white hover:from-indigo-700 hover:to-purple-700 focus:ring-indigo-500',
            secondary: 'bg-gray-100 text-gray-900 hover:bg-gray-200 focus:ring-gray-500',
            outline: 'border-2 border-indigo-600 text-indigo-600 hover:bg-indigo-600 hover:text-white focus:ring-indigo-500',
            ghost: 'text-gray-600 hover:bg-gray-100 hover:text-gray-900 focus:ring-gray-500'
        }
    },

    // Input component classes
    input: {
        base: 'block w-full rounded-lg border-gray-300 shadow-sm focus:border-indigo-500 focus:ring-indigo-500 transition-colors duration-200',
        error: 'border-red-300 focus:border-red-500 focus:ring-red-500',
        success: 'border-green-300 focus:border-green-500 focus:ring-green-500'
    },

    // Modal component classes
    modal: {
        overlay: 'fixed inset-0 bg-black/50 backdrop-blur-sm z-50',
        container: 'fixed inset-0 z-50 flex items-center justify-center p-4',
        content: 'bg-white rounded-2xl shadow-2xl max-w-md w-full max-h-[90vh] overflow-auto'
    }
}

/**
 * Animation and Interaction Helpers
 */
export const interactions = {
    // Smooth scroll to element
    scrollToElement: (elementId, offset = 0) => {
        const element = document.getElementById(elementId)
        if (element) {
            const elementPosition = element.getBoundingClientRect().top + window.pageYOffset
            window.scrollTo({
                top: elementPosition - offset,
                behavior: 'smooth'
            })
        }
    },

    // Copy text to clipboard with modern API
    copyToClipboard: async (text) => {
        try {
            await navigator.clipboard.writeText(text)
            return true
        } catch (err) {
            // Fallback for older browsers using DOM safety utilities
            const { createTemporaryElement } = await import('./domSafety')
            const tempElement = createTemporaryElement('textarea', {
                properties: { value: text }
            })
            
            if (tempElement.append()) {
                try {
                    tempElement.element.select()
                    document.execCommand('copy')
                    return true
                } finally {
                    tempElement.remove()
                }
            }
            return false
        }
    },

    // Debounce function for performance
    debounce: (func, wait) => {
        let timeout
        return function executedFunction(...args) {
            const later = () => {
                clearTimeout(timeout)
                func(...args)
            }
            clearTimeout(timeout)
            timeout = setTimeout(later, wait)
        }
    },

    // Throttle function for performance
    throttle: (func, limit) => {
        let inThrottle
        return function() {
            const args = arguments
            const context = this
            if (!inThrottle) {
                func.apply(context, args)
                inThrottle = true
                setTimeout(() => inThrottle = false, limit)
            }
        }
    },

    // Intersection Observer for animations
    observeIntersection: (elements, callback, options = {}) => {
        const defaultOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        }
        
        const observer = new IntersectionObserver(callback, { ...defaultOptions, ...options })
        
        if (Array.isArray(elements)) {
            elements.forEach(el => observer.observe(el))
        } else {
            observer.observe(elements)
        }
        
        return observer
    }
}

/**
 * Accessibility Helpers
 */
export const accessibility = {
    // Focus management
    trapFocus: (element) => {
        const focusableElements = element.querySelectorAll(
            'button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])'
        )
        const firstElement = focusableElements[0]
        const lastElement = focusableElements[focusableElements.length - 1]

        const handleTabKey = (e) => {
            if (e.key === 'Tab') {
                if (e.shiftKey) {
                    if (document.activeElement === firstElement) {
                        lastElement.focus()
                        e.preventDefault()
                    }
                } else {
                    if (document.activeElement === lastElement) {
                        firstElement.focus()
                        e.preventDefault()
                    }
                }
            }
        }

        element.addEventListener('keydown', handleTabKey)
        firstElement.focus()

        return () => element.removeEventListener('keydown', handleTabKey)
    },

    // Announce to screen readers
    announce: (message, priority = 'polite') => {
        const announcer = document.createElement('div')
        announcer.setAttribute('aria-live', priority)
        announcer.setAttribute('aria-atomic', 'true')
        announcer.className = 'sr-only'
        document.body.appendChild(announcer)
        
        setTimeout(() => {
            if (announcer.parentNode) {
                announcer.textContent = message
                setTimeout(() => {
                    if (announcer.parentNode === document.body) {
                        document.body.removeChild(announcer)
                    }
                }, 1000)
            }
        }, 100)
    }
}

/**
 * Performance Utilities
 */
export const performance = {
    // Lazy load images
    lazyLoadImages: (selector = 'img[data-src]') => {
        const images = document.querySelectorAll(selector)
        
        const imageObserver = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    const img = entry.target
                    img.src = img.dataset.src
                    img.classList.remove('lazy')
                    imageObserver.unobserve(img)
                }
            })
        })
        
        images.forEach(img => imageObserver.observe(img))
    },

    // Preload critical resources
    preloadResource: (href, as = 'script') => {
        const link = document.createElement('link')
        link.rel = 'preload'
        link.href = href
        link.as = as
        document.head.appendChild(link)
    },

    // Measure performance
    measurePerformance: (name, fn) => {
        const start = performance.now()
        const result = fn()
        const end = performance.now()
        console.log(`${name} took ${end - start} milliseconds`)
        return result
    }
}

/**
 * Form Enhancement Utilities
 */
export const forms = {
    // Auto-resize textarea
    autoResizeTextarea: (textarea) => {
        const resize = () => {
            textarea.style.height = 'auto'
            textarea.style.height = textarea.scrollHeight + 'px'
        }
        
        textarea.addEventListener('input', resize)
        resize() // Initial resize
        
        return () => textarea.removeEventListener('input', resize)
    },

    // Format input values
    formatters: {
        phone: (value) => {
            const cleaned = value.replace(/\D/g, '')
            const match = cleaned.match(/^(\d{3})(\d{3})(\d{4})$/)
            return match ? `(${match[1]}) ${match[2]}-${match[3]}` : value
        },
        
        currency: (value) => {
            const number = parseFloat(value.replace(/[^\d.-]/g, ''))
            return isNaN(number) ? '' : new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD'
            }).format(number)
        }
    }
}

// Export all utilities as default
export default {
    animations,
    theme,
    responsive,
    components,
    interactions,
    accessibility,
    performance,
    forms
}