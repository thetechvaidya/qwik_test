<template>
    <section class="py-20 bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 relative overflow-hidden">
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
                            <i class="pi pi-users text-white text-3xl"></i>
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
                            <i class="pi pi-check-circle text-white text-3xl"></i>
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
                            <i class="pi pi-book text-white text-3xl"></i>
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
                        <i class="pi pi-shield text-green-600 text-xl"></i>
                        <span class="text-gray-700 font-medium">Secure & Trusted</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <i class="pi pi-verified text-blue-600 text-xl"></i>
                        <span class="text-gray-700 font-medium">Verified Platform</span>
                    </div>
                    <div class="flex items-center gap-2">
                        <i class="pi pi-heart text-red-500 text-xl"></i>
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
