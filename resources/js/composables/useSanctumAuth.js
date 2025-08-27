/**
 * Sanctum Authentication Composable
 * Handles SPA authentication with Laravel Sanctum
 */

import { ref, computed } from 'vue'
import { router } from '@inertiajs/vue3'
import axios from 'axios'

// Global authentication state
const isAuthenticated = ref(false)
const user = ref(null)
const isLoading = ref(false)

export function useSanctumAuth() {
    /**
     * Initialize CSRF cookie for Sanctum
     */
    const initializeCsrf = async () => {
        try {
            await axios.get('/sanctum/csrf-cookie')
        } catch (error) {
            console.error('Failed to initialize CSRF cookie:', error)
            throw error
        }
    }

    /**
     * Login with Sanctum
     */
    const login = async (credentials) => {
        isLoading.value = true
        
        try {
            // Initialize CSRF cookie first
            await initializeCsrf()
            
            // Attempt login via Inertia (maintains session-based auth)
            return new Promise((resolve, reject) => {
                router.post('/login', credentials, {
                    onSuccess: (page) => {
                        isAuthenticated.value = true
                        user.value = page.props.auth?.user || null
                        resolve(page)
                    },
                    onError: (errors) => {
                        reject(errors)
                    },
                    onFinish: () => {
                        isLoading.value = false
                    }
                })
            })
        } catch (error) {
            isLoading.value = false
            throw error
        }
    }

    /**
     * Logout with Sanctum
     */
    const logout = async () => {
        isLoading.value = true
        
        try {
            return new Promise((resolve, reject) => {
                router.post('/logout', {}, {
                    onSuccess: () => {
                        isAuthenticated.value = false
                        user.value = null
                        resolve()
                    },
                    onError: (errors) => {
                        reject(errors)
                    },
                    onFinish: () => {
                        isLoading.value = false
                    }
                })
            })
        } catch (error) {
            isLoading.value = false
            throw error
        }
    }

    /**
     * Register with Sanctum
     */
    const register = async (userData) => {
        isLoading.value = true
        
        try {
            // Initialize CSRF cookie first
            await initializeCsrf()
            
            return new Promise((resolve, reject) => {
                router.post('/register', userData, {
                    onSuccess: (page) => {
                        isAuthenticated.value = true
                        user.value = page.props.auth?.user || null
                        resolve(page)
                    },
                    onError: (errors) => {
                        reject(errors)
                    },
                    onFinish: () => {
                        isLoading.value = false
                    }
                })
            })
        } catch (error) {
            isLoading.value = false
            throw error
        }
    }

    /**
     * Get current user via API
     */
    const getCurrentUser = async () => {
        try {
            const response = await axios.get('/api/user')
            user.value = response.data
            isAuthenticated.value = true
            return response.data
        } catch (error) {
            if (error.response?.status === 401) {
                isAuthenticated.value = false
                user.value = null
            }
            throw error
        }
    }

    /**
     * Check if user is authenticated
     */
    const checkAuth = async () => {
        try {
            await getCurrentUser()
            return true
        } catch (error) {
            return false
        }
    }

    /**
     * Update authentication state from Inertia page props
     */
    const updateAuthState = (pageProps) => {
        if (pageProps.auth?.user) {
            isAuthenticated.value = true
            user.value = pageProps.auth.user
        } else {
            isAuthenticated.value = false
            user.value = null
        }
    }

    /**
     * Make authenticated API request
     */
    const apiRequest = async (method, url, data = null, config = {}) => {
        try {
            const response = await axios({
                method,
                url,
                data,
                ...config
            })
            return response
        } catch (error) {
            if (error.response?.status === 401) {
                isAuthenticated.value = false
                user.value = null
                // Redirect to login if not already there
                if (window.location.pathname !== '/login') {
                    router.visit('/login')
                }
            }
            throw error
        }
    }

    // Computed properties
    const isGuest = computed(() => !isAuthenticated.value)
    const hasUser = computed(() => !!user.value)
    const userRole = computed(() => user.value?.role || null)
    const userRoles = computed(() => user.value?.roles || [])

    return {
        // State
        isAuthenticated: computed(() => isAuthenticated.value),
        user: computed(() => user.value),
        isLoading: computed(() => isLoading.value),
        isGuest,
        hasUser,
        userRole,
        userRoles,
        
        // Methods
        login,
        logout,
        register,
        getCurrentUser,
        checkAuth,
        updateAuthState,
        apiRequest,
        initializeCsrf
    }
}

// Export singleton instance for global state management
export const sanctumAuth = useSanctumAuth()

// Auto-update auth state on Inertia page visits
if (typeof window !== 'undefined') {
    router.on('success', (event) => {
        if (event.detail.page.props) {
            sanctumAuth.updateAuthState(event.detail.page.props)
        }
    })
}