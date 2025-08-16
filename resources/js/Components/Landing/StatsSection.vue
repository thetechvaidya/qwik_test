<template>
    <section class="stats-section py-20 bg-gray-50">
        <div class="container mx-auto px-6">
            <div ref="statsContainer" class="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-4xl mx-auto">
                <!-- Students Count -->
                <div
                    class="stat-card text-center p-8 bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                >
                    <div class="stat-icon mb-4">
                        <div
                            class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-full flex items-center justify-center mx-auto"
                        >
                            <i class="pi pi-users text-white text-2xl"></i>
                        </div>
                    </div>
                    <div class="stat-number text-4xl font-bold text-gray-900 mb-2">
                        {{ displayStudentsCount.toLocaleString() }}+
                    </div>
                    <div class="stat-label text-gray-600 font-medium"> Active Students </div>
                    <div class="stat-description text-sm text-gray-500 mt-2"> Learning and growing every day </div>
                </div>

                <!-- Success Rate -->
                <div
                    class="stat-card text-center p-8 bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                >
                    <div class="stat-icon mb-4">
                        <div
                            class="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-full flex items-center justify-center mx-auto"
                        >
                            <i class="pi pi-check-circle text-white text-2xl"></i>
                        </div>
                    </div>
                    <div class="stat-number text-4xl font-bold text-gray-900 mb-2">
                        {{ formatPercentage(displaySuccessRate) }}
                    </div>
                    <div class="stat-label text-gray-600 font-medium"> Success Rate </div>
                    <div class="stat-description text-sm text-gray-500 mt-2"> Average test completion rate </div>
                </div>

                <!-- Tests Count -->
                <div
                    class="stat-card text-center p-8 bg-white rounded-2xl shadow-lg hover:shadow-xl transition-all duration-300 transform hover:-translate-y-1"
                >
                    <div class="stat-icon mb-4">
                        <div
                            class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-600 rounded-full flex items-center justify-center mx-auto"
                        >
                            <i class="pi pi-book text-white text-2xl"></i>
                        </div>
                    </div>
                    <div class="stat-number text-4xl font-bold text-gray-900 mb-2">
                        {{ displayTestsCount.toLocaleString() }}+
                    </div>
                    <div class="stat-label text-gray-600 font-medium"> Available Tests </div>
                    <div class="stat-description text-sm text-gray-500 mt-2"> Across multiple categories </div>
                </div>
            </div>

            <!-- Additional Stats Row -->
            <div class="mt-16 grid grid-cols-2 md:grid-cols-4 gap-6 max-w-3xl mx-auto">
                <div class="text-center">
                    <div class="text-2xl font-bold text-gray-900 mb-1">24/7</div>
                    <div class="text-gray-600 text-sm">Support</div>
                </div>
                <div class="text-center">
                    <div class="text-2xl font-bold text-gray-900 mb-1">50+</div>
                    <div class="text-gray-600 text-sm">Categories</div>
                </div>
                <div class="text-center">
                    <div class="text-2xl font-bold text-gray-900 mb-1">99.9%</div>
                    <div class="text-gray-600 text-sm">Uptime</div>
                </div>
                <div class="text-center">
                    <div class="text-2xl font-bold text-gray-900 mb-1">4.9/5</div>
                    <div class="text-gray-600 text-sm">Rating</div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'

import { useAnimations } from '@/composables/useAnimations'

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

// Composables
const { animateCounters, observeElement, formatPercentage } = useAnimations()

// Refs
const statsContainer = ref(null)
const displayStudentsCount = ref(0)
const displaySuccessRate = ref(0)
const displayTestsCount = ref(0)

// Animation state
const hasAnimated = ref(false)

// Methods
const startCounterAnimations = () => {
    if (hasAnimated.value) return

    hasAnimated.value = true

    animateCounters([
        {
            start: 0,
            end: props.studentsCount,
            duration: 2500,
            callback: value => {
                displayStudentsCount.value = value
            },
            easing: 'easeOutCubic',
        },
        {
            start: 0,
            end: props.successRate,
            duration: 2200,
            callback: value => {
                displaySuccessRate.value = value / 10 // Convert to proper decimal for percentage
            },
            easing: 'easeOutCubic',
        },
        {
            start: 0,
            end: props.testsCount,
            duration: 2000,
            callback: value => {
                displayTestsCount.value = value
            },
            easing: 'easeOutCubic',
        },
    ])
}

// Lifecycle
onMounted(() => {
    if (statsContainer.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            entries => {
                entries.forEach(entry => {
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
.stat-card {
    position: relative;
    overflow: hidden;
}

.stat-card::before {
    content: '';
    position: absolute;
    top: 0;
    left: -100%;
    width: 100%;
    height: 100%;
    background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
    transition: left 0.8s ease;
}

.stat-card:hover::before {
    left: 100%;
}

.stat-number {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    background-clip: text;
}

@keyframes countUp {
    from {
        transform: translateY(20px);
        opacity: 0;
    }
    to {
        transform: translateY(0);
        opacity: 1;
    }
}

.animate-count-up {
    animation: countUp 0.6s ease-out;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .stat-card {
        padding: 1.5rem;
    }

    .stat-number {
        font-size: 2.5rem;
    }
}
</style>
