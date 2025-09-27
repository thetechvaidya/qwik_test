<template>
    <section
        class="hero-section relative overflow-hidden bg-gradient-to-br from-indigo-900 via-purple-900 to-pink-900 text-white scroll-mt-24 sm:scroll-mt-32"
    >
        <!-- Animated Background SVG -->
        <div class="absolute inset-0 overflow-hidden">
            <svg class="absolute top-0 left-0 w-full h-full" viewBox="0 0 1200 800" fill="none" xmlns="http://www.w3.org/2000/svg">
                <!-- Animated geometric shapes -->
                <circle cx="200" cy="150" r="100" fill="url(#gradient1)" opacity="0.1" class="animate-float">
                    <animateTransform attributeName="transform" type="translate" values="0 0; 20 -20; 0 0" dur="6s" repeatCount="indefinite"/>
                </circle>
                <polygon points="800,100 900,300 700,300" fill="url(#gradient2)" opacity="0.08" class="animate-float-delayed">
                    <animateTransform attributeName="transform" type="translate" values="0 0; -15 25; 0 0" dur="8s" repeatCount="indefinite"/>
                </polygon>
                <rect x="1000" y="200" width="150" height="150" rx="20" fill="url(#gradient3)" opacity="0.06" class="animate-float">
                    <animateTransform attributeName="transform" type="translate" values="0 0; 10 -30; 0 0" dur="7s" repeatCount="indefinite"/>
                </rect>
                
                <!-- Gradients -->
                <defs>
                    <radialGradient id="gradient1" cx="50%" cy="50%" r="50%">
                        <stop offset="0%" style="stop-color:rgb(99, 102, 241);stop-opacity:1" />
                        <stop offset="100%" style="stop-color:rgb(139, 92, 246);stop-opacity:0" />
                    </radialGradient>
                    <linearGradient id="gradient2" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" style="stop-color:rgb(236, 72, 153);stop-opacity:1" />
                        <stop offset="100%" style="stop-color:rgb(139, 92, 246);stop-opacity:0" />
                    </linearGradient>
                    <linearGradient id="gradient3" x1="0%" y1="0%" x2="100%" y2="100%">
                        <stop offset="0%" style="stop-color:rgb(59, 130, 246);stop-opacity:1" />
                        <stop offset="100%" style="stop-color:rgb(99, 102, 241);stop-opacity:0" />
                    </linearGradient>
                </defs>
            </svg>
        </div>

        <!-- Content -->
        <div class="relative container mx-auto px-6 pt-28 pb-20 lg:pt-36 lg:pb-28">
            <div class="grid lg:grid-cols-2 gap-12 items-center">
                <!-- Left Content -->
                <div class="text-center lg:text-left">
                    <!-- Hero Title with Animation -->
                    <h1
                        class="text-4xl md:text-6xl lg:text-7xl font-bold mb-6 leading-tight"
                        :class="{ 'animate-fade-in-up': isVisible }"
                    >
                        {{ title }}
                    </h1>

                    <!-- Hero Subtitle with Delayed Animation -->
                    <p
                        class="text-xl md:text-2xl mb-10 text-white/90 max-w-3xl mx-auto lg:mx-0 leading-relaxed"
                        :class="{ 'animate-fade-in-up-delay': isVisible }"
                    >
                        {{ subtitle }}
                    </p>

                    <!-- CTA Button with Hover Effects -->
                    <div
                        class="flex flex-col sm:flex-row gap-4 justify-center lg:justify-start items-center"
                        :class="{ 'animate-fade-in-up-delay-2': isVisible }"
                    >
                        <Link
                            :href="ctaLink"
                            class="group relative px-8 py-4 bg-white text-slate-900 font-semibold rounded-xl hover:bg-gray-50 transition-all duration-300 transform hover:scale-105 hover:shadow-xl focus:outline-none focus:ring-4 focus:ring-white/30"
                        >
                            <span class="relative z-10 flex items-center">
                                <svg class="w-5 h-5 mr-2" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M10 12a2 2 0 100-4 2 2 0 000 4z"/>
                                    <path fill-rule="evenodd" d="M.458 10C1.732 5.943 5.522 3 10 3s8.268 2.943 9.542 7c-1.274 4.057-5.064 7-9.542 7S1.732 14.057.458 10zM14 10a4 4 0 11-8 0 4 4 0 018 0z" clip-rule="evenodd"/>
                                </svg>
                                {{ ctaText }}
                            </span>
                        </Link>

                        <button
                            class="group flex items-center gap-3 px-6 py-4 text-white/90 hover:text-white transition-colors duration-300"
                            @click="playDemo"
                        >
                            <div
                                class="w-12 h-12 bg-white/20 rounded-full flex items-center justify-center group-hover:bg-white/30 transition-all duration-300"
                            >
                                <svg class="w-6 h-6 text-white ml-1" fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M6.3 2.841A1.5 1.5 0 004 4.11V15.89a1.5 1.5 0 002.3 1.269l9.344-5.89a1.5 1.5 0 000-2.538L6.3 2.84z"/>
                                </svg>
                            </div>
                            <span class="font-medium">Watch Demo</span>
                        </button>
                    </div>

                    <!-- Stats Preview -->
                    <div class="mt-16 grid grid-cols-3 gap-8 max-w-2xl mx-auto lg:mx-0">
                        <div class="text-center lg:text-left">
                            <div class="text-2xl md:text-3xl font-bold mb-1">10K+</div>
                            <div class="text-white/70 text-sm">Students</div>
                        </div>
                        <div class="text-center lg:text-left">
                            <div class="text-2xl md:text-3xl font-bold mb-1">95%</div>
                            <div class="text-white/70 text-sm">Success Rate</div>
                        </div>
                        <div class="text-center lg:text-left">
                            <div class="text-2xl md:text-3xl font-bold mb-1">500+</div>
                            <div class="text-white/70 text-sm">Tests</div>
                        </div>
                    </div>
                </div>

                <!-- Right Content - Hero Illustration -->
                <div class="relative flex items-center justify-center" :class="{ 'animate-fade-in-right': isVisible }">
                    <div class="absolute -top-20 -left-16 w-56 h-56 bg-indigo-400/30 blur-3xl rounded-full"></div>
                    <div class="absolute -bottom-16 -right-14 w-64 h-64 bg-purple-500/25 blur-3xl rounded-full"></div>

                    <div class="relative max-w-xl w-full">
                        <div class="relative overflow-hidden rounded-3xl border border-white/10 bg-white/5 backdrop-blur-xl shadow-[0_45px_65px_rgba(79,70,229,0.35)]">
                            <img :src="heroImageUrl" :alt="heroAltText" class="w-full h-auto" loading="lazy" />
                            <div class="absolute inset-x-0 bottom-0 h-28 bg-gradient-to-t from-indigo-950/80 to-transparent pointer-events-none"></div>
                        </div>

                        <div class="absolute -bottom-10 left-6 bg-white text-slate-900 shadow-2xl rounded-2xl px-6 py-5 w-64 flex flex-col gap-3">
                            <div class="flex items-center gap-3">
                                <span class="inline-flex items-center justify-center w-10 h-10 rounded-xl bg-indigo-100 text-indigo-600">
                                    <i class="pi pi-check text-lg"></i>
                                </span>
                                <div>
                                    <p class="text-sm font-medium text-slate-500">Completion rate</p>
                                    <p class="text-xl font-semibold text-slate-900">95% avg</p>
                                </div>
                            </div>
                            <div class="flex items-center justify-between text-sm font-semibold text-slate-500">
                                <span class="flex items-center gap-2">
                                    <span class="inline-flex h-2.5 w-2.5 rounded-full bg-emerald-500"></span>
                                    Active learners
                                </span>
                                <span class="text-slate-900">10K+</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Scroll Indicator -->
        <div class="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce">
            <svg class="w-6 h-6 text-white/60" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 14l-7 7m0 0l-7-7m7 7V3"/>
            </svg>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted, computed } from 'vue'
import { Link, usePage } from '@inertiajs/vue3'

const props = defineProps({
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
    heroImage: {
        type: String,
        default: 'site/hero-illustration.svg',
    },
})

const page = usePage()

const heroImageUrl = computed(() => {
    const base = page?.props?.assetUrl ?? '/storage/'
    const path = props.heroImage || 'site/hero-illustration.svg'
    return `${base}${path}`
})

const heroAltText = computed(() => `${props.title} illustration`)

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

@keyframes fadeInRight {
    from {
        opacity: 0;
        transform: translateX(30px);
    }
    to {
        opacity: 1;
        transform: translateX(0);
    }
}

@keyframes float {
    0%, 100% { transform: translateY(0px); }
    50% { transform: translateY(-20px); }
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

.animate-fade-in-right {
    opacity: 0;
    animation: fadeInRight 1s ease-out 0.6s forwards;
}

.animate-float {
    animation: float 6s ease-in-out infinite;
}

.animate-float-delayed {
    animation: float 8s ease-in-out infinite 2s;
}

/* Custom background */
.hero-section::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: rgba(59, 130, 246, 0.05);
    pointer-events: none;
}
</style>
