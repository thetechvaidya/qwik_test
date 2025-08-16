<template>
    <section class="features-section py-20 bg-white">
        <div class="container mx-auto px-6">
            <!-- Section Header -->
            <div class="text-center mb-16">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6"> Why Choose Our Platform? </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Discover the features that make learning engaging, effective, and enjoyable for thousands of
                    students worldwide.
                </p>
            </div>

            <!-- Features Grid -->
            <div
                ref="featuresGrid"
                class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 max-w-7xl mx-auto"
            >
                <div
                    v-for="(feature, index) in features"
                    :key="index"
                    class="feature-card group p-8 bg-gradient-to-br from-gray-50 to-white rounded-2xl border border-gray-100 hover:border-indigo-200 hover:shadow-xl transition-all duration-300 transform hover:-translate-y-2"
                    :style="{ animationDelay: `${index * 100}ms` }"
                >
                    <!-- Feature Icon -->
                    <div class="feature-icon mb-6">
                        <div
                            class="w-16 h-16 bg-gradient-to-br from-indigo-500 to-purple-600 rounded-xl flex items-center justify-center group-hover:scale-110 transition-transform duration-300"
                        >
                            <i :class="(feature.icon || 'pi pi-star') + ' text-white text-2xl'"></i>
                        </div>
                    </div>

                    <!-- Feature Content -->
                    <div class="feature-content">
                        <h3
                            class="text-xl font-bold text-gray-900 mb-3 group-hover:text-indigo-600 transition-colors duration-300"
                        >
                            {{ feature.title }}
                        </h3>
                        <p class="text-gray-600 leading-relaxed">
                            {{ feature.description }}
                        </p>
                    </div>

                    <!-- Hover Effect Overlay -->
                    <div
                        class="absolute inset-0 bg-gradient-to-br from-indigo-500/5 to-purple-500/5 rounded-2xl opacity-0 group-hover:opacity-100 transition-opacity duration-300 pointer-events-none"
                    ></div>
                </div>
            </div>

            <!-- CTA Section -->
            <div class="text-center mt-16">
                <div
                    class="inline-flex items-center gap-4 p-6 bg-gradient-to-r from-indigo-50 to-purple-50 rounded-2xl border border-indigo-100"
                >
                    <i class="pi pi-lightbulb text-indigo-600 text-2xl"></i>
                    <div class="text-left">
                        <div class="font-semibold text-gray-900">Ready to experience these features?</div>
                        <div class="text-gray-600 text-sm"
                            >Join thousands of learners already benefiting from our platform</div
                        >
                    </div>
                    <Link
                        href="/register"
                        class="px-6 py-3 bg-indigo-600 text-white font-semibold rounded-lg hover:bg-indigo-700 transition-colors duration-300"
                    >
                        Get Started
                    </Link>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'

import { useAnimations } from '@/composables/useAnimations'

// Props
const props = defineProps({
    features: {
        type: Array,
        default: () => [
            {
                icon: 'pi pi-chart-line',
                title: 'Advanced Analytics',
                description:
                    'Track your progress with detailed analytics and performance insights that help you understand your learning patterns.',
            },
            {
                icon: 'pi pi-mobile',
                title: 'Mobile Friendly',
                description:
                    'Learn anywhere, anytime with our responsive mobile-first design that adapts to any device seamlessly.',
            },
            {
                icon: 'pi pi-shield',
                title: 'Secure Platform',
                description:
                    'Your data is protected with enterprise-grade security measures and industry-standard encryption protocols.',
            },
            {
                icon: 'pi pi-users',
                title: 'Community Driven',
                description:
                    'Join thousands of learners in our supportive community where knowledge sharing and collaboration thrive.',
            },
            {
                icon: 'pi pi-clock',
                title: 'Flexible Scheduling',
                description:
                    'Study at your own pace with flexible scheduling options that fit your busy lifestyle and commitments.',
            },
            {
                icon: 'pi pi-trophy',
                title: 'Gamification',
                description:
                    'Stay motivated with achievement badges, leaderboards, and rewards that make learning fun and engaging.',
            },
            {
                icon: 'pi pi-bookmark',
                title: 'Personalized Content',
                description:
                    'Get content recommendations tailored to your learning style, progress, and interests for optimal results.',
            },
            {
                icon: 'pi pi-heart',
                title: '24/7 Support',
                description:
                    'Access round-the-clock support from our dedicated team of experts who are always ready to help you succeed.',
            },
        ],
    },
})

// Composables
const { staggerChildren, observeElement } = useAnimations()

// Refs
const featuresGrid = ref(null)

// Animation state
const hasAnimated = ref(false)

// Methods
const animateFeatures = () => {
    if (hasAnimated.value || !featuresGrid.value) return

    hasAnimated.value = true

    // Add staggered animation to feature cards
    const cards = featuresGrid.value.querySelectorAll('.feature-card')
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('animate-slide-in-up')
        }, index * 100)
    })
}

// Lifecycle
onMounted(() => {
    if (featuresGrid.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            entries => {
                entries.forEach(entry => {
                    if (entry.isIntersecting && !hasAnimated.value) {
                        animateFeatures()
                        observer.unobserve(entry.target)
                    }
                })
            },
            {
                threshold: 0.2,
            }
        )

        observer.observe(featuresGrid.value)
    }
})
</script>

<style scoped>
.feature-card {
    position: relative;
    opacity: 0;
    transform: translateY(30px);
}

.feature-card.animate-slide-in-up {
    animation: slideInUp 0.6s ease-out forwards;
}

@keyframes slideInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Gradient text effect for feature titles */
.feature-card:hover h3 {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

/* Icon hover effects */
.feature-icon div {
    position: relative;
    overflow: hidden;
}

.feature-icon div::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.3), transparent);
    transition: left 0.6s ease;
}

.feature-card:hover .feature-icon div::before {
    left: 100%;
}

/* Responsive grid adjustments */
@media (max-width: 1280px) {
    .features-grid {
        grid-template-columns: repeat(3, 1fr);
    }
}

@media (max-width: 1024px) {
    .features-grid {
        grid-template-columns: repeat(2, 1fr);
    }
}

@media (max-width: 768px) {
    .features-grid {
        grid-template-columns: 1fr;
    }

    .feature-card {
        padding: 1.5rem;
    }
}

/* Enhanced hover states */
.feature-card:hover {
    background: linear-gradient(135deg, #f8fafc 0%, #ffffff 100%);
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
}

/* Pulse effect for icons */
@keyframes pulse {
    0%,
    100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
}

.feature-card:hover .feature-icon div {
    animation: pulse 2s infinite;
}
</style>
