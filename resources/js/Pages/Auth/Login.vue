<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Login" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-user text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Welcome Back') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ __('Sign in to your account to continue') }}
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-8">
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
              :disabled="!validator.$valid || isSubmitting"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <i v-if="isSubmitting" class="pi pi-spinner pi-spin mr-2"></i>
              {{ __('Sign in') }}
            </Button>
          </div>
        </form>

        <!-- Demo Credentials -->
        <div v-if="$page.props.isDemo" class="mt-8 p-4 bg-gray-50 rounded-lg">
          <div class="text-sm text-gray-600 mb-3">{{ __('Demo Login:') }}</div>
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
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createLoginValidation, useFormValidation, hasError, getFirstError } from '@/composables/useFormValidation'
import { useToast } from '@/composables/useToast'
import Button from 'primevue/button'
import Checkbox from 'primevue/checkbox'

// Props
const props = defineProps({
  settings: Object,
  canResetPassword: Boolean,
  status: String
})

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { loginSuccess, error: showError } = useToast()

// Form data
const formData = reactive({
  email: '',
  password: '',
  remember: false
})

// Form validation
const validator = createLoginValidation(formData)

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
  await handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post('/login', formData, {
          onSuccess: () => {
            loginSuccess()
            resolve()
          },
          onError: (errors) => {
            if (errors.email || errors.password) {
              showError('Invalid credentials. Please check your email and password.')
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
    admin: { email: 'admin', password: 'Admin@123' },
    instructor: { email: 'instructor', password: 'Instructor@123' },
    student: { email: 'student', password: 'Student@123' },
    guest: { email: 'guest', password: 'Guest@123' }
  }
  
  if (credentials[role]) {
    formData.email = credentials[role].email
    formData.password = credentials[role].password
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

<script>
    import { useForm, Head } from '@inertiajs/vue3'
    import AuthLayout from '@/Layouts/AuthLayout.vue';
    import ArcCheckbox from '@/Components/Checkbox';
    import ArcValidationErrors from '@/Components/ValidationErrors';
    import ArcButton from "@/Components/Button";
    export default {
        components: {
            AuthLayout,
            ArcCheckbox,
            ArcValidationErrors,
            ArcButton,
            Head,
        },

        props: {
            settings: Object,
            canResetPassword: Boolean,
            status: String
        },

        setup(props) {
            // Proper composable usage in setup() for Vue 3
            const form = useForm({
                email: '',
                password: '',
                remember: false
            });

            const submit = () => {
                form.post('/login', {
                    onFinish: () => form.reset('password'),
                });
            };

            const fillCredentials = (role) => {
                if(role === 'admin') {
                    form.email = 'admin';
                    form.password = 'Admin@123';
                }
                if(role === 'instructor') {
                    form.email = 'instructor';
                    form.password = 'Instructor@123';
                }
                if(role === 'student') {
                    form.email = 'student';
                    form.password = 'Student@123';
                }
                if(role === 'guest') {
                    form.email = 'guest';
                    form.password = 'Guest@123';
                }
            };

            return {
                form,
                submit,
                fillCredentials
            };
        }
    }
</script>
