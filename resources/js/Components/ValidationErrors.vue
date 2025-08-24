<template>
    <div v-if="hasErrors" class="mb-6">
        <div class="bg-red-50 border border-red-200 rounded-lg p-4">
            <div class="flex">
                <i class="pi pi-exclamation-triangle text-red-500 text-lg mr-3 mt-0.5"></i>
                <div class="flex-1">
                    <h3 class="text-sm font-medium text-red-800 mb-2">
                        {{ getErrorTitle() }}
                    </h3>
                    <ul class="text-sm text-red-700 space-y-1">
                        <li v-for="(error, key) in errors" :key="key" class="flex items-start">
                            <span class="mr-1">•</span>
                            <span>{{ formatError(error, key) }}</span>
                        </li>
                    </ul>
                    
                    <!-- Demo mode suggestions -->
                    <div v-if="showDemoSuggestions" class="mt-3 p-3 bg-blue-50 border border-blue-200 rounded">
                        <p class="text-sm text-blue-800 font-medium mb-2">Demo Mode - Try these credentials:</p>
                        <div class="grid grid-cols-1 gap-1 text-xs text-blue-700">
                            <div><strong>Admin:</strong> admin@qwiktest.com / password</div>
                            <div><strong>Instructor:</strong> instructor@qwiktest.com / password</div>
                            <div><strong>Student:</strong> student@qwiktest.com / password</div>
                            <div><strong>Guest:</strong> guest@qwiktest.com / password</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { computed } from 'vue'
import { usePage } from '@inertiajs/vue3'

const page = usePage()

const errors = computed(() => page.props.errors || {})

const hasErrors = computed(() => Object.keys(errors.value).length > 0)

const showDemoSuggestions = computed(() => {
    const isDemo = page.props.isDemo || page.props.demo_mode
    const hasAuthErrors = errors.value.email || errors.value.password || errors.value.message
    return isDemo && hasAuthErrors
})

const getErrorTitle = () => {
    const errorKeys = Object.keys(errors.value)
    
    if (errorKeys.includes('email') || errorKeys.includes('password')) {
        return 'Authentication Error'
    }
    
    if (errorKeys.some(key => ['first_name', 'last_name', 'user_name'].includes(key))) {
        return 'Registration Error'
    }
    
    return 'Please fix the following errors:'
}

const formatError = (error, key) => {
    // Handle authentication specific errors
    if (key === 'email' && error.includes('credentials')) {
        return 'Invalid email/username or password. Please check your credentials.'
    }
    
    if (key === 'email' && error.includes('disabled')) {
        return 'Your account has been disabled. Please contact support.'
    }
    
    if (key === 'password' && error.includes('field is required')) {
        return 'Password is required.'
    }
    
    // Handle registration specific errors
    if (key === 'email' && error.includes('already been taken')) {
        return 'This email is already registered. Try logging in instead.'
    }
    
    if (key === 'user_name' && error.includes('already been taken')) {
        return 'This username is already taken. Please choose a different one.'
    }
    
    // Return original error message
    return Array.isArray(error) ? error[0] : error
}
</script>

<style scoped>
/* Enhanced error styling */
.bg-red-50 {
    background-color: #fef2f2;
}

.border-red-200 {
    border-color: #fecaca;
}

.text-red-500 {
    color: #ef4444;
}

.text-red-700 {
    color: #b91c1c;
}

.text-red-800 {
    color: #991b1b;
}

.bg-blue-50 {
    background-color: #eff6ff;
}

.border-blue-200 {
    border-color: #bfdbfe;
}

.text-blue-700 {
    color: #1d4ed8;
}

.text-blue-800 {
    color: #1e40af;
}
</style>
