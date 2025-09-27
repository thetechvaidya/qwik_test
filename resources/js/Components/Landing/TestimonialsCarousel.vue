<template>
    <section class="py-20 bg-gradient-to-br from-indigo-50 via-purple-50 to-pink-50 relative overflow-hidden scroll-mt-24 sm:scroll-mt-32">
        <!-- Background Effects -->
        <div class="absolute inset-0 opacity-40">
            <div class="absolute top-1/4 left-1/4 w-96 h-96 bg-gradient-to-br from-indigo-400/20 to-purple-500/20 rounded-full blur-3xl animate-float"></div>
            <div class="absolute bottom-1/4 right-1/4 w-80 h-80 bg-gradient-to-br from-pink-400/20 to-rose-500/20 rounded-full blur-3xl animate-float" style="animation-delay: 2s;"></div>
            <div class="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-64 h-64 bg-gradient-to-br from-blue-400/15 to-cyan-500/15 rounded-full blur-3xl animate-float" style="animation-delay: 4s;"></div>
        </div>

        <div class="container-modern relative">
            <!-- Section Header -->
            <div class="text-center mb-20 animate-fadeInUp">
                <h2 class="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
                    What Our <span class="text-gradient">Students Say</span>
                </h2>
                <p class="text-xl text-gray-600 max-w-4xl mx-auto leading-relaxed">
                    Don't just take our word for it. Here's what thousands of successful learners have to say about their transformative experience with our platform.
                </p>
            </div>

            <!-- Testimonials Carousel -->
            <div class="relative max-w-6xl mx-auto mb-16">
                <!-- Main Carousel -->
                <div ref="carouselContainer" class="overflow-hidden rounded-3xl">
                    <div
                        class="flex transition-transform duration-700 ease-in-out"
                        :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
                    >
                        <div
                            v-for="(testimonial, index) in testimonials"
                            :key="index"
                            class="w-full flex-shrink-0 px-4"
                        >
                            <!-- Glassmorphism Testimonial Card -->
                            <div class="testimonial-card glass group relative p-8 md:p-12 rounded-3xl border border-white/30 shadow-2xl backdrop-blur-xl bg-white/70 hover:bg-white/80 transition-all duration-500">
                                <!-- Gradient Overlay -->
                                <div class="absolute inset-0 bg-gradient-to-br from-white/20 via-transparent to-indigo-500/10 rounded-3xl opacity-0 group-hover:opacity-100 transition-opacity duration-500"></div>
                                
                                <!-- Quote Icon with Glow -->
                                <div class="relative z-10 mb-8">
                                    <div class="w-16 h-16 bg-gradient-primary rounded-2xl flex items-center justify-center mx-auto shadow-glow group-hover:scale-110 transition-transform duration-300">
                                        <i class="pi pi-quote-left text-white text-2xl"></i>
                                    </div>
                                </div>

                                <!-- Testimonial Content -->
                                <div class="relative z-10">
                                    <blockquote class="text-xl md:text-2xl text-gray-700 leading-relaxed mb-8 italic font-medium text-center">
                                        "{{ testimonial.content }}"
                                    </blockquote>

                                    <!-- Rating Stars -->
                                    <div class="flex items-center justify-center gap-1 mb-8">
                                        <div class="flex gap-1">
                                            <i
                                                v-for="star in 5"
                                                :key="star"
                                                :class="[
                                                    'pi pi-star-fill text-2xl transition-all duration-300 hover:scale-125',
                                                    star <= testimonial.rating ? 'text-yellow-400' : 'text-gray-300',
                                                ]"
                                            ></i>
                                        </div>
                                        <span class="ml-3 text-gray-600 font-semibold text-lg">{{ testimonial.rating }}/5</span>
                                    </div>

                                    <!-- Author Info -->
                                    <div class="flex items-center justify-center gap-6">
                                        <div class="relative group/avatar">
                                            <TestimonialAvatar 
                                                :name="testimonial.name" 
                                                :size="80" 
                                                variant="primary"
                                                class="group-hover/avatar:scale-110 transition-transform duration-300"
                                            />
                                            <!-- Online Status Indicator -->
                                            <div class="absolute -bottom-1 -right-1 w-6 h-6 bg-gradient-to-br from-green-400 to-emerald-500 rounded-full border-3 border-white shadow-lg animate-pulse"></div>
                                        </div>
                                        <div class="text-center">
                                            <div class="font-bold text-gray-900 text-xl mb-1">
                                                {{ testimonial.name }}
                                            </div>
                                            <div class="text-gray-600 font-medium">
                                                {{ testimonial.role }}
                                            </div>
                                            <div v-if="testimonial.company" class="text-indigo-600 font-semibold text-sm mt-1">
                                                {{ testimonial.company }}
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <!-- Decorative Elements -->
                                <div class="absolute top-4 right-4 w-8 h-8 bg-gradient-to-br from-indigo-400/20 to-purple-500/20 rounded-full blur-sm"></div>
                                <div class="absolute bottom-4 left-4 w-6 h-6 bg-gradient-to-br from-pink-400/20 to-rose-500/20 rounded-full blur-sm"></div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Enhanced Navigation Buttons -->
                <button
                    :disabled="currentSlide === 0"
                    class="absolute left-4 top-1/2 transform -translate-y-1/2 w-14 h-14 bg-white/80 backdrop-blur-sm rounded-full shadow-xl border border-white/30 flex items-center justify-center hover:bg-white hover:scale-110 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 z-20 group"
                    @click="previousSlide"
                >
                    <i class="pi pi-chevron-left text-gray-700 text-lg group-hover:text-indigo-600 transition-colors duration-300"></i>
                </button>

                <button
                    :disabled="currentSlide === testimonials.length - 1"
                    class="absolute right-4 top-1/2 transform -translate-y-1/2 w-14 h-14 bg-white/80 backdrop-blur-sm rounded-full shadow-xl border border-white/30 flex items-center justify-center hover:bg-white hover:scale-110 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed disabled:hover:scale-100 z-20 group"
                    @click="nextSlide"
                >
                    <i class="pi pi-chevron-right text-gray-700 text-lg group-hover:text-indigo-600 transition-colors duration-300"></i>
                </button>

                <!-- Enhanced Dots Indicator -->
                <div class="flex justify-center gap-3 mt-12">
                    <button
                        v-for="(_, index) in testimonials"
                        :key="index"
                        :class="[
                            'transition-all duration-300 rounded-full',
                            index === currentSlide 
                                ? 'w-12 h-4 bg-gradient-primary shadow-glow' 
                                : 'w-4 h-4 bg-white/60 hover:bg-white/80 hover:scale-125'
                        ]"
                        @click="goToSlide(index)"
                    ></button>
                </div>
            </div>

            <!-- Trust Indicators with Glassmorphism -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-6 max-w-5xl mx-auto mb-16">
                <div class="glass-card text-center hover-lift group">
                    <div class="text-4xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">4.9/5</div>
                    <div class="text-gray-700 font-medium">Average Rating</div>
                    <div class="flex justify-center mt-2">
                        <i v-for="star in 5" :key="star" class="pi pi-star-fill text-yellow-400 text-sm"></i>
                    </div>
                </div>
                <div class="glass-card text-center hover-lift group">
                    <div class="text-4xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">2.5K+</div>
                    <div class="text-gray-700 font-medium">Happy Reviews</div>
                    <div class="text-green-600 text-sm mt-1">📈 Growing daily</div>
                </div>
                <div class="glass-card text-center hover-lift group">
                    <div class="text-4xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">98%</div>
                    <div class="text-gray-700 font-medium">Would Recommend</div>
                    <div class="text-blue-600 text-sm mt-1">💯 Satisfaction</div>
                </div>
                <div class="glass-card text-center hover-lift group">
                    <div class="text-4xl font-bold text-gradient mb-2 group-hover:scale-110 transition-transform duration-300">24/7</div>
                    <div class="text-gray-700 font-medium">Expert Support</div>
                    <div class="text-purple-600 text-sm mt-1">🚀 Always here</div>
                </div>
            </div>

            <!-- Social Proof Section -->
            <div class="text-center">
                <div class="inline-flex items-center gap-6 p-8 bg-white/60 backdrop-blur-sm rounded-3xl border border-white/30 shadow-modern hover-lift">
                    <div class="flex -space-x-4">
                        <div v-for="i in 5" :key="i" class="w-12 h-12 rounded-full border-3 border-white bg-gradient-to-br from-indigo-400 to-purple-500 flex items-center justify-center text-white font-bold shadow-lg">
                            {{ String.fromCharCode(64 + i) }}
                        </div>
                    </div>
                    <div class="text-left">
                        <div class="font-bold text-gray-900 text-lg">Join 10,000+ satisfied learners</div>
                        <div class="text-gray-600">Start your learning journey today and see why students love our platform</div>
                    </div>
                    <Link
                        href="/register"
                        class="btn-modern px-8 py-4 bg-gradient-primary text-white font-bold rounded-xl hover-lift shadow-modern hover:shadow-glow transition-all duration-300"
                    >
                        Join Now
                    </Link>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'
import { Link } from '@inertiajs/vue3'
import TestimonialAvatar from '@/Components/Placeholders/TestimonialAvatar.vue'

// Props
const props = defineProps({
    testimonials: {
        type: Array,
        default: () => [
            {
                name: 'Sarah Johnson',
                role: 'Software Developer',
                company: 'Tech Innovations Inc',
                content: 'This platform completely transformed how I prepare for certifications. The detailed analytics helped me identify weak areas and the mobile app made studying incredibly convenient. I passed my AWS certification on the first try with a 95% score!',
                rating: 5,
                avatar: '/images/avatars/sarah.jpg',
            },
            {
                name: 'Mike Chen',
                role: 'Medical Student',
                company: 'Harvard Medical School',
                content: 'As a medical student, I needed a reliable way to test my knowledge across multiple subjects. The spaced repetition and adaptive questioning kept me engaged for hours. The progress tracking is phenomenal - I could see my improvement week by week.',
                rating: 5,
                avatar: '/images/avatars/mike.jpg',
            },
            {
                name: 'Emily Rodriguez',
                role: 'High School Teacher',
                company: 'Lincoln High School',
                content: 'I use this platform to create engaging quizzes for my students. The interface is incredibly intuitive, the analytics provide deep insights, and my students actually enjoy taking the tests. It has been a complete game-changer for my classroom engagement.',
                rating: 5,
                avatar: '/images/avatars/emily.jpg',
            },
            {
                name: 'David Kim',
                role: 'Project Manager',
                company: 'Innovation Labs',
                content: 'The team collaboration features are outstanding. We use it for onboarding new employees and tracking their progress through training modules. The custom branding option makes it feel like an integral part of our company ecosystem.',
                rating: 5,
                avatar: '/images/avatars/david.jpg',
            },
            {
                name: 'Lisa Wang',
                role: 'PhD Candidate',
                company: 'MIT Research Lab',
                content: 'Perfect for comprehensive exam preparation and research methodology training. The ability to import questions and create custom categories saved me countless hours. The mobile synchronization means I can study during commutes and breaks.',
                rating: 5,
                avatar: '/images/avatars/lisa.jpg',
            },
        ],
    },
    autoPlay: {
        type: Boolean,
        default: true,
    },
    autoPlayInterval: {
        type: Number,
        default: 6000,
    },
})

// Reactive state
const currentSlide = ref(0)
const carouselContainer = ref(null)
let autoPlayTimer = null
let startX = null

// Methods
const nextSlide = () => {
    if (currentSlide.value < props.testimonials.length - 1) {
        currentSlide.value++
    } else {
        currentSlide.value = 0 // Loop back to first
    }
}

const previousSlide = () => {
    if (currentSlide.value > 0) {
        currentSlide.value--
    } else {
        currentSlide.value = props.testimonials.length - 1 // Loop to last
    }
}

const goToSlide = (index) => {
    currentSlide.value = index
    resetAutoPlay()
}

const handleImageError = (event) => {
    event.target.src = '/images/default-avatar.jpg'
}

const startAutoPlay = () => {
    if (props.autoPlay && props.testimonials.length > 1) {
        autoPlayTimer = setInterval(() => {
            nextSlide()
        }, props.autoPlayInterval)
    }
}

const stopAutoPlay = () => {
    if (autoPlayTimer) {
        clearInterval(autoPlayTimer)
        autoPlayTimer = null
    }
}

const resetAutoPlay = () => {
    stopAutoPlay()
    startAutoPlay()
}

// Touch/Swipe support
const handleTouchStart = (e) => {
    const touch = e.touches[0]
    startX = touch.clientX
}

const handleTouchMove = (e) => {
    if (!startX) return

    const touch = e.touches[0]
    const diff = startX - touch.clientX

    if (Math.abs(diff) > 50) {
        if (diff > 0) {
            nextSlide()
        } else {
            previousSlide()
        }
        startX = null
        resetAutoPlay()
    }
}

// Lifecycle
onMounted(() => {
    startAutoPlay()

    // Add touch event listeners
    if (carouselContainer.value) {
        carouselContainer.value.addEventListener('touchstart', handleTouchStart, { passive: true })
        carouselContainer.value.addEventListener('touchmove', handleTouchMove, { passive: true })
    }

    // Pause auto-play on hover
    if (carouselContainer.value) {
        carouselContainer.value.addEventListener('mouseenter', stopAutoPlay)
        carouselContainer.value.addEventListener('mouseleave', startAutoPlay)
    }
})

onUnmounted(() => {
    stopAutoPlay()

    // Clean up event listeners
    if (carouselContainer.value) {
        carouselContainer.value.removeEventListener('touchstart', handleTouchStart)
        carouselContainer.value.removeEventListener('touchmove', handleTouchMove)
        carouselContainer.value.removeEventListener('mouseenter', stopAutoPlay)
        carouselContainer.value.removeEventListener('mouseleave', startAutoPlay)
    }
})
</script>

<style scoped>
/* Glassmorphism testimonial card */
.testimonial-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.15);
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

.testimonial-card:hover {
    background: rgba(255, 255, 255, 0.8);
    transform: translateY(-8px);
    box-shadow: 0 35px 60px -12px rgba(0, 0, 0, 0.2);
}

/* Enhanced quote styling */
blockquote {
    position: relative;
}

blockquote::before {
    content: '';
    position: absolute;
    left: -3rem;
    top: 0;
    width: 6px;
    height: 100%;
    background: linear-gradient(to bottom, #6366f1, #8b5cf6);
    border-radius: 3px;
    opacity: 0.6;
}

/* Star animations */
.pi-star-fill {
    transition: all 0.3s ease;
    cursor: pointer;
}

.pi-star-fill:hover {
    transform: scale(1.3) rotate(15deg);
    filter: drop-shadow(0 0 8px rgba(251, 191, 36, 0.6));
}

/* Avatar enhancements */
.group\/avatar:hover img {
    transform: scale(1.1);
    transition: transform 0.3s ease;
}

/* Glass card styling */
.glass-card {
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(15px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 1.5rem;
    padding: 2rem;
    transition: all 0.3s ease;
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.1);
}

.glass-card:hover {
    background: rgba(255, 255, 255, 0.7);
    transform: translateY(-8px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.15);
}

/* Navigation button enhancements */
button:hover:not(:disabled) {
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

/* Floating animation */
@keyframes float {
    0%, 100% {
        transform: translateY(0px);
    }
    50% {
        transform: translateY(-20px);
    }
}

.animate-float {
    animation: float 6s ease-in-out infinite;
}

/* Carousel smooth transitions */
.testimonial-carousel {
    scroll-behavior: smooth;
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .testimonial-card {
        padding: 1.5rem;
    }

    blockquote {
        font-size: 1.125rem;
    }

    blockquote::before {
        left: -1.5rem;
        width: 4px;
    }
    
    .glass-card {
        padding: 1.5rem;
    }
}

/* Loading state for images */
.testimonial-card img {
    transition: opacity 0.3s ease;
}

/* Enhanced hover states */
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

/* Enhanced accessibility */
@media (prefers-reduced-motion: reduce) {
    .testimonial-card,
    .glass-card,
    .animate-float,
    .animate-pulse {
        animation: none;
        transition: none;
    }
    
    .hover-lift:hover {
        transform: none;
    }
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .testimonial-card {
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

/* Dot indicator animations */
.dots button {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Border gradient animation for active dot */
.dots button.active {
    position: relative;
    overflow: hidden;
}

.dots button.active::before {
    content: '';
    position: absolute;
    inset: 0;
    background: linear-gradient(45deg, #667eea, #764ba2);
    border-radius: inherit;
    animation: borderRotate 2s linear infinite;
}

@keyframes borderRotate {
    0% {
        transform: rotate(0deg);
    }
    100% {
        transform: rotate(360deg);
    }
}
</style>
