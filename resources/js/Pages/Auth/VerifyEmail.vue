<template>
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50 flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
    <Head title="Email Verification" />
    
    <div class="max-w-md w-full space-y-8">
      <!-- Header -->
      <div class="text-center">
        <div class="mx-auto h-12 w-auto flex items-center justify-center">
          <div class="w-12 h-12 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-xl flex items-center justify-center">
            <i class="pi pi-envelope text-white text-xl"></i>
          </div>
        </div>
        <h2 class="mt-6 text-3xl font-bold text-gray-900">
          {{ __('Verify Your Email') }}
        </h2>
        <p class="mt-2 text-sm text-gray-600">
          {{ __('Thanks for signing up! Before getting started, could you verify your email address by clicking on the link we just emailed to you?') }}
        </p>
      </div>

      <!-- Form Card -->
      <div class="bg-white rounded-2xl shadow-xl border border-gray-100 p-8">
        <!-- Success Message -->
        <div v-if="verificationLinkSent" class="mb-6 p-4 bg-green-50 border border-green-200 rounded-lg">
          <div class="flex">
            <i class="pi pi-check-circle text-green-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-green-800 mb-1">{{ __('Verification Link Sent!') }}</h3>
              <p class="text-sm text-green-700">{{ __('A new verification link has been sent to your email address.') }}</p>
            </div>
          </div>
        </div>

        <!-- Email Verification Info -->
        <div class="mb-6 p-4 bg-blue-50 border border-blue-200 rounded-lg">
          <div class="flex">
            <i class="pi pi-info-circle text-blue-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-blue-800 mb-1">{{ __('Check Your Email') }}</h3>
              <p class="text-sm text-blue-700">{{ __('We sent a verification link to your email address. Please click the link to verify your account.') }}</p>
            </div>
          </div>
        </div>

        <!-- Resend Form -->
        <form @submit.prevent="handleResend" class="space-y-6">
          <div>
            <Button
              type="submit"
              :loading="isSubmitting"
              :disabled="isSubmitting"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <i v-if="isSubmitting" class="pi pi-spinner pi-spin mr-2"></i>
              <i v-else class="pi pi-send mr-2"></i>
              {{ __('Resend Verification Email') }}
            </Button>
          </div>
        </form>

        <!-- Help Text -->
        <div class="mt-6 p-4 bg-gray-50 rounded-lg">
          <div class="flex">
            <i class="pi pi-question-circle text-gray-500 text-lg mr-3 mt-0.5"></i>
            <div>
              <h3 class="text-sm font-medium text-gray-800 mb-1">{{ __('Didn\'t receive the email?') }}</h3>
              <p class="text-sm text-gray-600">{{ __('Check your spam folder or click the button above to resend the verification email.') }}</p>
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
          
          <div class="mt-6 flex flex-col space-y-3">
            <!-- Edit Profile Link -->
            <Link
              :href="route('profile.show')"
              class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200"
            >
              <i class="pi pi-user mr-2"></i>
              {{ __('Edit Profile') }}
            </Link>
            
            <!-- Logout Link -->
            <Link
              :href="route('logout')"
              method="post"
              as="button"
              class="w-full flex justify-center py-2 px-4 border border-gray-300 rounded-lg shadow-sm text-sm font-medium text-gray-700 bg-white hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors duration-200"
            >
              <i class="pi pi-sign-out mr-2"></i>
              {{ __('Logout') }}
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
import { computed } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import { useFormValidation } from '@/composables/useFormValidation'
import { useToast } from '@/composables/useToast'
import Button from 'primevue/button'

// Props
const props = defineProps({
  status: String
})

// Composables
const { handleSubmit, isSubmitting } = useFormValidation()
const { success: showSuccess, error: showError } = useToast()

// Computed
const verificationLinkSent = computed(() => {
  return props.status === 'verification-link-sent'
})

// Methods
const handleResend = async () => {
  await handleSubmit(
    () => {
      return new Promise((resolve, reject) => {
        router.post(route('verification.send'), {}, {
          onSuccess: () => {
            showSuccess('Verification email sent! Please check your inbox.')
            resolve()
          },
          onError: (errors) => {
            showError('Failed to send verification email. Please try again.')
            reject(new Error('Verification email failed'))
          }
        })
      })
    },
    {
      successMessage: 'Verification email sent successfully!',
      errorMessage: 'Failed to send verification email. Please try again.'
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
button:focus, a:focus {
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
