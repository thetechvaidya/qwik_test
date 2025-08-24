<template>
  <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-indigo-50">
    <Head title="Login" />
    
    <!-- Modern Header -->
    <ModernHeader :showSearch="false" />
    
    <!-- Login Content -->
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    
    <div class="max-w-md w-full space-y-8">
      <!-- Enhanced Header -->
      <div class="text-center">
        <div class="mx-auto h-16 w-auto flex items-center justify-center mb-6">
          <div class="relative">
            <div class="w-16 h-16 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl flex items-center justify-center shadow-xl">
              <i class="pi pi-user text-white text-2xl"></i>
            </div>
            <!-- Glow effect -->
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-2xl blur-lg opacity-30 -z-10"></div>
          </div>
        </div>
        <h2 class="text-4xl font-bold bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-3">
          {{ __('Welcome Back') }}
        </h2>
        <p class="text-lg text-gray-600 max-w-md mx-auto">
          {{ __('Sign in to your account and continue your learning journey') }}
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

        <form @submit.prevent="handleLogin" class="space-y-6">
          <!-- Email Field -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Email') }} / {{ __('User Name') }}
            </label>
            <div class="relative">
              <input
                id="email"
                v-model="formData.email"
                type="text"
                autocomplete="username"
                required
                :class="[
                  'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  hasError(validator, 'email') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your email or username')"
                @blur="validator.email.$touch()"
              />
              <i class="pi pi-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <div v-if="hasError(validator, 'email')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'email') }}
            </div>
          </div>

          <!-- Password Field -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Password') }}
            </label>
            <div class="relative">
              <input
                id="password"
                v-model="formData.password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="current-password"
                required
                :class="[
                  'block w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  hasError(validator, 'password') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your password')"
                @blur="validator.password.$touch()"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <i :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"></i>
              </button>
            </div>
            <div v-if="hasError(validator, 'password')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'password') }}
            </div>
          </div>

          <!-- Remember Me & Forgot Password -->
          <div class="flex items-center justify-between">
            <label class="flex items-center">
              <Checkbox
                v-model="formData.remember"
                name="remember"
                class="mr-2"
              />
              <span class="text-sm text-gray-600">{{ __('Remember me') }}</span>
            </label>
            <Link
              v-if="canResetPassword"
              :href="route('password.request')"
              class="text-sm font-medium text-indigo-600 hover:text-indigo-500"
            >
              {{ __('Forgot Password?') }}
            </Link>
          </div>

          <!-- Submit Button -->
          <div>
            <Button
              type="submit"
              :loading="isSubmitting"
              :disabled="isSubmitting"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <i v-if="isSubmitting" class="pi pi-spinner pi-spin mr-2"></i>
              {{ __('Sign in') }}
            </Button>
          </div>
        </form>

        <!-- Demo Credentials -->
        <div v-if="$page.props.isDemo" class="mt-8 p-4 bg-gray-50 rounded-lg">
          <div class="text-sm text-gray-600 mb-3">{{ __('Demo Login Credentials:') }}</div>
          <div class="text-xs text-gray-500 mb-3">
            {{ __('Use these credentials to test different user roles:') }}
          </div>
          <div class="grid grid-cols-2 gap-2">
            <Button
              v-for="role in demoRoles"
              :key="role.key"
              @click="fillCredentials(role.key)"
              variant="outlined"
              size="small"
              :class="role.color"
            >
              {{ role.label }}
            </Button>
          </div>
          <div class="mt-3 text-xs text-gray-400">
            {{ __('All demo accounts use password: "password"') }}
          </div>
        </div>

        <!-- Register Link -->
        <div v-if="!$page.props.isDemo && $page.props.general?.can_register" class="mt-8">
          <div class="relative">
            <div class="absolute inset-0 flex items-center">
              <div class="w-full border-t border-gray-300" />
            </div>
            <div class="relative flex justify-center text-sm">
              <span class="px-2 bg-white text-gray-500">{{ __('or') }}</span>
            </div>
          </div>
          
          <div class="mt-6 text-center">
            <span class="text-sm text-gray-600">{{ __("Don't have an account?") }} </span>
            <Link
              :href="route('register')"
              class="font-medium text-indigo-600 hover:text-indigo-500"
            >
              {{ __('Create one now') }}
            </Link>
          </div>
        </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="text-center">
        <p class="text-xs text-gray-500">
          {{ __('By signing in, you agree to our') }}
          <Link href="/terms" class="underline hover:text-gray-700">{{ __('Terms of Service') }}</Link>
          {{ __('and') }}
          <Link href="/privacy" class="underline hover:text-gray-700">{{ __('Privacy Policy') }}</Link>
        </p>
      </div>
    </div>
    </div>
    
    <!-- Modern Footer -->
    <ModernFooter />
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createLoginValidation, useFormValidation, hasError, getFirstError } from '@/composables/useFormValidation'
import ModernHeader from '@/Components/Layout/ModernHeader.vue'
import ModernFooter from '@/Components/Layout/ModernFooter.vue'
import { useToast } from '@/composables/useToast'
import { useTranslate } from '@/composables/useTranslate'
import { useAuthDebug } from '@/composables/useAuthDebug'
import Button from 'primevue/button'
import Checkbox from 'primevue/checkbox'

// Props
const props = defineProps({
  settings: Object,
  canResetPassword: Boolean,
  status: String
})

// Form data
const formData = reactive({
  email: '',
  password: '',
  remember: false
})

// Form validation
const validator = createLoginValidation(formData)

// Composables (don't pass validator for now to avoid errors)
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: loginSuccess, error: showError } = useToast()
const { __ } = useTranslate()
const { testCredentials, validateFormData, isDemoMode } = useAuthDebug()

// UI state
const showPassword = ref(false)

// Demo roles configuration
const demoRoles = [
  { key: 'admin', label: 'Admin', color: 'bg-red-100 text-red-700 hover:bg-red-200' },
  { key: 'instructor', label: 'Instructor', color: 'bg-blue-100 text-blue-700 hover:bg-blue-200' },
  { key: 'student', label: 'Student', color: 'bg-green-100 text-green-700 hover:bg-green-200' },
  { key: 'guest', label: 'Guest', color: 'bg-gray-100 text-gray-700 hover:bg-gray-200' }
]

// Methods
const handleLogin = async () => {
  // Basic validation before submission
  if (!formData.email || !formData.password) {
    showError('Please fill in both email/username and password.')
    return
  }

  // Pre-validate credentials for better UX
  if (isDemoMode.value) {
    const validation = validateFormData(formData)
    if (!validation.isValid) {
      console.log('Form validation failed:', validation.errors)
    }
    if (validation.warnings.length > 0) {
      console.log('Form validation warnings:', validation.warnings)
    }
  }

  await handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post('/login', formData, {
          onSuccess: () => {
            loginSuccess()
            resolve()
          },
          onError: (errors) => {
            console.log('Login errors:', errors)
            
            // Handle specific authentication errors
            if (errors.email || errors.password) {
              if (errors.email && errors.email.includes('disabled')) {
                showError('Your account has been disabled. Please contact administrator.')
              } else if (errors.email && errors.email.includes('These credentials')) {
                showError('Invalid credentials. Please check your email/username and password.')
              } else {
                showError('Login failed. Please verify your credentials and try again.')
              }
            } else if (Object.keys(errors).length > 0) {
              const firstError = Object.values(errors)[0]
              showError(Array.isArray(firstError) ? firstError[0] : firstError)
            } else {
              showError('Login failed. Please check your credentials and try again.')
            }
            
            // Add debug information for demo mode
            if (props.settings?.demo_mode || isDemoMode.value) {
              console.log('Demo mode login attempt:', {
                email: formData.email,
                availableCredentials: {
                  admin: 'admin@qwiktest.com / password',
                  instructor: 'instructor@qwiktest.com / password',
                  student: 'student@qwiktest.com / password',
                  guest: 'guest@qwiktest.com / password'
                }
              })
            }
            
            reject(new Error('Login failed'))
          },
          onFinish: () => {
            formData.password = ''
          }
        })
      })
    },
    {
      successMessage: 'Login successful! Welcome back.',
      errorMessage: 'Login failed. Please check your credentials and try again.'
    }
  )
}

const fillCredentials = (role) => {
  const credentials = {
    admin: { email: 'admin@qwiktest.com', password: 'password' },
    instructor: { email: 'instructor@qwiktest.com', password: 'password' },
    student: { email: 'student@qwiktest.com', password: 'password' },
    guest: { email: 'guest@qwiktest.com', password: 'password' }
  }
  
  if (credentials[role]) {
    formData.email = credentials[role].email
    formData.password = credentials[role].password
    
    // Clear validation errors when filling demo credentials
    if (validator && typeof validator.$reset === 'function') {
      validator.$reset()
    }
  }
}
</script>

<style scoped>
/* Loading animation for button */
.pi-spin {
  animation: spin 1s linear infinite;
}

@keyframes spin {
  from { transform: rotate(0deg); }
  to { transform: rotate(360deg); }
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
</style>

