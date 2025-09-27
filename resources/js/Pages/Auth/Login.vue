<template>
  <div class="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-100 relative overflow-hidden">
    <Head title="Login" />
    
    <!-- Animated Background Elements -->
    <div class="absolute inset-0 overflow-hidden pointer-events-none">
      <div class="absolute -top-40 -right-40 w-80 h-80 bg-gradient-to-br from-blue-400/20 to-purple-600/20 rounded-full blur-3xl animate-pulse"></div>
      <div class="absolute -bottom-40 -left-40 w-96 h-96 bg-gradient-to-tr from-indigo-400/20 to-pink-600/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 2s;"></div>
      <div class="absolute top-1/4 left-1/4 w-64 h-64 bg-gradient-to-br from-cyan-400/10 to-blue-600/10 rounded-full blur-2xl animate-bounce" style="animation-duration: 6s;"></div>
    </div>
    
    <!-- Modern Header -->
    <ModernHeader :showSearch="false" />
    
    <!-- Main Content - Two Column Layout -->
    <div class="relative flex min-h-screen pt-16">
      <!-- Left Column - Hero Section -->
      <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 relative overflow-hidden">
        <!-- Hero Background Pattern -->
        <div class="absolute inset-0 opacity-10">
          <div class="absolute inset-0" style="background-image: radial-gradient(circle at 2px 2px, white 1px, transparent 0); background-size: 40px 40px;"></div>
        </div>
        
        <!-- Hero Content -->
        <div class="relative z-10 flex flex-col justify-center items-center text-center p-12 text-white">
          <!-- Large Hero Illustration -->
          <div class="mb-8">
            <svg class="w-80 h-80" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">
              <!-- Background Elements -->
              <circle cx="200" cy="200" r="180" fill="url(#heroGradient)" opacity="0.1"/>
              <circle cx="200" cy="200" r="140" fill="url(#heroGradient)" opacity="0.15"/>
              <circle cx="200" cy="200" r="100" fill="url(#heroGradient)" opacity="0.2"/>
              
              <!-- Main Learning Platform Icon -->
              <rect x="120" y="120" width="160" height="120" rx="20" fill="white" opacity="0.9"/>
              <rect x="130" y="140" width="140" height="8" rx="4" fill="url(#heroGradient)" opacity="0.6"/>
              <rect x="130" y="160" width="100" height="8" rx="4" fill="url(#heroGradient)" opacity="0.4"/>
              <rect x="130" y="180" width="120" height="8" rx="4" fill="url(#heroGradient)" opacity="0.5"/>
              
              <!-- Books Stack -->
              <rect x="140" y="200" width="40" height="6" rx="3" fill="#4F46E5"/>
              <rect x="142" y="194" width="36" height="6" rx="3" fill="#7C3AED"/>
              <rect x="144" y="188" width="32" height="6" rx="3" fill="#EC4899"/>
              
              <!-- Trophy Icon -->
              <circle cx="220" cy="200" r="15" fill="#FCD34D"/>
              <rect x="213" y="210" width="14" height="8" rx="2" fill="#F59E0B"/>
              <rect x="210" y="218" width="20" height="4" rx="2" fill="#D97706"/>
              
              <!-- Floating Elements -->
              <circle cx="100" cy="100" r="8" fill="white" opacity="0.8">
                <animate attributeName="cy" values="100;90;100" dur="3s" repeatCount="indefinite"/>
              </circle>
              <polygon points="320,80 330,90 340,80 330,70" fill="white" opacity="0.7">
                <animateTransform attributeName="transform" type="rotate" values="0 330 80; 360 330 80" dur="8s" repeatCount="indefinite"/>
              </polygon>
              <rect x="80" y="280" width="12" height="12" rx="2" fill="white" opacity="0.6">
                <animate attributeName="opacity" values="0.6;1;0.6" dur="2s" repeatCount="indefinite"/>
              </rect>
              
              <!-- Success Checkmarks -->
              <circle cx="300" cy="150" r="12" fill="white" opacity="0.8"/>
              <path d="M295 150 L299 154 L305 146" stroke="#10B981" stroke-width="2" fill="none" stroke-linecap="round"/>
              
              <defs>
                <linearGradient id="heroGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" style="stop-color:rgb(255, 255, 255);stop-opacity:1" />
                  <stop offset="50%" style="stop-color:rgb(240, 249, 255);stop-opacity:1" />
                  <stop offset="100%" style="stop-color:rgb(219, 234, 254);stop-opacity:1" />
                </linearGradient>
              </defs>
            </svg>
          </div>
          
          <!-- Hero Text -->
          <div class="max-w-md">
            <h1 class="text-4xl lg:text-5xl font-bold mb-6 leading-tight">
              Welcome to Your
              <span class="block text-yellow-300">Learning Journey</span>
            </h1>
            <p class="text-xl text-blue-100 mb-8 leading-relaxed">
              Join thousands of learners advancing their skills through our comprehensive exam platform
            </p>
            
            <!-- Feature Points -->
            <div class="space-y-4 text-left">
              <div class="flex items-center space-x-3">
                <div class="flex-shrink-0 w-6 h-6 bg-green-400 rounded-full flex items-center justify-center">
                  <i class="pi pi-check text-xs text-white"></i>
                </div>
                <span class="text-blue-100">Interactive quizzes and exams</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="flex-shrink-0 w-6 h-6 bg-yellow-400 rounded-full flex items-center justify-center">
                  <i class="pi pi-chart-line text-xs text-white"></i>
                </div>
                <span class="text-blue-100">Track your progress in real-time</span>
              </div>
              <div class="flex items-center space-x-3">
                <div class="flex-shrink-0 w-6 h-6 bg-pink-400 rounded-full flex items-center justify-center">
                  <i class="pi pi-users text-xs text-white"></i>
                </div>
                <span class="text-blue-100">Join a community of learners</span>
              </div>
            </div>
          </div>
        </div>
        
        <!-- Decorative Elements -->
        <div class="absolute top-10 right-10 w-20 h-20 border-2 border-white/20 rounded-full animate-spin" style="animation-duration: 20s;"></div>
        <div class="absolute bottom-10 left-10 w-16 h-16 border border-white/20 rounded-full animate-ping" style="animation-duration: 4s;"></div>
      </div>
      
      <!-- Right Column - Login Form -->
      <div class="w-full lg:w-1/2 flex items-center justify-center p-8 lg:p-16">
        <div class="max-w-md w-full space-y-8">
          <!-- Enhanced Header with SVG -->
      <div class="text-center">
        <div class="mx-auto h-24 w-auto flex items-center justify-center mb-6">
          <div class="relative">
            <!-- SVG Login Icon -->
            <svg class="w-24 h-24" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
              <!-- Background Circle -->
              <circle cx="50" cy="50" r="45" fill="url(#loginGradient)" opacity="0.1"/>
              <circle cx="50" cy="50" r="40" fill="url(#loginGradient)" opacity="0.2"/>
              
              <!-- Login Door/Portal -->
              <rect x="35" y="25" width="30" height="40" rx="5" fill="url(#loginGradient)" stroke="white" stroke-width="1.5"/>
              
              <!-- Door Handle -->
              <circle cx="58" cy="45" r="2" fill="white"/>
              
              <!-- User Icon -->
              <circle cx="50" cy="35" r="4" fill="white"/>
              <path d="M42 55 C42 50, 46 48, 50 48 C54 48, 58 50, 58 55" stroke="white" stroke-width="2" fill="none" stroke-linecap="round"/>
              
              <!-- Welcome Sparkles -->
              <circle cx="25" cy="30" r="1.5" fill="#FCD34D">
                <animate attributeName="opacity" values="0;1;0" dur="2s" repeatCount="indefinite"/>
              </circle>
              <circle cx="75" cy="35" r="1" fill="#F59E0B">
                <animate attributeName="opacity" values="0;1;0" dur="2.5s" repeatCount="indefinite" begin="0.8s"/>
              </circle>
              <circle cx="30" cy="70" r="1.2" fill="#EF4444">
                <animate attributeName="opacity" values="0;1;0" dur="3s" repeatCount="indefinite" begin="1.2s"/>
              </circle>
              
              <defs>
                <linearGradient id="loginGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                  <stop offset="0%" style="stop-color:rgb(99, 102, 241);stop-opacity:1" />
                  <stop offset="50%" style="stop-color:rgb(139, 92, 246);stop-opacity:1" />
                  <stop offset="100%" style="stop-color:rgb(236, 72, 153);stop-opacity:1" />
                </linearGradient>
              </defs>
            </svg>
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
                v-model="form.email"
                type="text"
                autocomplete="username"
                required
                :class="[
                  'block w-full px-4 py-3 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  form.errors.email ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your email or username')"
              />
              <i class="pi pi-envelope absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400"></i>
            </div>
            <div v-if="form.errors.email" class="mt-1 text-sm text-red-600">
              {{ form.errors.email }}
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
                v-model="form.password"
                :type="showPassword ? 'text' : 'password'"
                autocomplete="current-password"
                required
                :class="[
                  'block w-full px-4 py-3 pr-12 border border-gray-300 rounded-lg shadow-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition-colors duration-200',
                  form.errors.password ? 'border-red-300 focus:border-red-500 focus:ring-red-500' : ''
                ]"
                :placeholder="__('Enter your password')"
              />
              <button
                type="button"
                @click="showPassword = !showPassword"
                class="absolute right-3 top-1/2 transform -translate-y-1/2 text-gray-400 hover:text-gray-600"
              >
                <i :class="showPassword ? 'pi pi-eye-slash' : 'pi pi-eye'"></i>
              </button>
            </div>
            <div v-if="form.errors.password" class="mt-1 text-sm text-red-600">
              {{ form.errors.password }}
            </div>
          </div>

          <!-- Remember Me & Forgot Password -->
          <div class="flex items-center justify-between">
            <label class="flex items-center">
              <Checkbox
                v-model="form.remember"
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
              :loading="form.processing"
              :disabled="form.processing"
              class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
            >
              <i v-if="form.processing" class="pi pi-spinner pi-spin mr-2"></i>
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
    </div>
    
    <!-- Modern Footer -->
    <ModernFooter />
  </div>
</template>

<script setup>
import { ref, reactive } from 'vue'
import { Head, Link, router } from '@inertiajs/vue3'
import ModernHeader from '@/Components/Layout/ModernHeader.vue'
import ModernFooter from '@/Components/Layout/ModernFooter.vue'
import { usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import Button from 'primevue/button'
import Checkbox from 'primevue/checkbox'

// Props
const props = defineProps({
  settings: Object,
  canResetPassword: Boolean,
  status: String
})

// Composables
const { __ } = useTranslate()

// Form data
const form = reactive({
  email: '',
  password: '',
  remember: false,
  processing: false,
  errors: {}
})

// UI state
const showPassword = ref(false)

// Demo roles configuration
const demoRoles = [
  { key: 'admin', label: 'Admin', color: 'bg-red-100 text-red-700 hover:bg-red-200' },
  { key: 'instructor', label: 'Instructor', color: 'bg-blue-100 text-blue-700 hover:bg-blue-200' },
  { key: 'student', label: 'Student', color: 'bg-green-100 text-green-700 hover:bg-green-200' }
]

// Methods
const handleLogin = () => {
  form.processing = true
  form.errors = {}
  
  router.post(route('login'), {
    email: form.email,
    password: form.password,
    remember: form.remember
  }, {
    onSuccess: () => {
      // Login successful - redirect will be handled by server
    },
    onError: (errors) => {
      form.errors = errors
      form.password = '' // Clear password on error
    },
    onFinish: () => {
      form.processing = false
    }
  })
}

const fillCredentials = (role) => {
  const credentials = {
    admin: { email: 'admin@qwiktest.com', password: 'password' },
    instructor: { email: 'instructor@qwiktest.com', password: 'password' },
    student: { email: 'student@qwiktest.com', password: 'password' }
  }
  
  if (credentials[role]) {
    form.email = credentials[role].email
    form.password = credentials[role].password
    
    // Clear validation errors when filling demo credentials
    form.errors = {}
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

