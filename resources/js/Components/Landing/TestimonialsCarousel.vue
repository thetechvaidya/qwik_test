<template>
    <section class="testimonials-section py-20 bg-gradient-to-br from-indigo-50 via-white to-purple-50">
        <div class="container mx-auto px-6">
            <!-- Section Header -->
            <div class="text-center mb-16">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6"> What Our Students Say </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto">
                    Don't just take our word for it. Here's what thousands of successful learners have to say about
                    their experience.
                </p>
            </div>

            <!-- Testimonials Carousel -->
            <div class="relative max-w-6xl mx-auto">
                <!-- Main Carousel -->
                <div ref="carouselContainer" class="overflow-hidden rounded-2xl">
                    <div
                        class="flex transition-transform duration-500 ease-in-out"
                        :style="{ transform: `translateX(-${currentSlide * 100}%)` }"
                    >
                        <div
                            v-for="(testimonial, index) in testimonials"
                            :key="index"
                            class="w-full flex-shrink-0 px-4"
                        >
                            <div class="bg-white rounded-2xl shadow-xl p-8 md:p-12 border border-gray-100">
                                <!-- Quote Icon -->
                                <div class="text-indigo-500 mb-6">
                                    <i class="pi pi-quote-left text-4xl"></i>
                                </div>

                                <!-- Testimonial Content -->
                                <blockquote class="text-lg md:text-xl text-gray-700 leading-relaxed mb-8 italic">
                                    "{{ testimonial.content }}"
                                </blockquote>

                                <!-- Rating Stars -->
                                <div class="flex items-center gap-1 mb-6">
                                    <i
                                        v-for="star in 5"
                                        :key="star"
                                        :class="[
                                            'pi pi-star-fill text-xl',
                                            star <= testimonial.rating ? 'text-yellow-400' : 'text-gray-300',
                                        ]"
                                    ></i>
                                    <span class="ml-2 text-gray-600 font-medium"> {{ testimonial.rating }}/5 </span>
                                </div>

                                <!-- Author Info -->
                                <div class="flex items-center gap-4">
                                    <div class="relative">
                                        <img
                                            :src="testimonial.avatar || '/images/default-avatar.jpg'"
                                            :alt="testimonial.name"
                                            class="w-16 h-16 rounded-full object-cover border-4 border-indigo-100"
                                            @error="handleImageError"
                                        />
                                        <div
                                            class="absolute -bottom-1 -right-1 w-6 h-6 bg-green-500 rounded-full border-2 border-white"
                                        ></div>
                                    </div>
                                    <div>
                                        <div class="font-bold text-gray-900 text-lg">
                                            {{ testimonial.name }}
                                        </div>
                                        <div class="text-gray-600">
                                            {{ testimonial.role }}
                                        </div>
                                        <div v-if="testimonial.company" class="text-indigo-600 text-sm">
                                            {{ testimonial.company }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Navigation Buttons -->
                <button
                    :disabled="currentSlide === 0"
                    class="absolute left-4 top-1/2 transform -translate-y-1/2 w-12 h-12 bg-white rounded-full shadow-lg border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors duration-300 disabled:opacity-50 disabled:cursor-not-allowed z-10"
                    @click="previousSlide"
                >
                    <i class="pi pi-chevron-left text-gray-600"></i>
                </button>

                <button
                    :disabled="currentSlide === testimonials.length - 1"
                    class="absolute right-4 top-1/2 transform -translate-y-1/2 w-12 h-12 bg-white rounded-full shadow-lg border border-gray-200 flex items-center justify-center hover:bg-gray-50 transition-colors duration-300 disabled:opacity-50 disabled:cursor-not-allowed z-10"
                    @click="nextSlide"
                >
                    <i class="pi pi-chevron-right text-gray-600"></i>
                </button>

                <!-- Dots Indicator -->
                <div class="flex justify-center gap-2 mt-8">
                    <button
                        v-for="(_, index) in testimonials"
                        :key="index"
                        :class="[
                            'w-3 h-3 rounded-full transition-all duration-300',
                            index === currentSlide ? 'bg-indigo-600 w-8' : 'bg-gray-300 hover:bg-gray-400',
                        ]"
                        @click="goToSlide(index)"
                    ></button>
                </div>
            </div>

            <!-- Trust Indicators -->
            <div class="grid grid-cols-2 md:grid-cols-4 gap-8 mt-16 max-w-4xl mx-auto">
                <div class="text-center">
                    <div class="text-3xl font-bold text-indigo-600 mb-2">4.9/5</div>
                    <div class="text-gray-600 text-sm">Average Rating</div>
                </div>
                <div class="text-center">
                    <div class="text-3xl font-bold text-indigo-600 mb-2">2K+</div>
                    <div class="text-gray-600 text-sm">Reviews</div>
                </div>
                <div class="text-center">
                    <div class="text-3xl font-bold text-indigo-600 mb-2">98%</div>
                    <div class="text-gray-600 text-sm">Would Recommend</div>
                </div>
                <div class="text-center">
                    <div class="text-3xl font-bold text-indigo-600 mb-2">24/7</div>
                    <div class="text-gray-600 text-sm">Support</div>
                </div>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, onMounted, onUnmounted } from 'vue'

// Props
const props = defineProps({
    testimonials: {
        type: Array,
        default: () => [
            {
                name: 'Sarah Johnson',
                role: 'Software Developer',
                company: 'Tech Corp',
                content:
                    'This platform completely transformed how I prepare for certifications. The detailed analytics helped me identify weak areas and the mobile app made studying so convenient. I passed my AWS certification on the first try!',
                rating: 5,
                avatar: '/images/avatars/sarah.jpg',
            },
            {
                name: 'Mike Chen',
                role: 'Medical Student',
                company: 'Harvard Medical',
                content:
                    'As a medical student, I needed a reliable way to test my knowledge. The spaced repetition and adaptive questioning kept me engaged. The progress tracking is phenomenal - I could see my improvement week by week.',
                rating: 5,
                avatar: '/images/avatars/mike.jpg',
            },
            {
                name: 'Emily Rodriguez',
                role: 'High School Teacher',
                company: 'Lincoln High',
                content:
                    "I use this platform to create engaging quizzes for my students. The interface is intuitive, the analytics are detailed, and my students actually enjoy taking the tests. It's been a game-changer for my classroom.",
                rating: 5,
                avatar: '/images/avatars/emily.jpg',
            },
            {
                name: 'David Kim',
                role: 'Project Manager',
                company: 'Innovation Inc',
                content:
                    'The team collaboration features are excellent. We use it for onboarding new employees and tracking their progress. The custom branding option makes it feel like part of our company ecosystem.',
                rating: 5,
                avatar: '/images/avatars/david.jpg',
            },
            {
                name: 'Lisa Wang',
                role: 'PhD Candidate',
                company: 'MIT',
                content:
                    'Perfect for research preparation and comprehensive exams. The ability to import questions and create custom categories saved me countless hours. The mobile synchronization means I can study anywhere.',
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
        default: 5000,
    },
})

// Reactive state
const currentSlide = ref(0)
const carouselContainer = ref(null)
let autoPlayTimer = null

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

const goToSlide = index => {
    currentSlide.value = index
    resetAutoPlay()
}

const handleImageError = event => {
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
const handleTouchStart = e => {
    const touch = e.touches[0]
    startX = touch.clientX
}

const handleTouchMove = e => {
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

let startX = null

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
/* Smooth carousel transitions */
.testimonial-carousel {
    scroll-behavior: smooth;
}

/* Quote styling */
blockquote {
    position: relative;
}

blockquote::before {
    content: '';
    position: absolute;
    left: -2rem;
    top: 0;
    width: 4px;
    height: 100%;
    background: linear-gradient(to bottom, #6366f1, #8b5cf6);
    border-radius: 2px;
}

/* Star animations */
.pi-star-fill {
    transition: all 0.3s ease;
}

.pi-star-fill:hover {
    transform: scale(1.2);
}

/* Avatar hover effects */
.testimonial-avatar {
    transition: all 0.3s ease;
}

.testimonial-avatar:hover {
    transform: scale(1.05);
}

/* Navigation button animations */
button:hover:not(:disabled) {
    transform: scale(1.1);
}

/* Responsive adjustments */
@media (max-width: 768px) {
    .testimonials-section {
        padding: 3rem 0;
    }

    blockquote {
        font-size: 1rem;
    }

    blockquote::before {
        left: -1rem;
    }
}

/* Loading state for images */
.testimonial-avatar {
    background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
    background-size: 200% 100%;
    animation: loading 1.5s infinite;
}

@keyframes loading {
    0% {
        background-position: 200% 0;
    }
    100% {
        background-position: -200% 0;
    }
}

.testimonial-avatar img {
    opacity: 0;
    transition: opacity 0.3s ease;
}

.testimonial-avatar img.loaded {
    opacity: 1;
}

/* Enhanced hover states */
.testimonial-card:hover {
    transform: translateY(-5px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Carousel slide animation */
.carousel-slide {
    opacity: 0;
    transform: translateX(30px);
    transition: all 0.5s ease;
}

.carousel-slide.active {
    opacity: 1;
    transform: translateX(0);
}
</style>
