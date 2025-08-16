<template>
    <section class="pricing-section py-20 bg-gradient-to-br from-gray-50 via-white to-indigo-50">
        <div class="container mx-auto px-6">
            <!-- Section Header -->
            <div class="text-center mb-16">
                <h2 class="text-4xl md:text-5xl font-bold text-gray-900 mb-6"> Choose Your Learning Path </h2>
                <p class="text-xl text-gray-600 max-w-3xl mx-auto mb-8">
                    Select the perfect plan that fits your learning goals and budget. All plans include our core
                    features with varying levels of access.
                </p>

                <!-- Billing Toggle -->
                <div class="inline-flex items-center bg-white rounded-full p-1 shadow-lg">
                    <button
                        :class="[
                            'px-6 py-2 rounded-full font-medium transition-all duration-300',
                            billingCycle === 'monthly'
                                ? 'bg-indigo-600 text-white shadow-md'
                                : 'text-gray-600 hover:text-gray-900',
                        ]"
                        @click="billingCycle = 'monthly'"
                    >
                        Monthly
                    </button>
                    <button
                        :class="[
                            'px-6 py-2 rounded-full font-medium transition-all duration-300 relative',
                            billingCycle === 'yearly'
                                ? 'bg-indigo-600 text-white shadow-md'
                                : 'text-gray-600 hover:text-gray-900',
                        ]"
                        @click="billingCycle = 'yearly'"
                    >
                        Yearly
                        <span class="absolute -top-2 -right-2 bg-green-500 text-white text-xs px-2 py-1 rounded-full">
                            Save 20%
                        </span>
                    </button>
                </div>
            </div>

            <!-- Pricing Cards -->
            <div ref="pricingGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-6xl mx-auto">
                <div
                    v-for="(plan, index) in displayedPlans"
                    :key="index"
                    :class="[
                        'pricing-card relative p-8 bg-white rounded-2xl border-2 transition-all duration-300 transform hover:-translate-y-2',
                        plan.popular
                            ? 'border-indigo-500 shadow-2xl scale-105'
                            : 'border-gray-200 hover:border-indigo-300 shadow-lg hover:shadow-xl',
                    ]"
                >
                    <!-- Popular Badge -->
                    <div v-if="plan.popular" class="absolute -top-4 left-1/2 transform -translate-x-1/2">
                        <div
                            class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-6 py-2 rounded-full text-sm font-semibold shadow-lg"
                        >
                            Most Popular
                        </div>
                    </div>

                    <!-- Plan Header -->
                    <div class="text-center mb-8">
                        <h3 class="text-2xl font-bold text-gray-900 mb-2">
                            {{ plan.name }}
                        </h3>
                        <div class="mb-4">
                            <span class="text-5xl font-bold text-gray-900">
                                {{ getPlanPrice(plan) }}
                            </span>
                            <span class="text-gray-600 ml-1">
                                {{ getPlanPeriod(plan) }}
                            </span>
                        </div>
                        <p v-if="plan.description" class="text-gray-600">
                            {{ plan.description }}
                        </p>
                    </div>

                    <!-- Features List -->
                    <div class="mb-8">
                        <ul class="space-y-4">
                            <li
                                v-for="(feature, featureIndex) in plan.features"
                                :key="featureIndex"
                                class="flex items-start gap-3"
                            >
                                <i
                                    :class="[
                                        'pi pi-check text-lg mt-0.5 flex-shrink-0',
                                        plan.popular ? 'text-indigo-600' : 'text-green-500',
                                    ]"
                                ></i>
                                <span class="text-gray-700">{{ feature }}</span>
                            </li>
                        </ul>
                    </div>

                    <!-- CTA Button -->
                    <div class="text-center">
                        <Link
                            :href="plan.cta_link || '/register'"
                            :class="[
                                'inline-block w-full px-8 py-4 font-semibold rounded-xl transition-all duration-300 transform hover:scale-105',
                                plan.popular
                                    ? 'bg-gradient-to-r from-indigo-600 to-purple-600 text-white hover:from-indigo-700 hover:to-purple-700 shadow-lg hover:shadow-xl'
                                    : 'bg-gray-900 text-white hover:bg-gray-800',
                            ]"
                        >
                            {{ plan.cta_text || 'Get Started' }}
                        </Link>
                    </div>

                    <!-- Background Gradient for Popular Plan -->
                    <div
                        v-if="plan.popular"
                        class="absolute inset-0 bg-gradient-to-br from-indigo-50 to-purple-50 rounded-2xl opacity-30 pointer-events-none"
                    ></div>
                </div>
            </div>

            <!-- Money Back Guarantee -->
            <div class="text-center mt-16">
                <div class="inline-flex items-center gap-4 p-6 bg-green-50 rounded-2xl border border-green-200">
                    <i class="pi pi-shield text-green-600 text-2xl"></i>
                    <div class="text-left">
                        <div class="font-semibold text-gray-900">30-Day Money Back Guarantee</div>
                        <div class="text-gray-600 text-sm"
                            >Try any plan risk-free. Not satisfied? Get a full refund.</div
                        >
                    </div>
                </div>
            </div>

            <!-- FAQ Teaser -->
            <div class="text-center mt-12">
                <p class="text-gray-600 mb-4">Have questions about our pricing?</p>
                <Link href="/faq" class="text-indigo-600 hover:text-indigo-700 font-medium underline">
                    Check our FAQ →
                </Link>
            </div>
        </div>
    </section>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'

// Props
const props = defineProps({
    plans: {
        type: Array,
        default: () => [
            {
                name: 'Basic',
                price: 'Free',
                yearly_price: 'Free',
                period: '',
                description: 'Perfect for getting started',
                features: ['5 quizzes per month', 'Basic analytics', 'Community support', 'Mobile access'],
                cta_text: 'Get Started',
                cta_link: '/register',
                popular: false,
            },
            {
                name: 'Pro',
                price: '$9.99',
                yearly_price: '$8.99',
                period: '/month',
                description: 'Best for serious learners',
                features: [
                    'Unlimited quizzes',
                    'Advanced analytics',
                    'Priority support',
                    'Custom categories',
                    'Progress tracking',
                    'Export results',
                ],
                cta_text: 'Go Pro',
                cta_link: '/subscribe/pro',
                popular: true,
            },
            {
                name: 'Enterprise',
                price: '$29.99',
                yearly_price: '$24.99',
                period: '/month',
                description: 'For teams and organizations',
                features: [
                    'Everything in Pro',
                    'Team management',
                    'API access',
                    'Custom branding',
                    'Advanced reporting',
                    'SSO integration',
                    'Dedicated support',
                ],
                cta_text: 'Contact Sales',
                cta_link: '/contact',
                popular: false,
            },
        ],
    },
})

// Reactive state
const billingCycle = ref('monthly')
const pricingGrid = ref(null)
const hasAnimated = ref(false)

// Computed
const displayedPlans = computed(() => {
    return props.plans.map(plan => ({
        ...plan,
        currentPrice: billingCycle.value === 'yearly' && plan.yearly_price ? plan.yearly_price : plan.price,
    }))
})

// Methods
const getPlanPrice = plan => {
    if (plan.price === 'Free') return 'Free'

    if (billingCycle.value === 'yearly' && plan.yearly_price) {
        return plan.yearly_price
    }

    return plan.price
}

const getPlanPeriod = plan => {
    if (plan.price === 'Free') return ''

    if (billingCycle.value === 'yearly') {
        return '/year'
    }

    return plan.period || '/month'
}

const animatePricingCards = () => {
    if (hasAnimated.value || !pricingGrid.value) return

    hasAnimated.value = true

    const cards = pricingGrid.value.querySelectorAll('.pricing-card')
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('animate-slide-in-up')
        }, index * 150)
    })
}

// Lifecycle
onMounted(() => {
    if (pricingGrid.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            entries => {
                entries.forEach(entry => {
                    if (entry.isIntersecting && !hasAnimated.value) {
                        animatePricingCards()
                        observer.unobserve(entry.target)
                    }
                })
            },
            {
                threshold: 0.2,
            }
        )

        observer.observe(pricingGrid.value)
    }
})
</script>

<style scoped>
.pricing-card {
    opacity: 0;
    transform: translateY(30px);
}

.pricing-card.animate-slide-in-up {
    animation: slideInUp 0.6s ease-out forwards;
}

@keyframes slideInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Hover effects for pricing cards */
.pricing-card:hover {
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

/* Popular plan glow effect */
.pricing-card.border-indigo-500 {
    box-shadow:
        0 0 0 1px rgba(99, 102, 241, 0.1),
        0 25px 50px -12px rgba(99, 102, 241, 0.25);
}

/* Feature checkmark animations */
.pricing-card:hover .pi-check {
    animation: checkBounce 0.6s ease-out;
}

@keyframes checkBounce {
    0%,
    100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.2);
    }
}

/* Button hover effects */
.pricing-card button:hover,
.pricing-card a:hover {
    transform: translateY(-2px);
    box-shadow: 0 10px 25px rgba(0, 0, 0, 0.15);
}

/* Responsive adjustments */
@media (max-width: 1024px) {
    .pricing-card.scale-105 {
        transform: scale(1);
    }
}

@media (max-width: 768px) {
    .pricing-card {
        padding: 1.5rem;
    }
}

/* Billing toggle animations */
.billing-toggle button {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Price change animations */
.price-change {
    animation: priceFlip 0.4s ease-in-out;
}

@keyframes priceFlip {
    0% {
        transform: rotateX(0deg);
    }
    50% {
        transform: rotateX(90deg);
    }
    100% {
        transform: rotateX(0deg);
    }
}
</style>
