<template>
    <section class="py-20 bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 relative overflow-hidden scroll-mt-24 sm:scroll-mt-32">
        <!-- Background Pattern -->
        <div class="absolute inset-0 opacity-30">
            <div class="absolute top-0 left-1/4 w-72 h-72 bg-gradient-to-br from-blue-400/20 to-indigo-500/20 rounded-full blur-3xl"></div>
            <div class="absolute bottom-0 right-1/4 w-96 h-96 bg-gradient-to-br from-purple-400/20 to-pink-500/20 rounded-full blur-3xl"></div>
        </div>

        <div class="container-modern relative">
            <!-- Section Header -->
            <div class="text-center mb-16 animate-fadeInUp">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6">
                    Trusted by <span class="text-gradient">Thousands</span>
                </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Join a growing community of successful learners who have transformed their careers with our platform
                </p>
            </div>

            <!-- Main Stats Grid -->
            <div ref="statsContainer" class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-5xl mx-auto mb-16">
                <!-- Students Count -->
                <div class="card-modern hover-lift group text-center p-8 bg-white/80 backdrop-blur-sm border border-white/20 shadow-modern">
                    <div class="stat-icon mb-6">
                        <div class="w-20 h-20 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center mx-auto group-hover:scale-110 transition-all duration-300 shadow-glow">
                            <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M16 4c0-1.11.89-2 2-2s2 .89 2 2-.89 2-2 2-2-.89-2-2zm4 18v-6h2.5l-2.54-7.63A3.014 3.014 0 0 0 16.68 6c-.8 0-1.54.37-2.01.99l-.7 1.06c-.56.85-.35 2 .47 2.58L16 11.5V22h4zM12.5 11.5c.28 0 .5-.22.5-.5s-.22-.5-.5-.5-.5.22-.5.5.22.5.5.5z"/>
                                <path d="M6 6c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm1 16h-2v-4.5l-2.5-1.5v-3c0-.8.7-1.5 1.5-1.5h4c.8 0 1.5.7 1.5 1.5v3L7 17.5V22z"/>
                            </svg>
                        </div>
                    </div>
                    <div class="stats-number text-5xl font-bold mb-3 text-gradient">
                        {{ displayStudentsCount.toLocaleString() }}+
                    </div>
                    <div class="text-lg font-semibold text-gray-900 mb-2">Active Students</div>
                    <div class="text-gray-600">Learning and growing every day</div>
                </div>

                <!-- Success Rate -->
                <div class="card-modern hover-lift group text-center p-8 bg-white/80 backdrop-blur-sm border border-white/20 shadow-modern">
                    <div class="stat-icon mb-6">
                        <div class="w-20 h-20 bg-gradient-to-br from-emerald-500 to-green-600 rounded-2xl flex items-center justify-center mx-auto group-hover:scale-110 transition-all duration-300 shadow-glow">
                            <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                            </svg>
                        </div>
                    </div>
                    <div class="stats-number text-5xl font-bold mb-3 text-gradient">
                        {{ formatPercentage(displaySuccessRate) }}
                    </div>
                    <div class="text-lg font-semibold text-gray-900 mb-2">Success Rate</div>
                    <div class="text-gray-600">Average test completion rate</div>
                </div>

                <!-- Tests Count -->
                <div class="card-modern hover-lift group text-center p-8 bg-white/80 backdrop-blur-sm border border-white/20 shadow-modern">
                    <div class="stat-icon mb-6">
                        <div class="w-20 h-20 bg-gradient-to-br from-purple-500 to-pink-600 rounded-2xl flex items-center justify-center mx-auto group-hover:scale-110 transition-all duration-300 shadow-glow">
                            <svg class="w-10 h-10 text-white" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M18 2H6c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zM6 4h5v8l-2.5-1.5L6 12V4z"/>
                            </svg>
                        </div>
                    </div>
                    <div class="stats-number text-5xl font-bold mb-3 text-gradient">
                        {{ displayTestsCount.toLocaleString() }}+
                    </div>
                    <div class="text-lg font-semibold text-gray-900 mb-2">Available Tests</div>
                    <div class="text-gray-600">Across multiple categories</div>
                </div>
            </div>

            <!-- Additional Stats Row -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-4xl mx-auto">
                <div class="glass-card text-center hover-scale group">
                    <div class="text-3xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">24/7</div>
                    <div class="text-gray-700 font-medium">Support</div>
                </div>
                <div class="glass-card text-center hover-scale group">
                    <div class="text-3xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">50+</div>
                    <div class="text-gray-700 font-medium">Categories</div>
                </div>
                <div class="glass-card text-center hover-scale group">
                    <div class="text-3xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">99.9%</div>
                    <div class="text-gray-700 font-medium">Uptime</div>
                </div>
                <div class="glass-card text-center hover-scale group">
                    <div class="text-3xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">4.9/5</div>
                    <div class="text-gray-700 font-medium">Rating</div>
                </div>
            </div>

            <!-- Trust Indicators -->
            <div class="mt-16 text-center">
                <div class="inline-flex items-center gap-8 p-6 bg-white/60 backdrop-blur-sm rounded-2xl border border-white/30 shadow-modern">
                    <div class="flex items-center gap-2">
                        <svg class="w-6 h-6 text-green-600" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12,1L3,5V11C3,16.55 6.84,21.74 12,23C17.16,21.74 21,16.55 21,11V5L12,1M10,17L6,13L7.41,11.59L10,14.17L16.59,7.58L18,9L10,17Z"/>
                        </svg>
                        <span class="text-gray-700 font-medium">Secure & Trusted</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg class="w-6 h-6 text-blue-600" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M23,12L20.56,9.22L20.9,5.54L17.29,4.72L15.4,1.54L12,3L8.6,1.54L6.71,4.72L3.1,5.53L3.44,9.21L1,12L3.44,14.78L3.1,18.47L6.71,19.29L8.6,22.47L12,21L15.4,22.46L17.29,19.28L20.9,18.46L20.56,14.78L23,12M10,17L6,13L7.41,11.59L10,14.17L16.59,7.58L18,9L10,17Z"/>
                        </svg>
                        <span class="text-gray-700 font-medium">Verified Platform</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <svg class="w-6 h-6 text-red-500" fill="currentColor" viewBox="0 0 24 24">
                            <path d="M12,21.35L10.55,20.03C5.4,15.36 2,12.27 2,8.5C2,5.41 4.42,3 7.5,3C9.24,3 10.91,3.81 12,5.08C13.09,3.81 14.76,3 16.5,3C19.58,3 22,5.41 22,8.5C22,12.27 18.6,15.36 13.45,20.03L12,21.35Z"/>
                        </svg>
                        <span class="text-gray-700 font-medium">Loved by Users</span>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'

// Props
const props = defineProps({
    studentsCount: {
        type: Number,
        default: 10000,
    },
    successRate: {
        type: Number,
        default: 95.5,
    },
    testsCount: {
        type: Number,
        default: 500,
    },
})

// Refs
const statsContainer = ref(null)
const displayStudentsCount = ref(0)
const displaySuccessRate = ref(0)
const displayTestsCount = ref(0)

// Animation state
const hasAnimated = ref(false)

// Methods
const formatPercentage = (value) => {
    return `${Math.round(value)}%`
}

const easeOutCubic = (t) => {
    return 1 - Math.pow(1 - t, 3)
}

const animateCounter = (start, end, duration, callback, easing = easeOutCubic) => {
    const startTime = performance.now()
    
    const animate = (currentTime) => {
        const elapsed = currentTime - startTime
        const progress = Math.min(elapsed / duration, 1)
        const easedProgress = easing(progress)
        const currentValue = start + (end - start) * easedProgress
        
        callback(Math.round(currentValue))
        
        if (progress < 1) {
            requestAnimationFrame(animate)
        }
    }
    
    requestAnimationFrame(animate)
}

const startCounterAnimations = () => {
    if (hasAnimated.value) return

    hasAnimated.value = true

    // Animate students count
    animateCounter(0, props.studentsCount, 2500, (value) => {
        displayStudentsCount.value = value
    })

    // Animate success rate
    animateCounter(0, props.successRate, 2200, (value) => {
        displaySuccessRate.value = value
    })

    // Animate tests count
    animateCounter(0, props.testsCount, 2000, (value) => {
        displayTestsCount.value = value
    })
}

// Lifecycle
onMounted(() => {
    if (statsContainer.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting && !hasAnimated.value) {
                        startCounterAnimations()
                        observer.unobserve(entry.target)
                    }
                })
            },
            {
                threshold: 0.3,
            }
        )

        observer.observe(statsContainer.value)
    }
})
</script>

<style scoped>
/* Custom animations for stats */
.stats-number {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    background-clip: text;
    -webkit-text-fill-color: transparent;
    font-family: 'Inter', system-ui, sans-serif;
    font-weight: 800;
    letter-spacing: -0.02em;
}

/* Enhanced card hover effects */
.card-modern:hover {
    transform: translateY(-8px);
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
}

/* Icon glow effect on hover */
.stat-icon div:hover {
    box-shadow: 0 0 30px rgba(99, 102, 241, 0.5);
}

/* Staggered animation delays */
.card-modern:nth-child(1) {
    animation-delay: 0ms;
}

.card-modern:nth-child(2) {
    animation-delay: 200ms;
}

.card-modern:nth-child(3) {
    animation-delay: 400ms;
}

/* Glass card enhancements */
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

/* Responsive adjustments */
@media (max-width: 768px) {
    .stats-number {
        font-size: 3rem;
    }
    
    .stat-icon div {
        width: 4rem;
        height: 4rem;
    }
    
    .stat-icon i {
        font-size: 1.5rem;
    }
    
    .card-modern {
        padding: 1.5rem;
    }
    
    .glass-card {
        padding: 1rem;
    }
}

/* Loading animation for numbers */
@keyframes countUp {
    from {
        opacity: 0;
        transform: translateY(20px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.stats-number {
    animation: countUp 0.6s ease-out;
}

/* Enhanced accessibility */
@media (prefers-reduced-motion: reduce) {
    .card-modern,
    .glass-card,
    .stat-icon div {
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
    .card-modern {
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
</style>
