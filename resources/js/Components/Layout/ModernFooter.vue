<template>
  <!-- Ultra-Modern Footer -->
  <footer class="modern-footer relative overflow-hidden bg-gradient-to-br from-gray-900 via-gray-800 to-indigo-900 text-white">
    <!-- Background Effects -->
    <div class="absolute inset-0 bg-black/20"></div>
    <div class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-br from-indigo-500/10 to-purple-500/10 rounded-full blur-3xl"></div>
    <div class="absolute bottom-0 right-1/4 w-80 h-80 bg-gradient-to-br from-purple-500/10 to-pink-500/10 rounded-full blur-3xl"></div>
    
    <!-- Main Footer Content -->
    <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16 lg:py-20">
      <!-- Top Section -->
      <div class="grid grid-cols-1 lg:grid-cols-4 gap-12 lg:gap-8 mb-12">
        
        <!-- Brand Column -->
        <div class="lg:col-span-2 space-y-6">
          <!-- Logo and Brand -->
          <div class="flex items-center space-x-4 group">
            <div class="relative">
              <QwikTestLogo 
                :width="200" 
                :height="60" 
                class="h-12 w-auto transition-transform duration-300 group-hover:scale-105"
                variant="dark"
              />
              <!-- Logo glow effect -->
              <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/20 to-purple-500/20 rounded-lg blur-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
            </div>
            <div>
              <h3 class="text-2xl font-bold bg-gradient-to-r from-indigo-400 to-purple-400 bg-clip-text text-transparent">
                {{ $page.props.general.app_name || 'QwikTest' }}
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
            <h4 class="text-lg font-semibold text-white flex items-center">
              <i class="pi pi-envelope mr-2 text-indigo-400"></i>
              Stay Updated
            </h4>
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
                class="px-6 py-3 bg-gradient-to-r from-indigo-600 to-purple-600 hover:from-indigo-700 hover:to-purple-700 text-white font-semibold rounded-xl transition-all duration-300 transform hover:scale-105 hover:shadow-xl hover:shadow-indigo-500/25 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 disabled:opacity-50 disabled:cursor-not-allowed"
              >
                <span v-if="!isSubscribing">Subscribe</span>
                <i v-else class="pi pi-spin pi-spinner"></i>
              </button>
            </div>
            <p v-if="subscriptionMessage" class="text-sm" :class="subscriptionSuccess ? 'text-green-400' : 'text-red-400'">
              {{ subscriptionMessage }}
            </p>
          </div>

          <!-- Social Media Links -->
          <div class="flex space-x-4">
            <a
              v-for="social in socialLinks"
              :key="social.name"
              :href="social.url"
              :aria-label="social.name"
              class="p-3 bg-white/10 backdrop-blur-sm border border-white/20 rounded-xl text-gray-300 hover:text-white hover:bg-white/20 hover:border-white/30 transition-all duration-300 transform hover:scale-110 hover:shadow-lg"
            >
              <i :class="social.icon" class="text-lg"></i>
            </a>
          </div>
        </div>

        <!-- Quick Links -->
        <div class="space-y-6">
          <h4 class="text-lg font-semibold text-white flex items-center">
            <i class="pi pi-link mr-2 text-indigo-400"></i>
            Quick Links
          </h4>
          <ul class="space-y-3">
            <li v-for="link in quickLinks" :key="link.name">
              <button
                v-if="link.section"
                type="button"
                class="footer-link group flex w-full items-center text-left text-gray-300 hover:text-white transition-all duration-200"
                @click="handleQuickLink(link.section)"
              >
                <i :class="link.icon" class="mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                <span>{{ link.name }}</span>
                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
              </button>
              <Link
                v-else
                :href="link.url"
                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
              >
                <i :class="link.icon" class="mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                <span>{{ link.name }}</span>
                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
              </Link>
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
            <li v-for="link in supportLinks" :key="link.name">
              <Link
                :href="link.url"
                class="footer-link group flex items-center text-gray-300 hover:text-white transition-all duration-200"
              >
                <i :class="link.icon" class="mr-3 text-sm text-indigo-400 group-hover:text-indigo-300 transition-colors duration-200"></i>
                <span>{{ link.name }}</span>
                <i class="pi pi-arrow-right ml-auto text-xs opacity-0 group-hover:opacity-100 transform translate-x-0 group-hover:translate-x-1 transition-all duration-200"></i>
              </Link>
            </li>
          </ul>
        </div>
      </div>

      <!-- Stats Section -->
      <div class="grid grid-cols-2 lg:grid-cols-4 gap-8 py-12 border-t border-white/10">
        <div v-for="stat in stats" :key="stat.label" class="text-center group">
          <div class="relative">
            <div class="text-3xl lg:text-4xl font-bold text-white mb-2 group-hover:scale-110 transition-transform duration-300">
              {{ stat.value }}
            </div>
            <div class="text-gray-300 text-sm font-medium">
              {{ stat.label }}
            </div>
            <!-- Stat glow effect -->
            <div class="absolute inset-0 bg-gradient-to-r from-indigo-500/10 to-purple-500/10 rounded-lg blur-lg opacity-0 group-hover:opacity-100 transition-opacity duration-300 -z-10"></div>
          </div>
        </div>
      </div>

      <!-- Bottom Section -->
      <div class="border-t border-white/10 pt-8">
        <div class="flex flex-col lg:flex-row justify-between items-center space-y-4 lg:space-y-0">
          <!-- Copyright -->
          <div class="text-gray-300 text-sm">
            <p>&copy; {{ new Date().getFullYear() }} {{ $page.props.general.app_name }}. All rights reserved.</p>
          </div>

          <!-- Legal Links -->
          <div class="flex flex-wrap justify-center lg:justify-end space-x-6 text-sm">
            <Link
              v-for="legal in legalLinks"
              :key="legal.name"
              :href="legal.url"
              class="text-gray-300 hover:text-white transition-colors duration-200"
            >
              {{ legal.name }}
            </Link>
          </div>
        </div>
      </div>
    </div>

    <!-- Scroll to Top Button -->
    <Transition name="fade">
      <button
        v-if="showScrollTop"
        @click="scrollToTop"
        class="fixed bottom-8 right-8 p-3 bg-gradient-to-r from-indigo-600 to-purple-600 text-white rounded-full shadow-lg hover:shadow-xl hover:shadow-indigo-500/25 transform hover:scale-110 transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-indigo-500/50 z-40"
        aria-label="Scroll to top"
      >
        <i class="pi pi-arrow-up text-lg"></i>
      </button>
    </Transition>
  </footer>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { Link, usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import QwikTestLogo from '@/Components/Icons/QwikTestLogo.vue'

// Composables
const { __ } = useTranslate()
const page = usePage()

// Reactive state
const newsletterEmail = ref('')
const isSubscribing = ref(false)
const subscriptionMessage = ref('')
const subscriptionSuccess = ref(false)
const showScrollTop = ref(false)

// Static data
const socialLinks = [
  { name: 'Facebook', icon: 'pi pi-facebook', url: '#' },
  { name: 'Twitter', icon: 'pi pi-twitter', url: '#' },
  { name: 'LinkedIn', icon: 'pi pi-linkedin', url: '#' },
  { name: 'Instagram', icon: 'pi pi-instagram', url: '#' }
]

const quickLinks = [
  { name: __('Home'), icon: 'pi pi-home', section: 'hero' },
  { name: __('Quick Links'), icon: 'pi pi-compass', section: 'quicklinks' },
  { name: __('Features'), icon: 'pi pi-star', section: 'features' },
  { name: __('Pricing'), icon: 'pi pi-credit-card', section: 'pricing' },
  { name: __('Sign In'), icon: 'pi pi-sign-in', url: route('login') },
  { name: __('Create Account'), icon: 'pi pi-user-plus', url: route('register') }
]

const supportLinks = [
  { name: __('Help Center'), icon: 'pi pi-question-circle', url: '/help' },
  { name: __('Contact Us'), icon: 'pi pi-envelope', url: '/contact' },
  { name: __('FAQ'), icon: 'pi pi-list', url: '/faq' },
  { name: __('Documentation'), icon: 'pi pi-book', url: '/docs' }
]

const legalLinks = [
  { name: __('Privacy Policy'), url: '/privacy' },
  { name: __('Terms of Service'), url: '/terms' },
  { name: __('Cookie Policy'), url: '/cookies' }
]

const stats = [
  { value: '50K+', label: __('Active Students') },
  { value: '1M+', label: __('Questions Answered') },
  { value: '95%', label: __('Success Rate') },
  { value: '24/7', label: __('Support Available') }
]

const scrollToSection = sectionId => {
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

const handleQuickLink = sectionId => {
  if (sectionId) {
    if (window.location.pathname !== '/') {
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
}

// Methods
const subscribeNewsletter = async () => {
  if (!newsletterEmail.value || isSubscribing.value) return
  
  isSubscribing.value = true
  subscriptionMessage.value = ''
  
  try {
    // Simulate API call
    await new Promise(resolve => setTimeout(resolve, 1000))
    
    subscriptionSuccess.value = true
    subscriptionMessage.value = __('Successfully subscribed to our newsletter!')
    newsletterEmail.value = ''
  } catch (error) {
    subscriptionSuccess.value = false
    subscriptionMessage.value = __('Failed to subscribe. Please try again.')
  } finally {
    isSubscribing.value = false
    
    // Clear message after 5 seconds
    setTimeout(() => {
      subscriptionMessage.value = ''
    }, 5000)
  }
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

// Lifecycle
onMounted(() => {
  window.addEventListener('scroll', handleScroll)
  handleScroll()
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

/* Footer link hover effects */
.footer-link {
  position: relative;
  padding: 0.5rem 0;
}

.footer-link::before {
  content: '';
  position: absolute;
  bottom: 0;
  left: 0;
  width: 0;
  height: 1px;
  background: linear-gradient(90deg, #6366f1, #8b5cf6);
  transition: width 0.3s ease;
}

.footer-link:hover::before {
  width: 100%;
}

/* Background effects */
.modern-footer {
  position: relative;
}

.modern-footer::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 1px;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
}

/* Scroll to top button animation */
@keyframes bounce {
  0%, 20%, 50%, 80%, 100% {
    transform: translateY(0);
  }
  40% {
    transform: translateY(-10px);
  }
  60% {
    transform: translateY(-5px);
  }
}

.scroll-top:hover {
  animation: bounce 1s;
}
</style>