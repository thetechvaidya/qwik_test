<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Forgot Password" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-key text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Forgot Password?') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ __('No problem. Just let us know your email address and we will email you a password reset link.') }}
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

        <form @submit.prevent="submitForm" class="space-y-6">
          <!-- Email Field -->
          <div>
            <label for="email" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Email') }}
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
                  hasError(validator, 'email') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your email address')"
                @blur="validator.email.$touch()"
              />
              <i class="pi pi-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <div v-if="hasError(validator, 'email')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'email') }}
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
              {{ __('Email Password Reset Link') }}
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
            <span class="text-sm text-gray-600">{{ __('Remember your password?') }} </span>
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
import { reactive } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createEmailValidation, useFormValidation, hasError, getFirstError } from '@/composables/useModernValidation'
import { useToast } from '@/composables/useToast'
import { useTranslate } from '@/composables/useTranslate'
import Button from 'primevue/button'

// Props
const props = defineProps({
  status: String,
  settings: Object
})

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: showSuccess, error: showError } = useToast()
const { __ } = useTranslate()

// Form data
const formData = reactive({
  email: ''
})

// Form validation
const validator = createEmailValidation(formData)

// Methods
const submitForm = () => {
  handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post(route('password.email'), formData, {
          onSuccess: () => {
            showSuccess('Password reset link sent! Check your email.')
            resolve()
          },
          onError: (errors) => {
            if (errors.email) {
              showError('Unable to send reset link. Please check your email address.')
            }
            reject(new Error('Password reset failed'))
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
