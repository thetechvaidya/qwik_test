<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Reset Password" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-lock text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Reset Password') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ __('Enter your new password to complete the reset process') }}
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-8">
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

        <form @submit.prevent="submitForm" class="space-y-6">
          <!-- Email Field (readonly) -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Email') }}
            </label>
            <div class="relative">
              <input
                id="email"
                v-model="formData.email"
                type="email"
                readonly
                class="block w-full px-4 py-3 border border-gray-200 rounded-lg shadow-sm bg-gray-50 text-gray-600 cursor-not-allowed"
              />
              <i class="pi pi-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
          </div>

          <!-- Password Field -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('New Password') }}
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
                  hasError(validator, 'password') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your new password')"
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
            <!-- Password strength indicator -->
            <div class="mt-2">
              <div class="flex items-center space-x-1">
                <div class="flex-1 h-1 bg-gray-200 rounded-full overflow-hidden">
                  <div 
                    :class="[
                      'h-full transition-all duration-300',
                      passwordStrength.color
                    ]"
                    :style="{ width: passwordStrength.width }"
                  ></div>
                </div>
                <span class="text-xs text-gray-500">{{ passwordStrength.label }}</span>
              </div>
            </div>
          </div>

          <!-- Confirm Password Field -->
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
                  hasError(validator, 'password_confirmation') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Confirm your new password')"
                @blur="validator.password_confirmation.$touch()"
              />
              <button
                type="button"
                @click="showConfirmPassword = !showConfirmPassword"
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <i :class="showConfirmPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"></i>
              </button>
            </div>
            <div v-if="hasError(validator, 'password_confirmation')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'password_confirmation') }}
            </div>
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
              {{ __('Reset Password') }}
            </Button>
          </div>
        </form>

        <!-- Back to Login -->
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
            <Link
              :href="route('login')"
              class="font-medium text-indigo-600 hover:text-indigo-500"
            >
              {{ __('Back to Login') }}
            </Link>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="text-center">
        <p class="text-xs text-gray-500">
          {{ __('By using this service, you agree to our') }}
          <Link href="/terms" class="underline hover:text-gray-700">{{ __('Terms of Service') }}</Link>
          {{ __('and') }}
          <Link href="/privacy" class="underline hover:text-gray-700">{{ __('Privacy Policy') }}</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createPasswordResetValidation, useFormValidation, hasError, getFirstError } from '@/composables/useModernValidation'
import { useToast } from '@/composables/useToast'
import Button from 'primevue/button'

// Props
const props = defineProps({
  email: String,
  token: String
})

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: showSuccess, error: showError } = useToast()

// Form data
const formData = reactive({
  token: props.token,
  email: props.email,
  password: '',
  password_confirmation: ''
})

// Form validation
const validator = createPasswordResetValidation(formData)

// UI state
const showPassword = ref(false)
const showConfirmPassword = ref(false)

// Password strength computation
const passwordStrength = computed(() => {
  const password = formData.password
  if (!password) return { width: '0%', color: 'bg-gray-300', label: '' }
  
  let score = 0
  if (password.length >= 8) score++
  if (/[a-z]/.test(password)) score++
  if (/[A-Z]/.test(password)) score++
  if (/[0-9]/.test(password)) score++
  if (/[^A-Za-z0-9]/.test(password)) score++
  
  const strengths = [
    { width: '20%', color: 'bg-red-500', label: 'Very Weak' },
    { width: '40%', color: 'bg-orange-500', label: 'Weak' },
    { width: '60%', color: 'bg-yellow-500', label: 'Fair' },
    { width: '80%', color: 'bg-blue-500', label: 'Good' },
    { width: '100%', color: 'bg-green-500', label: 'Strong' }
  ]
  
  return strengths[Math.min(score, 4)]
})

// Methods
const submitForm = () => {
  handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post(route('password.update'), formData, {
          onSuccess: () => {
            showSuccess('Password reset successfully! You can now login with your new password.')
            resolve()
          },
          onError: (errors) => {
            if (errors.password || errors.password_confirmation) {
              showError('Password reset failed. Please check your passwords and try again.')
            }
            reject(new Error('Password reset failed'))
          },
          onFinish: () => {
            formData.password = ''
            formData.password_confirmation = ''
          }
        })
      })
    },
    {
      validator
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
