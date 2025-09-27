<template>
  <!-- Ultra-Modern Navigation Header -->
  <header class="modern-header fixed top-0 left-0 right-0 z-50 transition-all duration-300" :class="headerClasses">
    <!-- Glassmorphism Background -->
    <div class="absolute inset-0 bg-white/90 dark:bg-gray-900/90 backdrop-blur-xl border-b border-gray-200/50 dark:border-gray-700/50"></div>
    
    <!-- Navigation Container -->
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
      <div class="flex items-center justify-between h-16 lg:h-20">
        
        <!-- Mobile Menu Toggle -->
        <button
          type="button"
          class="lg:hidden p-2 rounded-xl text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100/80 dark:hover:bg-gray-800/80 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500/30"
          @click="toggleMobileMenu"
          :aria-expanded="isMobileMenuOpen"
          aria-label="Toggle navigation menu"
        >
          <Transition name="rotate" mode="out-in">
            <i v-if="!isMobileMenuOpen" class="pi pi-bars text-xl" key="menu"></i>
            <i v-else class="pi pi-times text-xl" key="close"></i>
          </Transition>
        </button>

        <!-- Brand Logo -->
        <div class="flex items-center">
          <Link :href="route('welcome')" class="flex items-center group">
            <div class="relative">
              <!-- Use QwikTest Logo Component with fallback -->
              <QwikTestLogo 
                v-if="!$page.props.general.logo_path || useDefaultLogo"
                :width="120" 
                :height="40" 
                class="h-8 lg:h-10 w-auto transition-all duration-300 group-hover:scale-105"
                :variant="isDark ? 'dark' : 'light'"
              />
              <img
                v-else
                class="h-8 lg:h-10 w-auto transition-all duration-300 group-hover:scale-105"
                :src="$page.props.assetUrl + $page.props.general.logo_path"
                :alt="$page.props.general.app_name"
              />
              <!-- Logo glow effect -->
              <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-lg blur-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
            </div>
            <span class="ml-3 text-xl lg:text-2xl font-bold bg-gradient-to-r from-indigo-600 to-purple-600 bg-clip-text text-transparent hidden sm:block">
              {{ $page.props.general.app_name || 'QwikTest' }}
            </span>
          </Link>
        </div>

        <!-- Desktop Navigation -->
                <nav class="hidden lg:flex items-center space-x-1">
                  <Link
                    :href="route('welcome')"
                    class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300 rounded-lg"
                    :class="{ 'text-indigo-600 dark:text-indigo-400': $page.url === '/' }"
                    @click="handleHomeClick($event)"
                  >
                    <span class="relative z-10">{{ __('Home') }}</span>
                    <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                  </Link>

                  <button
                    type="button"
                    class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300 rounded-lg"
                    @click="handleSectionClick('quicklinks')"
                  >
                    <span class="relative z-10">{{ __('Explore') }}</span>
                    <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                  </button>

                  <button
                    type="button"
                    class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300 rounded-lg"
                    @click="handleSectionClick('pricing')"
                  >
                    <span class="relative z-10">{{ __('Pricing') }}</span>
                    <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                  </button>

                  <button
                    type="button"
                    class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300 rounded-lg"
                    @click="handleSectionClick('features')"
                  >
                    <span class="relative z-10">{{ __('Features') }}</span>
                    <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                  </button>
                </nav>

        <!-- Right Side Actions -->
        <div class="flex items-center space-x-4">
          <!-- Theme Toggle -->
          <button
            @click="toggleTheme"
            class="p-2 rounded-xl text-gray-600 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500/30"
            aria-label="Toggle theme"
          >
            <Transition name="rotate" mode="out-in">
              <i v-if="isDark" class="pi pi-sun text-lg" key="sun"></i>
              <i v-else class="pi pi-moon text-lg" key="moon"></i>
            </Transition>
          </button>

          <!-- Authentication Buttons -->
          <div class="hidden lg:flex items-center space-x-3">
            <template v-if="!$page.props.auth.user">
              <Link
                :href="route('login')"
                class="px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-colors duration-200 rounded-lg"
              >
                {{ __('Sign In') }}
              </Link>
              
              <Link
                :href="route('register')"
                class="btn-primary group relative px-6 py-2.5 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transform hover:scale-105 hover:shadow-xl hover:shadow-indigo-500/25 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/30"
              >
                <span class="relative z-10">{{ __('Get Started') }}</span>
                <!-- Button shine effect -->
                <div class="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 transform -skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-700 rounded-xl"></div>
              </Link>
            </template>
            
            <template v-else>
              <Link
                :href="route('dashboard')"
                class="btn-primary group relative px-6 py-2.5 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transform hover:scale-105 hover:shadow-xl hover:shadow-indigo-500/25 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/30"
              >
                <span class="relative z-10">{{ __('Dashboard') }}</span>
                <div class="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 transform -skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-700 rounded-xl"></div>
              </Link>
            </template>
          </div>

          <!-- Mobile CTA -->
          <div class="lg:hidden">
            <Link
              :href="$page.props.auth.user ? route('dashboard') : route('register')"
              class="px-4 py-2 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-lg text-sm hover:from-indigo-700 hover:to-purple-700 transition-all duration-200"
            >
              {{ $page.props.auth.user ? __('Dashboard') : __('Start') }}
            </Link>
          </div>
        </div>
      </div>
    </div>

    <!-- Mobile Menu Overlay -->
    <Transition name="fade">
      <div
        v-if="isMobileMenuOpen"
        class="fixed inset-0 bg-black/50 backdrop-blur-sm z-40 lg:hidden"
        @click="closeMobileMenu"
      ></div>
    </Transition>

    <!-- Mobile Menu Panel -->
    <Transition name="slide-down">
      <div
        v-if="isMobileMenuOpen"
        class="absolute top-full left-0 right-0 bg-white/95 dark:bg-gray-900/95 backdrop-blur-xl border-b border-gray-200/50 dark:border-gray-700/50 shadow-xl z-50 lg:hidden"
      >
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
          <nav class="space-y-2">
            <!-- Mobile Navigation Links -->
            <Link
              :href="route('welcome')"
              class="block px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 rounded-xl font-medium transition-all duration-200"
              @click="handleHomeClick($event, true)"
            >
              <i class="pi pi-home mr-3 text-sm"></i>
              {{ __('Home') }}
            </Link>
            
            <button
              type="button"
              class="w-full text-left px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 rounded-xl font-medium transition-all duration-200"
              @click="handleSectionClick('quicklinks')"
            >
              <i class="pi pi-compass mr-3 text-sm"></i>
              {{ __('Explore') }}
            </button>
            
            <button
              type="button"
              class="w-full text-left px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 rounded-xl font-medium transition-all duration-200"
              @click="handleSectionClick('pricing')"
            >
              <i class="pi pi-credit-card mr-3 text-sm"></i>
              {{ __('Pricing') }}
            </button>
            
            <button
              type="button"
              class="w-full text-left px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 rounded-xl font-medium transition-all duration-200"
              @click="handleSectionClick('features')"
            >
              <i class="pi pi-star mr-3 text-sm"></i>
              {{ __('Features') }}
            </button>

            <!-- Mobile Auth Links -->
            <div v-if="!$page.props.auth.user" class="pt-4 border-t border-gray-200/50 dark:border-gray-700/50 space-y-2">
              <Link
                :href="route('login')"
                class="block px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/80 dark:hover:bg-gray-800/80 rounded-xl font-medium transition-all duration-200"
                @click="closeMobileMenu"
              >
                <i class="pi pi-sign-in mr-3 text-sm"></i>
                {{ __('Sign In') }}
              </Link>
              
              <Link
                :href="route('register')"
                class="block px-4 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white hover:from-indigo-700 hover:to-purple-700 rounded-xl font-semibold transition-all duration-200"
                @click="closeMobileMenu"
              >
                <i class="pi pi-user-plus mr-3 text-sm"></i>
                {{ __('Get Started') }}
              </Link>
            </div>
          </nav>
        </div>
      </div>
    </Transition>
  </header>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { Link, usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import QwikTestLogo from '@/Components/Icons/QwikTestLogo.vue'

// Props
defineProps({
  useDefaultLogo: {
    type: Boolean,
    default: true
  }
})

// Composables
const { __ } = useTranslate()
const page = usePage()

// Reactive state
const isMobileMenuOpen = ref(false)
const isScrolled = ref(false)
const isDark = ref(false)

// Computed properties
const headerClasses = computed(() => ({
  'header-scrolled': isScrolled.value,
  'shadow-lg': isScrolled.value
}))

// Methods
const toggleMobileMenu = () => {
  isMobileMenuOpen.value = !isMobileMenuOpen.value
}

const closeMobileMenu = () => {
  isMobileMenuOpen.value = false
}

const scrollToSection = async sectionId => {
  await nextTick()

  const element = document.getElementById(sectionId)

  if (element) {
    const headerOffset = 80
    const elementPosition = element.getBoundingClientRect().top + window.scrollY
    const offsetPosition = elementPosition - headerOffset

    window.scrollTo({
      top: offsetPosition < 0 ? 0 : offsetPosition,
      behavior: 'smooth'
    })
  }
}

const focusSection = sectionId => {
  closeMobileMenu()

  if (page.url !== '/') {
    router.visit(route('welcome'), {
      preserveScroll: true,
      preserveState: true,
      onSuccess: () => {
        requestAnimationFrame(() => scrollToSection(sectionId))
      }
    })
  } else {
    scrollToSection(sectionId)
  }
}

const handleSectionClick = sectionId => {
  focusSection(sectionId)
}

const handleHomeClick = (event, fromMobile = false) => {
  if (event?.preventDefault) {
    event.preventDefault()
  }

  if (fromMobile) {
    closeMobileMenu()
  }

  if (page.url !== '/') {
    router.visit(route('welcome'), {
      onSuccess: () => {
        requestAnimationFrame(() => scrollToSection('hero'))
      }
    })
  } else {
    scrollToSection('hero')
  }
}

const toggleTheme = () => {
  isDark.value = !isDark.value
  document.documentElement.classList.toggle('dark', isDark.value)
  localStorage.setItem('theme', isDark.value ? 'dark' : 'light')
}

const handleScroll = () => {
  isScrolled.value = window.scrollY > 20
}

// Lifecycle
onMounted(() => {
  // Initialize theme
  const savedTheme = localStorage.getItem('theme')
  const prefersDark = window.matchMedia('(prefers-color-scheme: dark)').matches
  isDark.value = savedTheme === 'dark' || (!savedTheme && prefersDark)
  document.documentElement.classList.toggle('dark', isDark.value)
  
  // Add scroll listener
  window.addEventListener('scroll', handleScroll)
  handleScroll() // Check initial scroll position

  if (window.location.hash) {
    const hash = window.location.hash.replace('#', '')
    if (hash) {
      requestAnimationFrame(() => scrollToSection(hash))
    }
  }
})

onUnmounted(() => {
  window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* Transitions */
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}

.slide-down-enter-active,
.slide-down-leave-active {
  transition: all 0.3s ease;
}

.slide-down-enter-from,
.slide-down-leave-to {
  opacity: 0;
  transform: translateY(-10px);
}

.rotate-enter-active,
.rotate-leave-active {
  transition: all 0.2s ease;
}

.rotate-enter-from,
.rotate-leave-to {
  opacity: 0;
  transform: rotate(90deg);
}

/* Header styles */
.modern-header {
  backdrop-filter: blur(20px);
  -webkit-backdrop-filter: blur(20px);
}

.header-scrolled {
  @apply bg-white/95 dark:bg-gray-900/95;
}

/* Navigation link hover effects */
.nav-link {
  position: relative;
  overflow: hidden;
}

.nav-link::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 50%;
  width: 0;
  height: 2px;
  background: linear-gradient(90deg, #6366f1, #8b5cf6);
  transition: all 0.3s ease;
  transform: translateX(-50%);
}

.nav-link:hover::before {
  width: 80%;
}

/* Button styles */
.btn-primary {
  position: relative;
  overflow: hidden;
}

.btn-primary:hover {
  box-shadow: 0 20px 25px -5px rgba(99, 102, 241, 0.25), 0 10px 10px -5px rgba(99, 102, 241, 0.1);
}

/* Dark mode adjustments */
@media (prefers-color-scheme: dark) {
  .modern-header {
    @apply border-gray-700/50;
  }
}
</style>