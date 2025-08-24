<template>
    <!-- Modern Navigation Bar with Glassmorphism -->
    <nav class="modern-navbar fixed top-0 left-0 right-0 z-50 transition-all duration-300" :class="navbarClasses">
        <!-- Background blur overlay -->
        <div class="absolute inset-0 bg-white/80 dark:bg-gray-900/80 backdrop-blur-md border-b border-white/20 dark:border-gray-700/30"></div>
        
        <!-- Navigation Content -->
        <div class="relative container-modern">
            <div class="flex items-center justify-between h-16 lg:h-20">
                <!-- Mobile Menu Button -->
                <button
                    type="button"
                    class="lg:hidden p-2 rounded-xl text-gray-600 dark:text-gray-300 hover:text-gray-900 dark:hover:text-white hover:bg-gray-100/50 dark:hover:bg-gray-800/50 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500/20"
                    @click="toggleMobileMenu"
                    :aria-expanded="isMobileMenuOpen"
                    aria-label="Toggle navigation menu"
                >
                    <Transition name="rotate" mode="out-in">
                        <i v-if="!isMobileMenuOpen" class="pi pi-bars text-xl" key="menu"></i>
                        <i v-else class="pi pi-times text-xl" key="close"></i>
                    </Transition>
                </button>

                <!-- Logo -->
                <div class="flex items-center">
                    <Link :href="route('welcome')" class="flex items-center group">
                        <div class="relative">
                            <img
                                class="h-8 lg:h-10 w-auto transition-transform duration-300 group-hover:scale-105"
                                :src="$page.props.assetUrl + $page.props.general.logo_path"
                                :alt="$page.props.general.app_name"
                            />
                            <!-- Logo glow effect on hover -->
                            <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-lg blur-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
                        </div>
                        <span class="ml-3 text-xl lg:text-2xl font-bold text-gradient hidden sm:block">
                            {{ $page.props.general.app_name }}
                        </span>
                    </Link>
                </div>

                <!-- Desktop Navigation Links -->
                <div class="hidden lg:flex items-center space-x-8">
                    <Link
                        :href="route('welcome')"
                        class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300"
                    >
                        <span class="relative z-10">{{ __('Home') }}</span>
                        <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    </Link>
                    
                    <Link
                        :href="route('welcome') + '#explore'"
                        class="nav-link group relative px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-all duration-300"
                    >
                        <span class="relative z-10">{{ __('Explore') }}</span>
                        <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300"></div>
                    </Link>

                    <!-- Search Button (if needed) -->
                    <button
                        v-if="showSearch"
                        @click="toggleSearch"
                        class="p-2 rounded-xl text-gray-600 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 transition-all duration-200 focus:outline-none focus:ring-2 focus:ring-indigo-500/20"
                        aria-label="Search"
                    >
                        <i class="pi pi-search text-lg"></i>
                    </button>
                </div>

                <!-- CTA Buttons -->
                <div class="hidden lg:flex items-center space-x-4">
                    <Link
                        v-if="!$page.props.auth.user"
                        :href="route('login')"
                        class="px-4 py-2 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 font-medium transition-colors duration-200"
                    >
                        {{ __('Sign In') }}
                    </Link>
                    
                    <Link
                        :href="$page.props.auth.user ? route('dashboard') : route('register')"
                        class="btn-modern group relative px-6 py-2.5 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transform hover:scale-105 hover:shadow-glow transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/20"
                    >
                        <span class="relative z-10">
                            {{ $page.props.auth.user ? __('Dashboard') : __('Get Started') }}
                        </span>
                        <!-- Button shine effect -->
                        <div class="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 transform -skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-700 rounded-xl"></div>
                    </Link>
                </div>

                <!-- Mobile CTA Button -->
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
                class="absolute top-full left-0 right-0 bg-white/95 dark:bg-gray-900/95 backdrop-blur-md border-b border-white/20 dark:border-gray-700/30 shadow-modern-lg z-50 lg:hidden"
            >
                <div class="container-modern py-6">
                    <div class="space-y-4">
                        <!-- Mobile Navigation Links -->
                        <Link
                            :href="route('welcome')"
                            class="block px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-xl font-medium transition-all duration-200"
                            @click="closeMobileMenu"
                        >
                            <i class="pi pi-home mr-3 text-sm"></i>
                            {{ __('Home') }}
                        </Link>
                        
                        <Link
                            :href="route('welcome') + '#explore'"
                            class="block px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-xl font-medium transition-all duration-200"
                            @click="closeMobileMenu"
                        >
                            <i class="pi pi-compass mr-3 text-sm"></i>
                            {{ __('Explore') }}
                        </Link>

                        <!-- Mobile Auth Links -->
                        <div v-if="!$page.props.auth.user" class="pt-4 border-t border-gray-200/50 dark:border-gray-700/50 space-y-3">
                            <Link
                                :href="route('login')"
                                class="block px-4 py-3 text-gray-700 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-gray-100/50 dark:hover:bg-gray-800/50 rounded-xl font-medium transition-all duration-200"
                                @click="closeMobileMenu"
                            >
                                <i class="pi pi-sign-in mr-3 text-sm"></i>
                                {{ __('Sign In') }}
                            </Link>
                            
                            <Link
                                :href="route('register')"
                                class="block px-4 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 text-center"
                                @click="closeMobileMenu"
                            >
                                <i class="pi pi-user-plus mr-3 text-sm"></i>
                                {{ __('Get Started') }}
                            </Link>
                        </div>
                        
                        <div v-else class="pt-4 border-t border-gray-200/50 dark:border-gray-700/50">
                            <Link
                                :href="route('dashboard')"
                                class="block px-4 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white font-semibold rounded-xl hover:from-indigo-700 hover:to-purple-700 transition-all duration-200 text-center"
                                @click="closeMobileMenu"
                            >
                                <i class="pi pi-th-large mr-3 text-sm"></i>
                                {{ __('Dashboard') }}
                            </Link>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>

        <!-- Search Overlay (if implemented) -->
        <Transition name="fade">
            <div
                v-if="isSearchOpen"
                class="fixed inset-0 bg-black/50 backdrop-blur-sm z-50"
                @click="closeSearch"
            >
                <div class="flex items-start justify-center pt-20 px-4">
                    <div class="bg-white dark:bg-gray-900 rounded-2xl shadow-modern-lg p-6 w-full max-w-2xl" @click.stop>
                        <div class="flex items-center space-x-4">
                            <i class="pi pi-search text-gray-400 text-xl"></i>
                            <input
                                ref="searchInput"
                                type="text"
                                placeholder="Search courses, topics..."
                                class="flex-1 bg-transparent text-lg text-gray-900 dark:text-white placeholder-gray-400 focus:outline-none"
                                v-model="searchQuery"
                                @keyup.enter="performSearch"
                            />
                            <button
                                @click="closeSearch"
                                class="p-2 text-gray-400 hover:text-gray-600 dark:hover:text-gray-300 transition-colors"
                            >
                                <i class="pi pi-times text-lg"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </Transition>
    </nav>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { Link } from '@inertiajs/vue3'

// Reactive state
const isMobileMenuOpen = ref(false)
const isSearchOpen = ref(false)
const isScrolled = ref(false)
const searchQuery = ref('')
const searchInput = ref(null)

// Props
const props = defineProps({
    showSearch: {
        type: Boolean,
        default: false,
    },
})

// Computed properties
const navbarClasses = computed(() => ({
    'navbar-scrolled': isScrolled.value,
    'shadow-modern': isScrolled.value,
}))

// Methods
const toggleMobileMenu = () => {
    isMobileMenuOpen.value = !isMobileMenuOpen.value
    // Prevent body scroll when menu is open
    if (isMobileMenuOpen.value) {
        document.body.style.overflow = 'hidden'
    } else {
        document.body.style.overflow = ''
    }
}

const closeMobileMenu = () => {
    isMobileMenuOpen.value = false
    document.body.style.overflow = ''
}

const toggleSearch = async () => {
    isSearchOpen.value = !isSearchOpen.value
    if (isSearchOpen.value) {
        await nextTick()
        searchInput.value?.focus()
    }
}

const closeSearch = () => {
    isSearchOpen.value = false
    searchQuery.value = ''
}

const performSearch = () => {
    if (searchQuery.value.trim()) {
        // Implement search functionality
        console.log('Searching for:', searchQuery.value)
        closeSearch()
    }
}

const handleScroll = () => {
    isScrolled.value = window.scrollY > 20
}

// Lifecycle hooks
onMounted(() => {
    window.addEventListener('scroll', handleScroll)
    // Close mobile menu on route change
    window.addEventListener('popstate', closeMobileMenu)
})

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll)
    window.removeEventListener('popstate', closeMobileMenu)
    document.body.style.overflow = ''
})

// Close mobile menu on escape key
const handleKeydown = (event) => {
    if (event.key === 'Escape') {
        if (isMobileMenuOpen.value) {
            closeMobileMenu()
        }
        if (isSearchOpen.value) {
            closeSearch()
        }
    }
}

onMounted(() => {
    document.addEventListener('keydown', handleKeydown)
})

onUnmounted(() => {
    document.removeEventListener('keydown', handleKeydown)
})
</script>

<style scoped>
/* Modern navbar styling */
.modern-navbar {
    backdrop-filter: blur(12px);
    -webkit-backdrop-filter: blur(12px);
}

.navbar-scrolled {
    background: rgba(255, 255, 255, 0.9);
    backdrop-filter: blur(20px);
    -webkit-backdrop-filter: blur(20px);
}

@media (prefers-color-scheme: dark) {
    .navbar-scrolled {
        background: rgba(17, 24, 39, 0.9);
    }
}

/* Navigation link hover effects */
.nav-link::after {
    content: '';
    position: absolute;
    bottom: -2px;
    left: 50%;
    width: 0;
    height: 2px;
    background: linear-gradient(90deg, #6366f1, #8b5cf6);
    transition: all 0.3s ease;
    transform: translateX(-50%);
}

.nav-link:hover::after {
    width: 80%;
}

/* Button shine animation */
@keyframes shine {
    0% {
        transform: translateX(-100%) skewX(-12deg);
    }
    100% {
        transform: translateX(200%) skewX(-12deg);
    }
}

/* Transition animations */
.fade-enter-active,
.fade-leave-active {
    transition: opacity 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
}

.slide-down-enter-active {
    transition: all 0.3s ease;
}

.slide-down-leave-active {
    transition: all 0.2s ease;
}

.slide-down-enter-from {
    opacity: 0;
    transform: translateY(-10px);
}

.slide-down-leave-to {
    opacity: 0;
    transform: translateY(-5px);
}

.rotate-enter-active,
.rotate-leave-active {
    transition: all 0.2s ease;
}

.rotate-enter-from {
    opacity: 0;
    transform: rotate(90deg) scale(0.8);
}

.rotate-leave-to {
    opacity: 0;
    transform: rotate(-90deg) scale(0.8);
}

/* Responsive adjustments */
@media (max-width: 1024px) {
    .modern-navbar {
        padding: 0 1rem;
    }
}

/* Accessibility improvements */
@media (prefers-reduced-motion: reduce) {
    .modern-navbar,
    .nav-link,
    .btn-modern,
    .fade-enter-active,
    .fade-leave-active,
    .slide-down-enter-active,
    .slide-down-leave-active,
    .rotate-enter-active,
    .rotate-leave-active {
        transition: none !important;
        animation: none !important;
    }
}

/* Focus styles for accessibility */
.nav-link:focus,
.btn-modern:focus {
    outline: 2px solid #6366f1;
    outline-offset: 2px;
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    .modern-navbar {
        background: white;
        border-bottom: 2px solid black;
    }
    
    .nav-link {
        color: black;
    }
    
    .nav-link:hover {
        background: black;
        color: white;
    }
}
</style>
