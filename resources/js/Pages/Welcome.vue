<template>
    <div class="landing-page">
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

        <!-- CTA Section -->
        <section
            v-if="sections.cta.enabled"
            class="cta-section py-20 bg-gradient-to-r from-indigo-600 to-purple-600 text-white"
        >
            <div class="container mx-auto px-6 text-center">
                <div class="max-w-4xl mx-auto">
                    <h2 class="text-4xl md:text-5xl font-bold mb-6"> Ready to Transform Your Learning? </h2>
                    <p class="text-xl mb-10 opacity-90">
                        Join thousands of successful learners who have already started their journey with us.
                    </p>
                    <div class="flex flex-col sm:flex-row gap-4 justify-center">
                        <Link
                            href="/register"
                            class="px-8 py-4 bg-white text-indigo-600 font-semibold rounded-xl hover:bg-gray-50 transition-all duration-300 transform hover:scale-105"
                        >
                            Get Started for Free
                        </Link>
                        <Link
                            href="/login"
                            class="px-8 py-4 border-2 border-white text-white font-semibold rounded-xl hover:bg-white hover:text-indigo-600 transition-all duration-300"
                        >
                            Sign In
                        </Link>
                    </div>
                </div>
            </div>
        </section>

        <!-- Footer -->
        <footer v-if="legacy_settings.enable_footer" class="bg-gray-900 text-white py-16">
            <div class="container mx-auto px-6">
                <div class="grid grid-cols-1 md:grid-cols-4 gap-8">
                    <!-- Brand Column -->
                    <div class="md:col-span-2">
                        <div class="flex items-center gap-3 mb-4">
                            <img v-if="site.logo" :src="site.logo" :alt="site.name" class="h-10 w-auto" />
                            <span class="text-2xl font-bold">{{ site.name }}</span>
                        </div>
                        <p class="text-gray-400 mb-6 max-w-md">
                            {{ site.description }}
                        </p>
                        <div class="flex gap-4">
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <i class="pi pi-facebook text-xl"></i>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <i class="pi pi-twitter text-xl"></i>
                            </a>
                            <a href="#" class="text-gray-400 hover:text-white transition-colors">
                                <i class="pi pi-linkedin text-xl"></i>
                            </a>
                        </div>
                    </div>

                    <!-- Quick Links -->
                    <div>
                        <h3 class="text-lg font-semibold mb-4">Quick Links</h3>
                        <ul class="space-y-2">
                            <li
                                ><Link href="/about" class="text-gray-400 hover:text-white transition-colors"
                                    >About Us</Link
                                ></li
                            >
                            <li
                                ><Link href="/features" class="text-gray-400 hover:text-white transition-colors"
                                    >Features</Link
                                ></li
                            >
                            <li
                                ><Link href="/pricing" class="text-gray-400 hover:text-white transition-colors"
                                    >Pricing</Link
                                ></li
                            >
                            <li
                                ><Link href="/contact" class="text-gray-400 hover:text-white transition-colors"
                                    >Contact</Link
                                ></li
                            >
                        </ul>
                    </div>

                    <!-- Support -->
                    <div>
                        <h3 class="text-lg font-semibold mb-4">Support</h3>
                        <ul class="space-y-2">
                            <li
                                ><Link href="/help" class="text-gray-400 hover:text-white transition-colors"
                                    >Help Center</Link
                                ></li
                            >
                            <li
                                ><Link href="/faq" class="text-gray-400 hover:text-white transition-colors"
                                    >FAQ</Link
                                ></li
                            >
                            <li
                                ><Link href="/privacy" class="text-gray-400 hover:text-white transition-colors"
                                    >Privacy Policy</Link
                                ></li
                            >
                            <li
                                ><Link href="/terms" class="text-gray-400 hover:text-white transition-colors"
                                    >Terms of Service</Link
                                ></li
                            >
                        </ul>
                    </div>
                </div>

                <div class="border-t border-gray-800 mt-12 pt-8 text-center text-gray-400">
                    <p>&copy; {{ new Date().getFullYear() }} {{ site.name }}. All rights reserved.</p>
                </div>
            </div>
        </footer>
    </div>
</template>

<script setup>
import { Head, Link } from '@inertiajs/vue3'
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
