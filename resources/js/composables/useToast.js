import { useToast as usePrimeToast } from 'primevue/usetoast'

/**
 * Composable for toast notifications using PrimeVue's Toast service
 * Provides a consistent API for success, error, warning, and info messages
 */
export function useToast() {
    const primeToast = usePrimeToast()

    /**
     * Show a success toast message
     */
    const success = (message, options = {}) => {
        const { summary = 'Success', detail = message, life = 3000, closable = true, ...restOptions } = options

        primeToast.add({
            severity: 'success',
            summary,
            detail,
            life,
            closable,
            ...restOptions,
        })
    }

    /**
     * Show an error toast message
     */
    const error = (message, options = {}) => {
        const { summary = 'Error', detail = message, life = 5000, closable = true, ...restOptions } = options

        primeToast.add({
            severity: 'error',
            summary,
            detail,
            life,
            closable,
            ...restOptions,
        })
    }

    /**
     * Show a warning toast message
     */
    const warning = (message, options = {}) => {
        const { summary = 'Warning', detail = message, life = 4000, closable = true, ...restOptions } = options

        primeToast.add({
            severity: 'warn',
            summary,
            detail,
            life,
            closable,
            ...restOptions,
        })
    }

    /**
     * Show an info toast message
     */
    const info = (message, options = {}) => {
        const { summary = 'Information', detail = message, life = 3000, closable = true, ...restOptions } = options

        primeToast.add({
            severity: 'info',
            summary,
            detail,
            life,
            closable,
            ...restOptions,
        })
    }

    /**
     * Show a custom toast message
     */
    const custom = (options = {}) => {
        primeToast.add(options)
    }

    /**
     * Clear all toast messages
     */
    const clear = () => {
        primeToast.removeAllGroups()
    }

    /**
     * Remove a specific toast message
     */
    const remove = toast => {
        primeToast.remove(toast)
    }

    // Helper methods for common scenarios

    /**
     * Show form validation error
     */
    const validationError = (message = 'Please check the form for errors') => {
        error(message, {
            summary: 'Validation Error',
            life: 5000,
        })
    }

    /**
     * Show server error
     */
    const serverError = (message = 'Something went wrong. Please try again later.') => {
        error(message, {
            summary: 'Server Error',
            life: 6000,
        })
    }

    /**
     * Show network error
     */
    const networkError = (message = 'Network error. Please check your connection.') => {
        error(message, {
            summary: 'Connection Error',
            life: 6000,
        })
    }

    /**
     * Show operation success
     */
    const operationSuccess = (operation = 'Operation', message = null) => {
        success(message || `${operation} completed successfully`, {
            summary: 'Success',
            life: 3000,
        })
    }

    /**
     * Show save success
     */
    const saveSuccess = (message = 'Changes saved successfully') => {
        success(message, {
            summary: 'Saved',
            life: 2000,
        })
    }

    /**
     * Show delete success
     */
    const deleteSuccess = (message = 'Item deleted successfully') => {
        success(message, {
            summary: 'Deleted',
            life: 2000,
        })
    }

    /**
     * Show update success
     */
    const updateSuccess = (message = 'Item updated successfully') => {
        success(message, {
            summary: 'Updated',
            life: 2000,
        })
    }

    /**
     * Show create success
     */
    const createSuccess = (message = 'Item created successfully') => {
        success(message, {
            summary: 'Created',
            life: 2000,
        })
    }

    /**
     * Show login success
     */
    const loginSuccess = (name = null) => {
        success(name ? `Welcome back, ${name}!` : 'Login successful', {
            summary: 'Welcome',
            life: 3000,
        })
    }

    /**
     * Show logout success
     */
    const logoutSuccess = (message = 'You have been logged out successfully') => {
        info(message, {
            summary: 'Logged Out',
            life: 2000,
        })
    }

    /**
     * Show registration success
     */
    const registrationSuccess = (message = 'Account created successfully! Welcome aboard!') => {
        success(message, {
            summary: 'Welcome!',
            life: 4000,
        })
    }

    /**
     * Show password change success
     */
    const passwordChangeSuccess = (message = 'Password changed successfully') => {
        success(message, {
            summary: 'Security',
            life: 3000,
        })
    }

    /**
     * Show upload success
     */
    const uploadSuccess = (message = 'File uploaded successfully') => {
        success(message, {
            summary: 'Upload Complete',
            life: 3000,
        })
    }

    /**
     * Show upload error
     */
    const uploadError = (message = 'File upload failed') => {
        error(message, {
            summary: 'Upload Failed',
            life: 5000,
        })
    }

    /**
     * Show permission denied error
     */
    const permissionDenied = (message = 'You do not have permission to perform this action') => {
        warning(message, {
            summary: 'Access Denied',
            life: 4000,
        })
    }

    /**
     * Show session expired warning
     */
    const sessionExpired = (message = 'Your session has expired. Please log in again.') => {
        warning(message, {
            summary: 'Session Expired',
            life: 0, // Don't auto-hide
            closable: true,
        })
    }

    /**
     * Show maintenance mode info
     */
    const maintenanceMode = (message = 'The system is currently under maintenance. Please try again later.') => {
        info(message, {
            summary: 'Maintenance',
            life: 0, // Don't auto-hide
            closable: true,
        })
    }

    return {
        // Basic toast methods
        success,
        error,
        warning,
        info,
        custom,
        clear,
        remove,

        // Helper methods for common scenarios
        validationError,
        serverError,
        networkError,
        operationSuccess,
        saveSuccess,
        deleteSuccess,
        updateSuccess,
        createSuccess,
        loginSuccess,
        logoutSuccess,
        registrationSuccess,
        passwordChangeSuccess,
        uploadSuccess,
        uploadError,
        permissionDenied,
        sessionExpired,
        maintenanceMode,

        // Access to underlying PrimeVue toast instance
        toast: primeToast,
    }
}

/**
 * Toast configuration presets
 */
export const toastPresets = {
    success: {
        severity: 'success',
        life: 3000,
        closable: true,
    },
    error: {
        severity: 'error',
        life: 5000,
        closable: true,
    },
    warning: {
        severity: 'warn',
        life: 4000,
        closable: true,
    },
    info: {
        severity: 'info',
        life: 3000,
        closable: true,
    },
    sticky: {
        life: 0,
        closable: true,
    },
}
