<template>
    <div class="min-h-screen bg-white font-inter pt-20 md:pt-24">
        <Head :title="pageTitle" />
        <!-- Professional Navigation -->
        <ModernHeader :showSearch="false" />

        <!-- Hero Section -->
        <ModernHero
            id="hero"
            v-if="sections.hero.enabled"
            :title="sections.hero.title"
            :subtitle="sections.hero.subtitle"
            :cta-text="sections.hero.cta_text"
            :cta-link="sections.hero.cta_link"
            :hero-image="sections.hero.image_path"
        />

        <!-- Stats Section -->
        <StatsSection
            id="quicklinks"
            v-if="sections.stats.enabled"
            :students-count="sections.stats.students_count"
            :success-rate="sections.stats.success_rate"
            :tests-count="sections.stats.tests_count"
        />

        <!-- Features Section -->
        <FeaturesGrid
            id="features"
            v-if="sections.features.enabled"
            :features="sections.features.list"
        />

        <!-- Pricing Section -->
        <PricingSection
            id="pricing"
            v-if="sections.pricing.enabled"
            :plans="sections.pricing.plans"
        />

        <!-- Testimonials Section -->
        <TestimonialsCarousel
            id="testimonials"
            v-if="sections.testimonials.enabled"
            :testimonials="sections.testimonials.list"
        />

        <!-- Conversion-Focused CTA Section -->
        <section
            id="cta"
            v-if="sections.cta.enabled"
            class="relative py-24 bg-slate-900 overflow-hidden scroll-mt-24 sm:scroll-mt-32"
        >
            <!-- Background Pattern -->
            <div class="absolute inset-0 opacity-5">
                <div class="absolute inset-0" style="background-image: radial-gradient(circle at 1px 1px, rgba(255,255,255,0.3) 1px, transparent 0); background-size: 20px 20px;"></div>
            </div>
            
            <div class="relative max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Main CTA Content -->
                <div class="text-center">
                    <h2 class="text-4xl lg:text-6xl font-bold text-white mb-6 leading-tight">
                        Start Your <span class="text-blue-400">Learning Journey</span> Today
                    </h2>
                    <p class="text-xl lg:text-2xl text-slate-300 mb-12 max-w-3xl mx-auto leading-relaxed">
                        Join thousands of professionals who trust our platform to accelerate their career growth and skill development.
                    </p>
                    
                    <!-- Primary CTA -->
                    <div class="mb-8">
                        <Link
                            href="/register"
                            class="inline-flex items-center px-10 py-5 text-xl font-semibold text-white bg-blue-600 hover:bg-blue-700 rounded-lg shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-300 focus:outline-none focus:ring-4 focus:ring-blue-500/50"
                        >
                            <i class="pi pi-rocket mr-3"></i>
                            Get Started Free
                            <i class="pi pi-arrow-right ml-3"></i>
                        </Link>
                    </div>
                    
                    <!-- Secondary CTA -->
                    <div class="mb-12">
                        <p class="text-slate-400 mb-4">Already have an account?</p>
                        <Link
                            href="/login"
                            class="inline-flex items-center px-8 py-3 text-lg font-medium text-blue-400 hover:text-blue-300 border border-blue-400/30 hover:border-blue-400/50 rounded-lg transition-all duration-300 focus:outline-none focus:ring-2 focus:ring-blue-400/50"
                        >
                            <i class="pi pi-sign-in mr-2"></i>
                            Sign In to Continue
                        </Link>
                    </div>
                    
                    <!-- Trust Indicators -->
                    <div class="grid grid-cols-1 md:grid-cols-3 gap-8 text-slate-300">
                        <div class="flex flex-col items-center">
                            <div class="w-12 h-12 bg-blue-600 rounded-full flex items-center justify-center mb-3">
                                <i class="pi pi-users text-white text-xl"></i>
                            </div>
                            <div class="text-2xl font-bold text-white mb-1">{{ sections.stats.students_count.toLocaleString() }}+</div>
                            <div class="text-sm">Active Learners</div>
                        </div>
                        <div class="flex flex-col items-center">
                            <div class="w-12 h-12 bg-green-600 rounded-full flex items-center justify-center mb-3">
                                <i class="pi pi-chart-line text-white text-xl"></i>
                            </div>
                            <div class="text-2xl font-bold text-white mb-1">{{ sections.stats.success_rate }}%</div>
                            <div class="text-sm">Success Rate</div>
                        </div>
                        <div class="flex flex-col items-center">
                            <div class="w-12 h-12 bg-purple-600 rounded-full flex items-center justify-center mb-3">
                                <i class="pi pi-check-circle text-white text-xl"></i>
                            </div>
                            <div class="text-2xl font-bold text-white mb-1">{{ sections.stats.tests_count }}+</div>
                            <div class="text-sm">Tests Available</div>
                        </div>
                    </div>
                    
                    <!-- Social Proof -->
                    <div class="mt-16 pt-12 border-t border-slate-700">
                        <p class="text-slate-400 text-sm mb-6">Trusted by leading companies and educational institutions</p>
                        <div class="flex flex-wrap justify-center items-center gap-8 opacity-60">
                            <div class="text-slate-500 font-semibold">Company A</div>
                            <div class="text-slate-500 font-semibold">University B</div>
                            <div class="text-slate-500 font-semibold">Tech Corp C</div>
                            <div class="text-slate-500 font-semibold">Academy D</div>
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
/* Import Inter font */
@import url('https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap');

.font-inter {
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}

/* Professional styling */
.landing-page {
    min-height: 100vh;
}

/* Smooth scroll behavior */
html {
    scroll-behavior: smooth;
}

/* Enhanced button hover effects */
.btn-hover {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

.btn-hover:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
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
    background: #3b82f6;
    border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
    background: #2563eb;
}
</style>
