<template>
    <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-indigo-50">
        <Head title="Register" />
        
        <!-- Modern Header -->
        <ModernHeader :showSearch="false" />
        
        <!-- Register Content -->
        <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">

        <div class="max-w-lg w-full space-y-8">
            <!-- Enhanced Header -->
            <div class="text-center">
                <div class="mx-auto h-16 w-auto flex items-center justify-center mb-6">
                    <div class="relative">
                        <div class="w-16 h-16 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl flex items-center justify-center shadow-xl">
                            <i class="pi pi-user-plus text-white text-2xl"></i>
                        </div>
                        <!-- Glow effect -->
                        <div class="absolute inset-0 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl blur-lg opacity-30 -z-10"></div>
                    </div>
                </div>
                <h2 class="text-4xl font-bold bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-3">
                    {{ __('Create Your Account') }}
                </h2>
                <p class="text-lg text-gray-600 max-w-md mx-auto">
                    {{ __('Join thousands of learners and start your journey today') }}
                </p>
            </div>

            <!-- Enhanced Form Card -->
            <div class="relative bg-white/80 backdrop-blur-sm rounded-3xl shadow-2xl border border-white/20 p-8 hover:shadow-3xl transition-all duration-300">
                <!-- Card background effects -->
                <div class="absolute inset-0 bg-gradient-to-br from-white/50 to-indigo-50/30 rounded-3xl"></div>
                <div class="relative z-10">
                <!-- Status Message -->
                <div v-if="status" class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
                    <div class="flex">
                        <i class="pi pi-check-circle text-green-500 text-lg mr-3 mt-0.5"></i>
                        <span class="text-sm text-green-700">{{ status }}</span>
                    </div>
                </div>

                <!-- Validation Errors -->
                <div v-if="$page.props.errors && Object.keys($page.props.errors).length > 0" class="mb-6">
                    <div class="bg-red-50 border border-red-200 rounded-lg p-4">
                        <div class="flex">
                            <i class="pi pi-exclamation-triangle text-red-500 text-lg mr-3 mt-0.5"></i>
                            <div>
                                <h3 class="text-sm font-medium text-red-800 mb-2">Please fix the following errors:</h3>
                                <ul class="text-sm text-red-700 space-y-1">
                                    <li v-for="(error, key) in $page.props.errors" :key="key">{{ error }}</li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

                <form class="space-y-6" @submit.prevent="handleRegister">
                    <!-- Name Fields -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- First Name -->
                        <div>
                            <label for="first_name" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('First Name') }}
                            </label>
                            <input
                                id="first_name"
                                v-model="formData.first_name"
                                type="text"
                                autocomplete="given-name"
                                required
                                :class="[
                                    'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                    hasError(validator, 'first_name')
                                        ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                        : '',
                                ]"
                                :placeholder="__('John')"
                                @blur="validator.first_name?.$touch()"
                            />
                            <div v-if="hasError(validator, 'first_name')" class="mt-1 text-sm text-red-600">
                                {{ getFirstError(validator, 'first_name') }}
                            </div>
                        </div>

                        <!-- Last Name -->
                        <div>
                            <label for="last_name" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Last Name') }}
                            </label>
                            <input
                                id="last_name"
                                v-model="formData.last_name"
                                type="text"
                                autocomplete="family-name"
                                required
                                :class="[
                                    'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                    hasError(validator, 'last_name')
                                        ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                        : '',
                                ]"
                                :placeholder="__('Doe')"
                                @blur="validator.last_name?.$touch()"
                            />
                            <div v-if="hasError(validator, 'last_name')" class="mt-1 text-sm text-red-600">
                                {{ getFirstError(validator, 'last_name') }}
                            </div>
                        </div>
                    </div>

                    <!-- Email Field -->
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
                            {{ __('Email Address') }}
                        </label>
                        <div class="relative">
                            <input
                                id="email"
                                v-model="formData.email"
                                type="email"
                                autocomplete="email"
                                required
                                :class="[
                                    'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                    hasError(validator, 'email')
                                        ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                        : '',
                                ]"
                                :placeholder="__('john.doe@example.com')"
                                @blur="validator.email.$touch()"
                            />
                            <i
                                class="pi pi-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"
                            ></i>
                        </div>
                        <div v-if="hasError(validator, 'email')" class="mt-1 text-sm text-red-600">
                            {{ getFirstError(validator, 'email') }}
                        </div>
                    </div>

                    <!-- Username Field -->
                    <div>
                        <label for="user_name" class="block text-sm font-medium text-gray-700 mb-2">
                            {{ __('Username') }}
                        </label>
                        <div class="relative">
                            <input
                                id="user_name"
                                v-model="formData.user_name"
                                type="text"
                                autocomplete="username"
                                required
                                :class="[
                                    'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                    hasError(validator, 'user_name')
                                        ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                        : '',
                                ]"
                                :placeholder="__('johndoe')"
                                @blur="validator.user_name?.$touch()"
                            />
                            <i class="pi pi-user absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
                        </div>
                        <div v-if="hasError(validator, 'user_name')" class="mt-1 text-sm text-red-600">
                            {{ getFirstError(validator, 'user_name') }}
                        </div>
                    </div>

                    <!-- Password Fields -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                        <!-- Password -->
                        <div>
                            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Password') }}
                            </label>
                            <div class="relative">
                                <input
                                    id="password"
                                    v-model="formData.password"
                                    :type="showPassword ? 'text' : 'password'"
                                    autocomplete="new-password"
                                    required
                                    :class="[
                                        'block w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                        hasError(validator, 'password')
                                            ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                            : '',
                                    ]"
                                    :placeholder="__('Create password')"
                                    @blur="validator.password.$touch()"
                                />
                                <button
                                    type="button"
                                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                                    @click="showPassword = !showPassword"
                                >
                                    <i :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"></i>
                                </button>
                            </div>

                            <!-- Password Strength Indicator -->
                            <div v-if="formData.password" class="mt-2">
                                <div class="flex items-center gap-2">
                                    <div class="flex-1 bg-gray-200 rounded-full h-1">
                                        <div
                                            :class="[
                                                'h-1 rounded-full transition-all duration-300',
                                                passwordStrength.color === 'red' ? 'bg-red-500' : '',
                                                passwordStrength.color === 'orange' ? 'bg-orange-500' : '',
                                                passwordStrength.color === 'yellow' ? 'bg-yellow-500' : '',
                                                passwordStrength.color === 'blue' ? 'bg-blue-500' : '',
                                                passwordStrength.color === 'green' ? 'bg-green-500' : '',
                                            ]"
                                            :style="{ width: `${(passwordStrength.level / 5) * 100}%` }"
                                        ></div>
                                    </div>
                                    <span
                                        :class="[
                                            'text-xs font-medium',
                                            passwordStrength.color === 'red' ? 'text-red-500' : '',
                                            passwordStrength.color === 'orange' ? 'text-orange-500' : '',
                                            passwordStrength.color === 'yellow' ? 'text-yellow-500' : '',
                                            passwordStrength.color === 'blue' ? 'text-blue-500' : '',
                                            passwordStrength.color === 'green' ? 'text-green-500' : '',
                                        ]"
                                    >
                                        {{ passwordStrength.text }}
                                    </span>
                                </div>
                            </div>

                            <div v-if="hasError(validator, 'password')" class="mt-1 text-sm text-red-600">
                                {{ getFirstError(validator, 'password') }}
                            </div>
                        </div>

                        <!-- Confirm Password -->
                        <div>
                            <label for="password_confirmation" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Confirm Password') }}
                            </label>
                            <div class="relative">
                                <input
                                    id="password_confirmation"
                                    v-model="formData.password_confirmation"
                                    :type="showConfirmPassword ? 'text' : 'password'"
                                    autocomplete="new-password"
                                    required
                                    :class="[
                                        'block w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                                        hasError(validator, 'password_confirmation')
                                            ? 'border-red-300 focus:border-red-500 focus:ring-red-500'
                                            : '',
                                    ]"
                                    :placeholder="__('Confirm password')"
                                    @blur="validator.password_confirmation.$touch()"
                                />
                                <button
                                    type="button"
                                    class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
                                    @click="showConfirmPassword = !showConfirmPassword"
                                >
                                    <i :class="showConfirmPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"></i>
                                </button>
                            </div>
                            <div v-if="hasError(validator, 'password_confirmation')" class="mt-1 text-sm text-red-600">
                                {{ getFirstError(validator, 'password_confirmation') }}
                            </div>
                        </div>
                    </div>

                    <!-- Terms and Conditions -->
                    <div class="flex items-start">
                        <div class="flex items-center h-5">
                            <Checkbox
                                v-model="formData.terms"
                                name="terms"
                                class="focus:ring-indigo-500 h-4 w-4 text-indigo-600 border-gray-300 rounded"
                            />
                        </div>
                        <div class="ml-3 text-sm">
                            <span class="text-gray-600">
                                {{ __('I agree to the') }}
                                <Link href="/terms" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    {{ __('Terms of Service') }}
                                </Link>
                                {{ __('and') }}
                                <Link href="/privacy" class="font-medium text-indigo-600 hover:text-indigo-500">
                                    {{ __('Privacy Policy') }}
                                </Link>
                            </span>
                        </div>
                    </div>
                    <div v-if="hasError(validator, 'terms')" class="text-sm text-red-600">
                        {{ getFirstError(validator, 'terms') }}
                    </div>

                    <!-- Submit Button -->
                    <div>
                        <Button
                            type="submit"
                            :loading="isSubmitting"
                            :disabled="!validator.$valid || isSubmitting || !formData.terms"
                            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
                        >
                            <i v-if="isSubmitting" class="pi pi-spinner pi-spin mr-2"></i>
                            {{ __('Create Account') }}
                        </Button>
                    </div>
                </form></div>
                </div>

                <!-- Login Link -->
                <div class="mt-8">
                    <div class="relative">
                        <div class="absolute inset-0 flex items-center">
                            <div class="w-full border-t border-gray-300" />
                        </div>
                        <div class="relative flex justify-center text-sm">
                            <span class="px-2 bg-white text-gray-500">{{ __('or') }}</span>
                        </div>
                    </div>

                    <div class="mt-6 text-center">
                        <span class="text-sm text-gray-600">{{ __('Already have an account?') }} </span>
                        <Link :href="route('login')" class="font-medium text-indigo-600 hover:text-indigo-500">
                            {{ __('Sign in here') }}
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Security Badge -->
            <div class="text-center">
                <div class="inline-flex items-center gap-2 text-xs text-gray-500">
                    <i class="pi pi-shield text-green-500"></i>
                    <span>{{ __('Your information is secure and encrypted') }}</span>
                </div>
            </div>
        </div>
        
        <!-- Modern Footer -->
        <ModernFooter />
    </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import ModernHeader from '@/Components/Layout/ModernHeader.vue'
import ModernFooter from '@/Components/Layout/ModernFooter.vue'
import {
    createRegistrationValidation,
    useFormValidation,
    hasError,
    getFirstError,
    getPasswordStrength,
} from '@/composables/useFormValidation'
import { useToast } from '@/composables/useToast'
import { useTranslate } from '@/composables/useTranslate'
import Button from 'primevue/button'
import Checkbox from 'primevue/checkbox'

// Props
const props = defineProps({
    settings: Object,
    status: String,
})

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { registrationSuccess, error: showError } = useToast()
const { __ } = useTranslate()

// Form data
const formData = reactive({
    first_name: '',
    last_name: '',
    user_name: '',
    email: '',
    password: '',
    password_confirmation: '',
    terms: false,
})

// Form validation
const validator = createRegistrationValidation(formData)

// UI state
const showPassword = ref(false)
const showConfirmPassword = ref(false)

// Computed
const passwordStrength = computed(() => getPasswordStrength(formData.password))

// Methods
const handleRegister = async () => {
    await handleSubmit(
        () => {
            return new Promise((resolve, reject) => {
                router.post(route('register'), formData, {
                    onSuccess: () => {
                        registrationSuccess()
                        resolve()
                    },
                    onError: errors => {
                        console.log('Registration errors:', errors)
                        
                        // Handle specific registration errors
                        if (errors.email && errors.email.includes('already been taken')) {
                            showError('This email address is already registered. Please use a different email or try logging in.')
                        } else if (errors.user_name && errors.user_name.includes('already been taken')) {
                            showError('This username is already taken. Please choose a different username.')
                        } else if (errors.password) {
                            const passwordErrors = Array.isArray(errors.password) ? errors.password : [errors.password]
                            showError(`Password requirements not met: ${passwordErrors.join(', ')}`)
                        } else {
                            // Get the first error message
                            const errorMessages = Object.values(errors).flat()
                            if (errorMessages.length > 0) {
                                showError(errorMessages[0])
                            } else {
                                showError('Registration failed. Please check your information and try again.')
                            }
                        }
                        
                        reject(new Error('Registration failed'))
                    },
                    onFinish: () => {
                        formData.password = ''
                        formData.password_confirmation = ''
                    },
                })
            })
        },
        {
            successMessage: 'Account created successfully! Welcome aboard!',
            errorMessage: 'Registration failed. Please check your information and try again.',
        }
    )
}
</script>

<style scoped>
/* Loading animation for button */
.pi-spin {
    animation: spin 1s linear infinite;
}

@keyframes spin {
    from {
        transform: rotate(0deg);
    }
    to {
        transform: rotate(360deg);
    }
}

/* Enhanced focus states */
input:focus {
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

/* Smooth transitions */
.transition-all {
    transition: all 0.2s ease-in-out;
}

/* Custom button hover effects */
button:hover:not(:disabled) {
    transform: translateY(-1px);
}

button:active:not(:disabled) {
    transform: translateY(0);
}

/* Password strength bar animation */
.password-strength-bar {
    transition: width 0.3s ease-in-out;
}
</style>
