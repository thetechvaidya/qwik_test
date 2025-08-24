<template>
    <footer class="modern-footer relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-indigo-900 text-white">
        <!-- Background Effects -->
        <div class="absolute inset-0 bg-black/20"></div>
        <div class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-br from-indigo-500/10 to-purple-500/10 rounded-full blur-3xl"></div>
        <div class="absolute bottom-0 right-1/4 w-80 h-80 bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-full blur-3xl"></div>
        
        <!-- Main Footer Content -->
        <div class="relative container-modern py-16 lg:py-20">
            <!-- Top Section -->
            <div class="grid grid-cols-1 lg:grid-cols-4 gap-12 lg:gap-8 mb-12">
                <!-- Brand Column -->
                <div class="lg:col-span-2 space-y-6">
                    <!-- Logo and Brand -->
                    <div class="flex items-center space-x-4 group">
                        <div class="relative">
                            <img
                                class="h-12 w-auto transition-transform duration-300 group-hover:scale-105"
                                :src="$page.props.assetUrl + $page.props.general.white_logo_path"
                                :alt="$page.props.general.app_name"
                            />
                            <!-- Logo glow effect -->
                            <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-lg blur-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
                        </div>
                        <div>
                            <h3 class="text-2xl font-bold text-gradient">
                                {{ $page.props.general.app_name }}
                            </h3>
                            <p class="text-gray-300 text-sm mt-1">
                                {{ $page.props.general.tag_line }}
                            </p>
                        </div>
                    </div>

                    <!-- Description -->
                    <p class="text-gray-300 text-lg leading-relaxed max-w-md">
                        Transform your learning journey with our comprehensive quiz platform designed for modern learners. 
                        Join thousands of successful students worldwide.
                    </p>

                    <!-- Newsletter Signup -->
                    <div class="space-y-4">
                        <h4 class="text-lg font-semibold text-white">Stay Updated</h4>
                        <div class="flex flex-col sm:flex-row gap-3 max-w-md">
                            <div class="flex-1">
                                <input
                                    v-model="newsletterEmail"
                                    type="email"
                                    placeholder="Enter your email"
                                    class="w-full px-4 py-3 bg-white/10 backdrop-blur-sm border border-white/20 rounded-xl text-white placeholder-gray-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 focus:border-indigo-400 transition-all duration-200"
                                />
                            </div>
                            <button
                                @click="subscribeNewsletter"
                                :disabled="isSubscribing"
                                class="px-6 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white font-semibold rounded-xl transition-all duration-300 transform hover:scale-105 hover:shadow-glow focus:outline-none focus:ring-2 focus:ring-indigo-500/50 disabled:opacity-50 disabled:cursor-not-allowed"
                            >
                                <span v-if="!isSubscribing">Subscribe</span>
                                <i v-else class="pi pi-spin pi-spinner"></i>
                            </button>
                        </div>
                        <p v-if="subscriptionMessage" class="text-sm" :class="subscriptionSuccess ? 'text-green-400' : 'text-red-400'">
                            {{ subscriptionMessage }}
                        </p>
                    </div>
                </div>

                <!-- Quick Links -->
                <div class="space-y-6">
                    <h4 class="text-lg font-semibold text-white flex items-center">
                        <i class="pi pi-link mr-2 text-indigo-400"></i>
                        Quick Links
                    </h4>
                    <ul class="space-y-3">
                        <li>
                            <Link
                                :href="route('welcome')"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-home mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Home</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </Link>
                        </li>
                        <li>
                            <Link
                                :href="route('welcome') + '#explore'"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-compass mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Explore Courses</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </Link>
                        </li>
                        <li>
                            <a
                                href="#features"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-star mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Features</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                        <li>
                            <a
                                href="#pricing"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-tag mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Pricing</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                    </ul>
                </div>

                <!-- Support Links -->
                <div class="space-y-6">
                    <h4 class="text-lg font-semibold text-white flex items-center">
                        <i class="pi pi-question-circle mr-2 text-indigo-400"></i>
                        Support
                    </h4>
                    <ul class="space-y-3">
                        <li>
                            <a
                                href="/help"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-info-circle mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Help Center</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                        <li>
                            <a
                                href="/contact"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-envelope mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Contact Us</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                        <li>
                            <a
                                href="/privacy"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-shield mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Privacy Policy</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                        <li>
                            <a
                                href="/terms"
                                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                            >
                                <i class="pi pi-file-text mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                <span>Terms of Service</span>
                                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                            </a>
                        </li>
                    </ul>

                    <!-- Custom Footer Links -->
                    <template v-if="footerSettings.enable_links">
                        <ul class="space-y-3 pt-4 border-t border-white/10">
                            <li v-for="footerLink in footerSettings.footer_links" :key="footerLink[0]">
                                <a
                                    v-if="footerLink[2]"
                                    :href="footerLink[1]"
                                    class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
                                >
                                    <i class="pi pi-external-link mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                                    <span>{{ footerLink[0] }}</span>
                                    <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
                                </a>
                            </li>
                        </ul>
                    </template>
                </div>
            </div>

            <!-- Social Media Section -->
            <div v-if="footerSettings.enable_social_links" class="mb-12">
                <div class="text-center space-y-6">
                    <h4 class="text-lg font-semibold text-white">Connect With Us</h4>
                    <div class="flex justify-center space-x-6">
                        <template v-for="(socialLink, key) in footerSettings.social_links" :key="key">
                            <a
                                v-if="socialLink[1]"
                                :href="socialLink[2]"
                                target="_blank"
                                rel="noopener noreferrer"
                                class="social-link group relative p-4 bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl hover:bg-white/20 hover:border-white/30 transition-all duration-300 transform hover:scale-110 hover:shadow-glow focus:outline-none focus:ring-2 focus:ring-indigo-500/50"
                                :aria-label="socialLink[0]"
                            >
                                <!-- Social Icons -->
                                <i
                                    v-if="key === 'facebook'"
                                    class="pi pi-facebook text-2xl text-white group-hover:text-blue-400 transition-colors duration-300"
                                ></i>
                                <i
                                    v-else-if="key === 'twitter'"
                                    class="pi pi-twitter text-2xl text-white group-hover:text-blue-400 transition-colors duration-300"
                                ></i>
                                <i
                                    v-else-if="key === 'instagram'"
                                    class="pi pi-instagram text-2xl text-white group-hover:text-pink-400 transition-colors duration-300"
                                ></i>
                                <i
                                    v-else-if="key === 'youtube'"
                                    class="pi pi-youtube text-2xl text-white group-hover:text-red-400 transition-colors duration-300"
                                ></i>
                                <i
                                    v-else-if="key === 'linkedin'"
                                    class="pi pi-linkedin text-2xl text-white group-hover:text-blue-500 transition-colors duration-300"
                                ></i>
                                <i
                                    v-else-if="key === 'github'"
                                    class="pi pi-github text-2xl text-white group-hover:text-gray-300 transition-colors duration-300"
                                ></i>
                                
                                <!-- Hover glow effect -->
                                <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10 blur-lg"></div>
                            </a>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Trust Indicators -->
            <div class="mb-12">
                <div class="flex flex-wrap justify-center items-center gap-8 p-6 bg-white/5 backdrop-blur-sm rounded-2xl border border-white/10">
                    <div class="flex items-center space-x-3 text-gray-300">
                        <div class="p-2 bg-green-500/20 rounded-lg">
                            <i class="pi pi-shield text-green-400 text-lg"></i>
                        </div>
                        <div>
                            <div class="font-semibold text-white">Secure & Trusted</div>
                            <div class="text-sm text-gray-400">SSL Encrypted</div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-3 text-gray-300">
                        <div class="p-2 bg-blue-500/20 rounded-lg">
                            <i class="pi pi-verified text-blue-400 text-lg"></i>
                        </div>
                        <div>
                            <div class="font-semibold text-white">Verified Platform</div>
                            <div class="text-sm text-gray-400">ISO Certified</div>
                        </div>
                    </div>
                    <div class="flex items-center space-x-3 text-gray-300">
                        <div class="p-2 bg-red-500/20 rounded-lg">
                            <i class="pi pi-heart text-red-400 text-lg"></i>
                        </div>
                        <div>
                            <div class="font-semibold text-white">Loved by Users</div>
                            <div class="text-sm text-gray-400">4.9/5 Rating</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Bottom Section -->
            <div class="pt-8 border-t border-white/10">
                <div class="flex flex-col lg:flex-row justify-between items-center space-y-4 lg:space-y-0">
                    <!-- Copyright -->
                    <div class="text-center lg:text-left">
                        <p class="text-gray-300">
                            <span class="font-medium">© {{ new Date().getFullYear() }} {{ $page.props.general.app_name }}.</span>
                            <span class="ml-2">{{ footerSettings.copyright_text || 'All rights reserved.' }}</span>
                        </p>
                    </div>

                    <!-- Additional Info -->
                    <div class="flex items-center space-x-6 text-sm text-gray-400">
                        <span class="flex items-center">
                            <i class="pi pi-map-marker mr-2 text-indigo-400"></i>
                            Made with ❤️ worldwide
                        </span>
                        <span class="flex items-center">
                            <i class="pi pi-clock mr-2 text-indigo-400"></i>
                            24/7 Support
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scroll to Top Button -->
        <Transition name="fade">
            <button
                v-if="showScrollTop"
                @click="scrollToTop"
                class="fixed bottom-8 right-8 p-4 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-full shadow-modern-lg hover:shadow-glow transform hover:scale-110 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 z-50"
                aria-label="Scroll to top"
            >
                <i class="pi pi-chevron-up text-lg"></i>
            </button>
        </Transition>
    </footer>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Link } from '@inertiajs/vue3'

// Props
defineProps({
    footerSettings: {
        type: Object,
        default: () => ({
            enable_social_links: true,
            enable_links: true,
            social_links: {},
            footer_links: [],
            copyright_text: 'All rights reserved.',
        }),
    },
})

// Reactive state
const newsletterEmail = ref('')
const isSubscribing = ref(false)
const subscriptionMessage = ref('')
const subscriptionSuccess = ref(false)
const showScrollTop = ref(false)

// Methods
const subscribeNewsletter = async () => {
    if (!newsletterEmail.value || !isValidEmail(newsletterEmail.value)) {
        subscriptionMessage.value = 'Please enter a valid email address.'
        subscriptionSuccess.value = false
        return
    }

    isSubscribing.value = true
    subscriptionMessage.value = ''

    try {
        // Simulate API call - replace with actual implementation
        await new Promise(resolve => setTimeout(resolve, 1000))
        
        subscriptionMessage.value = 'Thank you for subscribing! Check your email for confirmation.'
        subscriptionSuccess.value = true
        newsletterEmail.value = ''
    } catch (error) {
        subscriptionMessage.value = 'Something went wrong. Please try again later.'
        subscriptionSuccess.value = false
    } finally {
        isSubscribing.value = false
        
        // Clear message after 5 seconds
        setTimeout(() => {
            subscriptionMessage.value = ''
        }, 5000)
    }
}

const isValidEmail = (email) => {
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/
    return emailRegex.test(email)
}

const scrollToTop = () => {
    window.scrollTo({
        top: 0,
        behavior: 'smooth'
    })
}

const handleScroll = () => {
    showScrollTop.value = window.scrollY > 500
}

// Lifecycle hooks
onMounted(() => {
    window.addEventListener('scroll', handleScroll)
})

onUnmounted(() => {
    window.removeEventListener('scroll', handleScroll)
})
</script>

<style scoped>
/* Modern footer styling */
.modern-footer {
    position: relative;
    background: linear-gradient(135deg, #1f2937 0%, #111827 50%, #312e81 100%);
}

/* Footer link hover effects */
.footer-link {
    position: relative;
    padding: 0.5rem 0;
    border-radius: 0.5rem;
    transition: all 0.3s ease;
}

.footer-link:hover {
    background: rgba(255, 255, 255, 0.05);
    padding-left: 0.5rem;
    padding-right: 0.5rem;
}

/* Social link hover effects */
.social-link::before {
    content: '';
    position: absolute;
    inset: 0;
    border-radius: 1rem;
    padding: 2px;
    background: linear-gradient(135deg, #6366f1, #8b5cf6, #ec4899);
    mask: linear-gradient(#fff 0 0) content-box, linear-gradient(#fff 0 0);
    mask-composite: xor;
    opacity: 0;
    transition: opacity 0.3s ease;
}

.social-link:hover::before {
    opacity: 1;
}

/* Newsletter input focus effects */
.newsletter-input:focus {
    background: rgba(255, 255, 255, 0.15);
    border-color: #6366f1;
    box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.1);
}

/* Gradient text effect */
.text-gradient {
    background: linear-gradient(135deg, #6366f1 0%, #8b5cf6 50%, #ec4899 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* Transition animations */
.fade-enter-active,
.fade-leave-active {
    transition: all 0.3s ease;
}

.fade-enter-from,
.fade-leave-to {
    opacity: 0;
    transform: translateY(10px);
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .modern-footer {
        padding: 3rem 1rem;
    }
    
    .social-link {
        padding: 0.75rem;
    }
}

/* Accessibility improvements */
@media (prefers-reduced-motion: reduce) {
    .footer-link,
    .social-link,
    .fade-enter-active,
    .fade-leave-active {
        transition: none !important;
        animation: none !important;
    }
    
    .footer-link:hover {
        transform: none !important;
    }
    
    .social-link:hover {
        transform: none !important;
    }
}

/* Focus styles for accessibility */
.footer-link:focus,
.social-link:focus {
    outline: 2px solid #6366f1;
    outline-offset: 2px;
}

/* High contrast mode support */
@media (prefers-contrast: high) {
    .modern-footer {
        background: black;
        color: white;
        border-top: 2px solid white;
    }
    
    .footer-link {
        color: white;
    }
    
    .footer-link:hover {
        background: white;
        color: black;
    }
    
    .social-link {
        border: 2px solid white;
        background: black;
    }
    
    .social-link:hover {
        background: white;
        color: black;
    }
}

/* Print styles */
@media print {
    .modern-footer {
        background: white !important;
        color: black !important;
    }
    
    .social-link,
    .newsletter-signup,
    .scroll-to-top {
        display: none;
    }
}
</style>
