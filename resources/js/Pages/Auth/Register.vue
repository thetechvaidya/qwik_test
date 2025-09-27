<template>
    <div class="min-h-screen bg-gradient-to-br from-emerald-50 via-cyan-50 to-blue-100 relative overflow-hidden">
        <Head title="Register" />
        
        <!-- Animated Background Elements -->
        <div class="absolute inset-0 overflow-hidden pointer-events-none">
            <div class="absolute -top-40 -left-40 w-80 h-80 bg-gradient-to-br from-green-400/20 to-blue-600/20 rounded-full blur-3xl animate-pulse"></div>
            <div class="absolute -bottom-40 -right-40 w-96 h-96 bg-gradient-to-tr from-cyan-400/20 to-purple-600/20 rounded-full blur-3xl animate-pulse" style="animation-delay: 3s;"></div>
            <div class="absolute top-1/3 right-1/4 w-64 h-64 bg-gradient-to-br from-teal-400/10 to-indigo-600/10 rounded-full blur-2xl animate-bounce" style="animation-duration: 8s;"></div>
        </div>
        
        <!-- Modern Header -->
        <ModernHeader :showSearch="false" />
        
        <!-- Main Content - Two Column Layout -->
        <div class="relative flex min-h-screen pt-16">
            <!-- Left Column - Hero Section -->
            <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-emerald-600 via-teal-600 to-cyan-600 relative overflow-hidden">
                <!-- Hero Background Pattern -->
                <div class="absolute inset-0 opacity-10">
                    <div class="absolute inset-0" style="background-image: linear-gradient(45deg, transparent 40%, white 41%, white 59%, transparent 60%), linear-gradient(-45deg, transparent 40%, white 41%, white 59%, transparent 60%); background-size: 30px 30px;"></div>
                </div>
                
                <!-- Hero Content -->
                <div class="relative z-10 flex flex-col justify-center items-center text-center p-12 text-white">
                    <!-- Large Hero Illustration -->
                    <div class="mb-8">
                        <svg class="w-80 h-80" viewBox="0 0 400 400" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <!-- Background Elements -->
                            <circle cx="200" cy="200" r="180" fill="url(#registerHeroGradient)" opacity="0.1"/>
                            <circle cx="200" cy="200" r="140" fill="url(#registerHeroGradient)" opacity="0.15"/>
                            <circle cx="200" cy="200" r="100" fill="url(#registerHeroGradient)" opacity="0.2"/>
                            
                            <!-- Main Rocket/Growth Icon -->
                            <path d="M200 80 L220 160 L280 180 L220 200 L200 280 L180 200 L120 180 L180 160 Z" fill="white" opacity="0.9"/>
                            <circle cx="200" cy="140" r="15" fill="#10B981"/>
                            <path d="M190 140 L195 145 L210 130" stroke="white" stroke-width="3" fill="none" stroke-linecap="round"/>
                            
                            <!-- Achievement Stars -->
                            <polygon points="150,120 155,130 165,130 157,137 160,147 150,140 140,147 143,137 135,130 145,130" fill="#FCD34D">
                                <animate attributeName="opacity" values="0.5;1;0.5" dur="2s" repeatCount="indefinite"/>
                            </polygon>
                            <polygon points="250,120 255,130 265,130 257,137 260,147 250,140 240,147 243,137 235,130 245,130" fill="#F472B6">
                                <animate attributeName="opacity" values="0.5;1;0.5" dur="2.5s" repeatCount="indefinite" begin="0.5s"/>
                            </polygon>
                            
                            <!-- Progress Circles -->
                            <circle cx="120" cy="220" r="20" fill="white" opacity="0.8"/>
                            <circle cx="120" cy="220" r="15" fill="none" stroke="#10B981" stroke-width="3" stroke-dasharray="15 85" stroke-linecap="round">
                                <animateTransform attributeName="transform" type="rotate" values="0 120 220; 360 120 220" dur="3s" repeatCount="indefinite"/>
                            </circle>
                            <text x="120" y="225" text-anchor="middle" fill="#10B981" font-size="10" font-weight="bold">75%</text>
                            
                            <circle cx="280" cy="220" r="20" fill="white" opacity="0.8"/>
                            <circle cx="280" cy="220" r="15" fill="none" stroke="#3B82F6" stroke-width="3" stroke-dasharray="25 75" stroke-linecap="round">
                                <animateTransform attributeName="transform" type="rotate" values="0 280 220; 360 280 220" dur="2s" repeatCount="indefinite"/>
                            </circle>
                            <text x="280" y="225" text-anchor="middle" fill="#3B82F6" font-size="10" font-weight="bold">90%</text>
                            
                            <!-- Floating Books -->
                            <rect x="100" y="300" width="30" height="4" rx="2" fill="white" opacity="0.7">
                                <animate attributeName="y" values="300;290;300" dur="4s" repeatCount="indefinite"/>
                            </rect>
                            <rect x="270" y="320" width="25" height="4" rx="2" fill="white" opacity="0.6">
                                <animate attributeName="y" values="320;310;320" dur="3s" repeatCount="indefinite" begin="1s"/>
                            </rect>
                            
                            <defs>
                                <linearGradient id="registerHeroGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" style="stop-color:rgb(255, 255, 255);stop-opacity:1" />
                                    <stop offset="50%" style="stop-color:rgb(240, 253, 244);stop-opacity:1" />
                                    <stop offset="100%" style="stop-color:rgb(209, 250, 229);stop-opacity:1" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>
                    
                    <!-- Hero Text -->
                    <div class="max-w-md">
                        <h1 class="text-4xl lg:text-5xl font-bold mb-6 leading-tight">
                            Start Your Success
                            <span class="block text-green-300">Story Today</span>
                        </h1>
                        <p class="text-xl text-emerald-100 mb-8 leading-relaxed">
                            Create your account and unlock a world of knowledge, skills, and endless learning opportunities
                        </p>
                        
                        <!-- Feature Points -->
                        <div class="space-y-4 text-left">
                            <div class="flex items-center space-x-3">
                                <div class="flex-shrink-0 w-6 h-6 bg-green-400 rounded-full flex items-center justify-center">
                                    <i class="pi pi-star text-xs text-white"></i>
                                </div>
                                <span class="text-emerald-100">Access to premium content</span>
                            </div>
                            <div class="flex items-center space-x-3">
                                <div class="flex-shrink-0 w-6 h-6 bg-cyan-400 rounded-full flex items-center justify-center">
                                    <i class="pi pi-trophy text-xs text-white"></i>
                                </div>
                                <span class="text-emerald-100">Earn certificates and badges</span>
                            </div>
                            <div class="flex items-center space-x-3">
                                <div class="flex-shrink-0 w-6 h-6 bg-blue-400 rounded-full flex items-center justify-center">
                                    <i class="pi pi-heart text-xs text-white"></i>
                                </div>
                                <span class="text-emerald-100">Join a supportive community</span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <!-- Decorative Elements -->
                <div class="absolute top-10 left-10 w-20 h-20 border-2 border-white/20 rounded-full animate-pulse"></div>
                <div class="absolute bottom-20 right-20 w-16 h-16 border border-white/20 rounded-lg animate-bounce" style="animation-duration: 3s;"></div>
                <div class="absolute top-1/2 left-5 w-8 h-8 bg-white/10 rounded-full animate-ping" style="animation-duration: 5s;"></div>
            </div>
            
            <!-- Right Column - Register Form -->
            <div class="w-full lg:w-1/2 flex items-center justify-center p-6 lg:p-12">
                <div class="max-w-lg w-full space-y-8">
            <!-- Enhanced Header -->
                        <!-- Enhanced Header with SVG -->
            <div class="text-center">
                <div class="mx-auto h-24 w-auto flex items-center justify-center mb-6">
                    <div class="relative">
                        <!-- SVG Register Icon -->
                        <svg class="w-24 h-24" viewBox="0 0 100 100" fill="none" xmlns="http://www.w3.org/2000/svg">
                            <!-- Background Elements -->
                            <circle cx="50" cy="50" r="45" fill="url(#registerGradient)" opacity="0.1"/>
                            <circle cx="50" cy="50" r="35" fill="url(#registerGradient)" opacity="0.15"/>
                            
                            <!-- Main User Icon -->
                            <circle cx="50" cy="35" r="8" fill="url(#registerGradient)"/>
                            <path d="M35 70 C35 60, 41 55, 50 55 C59 55, 65 60, 65 70" stroke="url(#registerGradient)" stroke-width="3" fill="none" stroke-linecap="round"/>
                            
                            <!-- Add/Plus Icon -->
                            <circle cx="70" cy="30" r="8" fill="white" stroke="url(#registerGradient)" stroke-width="2"/>
                            <path d="M66 30 L74 30 M70 26 L70 34" stroke="url(#registerGradient)" stroke-width="2" stroke-linecap="round"/>
                            
                            <!-- Success Indicators -->
                            <circle cx="25" cy="25" r="2" fill="#10B981">
                                <animate attributeName="r" values="2;3;2" dur="2s" repeatCount="indefinite"/>
                            </circle>
                            <circle cx="80" cy="75" r="1.5" fill="#F59E0B">
                                <animate attributeName="opacity" values="0.5;1;0.5" dur="2.5s" repeatCount="indefinite"/>
                            </circle>
                            <polygon points="20,75 25,80 30,70" fill="#EF4444">
                                <animateTransform attributeName="transform" type="rotate" values="0 25 75; 10 25 75; 0 25 75" dur="3s" repeatCount="indefinite"/>
                            </polygon>
                            
                            <defs>
                                <linearGradient id="registerGradient" x1="0%" y1="0%" x2="100%" y2="100%">
                                    <stop offset="0%" style="stop-color:rgb(16, 185, 129);stop-opacity:1" />
                                    <stop offset="50%" style="stop-color:rgb(59, 130, 246);stop-opacity:1" />
                                    <stop offset="100%" style="stop-color:rgb(139, 92, 246);stop-opacity:1" />
                                </linearGradient>
                            </defs>
                        </svg>
                    </div>
                </div>
                <h2 class="text-4xl font-bold bg-gradient-to-r from-green-600 via-blue-600 to-purple-600 bg-clip-text text-transparent mb-3">
                    {{ __('Create Account') }}
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
                            :loading="isSubmitting || authLoading"
                            :disabled="!validator.$valid || isSubmitting || authLoading || !formData.terms"
                            class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 disabled:opacity-50 disabled:cursor-not-allowed transition-all duration-200"
                        >
                            <i v-if="isSubmitting || authLoading" class="pi pi-spinner pi-spin mr-2"></i>
                            {{ __('Create Account') }}
                        </Button>
                    </div>
                </form>
                </div>
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

            <!-- Security Badge -->
            <div class="text-center mt-8">
                <div class="inline-flex items-center gap-2 text-xs text-gray-500">
                    <i class="pi pi-shield text-green-500"></i>
                    <span>{{ __('Your information is secure and encrypted') }}</span>
                </div>
            </div>
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
import { useSanctumAuth } from '@/composables/useSanctumAuth'
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
const { register: sanctumRegister, isLoading: authLoading } = useSanctumAuth()

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
        async () => {
            try {
                // Use Sanctum authentication for registration
                await sanctumRegister({
                    first_name: formData.first_name,
                    last_name: formData.last_name,
                    user_name: formData.user_name,
                    email: formData.email,
                    password: formData.password,
                    password_confirmation: formData.password_confirmation,
                    terms: formData.terms
                })
                
                registrationSuccess()
            } catch (error) {
                console.log('Registration errors:', error)
                
                // Handle specific registration errors
                if (error.email && error.email.includes('already been taken')) {
                    showError('This email address is already registered. Please use a different email or try logging in.')
                } else if (error.user_name && error.user_name.includes('already been taken')) {
                    showError('This username is already taken. Please choose a different username.')
                } else if (error.password) {
                    const passwordErrors = Array.isArray(error.password) ? error.password : [error.password]
                    showError(`Password requirements not met: ${passwordErrors.join(', ')}`)
                } else if (typeof error === 'object' && Object.keys(error).length > 0) {
                    // Get the first error message
                    const errorMessages = Object.values(error).flat()
                    if (errorMessages.length > 0) {
                        showError(errorMessages[0])
                    } else {
                        showError('Registration failed. Please check your information and try again.')
                    }
                } else {
                    showError('Registration failed. Please check your information and try again.')
                }
                
                // Clear passwords on error
                formData.password = ''
                formData.password_confirmation = ''
                throw error
            }
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
