import { ref, reactive, computed } from 'vue'
import { router } from '@inertiajs/vue3'

/**
 * Auth debugging composable for demo mode
 * Provides utilities to debug authentication issues
 */
export function useAuthDebug() {
    const debugData = ref({})
    const isLoading = ref(false)
    const lastCheck = ref(null)

    /**
     * Test form credentials before submission
     */
    const testCredentials = async (email, password) => {
        if (!email || !password) {
            return {
                valid: false,
                message: 'Email and password are required'
            }
        }

        // Basic format validation
        const isEmailFormat = email.includes('@')
        const isUsernameFormat = /^[a-zA-Z0-9._-]{3,30}$/.test(email)

        if (!isEmailFormat && !isUsernameFormat) {
            return {
                valid: false,
                message: 'Invalid email or username format'
            }
        }

        if (password.length < 6) {
            return {
                valid: false,
                message: 'Password must be at least 6 characters'
            }
        }

        return {
            valid: true,
            message: 'Credentials format is valid'
        }
    }

    /**
     * Check available demo users (demo mode only)
     */
    const checkDemoUsers = async () => {
        isLoading.value = true
        
        try {
            const response = await fetch('/auth-debug/users', {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })

            const data = await response.json()
            
            if (data.success) {
                debugData.value.users = data.data
                lastCheck.value = new Date()
                return data.data
            } else {
                console.error('Failed to fetch demo users:', data.message)
                return null
            }
        } catch (error) {
            console.error('Error checking demo users:', error)
            return null
        } finally {
            isLoading.value = false
        }
    }

    /**
     * Check specific user status
     */
    const checkUserStatus = async (email) => {
        if (!email) return null

        isLoading.value = true

        try {
            const response = await fetch(`/auth-debug/user-status/${encodeURIComponent(email)}`, {
                method: 'GET',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                }
            })

            const data = await response.json()
            
            debugData.value.userStatus = data
            return data
        } catch (error) {
            console.error('Error checking user status:', error)
            return {
                success: false,
                message: 'Failed to check user status'
            }
        } finally {
            isLoading.value = false
        }
    }

    /**
     * Test password verification
     */
    const testPassword = async (email, password) => {
        if (!email || !password) return null

        isLoading.value = true

        try {
            const response = await fetch('/auth-debug/test-password', {
                method: 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                    'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]')?.getAttribute('content')
                },
                body: JSON.stringify({ email, password })
            })

            const data = await response.json()
            
            debugData.value.passwordTest = data
            return data
        } catch (error) {
            console.error('Error testing password:', error)
            return {
                success: false,
                message: 'Failed to test password'
            }
        } finally {
            isLoading.value = false
        }
    }

    /**
     * Validate form data comprehensively
     */
    const validateFormData = (formData) => {
        const errors = []
        const warnings = []

        // Email/Username validation
        if (!formData.email) {
            errors.push('Email or username is required')
        } else {
            const isEmail = formData.email.includes('@')
            if (isEmail) {
                const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
                if (!emailRegex.test(formData.email)) {
                    errors.push('Invalid email format')
                }
            } else {
                const usernameRegex = /^[a-zA-Z0-9._-]{3,30}$/
                if (!usernameRegex.test(formData.email)) {
                    errors.push('Invalid username format (3-30 chars, letters, numbers, ., _, - allowed)')
                }
            }
        }

        // Password validation
        if (!formData.password) {
            errors.push('Password is required')
        } else if (formData.password.length < 6) {
            errors.push('Password must be at least 6 characters')
        }

        // Demo mode warnings
        if (formData.email && formData.password) {
            const commonDemoCredentials = [
                { email: 'admin@qwiktest.com', password: 'password' },
                { email: 'instructor@qwiktest.com', password: 'password' },
                { email: 'student@qwiktest.com', password: 'password' }
            ]

            const matchesDemo = commonDemoCredentials.some(cred => 
                cred.email === formData.email && cred.password === formData.password
            )

            if (!matchesDemo && formData.email.includes('@qwiktest.com')) {
                warnings.push('Demo users typically use password: "password"')
            }
        }

        return {
            isValid: errors.length === 0,
            errors,
            warnings,
            summary: {
                errorCount: errors.length,
                warningCount: warnings.length
            }
        }
    }

    /**
     * Get debug information for current state
     */
    const getDebugInfo = computed(() => {
        return {
            debugData: debugData.value,
            isLoading: isLoading.value,
            lastCheck: lastCheck.value,
            hasUserData: !!debugData.value.users,
            hasStatusData: !!debugData.value.userStatus,
            hasPasswordTest: !!debugData.value.passwordTest
        }
    })

    /**
     * Reset debug data
     */
    const resetDebugData = () => {
        debugData.value = {}
        lastCheck.value = null
    }

    /**
     * Get demo credentials suggestions
     */
    const getDemoCredentials = () => {
        return [
            { role: 'Admin', email: 'admin@qwiktest.com', password: 'password' },
            { role: 'Instructor', email: 'instructor@qwiktest.com', password: 'password' },
            { role: 'Student', email: 'student@qwiktest.com', password: 'password' }
        ]
    }

    /**
     * Check if current environment is demo mode
     */
    const isDemoMode = computed(() => {
        return window.location.hostname.includes('demo') || 
               document.querySelector('meta[name="demo-mode"]')?.getAttribute('content') === 'true'
    })

    return {
        // State
        debugData,
        isLoading,
        lastCheck,

        // Computed
        getDebugInfo,
        isDemoMode,

        // Methods
        testCredentials,
        checkDemoUsers,
        checkUserStatus,
        testPassword,
        validateFormData,
        resetDebugData,
        getDemoCredentials
    }
}
