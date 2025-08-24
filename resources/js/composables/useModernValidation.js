import { ref, reactive, computed, watch, unref } from 'vue'
import { useVuelidate } from '@vuelidate/core'
import { 
    required, 
    email, 
    minLength, 
    maxLength, 
    sameAs, 
    helpers 
} from '@vuelidate/validators'

/**
 * Modern validation composable for QwikTest e-learning platform
 * Provides consistent validation patterns, error handling, and user feedback
 */

// Custom validators for e-learning platform
const customValidators = {
    // Strong password validator for security
    strongPassword: helpers.withMessage(
        'Password must contain at least 8 characters, including uppercase, lowercase, number, and special character',
        (value) => {
            if (!value) return true // Let required handle empty values
            const hasUppercase = /[A-Z]/.test(value)
            const hasLowercase = /[a-z]/.test(value)
            const hasNumber = /\d/.test(value)
            const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(value)
            const hasMinLength = value.length >= 8
            return hasUppercase && hasLowercase && hasNumber && hasSpecial && hasMinLength
        }
    ),

    // Username validator for e-learning platform
    validUsername: helpers.withMessage(
        'Username must be 3-20 characters, alphanumeric and underscores only',
        (value) => {
            if (!value) return true
            return /^[a-zA-Z0-9_]{3,20}$/.test(value)
        }
    ),

    // Phone number validator
    phoneNumber: helpers.withMessage(
        'Please enter a valid phone number',
        (value) => {
            if (!value) return true
            return /^[\+]?[1-9][\d]{0,15}$/.test(value.replace(/\s/g, ''))
        }
    ),

    // Recovery code validator for 2FA
    recoveryCode: helpers.withMessage(
        'Recovery code must be alphanumeric',
        (value) => {
            if (!value) return true
            return /^[a-zA-Z0-9\-]{8,}$/.test(value)
        }
    ),

    // Two-factor authentication code validator
    twoFactorCode: helpers.withMessage(
        'Authentication code must be 6 digits',
        (value) => {
            if (!value) return true
            return /^\d{6}$/.test(value)
        }
    )
}

/**
 * Create login validation rules
 */
export function createLoginValidation(formData) {
    const rules = {
        email: {
            required: helpers.withMessage('Email or username is required', required)
        },
        password: {
            required: helpers.withMessage('Password is required', required)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create registration validation rules
 */
export function createRegistrationValidation(formData) {
    const rules = {
        name: {
            required: helpers.withMessage('Full name is required', required),
            minLength: helpers.withMessage('Name must be at least 2 characters', minLength(2)),
            maxLength: helpers.withMessage('Name must not exceed 50 characters', maxLength(50))
        },
        email: {
            required: helpers.withMessage('Email address is required', required),
            email: helpers.withMessage('Please enter a valid email address', email)
        },
        username: {
            required: helpers.withMessage('Username is required', required),
            validUsername: customValidators.validUsername
        },
        password: {
            required: helpers.withMessage('Password is required', required),
            strongPassword: customValidators.strongPassword
        },
        password_confirmation: {
            required: helpers.withMessage('Password confirmation is required', required),
            sameAs: helpers.withMessage('Passwords do not match', sameAs(computed(() => formData.password)))
        },
        terms: {
            required: helpers.withMessage('You must accept the terms and conditions', (value) => value === true)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create email validation rules
 */
export function createEmailValidation(formData) {
    const rules = {
        email: {
            required: helpers.withMessage('Email address is required', required),
            email: helpers.withMessage('Please enter a valid email address', email)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create password reset validation rules
 */
export function createPasswordResetValidation(formData) {
    const rules = {
        email: {
            required: helpers.withMessage('Email address is required', required),
            email: helpers.withMessage('Please enter a valid email address', email)
        },
        password: {
            required: helpers.withMessage('New password is required', required),
            strongPassword: customValidators.strongPassword
        },
        password_confirmation: {
            required: helpers.withMessage('Password confirmation is required', required),
            sameAs: helpers.withMessage('Passwords do not match', sameAs(computed(() => formData.password)))
        },
        token: {
            required: helpers.withMessage('Reset token is required', required)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create password validation rules (for confirm password page)
 */
export function createPasswordValidation(formData) {
    const rules = {
        password: {
            required: helpers.withMessage('Password is required', required)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create two-factor authentication validation rules
 */
export function createTwoFactorValidation(formData, recovery) {
    const rules = computed(() => {
        if (recovery.value) {
            return {
                recovery_code: {
                    required: helpers.withMessage('Recovery code is required', required),
                    recoveryCode: customValidators.recoveryCode
                }
            }
        } else {
            return {
                code: {
                    required: helpers.withMessage('Authentication code is required', required),
                    twoFactorCode: customValidators.twoFactorCode
                }
            }
        }
    })

    return useVuelidate(rules, formData)
}

/**
 * Create profile update validation rules
 */
export function createProfileValidation(formData) {
    const rules = {
        name: {
            required: helpers.withMessage('Full name is required', required),
            minLength: helpers.withMessage('Name must be at least 2 characters', minLength(2)),
            maxLength: helpers.withMessage('Name must not exceed 50 characters', maxLength(50))
        },
        email: {
            required: helpers.withMessage('Email address is required', required),
            email: helpers.withMessage('Please enter a valid email address', email)
        },
        phone: {
            phoneNumber: customValidators.phoneNumber
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Create course enrollment validation rules
 */
export function createEnrollmentValidation(formData) {
    const rules = {
        course_id: {
            required: helpers.withMessage('Please select a course', required)
        },
        syllabus_id: {
            required: helpers.withMessage('Please select a syllabus', required)
        }
    }

    return useVuelidate(rules, formData)
}

/**
 * Form validation composable with modern UX patterns
 */
export function useFormValidation() {
    const isSubmitting = ref(false)
    const submitAttempted = ref(false)

    const handleSubmit = async (submitFunction, options = {}) => {
        const {
            validator = null,
            resetForm = false
        } = options

        if (isSubmitting.value) return

        // Validate if validator is provided
        if (validator) {
            const v = unref(validator)
            const isValid = await v.$validate()
            if (!isValid) {
                submitAttempted.value = true
                return
            }
        }

        isSubmitting.value = true
        submitAttempted.value = true

        try {
            await submitFunction()
            
            if (resetForm && typeof resetForm === 'function') {
                resetForm()
            }
        } catch (error) {
            console.error('Form submission error:', error)
            // Error handling is done in the individual form components
            throw error
        } finally {
            isSubmitting.value = false
        }
    }

    const resetValidation = () => {
        submitAttempted.value = false
    }

    return {
        isSubmitting,
        submitAttempted,
        handleSubmit,
        resetValidation
    }
}

/**
 * Validation helper functions
 */
export function hasError(validator, field) {
    const v = unref(validator)
    return v[field].$error
}

export function getFirstError(validator, field) {
    const v = unref(validator)
    if (v[field].$errors.length > 0) {
        return v[field].$errors[0].$message
    }
    return ''
}

export function getAllErrors(validator, field) {
    const v = unref(validator)
    return v[field].$errors.map(error => error.$message)
}

/**
 * Real-time validation composable for better UX
 */
export function useRealTimeValidation(validator, field, delay = 500) {
    const isValidating = ref(false)
    const validationMessage = ref('')
    const isValid = ref(null)

    let timeoutId = null

    const validateField = () => {
        if (timeoutId) {
            clearTimeout(timeoutId)
        }

        isValidating.value = true
        
        timeoutId = setTimeout(() => {
            validator[field].$touch()
            
            if (validator[field].$error) {
                isValid.value = false
                validationMessage.value = getFirstError(validator, field)
            } else if (validator[field].$dirty) {
                isValid.value = true
                validationMessage.value = ''
            }
            
            isValidating.value = false
        }, delay)
    }

    return {
        isValidating,
        validationMessage,
        isValid,
        validateField
    }
}

/**
 * Password strength calculator
 */
export function usePasswordStrength() {
    const calculateStrength = (password) => {
        if (!password) return { score: 0, label: '', color: 'bg-gray-300' }

        let score = 0
        const checks = {
            length: password.length >= 8,
            lowercase: /[a-z]/.test(password),
            uppercase: /[A-Z]/.test(password),
            numbers: /\d/.test(password),
            symbols: /[^A-Za-z0-9]/.test(password)
        }

        score = Object.values(checks).filter(Boolean).length

        const strengths = [
            { score: 0, label: '', color: 'bg-gray-300', width: '0%' },
            { score: 1, label: 'Very Weak', color: 'bg-red-500', width: '20%' },
            { score: 2, label: 'Weak', color: 'bg-orange-500', width: '40%' },
            { score: 3, label: 'Fair', color: 'bg-yellow-500', width: '60%' },
            { score: 4, label: 'Good', color: 'bg-blue-500', width: '80%' },
            { score: 5, label: 'Strong', color: 'bg-green-500', width: '100%' }
        ]

        return strengths[score] || strengths[0]
    }

    return { calculateStrength }
}

/**
 * Form field focus management for better accessibility
 */
export function useFormFocus() {
    const focusFirstError = (validator) => {
        const firstErrorField = Object.keys(validator).find(field => 
            validator[field].$error
        )
        
        if (firstErrorField) {
            const element = document.getElementById(firstErrorField)
            if (element) {
                element.focus()
                element.scrollIntoView({ behavior: 'smooth', block: 'center' })
            }
        }
    }

    return { focusFirstError }
}

export default {
    createLoginValidation,
    createRegistrationValidation,
    createEmailValidation,
    createPasswordResetValidation,
    createPasswordValidation,
    createTwoFactorValidation,
    createProfileValidation,
    createEnrollmentValidation,
    useFormValidation,
    useRealTimeValidation,
    usePasswordStrength,
    useFormFocus,
    hasError,
    getFirstError,
    getAllErrors,
    customValidators
}