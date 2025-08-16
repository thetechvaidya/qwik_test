import { ref, computed, readonly, reactive } from 'vue'
import { useVuelidate } from '@vuelidate/core'
import { required, email, minLength, maxLength, sameAs, helpers } from '@vuelidate/validators'
import { useConfirmToast } from '@/composables/useConfirmToast'

/**
 * Custom password strength validator
 */
const strongPassword = value => {
    if (!value) return false

    const hasLowerCase = /[a-z]/.test(value)
    const hasUpperCase = /[A-Z]/.test(value)
    const hasNumbers = /\d/.test(value)
    const hasSpecialChar = /[!@#$%^&*(),.?":{}|<>]/.test(value)
    const hasMinLength = value.length >= 8

    return hasMinLength && hasLowerCase && hasUpperCase && hasNumbers && hasSpecialChar
}

/**
 * Enhanced form validation and submission handling with UX feedback
 * Provides submitStatus management, error handling, and user feedback
 */
export function useFormValidation(validator = null) {
    // Reactive state
    const submitStatus = ref('IDLE') // 'IDLE', 'PENDING', 'ERROR', 'OK'
    const validationErrors = ref([])
    const isSubmitting = ref(false)

    // Composables
    const { toast } = useConfirmToast()

    // Computed properties
    const hasValidationErrors = computed(() => validationErrors.value.length > 0)
    const canSubmit = computed(() => !isSubmitting.value && submitStatus.value !== 'PENDING')
    const showErrorFeedback = computed(() => submitStatus.value === 'ERROR')
    const showSuccessFeedback = computed(() => submitStatus.value === 'OK')

    /**
     * Validate form using provided validator (e.g., Vuelidate)
     */
    const validateForm = async () => {
        if (!validator) {
            return true // No validator provided, assume valid
        }

        try {
            // Trigger validation
            validator.$touch()

            // Check for validation errors
            if (validator.$invalid) {
                const errors = []

                // Collect all validation errors
                Object.keys(validator).forEach(field => {
                    if (field.startsWith('$')) return // Skip $-prefixed properties

                    const fieldValidator = validator[field]
                    if (fieldValidator && fieldValidator.$invalid) {
                        // Get error messages for this field
                        Object.keys(fieldValidator).forEach(rule => {
                            if (rule.startsWith('$')) return

                            const ruleValidator = fieldValidator[rule]
                            if (ruleValidator && !ruleValidator.$response) {
                                errors.push({
                                    field,
                                    rule,
                                    message: `${field} ${rule} validation failed`,
                                })
                            }
                        })
                    }
                })

                validationErrors.value = errors
                return false
            }

            validationErrors.value = []
            return true
        } catch (error) {
            console.error('Form validation error:', error)
            validationErrors.value = [{ field: 'general', rule: 'validation', message: 'Validation failed' }]
            return false
        }
    }

    /**
     * Handle form submission with enhanced UX feedback
     */
    const handleSubmit = async (submitFunction, options = {}) => {
        const {
            showSuccessToast = true,
            showErrorToast = true,
            successMessage = 'Operation completed successfully',
            errorMessage = 'Operation failed. Please try again.',
            resetOnSuccess = true,
            validationDelay = 100,
        } = options

        if (!canSubmit.value) {
            return false
        }

        try {
            // Step 1: Validate form
            const isValid = await validateForm()

            if (!isValid) {
                submitStatus.value = 'ERROR'

                if (showErrorToast && validationErrors.value.length > 0) {
                    const firstError = validationErrors.value[0]
                    toast({
                        severity: 'error',
                        summary: 'Validation Error',
                        detail: firstError.message || 'Please check the form for errors',
                        life: 5000,
                    })
                }

                // Auto-reset error state after delay
                setTimeout(() => {
                    if (submitStatus.value === 'ERROR') {
                        submitStatus.value = 'IDLE'
                    }
                }, 3000)

                return false
            }

            // Step 2: Set pending state
            submitStatus.value = 'PENDING'
            isSubmitting.value = true

            // Small delay for better UX feedback
            await new Promise(resolve => setTimeout(resolve, validationDelay))

            // Step 3: Execute submission
            submitStatus.value = 'OK'
            const result = await submitFunction()

            // Step 4: Handle success
            if (showSuccessToast) {
                toast({
                    severity: 'success',
                    summary: 'Success',
                    detail: successMessage,
                    life: 3000,
                })
            }

            if (resetOnSuccess) {
                setTimeout(() => {
                    resetStatus()
                }, 2000)
            }

            return result
        } catch (error) {
            console.error('Form submission error:', error)

            submitStatus.value = 'ERROR'

            if (showErrorToast) {
                const errorDetail = error?.response?.data?.message || error?.message || errorMessage

                toast({
                    severity: 'error',
                    summary: 'Error',
                    detail: errorDetail,
                    life: 5000,
                })
            }

            // Auto-reset error state after delay
            setTimeout(() => {
                if (submitStatus.value === 'ERROR') {
                    resetStatus()
                }
            }, 3000)

            throw error
        } finally {
            isSubmitting.value = false
        }
    }

    /**
     * Reset form status to idle
     */
    const resetStatus = () => {
        submitStatus.value = 'IDLE'
        validationErrors.value = []
        isSubmitting.value = false
    }

    /**
     * Set custom validation errors
     */
    const setValidationErrors = errors => {
        validationErrors.value = Array.isArray(errors) ? errors : [errors]
        if (validationErrors.value.length > 0) {
            submitStatus.value = 'ERROR'
        }
    }

    /**
     * Clear validation errors
     */
    const clearValidationErrors = () => {
        validationErrors.value = []
        if (submitStatus.value === 'ERROR') {
            submitStatus.value = 'IDLE'
        }
    }

    /**
     * Get validation error for specific field
     */
    const getFieldError = fieldName => {
        return validationErrors.value.find(error => error.field === fieldName)
    }

    /**
     * Check if field has validation error
     */
    const hasFieldError = fieldName => {
        return validationErrors.value.some(error => error.field === fieldName)
    }

    return {
        // State
        submitStatus: readonly(submitStatus),
        validationErrors: readonly(validationErrors),
        isSubmitting: readonly(isSubmitting),

        // Computed
        hasValidationErrors,
        canSubmit,
        showErrorFeedback,
        showSuccessFeedback,

        // Methods
        validateForm,
        handleSubmit,
        resetStatus,
        setValidationErrors,
        clearValidationErrors,
        getFieldError,
        hasFieldError,
    }
}

/**
 * Create login form validation
 */
export function createLoginValidation(formData) {
    const rules = {
        email: {
            required: helpers.withMessage('Email is required', required),
            email: helpers.withMessage('Please enter a valid email address', email),
        },
        password: {
            required: helpers.withMessage('Password is required', required),
            minLength: helpers.withMessage('Password must be at least 6 characters', minLength(6)),
        },
    }

    return useVuelidate(rules, formData)
}

/**
 * Create registration form validation
 */
export function createRegistrationValidation(formData) {
    const rules = {
        name: {
            required: helpers.withMessage('Name is required', required),
            minLength: helpers.withMessage('Name must be at least 2 characters', minLength(2)),
            maxLength: helpers.withMessage('Name cannot exceed 50 characters', maxLength(50)),
        },
        email: {
            required: helpers.withMessage('Email is required', required),
            email: helpers.withMessage('Please enter a valid email address', email),
        },
        password: {
            required: helpers.withMessage('Password is required', required),
            strongPassword: helpers.withMessage(
                'Password must contain at least 8 characters with uppercase, lowercase, number and special character',
                strongPassword
            ),
        },
        password_confirmation: {
            required: helpers.withMessage('Password confirmation is required', required),
            sameAs: helpers.withMessage('Passwords do not match', sameAs(computed(() => formData.password))),
        },
    }

    // Add optional fields if they exist
    if (formData.hasOwnProperty('terms')) {
        rules.terms = {
            required: helpers.withMessage('You must accept the terms and conditions', value => value === true),
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Get password strength level and color
 */
export function getPasswordStrength(password) {
    if (!password) {
        return { level: 0, color: 'gray', text: 'Enter password' }
    }

    let score = 0
    const checks = {
        length: password.length >= 8,
        lowercase: /[a-z]/.test(password),
        uppercase: /[A-Z]/.test(password),
        numbers: /\d/.test(password),
        special: /[!@#$%^&*(),.?":{}|<>]/.test(password),
    }

    score = Object.values(checks).filter(Boolean).length

    const levels = [
        { level: 0, color: 'gray', text: 'Very Weak' },
        { level: 1, color: 'red', text: 'Very Weak' },
        { level: 2, color: 'orange', text: 'Weak' },
        { level: 3, color: 'yellow', text: 'Fair' },
        { level: 4, color: 'blue', text: 'Good' },
        { level: 5, color: 'green', text: 'Strong' },
    ]

    return { ...levels[score], checks }
}

/**
 * Format validation errors for display
 */
export function formatErrors(validator, field) {
    if (!validator[field] || !validator[field].$errors) return []

    return validator[field].$errors.map(error => error.$message)
}

/**
 * Check if field has errors
 */
export function hasError(validator, field) {
    return validator[field].$error
}

/**
 * Get first error message for a field
 */
export function getFirstError(validator, field) {
    const errors = formatErrors(validator, field)
    return errors.length > 0 ? errors[0] : ''
}
