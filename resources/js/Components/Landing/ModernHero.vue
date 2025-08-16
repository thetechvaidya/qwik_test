<template>
    <section
        class="hero-section relative overflow-hidden bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-500 text-white"
    >
        <!-- Background Effects -->
        <div class="absolute inset-0 bg-black/10"></div>
        <div
            class="absolute top-0 left-1/2 w-96 h-96 bg-white/10 rounded-full blur-3xl transform -translate-x-1/2 -translate-y-1/2"
        ></div>
        <div class="absolute bottom-0 right-0 w-80 h-80 bg-white/5 rounded-full blur-3xl"></div>

        <!-- Content -->
        <div class="relative container mx-auto px-6 py-20 lg:py-32">
            <div class="max-w-4xl mx-auto text-center">
                <!-- Hero Title with Animation -->
                <h1
                    class="text-4xl md:text-6xl lg:text-7xl font-bold mb-6 leading-tight"
                    :class="{ 'animate-fade-in-up': isVisible }"
                >
                    {{ title }}
                </h1>

                <!-- Hero Subtitle with Delayed Animation -->
                <p
                    class="text-xl md:text-2xl mb-10 text-white/90 max-w-3xl mx-auto leading-relaxed"
                    :class="{ 'animate-fade-in-up-delay': isVisible }"
                >
                    {{ subtitle }}
                </p>

                <!-- CTA Button with Hover Effects -->
                <div
                    class="flex flex-col sm:flex-row gap-4 justify-center items-center"
                    :class="{ 'animate-fade-in-up-delay-2': isVisible }"
                >
                    <Link
                        :href="ctaLink"
                        class="group relative px-8 py-4 bg-white text-indigo-600 font-semibold rounded-xl hover:bg-gray-50 transition-all duration-300 transform hover:scale-105 hover:shadow-xl focus:outline-none focus:ring-4 focus:ring-white/30"
                    >
                        <span class="relative z-10">{{ ctaText }}</span>
                        <div
                            class="absolute inset-0 bg-gradient-to-r from-white to-gray-50 rounded-xl opacity-0 group-hover:opacity-100 transition-opacity duration-300"
                        ></div>
                    </Link>

                    <button
                        class="group flex items-center gap-3 px-6 py-4 text-white/90 hover:text-white transition-colors duration-300"
                        @click="playDemo"
                    >
                        <div
                            class="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center group-hover:bg-white/30 transition-all duration-300"
                        >
                            <i class="pi pi-play text-white text-lg ml-1"></i>
                        </div>
                        <span class="font-medium">Watch Demo</span>
                    </button>
                </div>

                <!-- Stats Preview -->
                <div class="mt-16 grid grid-cols-3 gap-8 max-w-2xl mx-auto">
                    <div class="text-center">
                        <div class="text-2xl md:text-3xl font-bold mb-1">10K+</div>
                        <div class="text-white/70 text-sm">Students</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl md:text-3xl font-bold mb-1">95%</div>
                        <div class="text-white/70 text-sm">Success Rate</div>
                    </div>
                    <div class="text-center">
                        <div class="text-2xl md:text-3xl font-bold mb-1">500+</div>
                        <div class="text-white/70 text-sm">Tests</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scroll Indicator -->
        <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce">
            <i class="pi pi-chevron-down text-white/60 text-xl"></i>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'

// Props
defineProps({
    title: {
        type: String,
        default: 'Transform Your Learning Journey',
    },
    subtitle: {
        type: String,
        default: 'Master new skills with our comprehensive quiz platform designed for modern learners',
    },
    ctaText: {
        type: String,
        default: 'Start Learning Today',
    },
    ctaLink: {
        type: String,
        default: '/register',
    },
})

// Animation state
const isVisible = ref(false)

// Methods
const playDemo = () => {
    // Placeholder for demo functionality
    console.log('Demo video clicked')
}

// Lifecycle
onMounted(() => {
    // Trigger entrance animations
    setTimeout(() => {
        isVisible.value = true
    }, 100)
})
</script>

<style scoped>
.hero-section {
    min-height: 100vh;
    display: flex;
    align-items: center;
}

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
    animation: fadeInUp 0.8s ease-out forwards;
}

.animate-fade-in-up-delay {
    opacity: 0;
    animation: fadeInUp 0.8s ease-out 0.2s forwards;
}

.animate-fade-in-up-delay-2 {
    opacity: 0;
    animation: fadeInUp 0.8s ease-out 0.4s forwards;
}

/* Custom gradient background */
.hero-section::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: linear-gradient(
        135deg,
        rgba(99, 102, 241, 0.1) 0%,
        rgba(168, 85, 247, 0.1) 50%,
        rgba(236, 72, 153, 0.1) 100%
    );
    pointer-events: none;
}
</style>
