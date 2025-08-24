<template>
    <section class="py-20 bg-gradient-to-br from-slate-50 via-indigo-50 to-purple-50 relative overflow-hidden">
        <!-- Background Effects -->
        <div class="absolute inset-0 opacity-30">
            <div class="absolute top-0 right-1/4 w-96 h-96 bg-gradient-to-br from-indigo-400/20 to-purple-500/20 rounded-full blur-3xl"></div>
            <div class="absolute bottom-0 left-1/4 w-80 h-80 bg-gradient-to-br from-blue-400/20 to-cyan-500/20 rounded-full blur-3xl"></div>
        </div>

        <div class="container-modern relative">
            <!-- Section Header -->
            <div class="text-center mb-16 animate-fadeInUp">
                <h2 class="text-4xl md:text-6xl font-bold text-gray-900 mb-6">
                    Choose Your <span class="text-gradient">Learning Path</span>
                </h2>
                <p class="text-xl text-gray-600 max-w-4xl mx-auto mb-8 leading-relaxed">
                    Select the perfect plan that fits your learning goals and budget. All plans include our core features with varying levels of access and premium benefits.
                </p>

                <!-- Enhanced Billing Toggle -->
                <div class="inline-flex items-center bg-white/80 backdrop-blur-sm rounded-2xl p-2 shadow-modern border border-white/30">
                    <button
                        :class="[
                            'px-8 py-3 rounded-xl font-semibold transition-all duration-300 relative overflow-hidden',
                            billingCycle === 'monthly'
                                ? 'bg-gradient-primary text-white shadow-modern'
                                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50',
                        ]"
                        @click="billingCycle = 'monthly'"
                    >
                        <span class="relative z-10">Monthly</span>
                        <div v-if="billingCycle === 'monthly'" class="absolute inset-0 bg-gradient-to-r from-indigo-600 to-purple-600 opacity-90"></div>
                    </button>
                    <button
                        :class="[
                            'px-8 py-3 rounded-xl font-semibold transition-all duration-300 relative overflow-hidden',
                            billingCycle === 'yearly'
                                ? 'bg-gradient-primary text-white shadow-modern'
                                : 'text-gray-600 hover:text-gray-900 hover:bg-gray-50',
                        ]"
                        @click="billingCycle = 'yearly'"
                    >
                        <span class="relative z-10">Yearly</span>
                        <div v-if="billingCycle === 'yearly'" class="absolute inset-0 bg-gradient-to-r from-indigo-600 to-purple-600 opacity-90"></div>
                        <span class="absolute -top-2 -right-2 bg-gradient-to-r from-green-500 to-emerald-600 text-white text-xs px-3 py-1 rounded-full font-bold shadow-lg animate-pulse">
                            Save 20%
                        </span>
                    </button>
                </div>
            </div>

            <!-- Pricing Cards -->
            <div ref="pricingGrid" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 max-w-7xl mx-auto mb-16">
                <div
                    v-for="(plan, index) in displayedPlans"
                    :key="index"
                    :class="[
                        'pricing-card group relative overflow-hidden transition-all duration-500 transform',
                        plan.popular
                            ? 'pricing-card-popular scale-105 lg:scale-110'
                            : 'hover:-translate-y-4',
                    ]"
                >
                    <!-- Popular Badge -->
                    <div v-if="plan.popular" class="absolute -top-4 left-1/2 transform -translate-x-1/2 z-20">
                        <div class="bg-gradient-to-r from-indigo-600 to-purple-600 text-white px-6 py-2 rounded-full text-sm font-bold shadow-xl animate-bounce">
                            ⭐ Most Popular
                        </div>
                    </div>

                    <!-- Card Background -->
                    <div :class="[
                        'relative p-8 rounded-3xl border-2 transition-all duration-500 h-full',
                        plan.popular
                            ? 'bg-gradient-to-br from-white via-indigo-50 to-purple-50 border-indigo-300 shadow-2xl'
                            : 'bg-white/80 backdrop-blur-sm border-white/30 shadow-modern hover:shadow-2xl hover:border-indigo-200'
                    ]">
                        <!-- Gradient Overlay for Popular Plan -->
                        <div v-if="plan.popular" class="absolute inset-0 bg-gradient-to-br from-indigo-500/5 to-purple-500/5 rounded-3xl"></div>
                        
                        <!-- Shimmer Effect -->
                        <div class="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-700">
                            <div class="absolute top-0 left-0 w-full h-full bg-gradient-to-r from-transparent via-white/20 to-transparent transform -skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                        </div>

                        <!-- Plan Header -->
                        <div class="text-center mb-8 relative z-10">
                            <h3 class="text-2xl font-bold text-gray-900 mb-4">
                                {{ plan.name }}
                            </h3>
                            <div class="mb-6">
                                <div class="flex items-baseline justify-center gap-2">
                                    <span :class="[
                                        'text-6xl font-bold transition-all duration-500',
                                        plan.popular ? 'text-gradient' : 'text-gray-900'
                                    ]">
                                        {{ getPlanPrice(plan) }}
                                    </span>
                                    <span class="text-gray-600 text-lg">
                                        {{ getPlanPeriod(plan) }}
                                    </span>
                                </div>
                                <div v-if="billingCycle === 'yearly' && plan.price !== 'Free'" class="text-green-600 font-semibold text-sm mt-2">
                                    💰 Save ${{ calculateYearlySavings(plan) }} per year
                                </div>
                            </div>
                            <p v-if="plan.description" class="text-gray-600 text-lg">
                                {{ plan.description }}
                            </p>
                        </div>

                        <!-- Features List -->
                        <div class="mb-8 relative z-10">
                            <ul class="space-y-4">
                                <li
                                    v-for="(feature, featureIndex) in plan.features"
                                    :key="featureIndex"
                                    class="flex items-start gap-3 group/feature"
                                >
                                    <div :class="[
                                        'flex-shrink-0 w-6 h-6 rounded-full flex items-center justify-center mt-0.5 transition-all duration-300 group-hover/feature:scale-110',
                                        plan.popular ? 'bg-gradient-primary' : 'bg-green-500'
                                    ]">
                                        <i class="pi pi-check text-white text-sm"></i>
                                    </div>
                                    <span class="text-gray-700 group-hover/feature:text-gray-900 transition-colors duration-300">{{ feature }}</span>
                                </li>
                            </ul>
                        </div>

                        <!-- CTA Button -->
                        <div class="text-center relative z-10">
                            <Link
                                :href="plan.cta_link || '/register'"
                                :class="[
                                    'inline-block w-full px-8 py-4 font-bold rounded-xl transition-all duration-300 transform hover:scale-105 relative overflow-hidden group/btn',
                                    plan.popular
                                        ? 'bg-gradient-primary text-white shadow-modern hover:shadow-glow'
                                        : 'bg-gray-900 text-white hover:bg-gray-800 shadow-modern',
                                ]"
                            >
                                <span class="relative z-10">{{ plan.cta_text || 'Get Started' }}</span>
                                <div class="absolute inset-0 bg-gradient-to-r from-white/0 via-white/20 to-white/0 transform -skew-x-12 -translate-x-full group-hover/btn:translate-x-full transition-transform duration-700"></div>
                            </Link>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Trust Indicators -->
            <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-16">
                <!-- Money Back Guarantee -->
                <div class="glass-card text-center hover-lift group">
                    <div class="w-16 h-16 bg-gradient-to-br from-green-500 to-emerald-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform duration-300">
                        <i class="pi pi-shield text-white text-2xl"></i>
                    </div>
                    <h3 class="font-bold text-gray-900 mb-2">30-Day Money Back</h3>
                    <p class="text-gray-600 text-sm">Try any plan risk-free. Not satisfied? Get a full refund, no questions asked.</p>
                </div>

                <!-- Instant Access -->
                <div class="glass-card text-center hover-lift group">
                    <div class="w-16 h-16 bg-gradient-to-br from-blue-500 to-indigo-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform duration-300">
                        <i class="pi pi-bolt text-white text-2xl"></i>
                    </div>
                    <h3 class="font-bold text-gray-900 mb-2">Instant Access</h3>
                    <p class="text-gray-600 text-sm">Start learning immediately after signup. No waiting, no setup required.</p>
                </div>

                <!-- Expert Support -->
                <div class="glass-card text-center hover-lift group">
                    <div class="w-16 h-16 bg-gradient-to-br from-purple-500 to-pink-600 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:scale-110 transition-transform duration-300">
                        <i class="pi pi-heart text-white text-2xl"></i>
                    </div>
                    <h3 class="font-bold text-gray-900 mb-2">Expert Support</h3>
                    <p class="text-gray-600 text-sm">Get help from our learning experts whenever you need it, 24/7.</p>
                </div>
            </div>

            <!-- FAQ Teaser -->
            <div class="text-center">
                <div class="inline-flex items-center gap-4 p-6 bg-white/60 backdrop-blur-sm rounded-2xl border border-white/30 shadow-modern hover-lift">
                    <i class="pi pi-question-circle text-indigo-600 text-2xl"></i>
                    <div class="text-left">
                        <div class="font-semibold text-gray-900">Have questions about our pricing?</div>
                        <Link href="/faq" class="text-indigo-600 hover:text-indigo-700 font-medium underline transition-colors duration-300">
                            Check our comprehensive FAQ →
                        </Link>
                    </div>
                </div>
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
                name: 'Starter',
                price: 'Free',
                yearly_price: 'Free',
                period: '',
                description: 'Perfect for getting started with learning',
                features: [
                    '5 quizzes per month',
                    'Basic analytics dashboard',
                    'Community support',
                    'Mobile app access',
                    'Progress tracking'
                ],
                cta_text: 'Start Free',
                cta_link: '/register',
                popular: false,
            },
            {
                name: 'Professional',
                price: '$12.99',
                yearly_price: '$9.99',
                period: '/month',
                description: 'Best for serious learners and professionals',
                features: [
                    'Unlimited quizzes & tests',
                    'Advanced analytics & insights',
                    'Priority email support',
                    'Custom study categories',
                    'Detailed progress reports',
                    'Export results to PDF',
                    'Ad-free experience',
                    'Offline mode access'
                ],
                cta_text: 'Go Professional',
                cta_link: '/subscribe/pro',
                popular: true,
            },
            {
                name: 'Enterprise',
                price: '$39.99',
                yearly_price: '$29.99',
                period: '/month',
                description: 'For teams and organizations',
                features: [
                    'Everything in Professional',
                    'Team management dashboard',
                    'API access & integrations',
                    'Custom branding options',
                    'Advanced reporting suite',
                    'SSO integration',
                    'Dedicated account manager',
                    'Custom training sessions',
                    'White-label solutions'
                ],
                cta_text: 'Contact Sales',
                cta_link: '/contact-sales',
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
const getPlanPrice = (plan) => {
    if (plan.price === 'Free') return 'Free'

    if (billingCycle.value === 'yearly' && plan.yearly_price) {
        return plan.yearly_price
    }

    return plan.price
}

const getPlanPeriod = (plan) => {
    if (plan.price === 'Free') return ''

    if (billingCycle.value === 'yearly') {
        return '/year'
    }

    return plan.period || '/month'
}

const calculateYearlySavings = (plan) => {
    if (plan.price === 'Free' || !plan.yearly_price) return 0
    
    const monthlyPrice = parseFloat(plan.price.replace('$', ''))
    const yearlyPrice = parseFloat(plan.yearly_price.replace('$', ''))
    
    return Math.round((monthlyPrice * 12) - (yearlyPrice * 12))
}

const animatePricingCards = () => {
    if (hasAnimated.value || !pricingGrid.value) return

    hasAnimated.value = true

    const cards = pricingGrid.value.querySelectorAll('.pricing-card')
    cards.forEach((card, index) => {
        setTimeout(() => {
            card.classList.add('animate-slideInUp')
        }, index * 200)
    })
}

// Lifecycle
onMounted(() => {
    if (pricingGrid.value) {
        // Create intersection observer to trigger animations when in view
        const observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
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
/* Pricing card animations */
.pricing-card {
    opacity: 0;
    transform: translateY(30px);
}

.pricing-card.animate-slideInUp {
    animation: slideInUp 0.8s ease-out forwards;
}

@keyframes slideInUp {
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Popular card special styling */
.pricing-card-popular {
    position: relative;
}

.pricing-card-popular::before {
    content: '';
    position: absolute;
    inset: -2px;
    background: linear-gradient(135deg, #667eea, #764ba2, #667eea);
    border-radius: 1.75rem;
    z-index: -1;
    animation: borderGlow 3s ease-in-out infinite;
}

@keyframes borderGlow {
    0%, 100% {
        opacity: 0.5;
        transform: scale(1);
    }
    50% {
        opacity: 0.8;
        transform: scale(1.02);
    }
}

/* Enhanced hover effects */
.pricing-card:hover {
    box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);
}

.pricing-card-popular:hover {
    box-shadow: 0 25px 50px -12px rgba(99, 102, 241, 0.4);
}

/* Feature checkmark animations */
.pricing-card:hover .pi-check {
    animation: checkBounce 0.6s ease-out;
}

@keyframes checkBounce {
    0%, 100% {
        transform: scale(1);
    }
    50% {
        transform: scale(1.3);
    }
}

/* Price change animations */
.pricing-card .text-6xl {
    transition: all 0.5s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Glass card styling */
.glass-card {
    background: rgba(255, 255, 255, 0.7);
    backdrop-filter: blur(10px);
    border: 1px solid rgba(255, 255, 255, 0.3);
    border-radius: 1.5rem;
    padding: 2rem;
    transition: all 0.3s ease;
}

.glass-card:hover {
    background: rgba(255, 255, 255, 0.8);
    transform: translateY(-8px);
    box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
}

/* Billing toggle enhancements */
.billing-toggle button {
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
}

/* Responsive adjustments */
@media (max-width: 1024px) {
    .pricing-card-popular {
        transform: scale(1);
    }
}

@media (max-width: 768px) {
    .pricing-card {
        padding: 1.5rem;
    }
    
    .text-6xl {
        font-size: 3rem;
    }
}

/* Staggered animation delays */
.pricing-card:nth-child(1) { animation-delay: 0ms; }
.pricing-card:nth-child(2) { animation-delay: 200ms; }
.pricing-card:nth-child(3) { animation-delay: 400ms; }

/* Enhanced accessibility */
@media (prefers-reduced-motion: reduce) {
    .pricing-card,
    .glass-card,
    .animate-bounce,
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
    .pricing-card > div {
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
