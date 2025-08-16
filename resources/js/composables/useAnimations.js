import { ref, onMounted, onUnmounted } from 'vue'

/**
 * Composable for managing modern animations and interactions
 */
export function useAnimations() {
    // Intersection Observer state
    const intersectionObserver = ref(null)
    const animatedElements = ref(new Set())

    /**
     * Initialize intersection observer for scroll-triggered animations
     */
    const initIntersectionObserver = () => {
        if (typeof window === 'undefined') return

        intersectionObserver.value = new IntersectionObserver(
            entries => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('animate-in-view')
                        animatedElements.value.add(entry.target)
                    }
                })
            },
            {
                threshold: 0.1,
                rootMargin: '0px 0px -50px 0px',
            }
        )
    }

    /**
     * Observe an element for scroll animations
     */
    const observeElement = element => {
        if (intersectionObserver.value && element) {
            intersectionObserver.value.observe(element)
        }
    }

    /**
     * Animate a number counter with easing
     */
    const animateCounter = (start = 0, end = 100, duration = 2000, callback = () => {}, easing = 'easeOutCubic') => {
        const startTime = performance.now()

        const easingFunctions = {
            linear: t => t,
            easeOutCubic: t => 1 - Math.pow(1 - t, 3),
            easeInOutCubic: t => (t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2),
            easeOutBounce: t => {
                const n1 = 7.5625
                const d1 = 2.75
                if (t < 1 / d1) {
                    return n1 * t * t
                } else if (t < 2 / d1) {
                    return n1 * (t -= 1.5 / d1) * t + 0.75
                } else if (t < 2.5 / d1) {
                    return n1 * (t -= 2.25 / d1) * t + 0.9375
                } else {
                    return n1 * (t -= 2.625 / d1) * t + 0.984375
                }
            },
        }

        const easeFn = easingFunctions[easing] || easingFunctions.easeOutCubic

        const animate = currentTime => {
            const elapsed = currentTime - startTime
            const progress = Math.min(elapsed / duration, 1)
            const easedProgress = easeFn(progress)

            const currentValue = start + (end - start) * easedProgress
            callback(Math.round(currentValue))

            if (progress < 1) {
                requestAnimationFrame(animate)
            }
        }

        requestAnimationFrame(animate)
    }

    /**
     * Animate multiple counters with staggered delays
     */
    const animateCounters = (counters = []) => {
        counters.forEach((counter, index) => {
            setTimeout(() => {
                animateCounter(
                    counter.start || 0,
                    counter.end,
                    counter.duration || 2000,
                    counter.callback,
                    counter.easing || 'easeOutCubic'
                )
            }, index * 200) // Stagger by 200ms
        })
    }

    /**
     * Smooth scroll to element
     */
    const smoothScrollTo = (target, offset = 0, duration = 1000) => {
        const element = typeof target === 'string' ? document.querySelector(target) : target

        if (!element) return

        const targetPosition = element.offsetTop - offset
        const startPosition = window.pageYOffset
        const distance = targetPosition - startPosition
        const startTime = performance.now()

        const easeInOutCubic = t => {
            return t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
        }

        const animate = currentTime => {
            const elapsed = currentTime - startTime
            const progress = Math.min(elapsed / duration, 1)
            const ease = easeInOutCubic(progress)

            window.scrollTo(0, startPosition + distance * ease)

            if (progress < 1) {
                requestAnimationFrame(animate)
            }
        }

        requestAnimationFrame(animate)
    }

    /**
     * Create staggered animation for child elements
     */
    const staggerChildren = (
        container,
        childSelector = ':scope > *',
        delay = 100,
        animationClass = 'animate-fade-in-up'
    ) => {
        if (!container) return

        const children = container.querySelectorAll(childSelector)

        children.forEach((child, index) => {
            setTimeout(() => {
                child.classList.add(animationClass)
            }, index * delay)
        })
    }

    /**
     * Add hover animations to elements
     */
    const addHoverAnimations = (elements, hoverClass = 'hover-lift') => {
        if (!Array.isArray(elements)) {
            elements = [elements]
        }

        elements.forEach(element => {
            if (!element) return

            element.addEventListener('mouseenter', () => {
                element.classList.add(hoverClass)
            })

            element.addEventListener('mouseleave', () => {
                element.classList.remove(hoverClass)
            })
        })
    }

    /**
     * Create parallax effect
     */
    const createParallax = (element, speed = 0.5) => {
        if (!element) return

        const handleScroll = () => {
            const scrolled = window.pageYOffset
            const parallax = scrolled * speed
            element.style.transform = `translateY(${parallax}px)`
        }

        window.addEventListener('scroll', handleScroll)

        return () => {
            window.removeEventListener('scroll', handleScroll)
        }
    }

    /**
     * Format number with commas
     */
    const formatNumber = num => {
        return num.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')
    }

    /**
     * Format percentage
     */
    const formatPercentage = (num, decimals = 1) => {
        return `${num.toFixed(decimals)}%`
    }

    // Lifecycle
    onMounted(() => {
        initIntersectionObserver()
    })

    onUnmounted(() => {
        if (intersectionObserver.value) {
            intersectionObserver.value.disconnect()
        }
    })

    return {
        // State
        animatedElements,

        // Methods
        observeElement,
        animateCounter,
        animateCounters,
        smoothScrollTo,
        staggerChildren,
        addHoverAnimations,
        createParallax,
        formatNumber,
        formatPercentage,

        // Utilities
        initIntersectionObserver,
    }
}

/**
 * Predefined animation configurations
 */
export const animationPresets = {
    counter: {
        duration: 2000,
        easing: 'easeOutCubic',
    },
    stagger: {
        delay: 100,
        animationClass: 'animate-fade-in-up',
    },
    parallax: {
        speed: 0.5,
    },
    hover: {
        hoverClass: 'hover-lift',
    },
}
