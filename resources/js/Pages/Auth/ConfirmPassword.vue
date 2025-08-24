<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Confirm Password" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-shield text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Confirm Password') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ __('This is a secure area of the application. Please confirm your password before continuing.') }}
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

        <!-- Security Notice -->
        <div class="mb-6 p-4 bg-amber-50 border border-amber-200 rounded-lg">
          <div class="flex">
            <i class="pi pi-exclamation-triangle text-amber-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-amber-800 mb-1">{{ __('Security Verification Required') }}</h3>
              <p class="text-sm text-amber-700">{{ __('For your security, please confirm your current password to access this protected area.') }}</p>
            </div>
          </div>
        </div>

        <form @submit.prevent="handlePasswordConfirm" class="space-y-6">
          <!-- Password Field -->
          <div>
            <label for="password" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Current Password') }}
            </label>
            <div class="relative">
              <input
                id="password"
                v-model="formData.password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="current-password"
                required
                autofocus
                :class="[
                  'block w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  hasError(validator, 'password') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your current password')"
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

          <!-- Submit Button -->
          <div>
            <Button
              type="submit"
              :loading="isSubmitting"
              :disabled="!validator.$valid || isSubmitting"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <i v-if="isSubmitting" class="pi pi-spinner pi-spin mr-2"></i>
              <i v-else class="pi pi-check mr-2"></i>
              {{ __('Confirm Password') }}
            </Button>
          </div>
        </form>

        <!-- Help Text -->
        <div class="mt-6 p-4 bg-gray-50 rounded-lg">
          <div class="flex">
            <i class="pi pi-info-circle text-gray-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-gray-800 mb-1">{{ __('Why do I need to confirm my password?') }}</h3>
              <p class="text-sm text-gray-600">{{ __('This extra security step helps protect your account and sensitive information from unauthorized access.') }}</p>
            </div>
          </div>
        </div>

        <!-- Actions -->
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
              :href="route('dashboard')"
              class="font-medium text-indigo-600 hover:text-indigo-500"
            >
              {{ __('Back to Dashboard') }}
            </Link>
          </div>
        </div>
      </div>

      <!-- Footer -->
      <div class="text-center">
        <p class="text-xs text-gray-500">
          {{ __('Having trouble?') }}
          <Link href="/contact" class="underline hover:text-gray-700">{{ __('Contact Support') }}</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createPasswordValidation, useFormValidation, hasError, getFirstError } from '@/composables/useModernValidation'
import { useToast } from '@/composables/useToast'
import Button from 'primevue/button'

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: showSuccess, error: showError } = useToast()

// Form data
const formData = reactive({
  password: ''
})

// Form validation
const validator = createPasswordValidation(formData)

// UI state
const showPassword = ref(false)

// Methods
const handlePasswordConfirm = async () => {
  await handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post(route('password.confirm'), formData, {
          onSuccess: () => {
            showSuccess('Password confirmed successfully!')
            resolve()
          },
          onError: (errors) => {
            if (errors.password) {
              showError('Password confirmation failed. Please check your password and try again.')
            }
            reject(new Error('Password confirmation failed'))
          },
          onFinish: () => {
            formData.password = ''
          }
        })
      })
    },
    {
      successMessage: 'Password confirmed successfully!',
      errorMessage: 'Failed to confirm password. Please try again.'
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
