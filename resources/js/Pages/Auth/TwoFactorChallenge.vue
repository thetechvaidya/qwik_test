<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Two-Factor Authentication" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-mobile text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Two-Factor Authentication') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          <span v-if="!recovery">
            {{ __('Please confirm access to your account by entering the authentication code provided by your authenticator application.') }}
          </span>
          <span v-else>
            {{ __('Please confirm access to your account by entering one of your emergency recovery codes.') }}
          </span>
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

        <!-- 2FA Info -->
        <div class="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <div class="flex">
            <i class="pi pi-shield text-blue-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-blue-800 mb-1">{{ __('Security Verification') }}</h3>
              <p class="text-sm text-blue-700">
                <span v-if="!recovery">
                  {{ __('Open your authenticator app and enter the 6-digit code.') }}
                </span>
                <span v-else>
                  {{ __('Enter one of your backup recovery codes.') }}
                </span>
              </p>
            </div>
          </div>
        </div>

        <form @submit.prevent="submitForm" class="space-y-6">
          <!-- Authentication Code Field -->
          <div v-if="!recovery">
            <label for="code" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Authentication Code') }}
            </label>
            <div class="relative">
              <input
                id="code"
                ref="codeInput"
                v-model="formData.code"
                type="text"
                inputmode="numeric"
                autocomplete="one-time-code"
                required
                autofocus
                maxlength="6"
                :class="[
                  'block w-full px-4 py-3 text-center text-2xl font-mono tracking-widest border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  hasError(validator, 'code') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('000000')"
                @input="formatCode"
                @blur="validator.code.$touch()"
              />
              <i class="pi pi-mobile absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <div v-if="hasError(validator, 'code')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'code') }}
            </div>
            <p class="mt-2 text-xs text-gray-500">{{ __('Enter the 6-digit code from your authenticator app') }}</p>
          </div>

          <!-- Recovery Code Field -->
          <div v-else>
            <label for="recovery_code" class="block text-sm font-medium text-gray-700 mb-2">
              {{ __('Recovery Code') }}
            </label>
            <div class="relative">
              <input
                id="recovery_code"
                ref="recoveryInput"
                v-model="formData.recovery_code"
                type="text"
                autocomplete="one-time-code"
                required
                :class="[
                  'block w-full px-4 py-3 text-center font-mono tracking-wider border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  hasError(validator, 'recovery_code') ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter recovery code')"
                @blur="validator.recovery_code.$touch()"
              />
              <i class="pi pi-key absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <div v-if="hasError(validator, 'recovery_code')" class="mt-1 text-sm text-red-600">
              {{ getFirstError(validator, 'recovery_code') }}
            </div>
            <p class="mt-2 text-xs text-gray-500">{{ __('Enter one of your backup recovery codes') }}</p>
          </div>

          <!-- Toggle Recovery Mode -->
          <div class="flex items-center justify-center">
            <button
              type="button"
              @click="toggleRecovery"
              class="text-sm font-medium text-indigo-600 hover:text-indigo-500 underline focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2 rounded"
            >
              <span v-if="!recovery">
                <i class="pi pi-key mr-1"></i>
                {{ __('Use a recovery code instead') }}
              </span>
              <span v-else>
                <i class="pi pi-mobile mr-1"></i>
                {{ __('Use an authentication code instead') }}
              </span>
            </button>
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
              <i v-else class="pi pi-sign-in mr-2"></i>
              {{ __('Verify & Login') }}
            </Button>
          </div>
        </form>

        <!-- Help Text -->
        <div class="mt-6 p-4 bg-gray-50 rounded-lg">
          <div class="flex">
            <i class="pi pi-question-circle text-gray-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-gray-800 mb-1">{{ __('Having trouble?') }}</h3>
              <p class="text-sm text-gray-600">
                <span v-if="!recovery">
                  {{ __('If you can\'t access your authenticator app, you can use a recovery code instead.') }}
                </span>
                <span v-else>
                  {{ __('Recovery codes are one-time use only. Make sure to save your remaining codes.') }}
                </span>
              </p>
            </div>
          </div>
        </div>

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
          {{ __('Having trouble?') }}
          <Link href="/contact" class="underline hover:text-gray-700">{{ __('Contact Support') }}</Link>
        </p>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, nextTick } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { createTwoFactorValidation, useFormValidation, hasError, getFirstError } from '@/composables/useModernValidation'
import { useToast } from '@/composables/useToast'
import Button from 'primevue/button'

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: showSuccess, error: showError } = useToast()

// Refs
const codeInput = ref(null)
const recoveryInput = ref(null)

// Reactive state
const recovery = ref(false)
const formData = reactive({
  code: '',
  recovery_code: ''
})

// Form validation
const validator = createTwoFactorValidation(formData, recovery)

// Methods
const formatCode = (event) => {
  // Only allow numbers and limit to 6 digits
  const value = event.target.value.replace(/\D/g, '').slice(0, 6)
  formData.code = value
}

const toggleRecovery = async () => {
  recovery.value = !recovery.value
  
  await nextTick()
  
  if (recovery.value) {
    recoveryInput.value?.focus()
    formData.code = ''
  } else {
    codeInput.value?.focus()
    formData.recovery_code = ''
  }
}

const submitForm = () => {
  validator.value.$touch()
  handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post(route('two-factor.login'), formData, {
          onSuccess: () => {
            showSuccess('Authentication successful! Welcome back.')
            resolve()
          },
          onError: (errors) => {
            if (errors.code || errors.recovery_code) {
              showError('Authentication failed. Please check your code and try again.')
            }
            reject(new Error('Two-factor authentication failed'))
          },
          onFinish: () => {
            if (recovery.value) {
              formData.recovery_code = ''
            } else {
              formData.code = ''
            }
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

/* Code input styling */
input[inputmode="numeric"] {
  letter-spacing: 0.5em;
}
</style>
