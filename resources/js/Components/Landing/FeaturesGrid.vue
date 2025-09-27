<template>
    <section class="py-20 bg-white relative overflow-hidden scroll-mt-24 sm:scroll-mt-32">
        <!-- Background Pattern -->
        <div class="absolute inset-0 opacity-40">
            <div class="absolute top-1/4 left-0 w-96 h-96 bg-gradient-to-br from-indigo-400/10 to-purple-500/10 rounded-full blur-3xl"></div>
            <div class="absolute bottom-1/4 right-0 w-80 h-80 bg-gradient-to-br from-blue-400/10 to-cyan-500/10 rounded-full blur-3xl"></div>
        </div>

        <div class="container-modern relative">
            <!-- Section Header -->
            <div class="text-center mb-20 animate-fadeInUp">
                <h2 class="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
                    Why Choose <span class="text-gradient">Our Platform</span>?
                </h2>
                <p class="text-xl text-gray-600 max-w-4xl mx-auto leading-relaxed">
                    Discover the powerful features that make learning engaging, effective, and enjoyable for thousands of students worldwide.
                </p>
            </div>

            <!-- Features Grid -->
            <div ref="featuresGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8 max-w-7xl mx-auto mb-16">
                <div
                    v-for="(feature, index) in features"
                    :key="index"
                    class="feature-card group card-modern hover-lift p-8 text-center bg-white/80 backdrop-blur-sm border border-white/20 shadow-modern relative overflow-hidden"
                    :style="{ animationDelay: `${index * 100}ms` }"
                >
                    <!-- Hover Gradient Overlay -->
                    <div class="absolute inset-0 bg-gradient-to-br from-indigo-500/5 to-purple-500/5 opacity-0 group-hover:opacity-100 transition-all duration-500 rounded-2xl"></div>
                    
                    <!-- Feature Icon with SVG -->
                    <div class="feature-icon mb-6 relative z-10">
                        <div class="w-20 h-20 bg-gradient-primary rounded-2xl flex items-center justify-center mx-auto group-hover:scale-110 group-hover:rotate-3 transition-all duration-500 shadow-modern group-hover:shadow-glow">
                            <!-- Dynamic SVG Icons based on feature type -->
                            <svg v-if="feature.type === 'quiz'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M9 11H7v2h2v-2zm4 0h-2v2h2v-2zm4 0h-2v2h2v-2zm2-7H5c-1.1 0-2 .9-2 2v14l4-4h12c1.1 0 2-.9 2-2V6c0-1.1-.9-2-2-2zM9 9H7V7h2v2zm4 0h-2V7h2v2zm4 0h-2V7h2v2z"/>
                            </svg>
                            <svg v-else-if="feature.type === 'analytics'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zM9 17H7v-7h2v7zm4 0h-2V7h2v10zm4 0h-2v-4h2v4z"/>
                            </svg>
                            <svg v-else-if="feature.type === 'mobile'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M17 1.01L7 1c-1.1 0-2 .9-2 2v18c0 1.1.9 2 2 2h10c1.1 0 2-.9 2-2V3c0-1.1-.9-1.99-2-1.99zM17 19H7V5h10v14z"/>
                            </svg>
                            <svg v-else-if="feature.type === 'secure'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12,1L3,5V11C3,16.55 6.84,21.74 12,23C17.16,21.74 21,16.55 21,11V5L12,1M12,7C13.4,7 14.8,8.6 14.8,10V11H16.2V16H7.8V11H9.2V10C9.2,8.6 10.6,7 12,7M12,8.2C11.2,8.2 10.4,8.7 10.4,10V11H13.6V10C13.6,8.7 12.8,8.2 12,8.2Z"/>
                            </svg>
                            <svg v-else-if="feature.type === 'fast'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M13,1L8.5,8.5L1,9L6,14L5,22L13,18L21,22L20,14L24,9L16.5,8.5L13,1Z"/>
                            </svg>
                            <svg v-else-if="feature.type === 'support'" class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                            </svg>
                            <svg v-else class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2l3.09 6.26L22 9l-5 4.87L18.18 21 12 17.27 5.82 21 7 13.87 2 9l6.91-1.74L12 2z"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Feature Content -->
                    <div class="feature-content relative z-10">
                        <h3 class="text-xl font-bold text-gray-900 mb-4 group-hover:text-gradient transition-all duration-300">
                            {{ feature.title }}
                        </h3>
                        <p class="text-gray-600 leading-relaxed group-hover:text-gray-700 transition-colors duration-300">
                            {{ feature.description }}
                        </p>
                    </div>

                    <!-- Shimmer Effect -->
                    <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700">
                        <div class="absolute top-0 left-0 w-full h-full bg-gradient-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                    </div>
                </div>
            </div>

            <!-- Enhanced CTA Section -->
            <div class="text-center">
                <div class="inline-flex flex-col md:flex-row items-center gap-6 p-8 bg-gradient-to-br from-indigo-50 via-white to-purple-50 rounded-3xl border border-indigo-100 shadow-modern hover-lift max-w-4xl mx-auto">
                    <div class="flex-shrink-0">
                        <div class="w-16 h-16 bg-gradient-primary rounded-2xl flex items-center justify-center shadow-glow">
                            <i class="pi pi-lightbulb text-white text-2xl"></i>
                        </div>
                    </div>
                    <div class="text-center md:text-left flex-grow">
                        <h3 class="text-2xl font-bold text-gray-900 mb-2">Ready to experience these features?</h3>
                        <p class="text-gray-600">Join thousands of learners already benefiting from our comprehensive platform</p>
                    </div>
                    <div class="flex flex-col sm:flex-row gap-4">
                        <Link
                            href="/register"
                            class="btn-modern px-8 py-4 bg-gradient-primary text-white font-semibold rounded-xl hover-lift shadow-modern hover:shadow-glow transition-all duration-300"
                        >
                            Get Started Free
                        </Link>
                        <Link
                            href="/demo"
                            class="px-8 py-4 border-2 border-indigo-200 text-indigo-600 font-semibold rounded-xl hover:bg-indigo-50 hover:border-indigo-300 transition-all duration-300"
                        >
                            Watch Demo
                        </Link>
                    </div>
                </div>
            </div>

            <!-- Feature Stats -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 mt-16 max-w-4xl mx-auto">
                <div class="glass-card text-center hover-scale">
                    <div class="text-2xl font-bold text-gradient mb-1">100%</div>
                    <div class="text-gray-600 text-sm">Feature Complete</div>
                </div>
                <div class="glass-card text-center hover-scale">
                    <div class="text-2xl font-bold text-gradient mb-1">24/7</div>
                    <div class="text-gray-600 text-sm">Always Available</div>
                </div>
                <div class="glass-card text-center hover-scale">
                    <div class="text-2xl font-bold text-gradient mb-1">∞</div>
                    <div class="text-gray-600 text-sm">Unlimited Access</div>
                </div>
                <div class="glass-card text-center hover-scale">
                    <div class="text-2xl font-bold text-gradient mb-1">⚡</div>
                    <div class="text-gray-600 text-sm">Lightning Fast</div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'

// Props
const props = defineProps({
    features: {
        type: Array,
        default: () => [
            {
                icon: 'pi pi-chart-line',
                title: 'Advanced Analytics',
                description: 'Track your progress with detailed analytics and performance insights that help you understand your learning patterns and identify areas for improvement.',
            },
            {
                icon: 'pi pi-mobile',
                title: 'Mobile Optimized',
                description: 'Learn anywhere, anytime with our responsive mobile-first design that adapts seamlessly to any device, ensuring a perfect experience on all screens.',
            },
            {
                icon: 'pi pi-shield',
                title: 'Enterprise Security',
                description: 'Your data is protected with enterprise-grade security measures and industry-standard encryption protocols, ensuring complete privacy and safety.',
            },
            {
                icon: 'pi pi-users',
                title: 'Community Driven',
                description: 'Join thousands of learners in our supportive community where knowledge sharing, collaboration, and peer learning create lasting connections.',
            },
            {
                icon: 'pi pi-clock',
                title: 'Flexible Learning',
                description: 'Study at your own pace with flexible scheduling options that fit your busy lifestyle, allowing you to balance learning with other commitments.',
            },
            {
                icon: 'pi pi-trophy',
                title: 'Gamification',
                description: 'Stay motivated with achievement badges, leaderboards, and rewards that make learning fun, engaging, and addictive in the best possible way.',
            },
            {
                icon: 'pi pi-bookmark',
                title: 'AI-Powered Content',
                description: 'Get personalized content recommendations tailored to your learning style, progress, and interests using advanced machine learning algorithms.',
            },
            {
                icon: 'pi pi-heart',
                title: 'Expert Support',
                description: 'Access round-the-clock support from our dedicated team of learning experts who are always ready to help you succeed and overcome challenges.',
            },
        ],
    },
})

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
            card.classList.add('animate-slideInUp')
        }, index * 100)
    })
}

// Lifecycle
onMounted(() => {
    if (featuresGrid.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
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
/* Feature card initial state */
.feature-card {
    opacity: 0;
    transform: translateY(30px);
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.feature-card.animate-slideInUp {
    animation: slideInUp 0.8s ease-out forwards;
}

@keyframes slideInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Enhanced hover effects */
.feature-card:hover {
    transform: translateY(-12px);
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
}

.feature-card:hover .feature-icon div {
    box-shadow: 0 0 30px rgba(99, 102, 241, 0.4);
}

/* Icon shimmer effect */
.feature-icon div::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
    transition: left 0.8s ease;
}

.feature-card:hover .feature-icon div::before {
    left: 100%;
}

/* Text gradient effect on hover */
.feature-card:hover h3 {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
}

/* Glass card styling */
.glass-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 1rem;
    padding: 1.5rem;
    transition: all 0.3s ease;
}

.glass-card:hover {
    background: rgba(255, 255, 255, 0.8);
    transform: translateY(-4px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

/* Button enhancements */
.btn-modern {
    position: relative;
    overflow: hidden;
}

.btn-modern::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.2), transparent);
    transition: left 0.5s;
}

.btn-modern:hover::before {
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
    
    .feature-icon div {
        width: 4rem;
        height: 4rem;
    }
    
    .feature-icon i {
        font-size: 1.5rem;
    }
}

/* Staggered animation delays */
.feature-card:nth-child(1) { animation-delay: 0ms; }
.feature-card:nth-child(2) { animation-delay: 100ms; }
.feature-card:nth-child(3) { animation-delay: 200ms; }
.feature-card:nth-child(4) { animation-delay: 300ms; }
.feature-card:nth-child(5) { animation-delay: 400ms; }
.feature-card:nth-child(6) { animation-delay: 500ms; }
.feature-card:nth-child(7) { animation-delay: 600ms; }
.feature-card:nth-child(8) { animation-delay: 700ms; }

/* Enhanced accessibility */
@media (prefers-reduced-motion: reduce) {
    .feature-card,
    .glass-card,
    .feature-icon div,
    .btn-modern {
        transition: none;
        animation: none;
    }
    
    .hover-lift:hover,
    .hover-scale:hover {
        transform: none;
    }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .feature-card {
        background: rgba(31, 41, 55, 0.8);
        color: white;
        border-color: rgba(255, 255, 255, 0.1);
    }
    
    .glass-card {
        background: rgba(31, 41, 55, 0.7);
        color: white;
        border-color: rgba(255, 255, 255, 0.1);
    }
}

/* Pulse animation for icons */
@keyframes iconPulse {
    0%, 100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.05);
    }
}

.feature-card:hover .feature-icon div {
    animation: iconPulse 2s infinite;
}
</style>
