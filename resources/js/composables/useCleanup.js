import { ref, readonly, onUnmounted } from 'vue'

/**
 * Memory leak prevention utilities for Vue 3 components
 * Automatically cleans up event listeners, timers, and network requests
 */
export function useCleanup() {
    // Track cleanup functions
    const cleanupFunctions = ref([])

    // Track event listeners
    const eventListeners = ref([])

    // Track timers
    const timers = ref([])

    // Track abort controllers
    const abortControllers = ref([])

    /**
     * Register a cleanup function to be called on unmount
     */
    const addCleanup = cleanupFn => {
        if (typeof cleanupFn === 'function') {
            cleanupFunctions.value.push(cleanupFn)
        }
    }

    /**
     * Add event listener with automatic cleanup
     */
    const addEventListener = (target, event, handler, options = {}) => {
        target.addEventListener(event, handler, options)

        const cleanup = () => {
            target.removeEventListener(event, handler, options)
        }

        eventListeners.value.push(cleanup)
        addCleanup(cleanup)

        return cleanup
    }

    /**
     * Set timeout with automatic cleanup
     */
    const setTimeout = (callback, delay) => {
        const timeoutId = window.setTimeout(callback, delay)

        const cleanup = () => {
            clearTimeout(timeoutId)
        }

        timers.value.push(cleanup)
        addCleanup(cleanup)

        return timeoutId
    }

    /**
     * Set interval with automatic cleanup
     */
    const setInterval = (callback, delay) => {
        const intervalId = window.setInterval(callback, delay)

        const cleanup = () => {
            clearInterval(intervalId)
        }

        timers.value.push(cleanup)
        addCleanup(cleanup)

        return intervalId
    }

    /**
     * Create abort controller with automatic cleanup
     */
    const createAbortController = () => {
        const controller = new AbortController()

        const cleanup = () => {
            if (!controller.signal.aborted) {
                controller.abort()
            }
        }

        abortControllers.value.push(cleanup)
        addCleanup(cleanup)

        return controller
    }

    /**
     * Create debounced function with automatic cleanup
     */
    const createDebouncer = (callback, delay) => {
        let timeoutId = null

        const debounced = (...args) => {
            if (timeoutId) {
                clearTimeout(timeoutId)
            }

            timeoutId = window.setTimeout(() => {
                callback.apply(this, args)
                timeoutId = null
            }, delay)
        }

        const cleanup = () => {
            if (timeoutId) {
                clearTimeout(timeoutId)
                timeoutId = null
            }
        }

        addCleanup(cleanup)

        // Return both the debounced function and cleanup
        return { debounced, cleanup }
    }

    /**
     * Create throttled function with automatic cleanup
     */
    const createThrottler = (callback, delay) => {
        let isThrottled = false
        let timeoutId = null

        const throttled = (...args) => {
            if (!isThrottled) {
                callback.apply(this, args)
                isThrottled = true

                timeoutId = window.setTimeout(() => {
                    isThrottled = false
                    timeoutId = null
                }, delay)
            }
        }

        const cleanup = () => {
            if (timeoutId) {
                clearTimeout(timeoutId)
                timeoutId = null
            }
            isThrottled = false
        }

        addCleanup(cleanup)

        return { throttled, cleanup }
    }

    /**
     * Register axios request with abort controller
     */
    const createAxiosRequest = axiosInstance => {
        const controller = createAbortController()

        // Return axios instance with signal
        return {
            axios: axiosInstance,
            signal: controller.signal,
            abort: () => controller.abort(),
        }
    }

    /**
     * Manually execute all cleanup functions
     */
    const executeCleanup = () => {
        // Execute all registered cleanup functions
        cleanupFunctions.value.forEach(cleanup => {
            try {
                cleanup()
            } catch (error) {
                console.warn('Cleanup function failed:', error)
            }
        })

        // Clear all arrays
        cleanupFunctions.value = []
        eventListeners.value = []
        timers.value = []
        abortControllers.value = []
    }

    /**
     * Get cleanup status for debugging
     */
    const getCleanupStatus = () => {
        return {
            cleanupFunctions: cleanupFunctions.value.length,
            eventListeners: eventListeners.value.length,
            timers: timers.value.length,
            abortControllers: abortControllers.value.length,
        }
    }

    // Automatically cleanup on component unmount
    onUnmounted(() => {
        executeCleanup()
    })

    return {
        // Registration methods
        addCleanup,

        // Enhanced utilities with cleanup
        addEventListener,
        setTimeout,
        setInterval,
        createAbortController,
        createDebouncer,
        createThrottler,
        createAxiosRequest,

        // Manual control
        executeCleanup,
        getCleanupStatus,
    }
}

/**
 * Enhanced search functionality with proper cleanup
 * Prevents memory leaks from search debouncing and network requests
 */
export function useSearchWithCleanup(searchFunction, options = {}) {
    const { debounceDelay = 600, minSearchLength = 2, onError = null, onLoading = null } = options

    const { createDebouncer, createAbortController } = useCleanup()

    // Track current search state
    const isSearching = ref(false)
    const searchResults = ref([])
    const searchError = ref(null)

    // Current abort controller
    let currentAbortController = null

    /**
     * Execute search with proper cleanup
     */
    const executeSearch = async query => {
        try {
            // Abort previous request
            if (currentAbortController) {
                currentAbortController.abort()
            }

            // Create new abort controller
            currentAbortController = createAbortController()

            isSearching.value = true
            searchError.value = null

            if (onLoading) onLoading(true)

            // Execute search function
            const results = await searchFunction(query, {
                signal: currentAbortController.signal,
            })

            searchResults.value = results
            currentAbortController = null
        } catch (error) {
            if (!error.name === 'AbortError') {
                searchError.value = error
                if (onError) onError(error)
            }
        } finally {
            isSearching.value = false
            if (onLoading) onLoading(false)
        }
    }

    // Create debounced search
    const { debounced: debouncedSearch } = createDebouncer(executeSearch, debounceDelay)

    /**
     * Public search method
     */
    const search = query => {
        if (!query || query.length < minSearchLength) {
            searchResults.value = []
            return
        }

        debouncedSearch(query)
    }

    /**
     * Clear search results
     */
    const clearSearch = () => {
        searchResults.value = []
        searchError.value = null
        isSearching.value = false

        // Abort any pending request
        if (currentAbortController) {
            currentAbortController.abort()
            currentAbortController = null
        }
    }

    return {
        // State
        isSearching: readonly(isSearching),
        searchResults: readonly(searchResults),
        searchError: readonly(searchError),

        // Methods
        search,
        clearSearch,
    }
}
