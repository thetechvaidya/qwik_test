<template>
    <div class="min-h-screen bg-gradient-to-br from-gray-50 via-white to-indigo-50">
        <!-- Modern Navigation -->
        <ModernHeader :showSearch="false" />

        <!-- Hero Section -->
        <ModernHero
            v-if="sections.hero.enabled"
            :title="sections.hero.title"
            :subtitle="sections.hero.subtitle"
            :cta-text="sections.hero.cta_text"
            :cta-link="sections.hero.cta_link"
        />

        <!-- Stats Section -->
        <StatsSection
            v-if="sections.stats.enabled"
            :students-count="sections.stats.students_count"
            :success-rate="sections.stats.success_rate"
            :tests-count="sections.stats.tests_count"
        />

        <!-- Features Section -->
        <FeaturesGrid v-if="sections.features.enabled" :features="sections.features.list" />

        <!-- Pricing Section -->
        <PricingSection v-if="sections.pricing.enabled" :plans="sections.pricing.plans" />

        <!-- Testimonials Section -->
        <TestimonialsCarousel v-if="sections.testimonials.enabled" :testimonials="sections.testimonials.list" />

        <!-- Enhanced CTA Section -->
        <section
            v-if="sections.cta.enabled"
            class="relative py-20 lg:py-24 overflow-hidden"
        >
            <!-- Background Effects -->
            <div class="absolute inset-0 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600"></div>
            <div class="absolute inset-0 bg-black/20"></div>
            <div class="absolute top-0 left-1/4 w-96 h-96 bg-gradient-to-br from-white/10 to-transparent rounded-full blur-3xl"></div>
            <div class="absolute bottom-0 right-1/4 w-80 h-80 bg-gradient-to-br from-purple-400/20 to-transparent rounded-full blur-3xl"></div>
            
            <div class="relative max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
                <!-- Main CTA Content -->
                <div class="max-w-4xl mx-auto">
                    <h2 class="text-4xl lg:text-5xl font-bold text-white mb-6 leading-tight">
                        Ready to <span class="bg-gradient-to-r from-yellow-300 to-orange-300 bg-clip-text text-transparent">Transform</span> Your Learning Journey?
                    </h2>
                    <p class="text-xl lg:text-2xl text-indigo-100 mb-8 leading-relaxed">
                        Join over <strong class="text-yellow-300">50,000+</strong> learners who are already mastering new skills with our interactive quiz platform.
                    </p>
                    
                    <!-- CTA Buttons -->
                    <div class="flex flex-col sm:flex-row justify-center items-center gap-4 mb-12">
                        <Link
                            href="/register"
                            class="group relative inline-flex items-center px-8 py-4 text-lg font-semibold text-indigo-600 bg-white rounded-2xl hover:bg-gray-50 transform hover:scale-105 transition-all duration-300 shadow-xl hover:shadow-2xl focus:outline-none focus:ring-4 focus:ring-white/30"
                        >
                            <i class="pi pi-rocket mr-3 text-indigo-600 group-hover:animate-bounce"></i>
                            Get Started Free
                            <i class="pi pi-arrow-right ml-3 text-indigo-600 transform group-hover:translate-x-1 transition-transform duration-200"></i>
                        </Link>
                        <Link
                            href="/login"
                            class="group inline-flex items-center px-8 py-4 text-lg font-semibold text-white bg-white/10 backdrop-blur-sm border border-white/20 rounded-2xl hover:bg-white/20 hover:border-white/30 transform hover:scale-105 transition-all duration-300 shadow-lg hover:shadow-xl focus:outline-none focus:ring-4 focus:ring-white/30"
                        >
                            <i class="pi pi-sign-in mr-3 group-hover:animate-pulse"></i>
                            Sign In
                        </Link>
                    </div>
                    
                    <!-- Trust Indicators -->
                    <div class="flex flex-col sm:flex-row justify-center items-center gap-8 text-indigo-100">
                        <div class="flex items-center">
                            <div class="flex -space-x-2 mr-3">
                                <div class="w-8 h-8 bg-gradient-to-br from-yellow-400 to-orange-500 rounded-full border-2 border-white"></div>
                                <div class="w-8 h-8 bg-gradient-to-br from-green-400 to-blue-500 rounded-full border-2 border-white"></div>
                                <div class="w-8 h-8 bg-gradient-to-br from-purple-400 to-pink-500 rounded-full border-2 border-white"></div>
                                <div class="w-8 h-8 bg-gradient-to-br from-indigo-400 to-purple-500 rounded-full border-2 border-white flex items-center justify-center text-xs font-bold text-white">+</div>
                            </div>
                            <span class="text-sm font-medium">50K+ Active Learners</span>
                        </div>
                        <div class="flex items-center">
                            <div class="flex text-yellow-300 mr-2">
                                <i class="pi pi-star-fill"></i>
                                <i class="pi pi-star-fill"></i>
                                <i class="pi pi-star-fill"></i>
                                <i class="pi pi-star-fill"></i>
                                <i class="pi pi-star-fill"></i>
                            </div>
                            <span class="text-sm font-medium">4.9/5 Rating</span>
                        </div>
                        <div class="flex items-center">
                            <i class="pi pi-shield-check mr-2 text-green-300"></i>
                            <span class="text-sm font-medium">100% Free to Start</span>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- Modern Footer -->
        <ModernFooter v-if="legacy_settings.enable_footer" />
    </div>
</template>

<script setup>
import { Head, Link } from '@inertiajs/vue3'
import ModernHeader from '@/Components/Layout/ModernHeader.vue'
import ModernFooter from '@/Components/Layout/ModernFooter.vue'
import ModernHero from '@/Components/Landing/ModernHero.vue'
import StatsSection from '@/Components/Landing/StatsSection.vue'
import FeaturesGrid from '@/Components/Landing/FeaturesGrid.vue'
import PricingSection from '@/Components/Landing/PricingSection.vue'
import TestimonialsCarousel from '@/Components/Landing/TestimonialsCarousel.vue'

// Props from the controller
const props = defineProps({
    site: {
        type: Object,
        required: true,
    },
    sections: {
        type: Object,
        required: true,
    },
    legacy_settings: {
        type: Object,
        required: true,
    },
})

// Page title
const pageTitle = `${props.site.name} - Transform Your Learning Journey`
</script>

<style scoped>
.landing-page {
    min-height: 100vh;
}

/* Smooth scroll behavior */
html {
    scroll-behavior: smooth;
}

/* Add some global modern styling */
.container {
    max-width: 1200px;
}

/* Enhanced button hover effects */
.btn-hover {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-hover:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

/* Gradient text effects */
.gradient-text {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* Loading animations */
@keyframes fadeInUp {
    from {
        opacity: 0;
        transform: translateY(30px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.animate-fade-in-up {
    animation: fadeInUp 0.6s ease-out;
}

/* Custom scrollbar for modern look */
::-webkit-scrollbar {
    width: 8px;
}

::-webkit-scrollbar-track {
    background: #f1f1f1;
}

::-webkit-scrollbar-thumb {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
    background: linear-gradient(135deg, #5a67d8 0%, #6b46c1 100%);
}
</style>
