<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">
                {{ __('Payment Settings') }}
            </h4>
        </template>

        <div>
            <div class="max-w-7xl mx-auto py-10 sm:px-6 lg:px-8">
                <payment-settings-form
                    :settings="paymentSettings"
                    :payment-processors="paymentProcessors"
                    :currencies="currencies"
                />
                <arc-section-border />
                <paypal-settings-form
                    :settings="paypalSettings"
                    :payment-settings="paymentSettings"
                ></paypal-settings-form>
                <arc-section-border />
                <stripe-settings-form
                    :settings="stripeSettings"
                    :payment-settings="paymentSettings"
                ></stripe-settings-form>
                <arc-section-border />
                <razorpay-settings-form
                    :settings="razorpaySettings"
                    :payment-settings="paymentSettings"
                ></razorpay-settings-form>
                <arc-section-border />
                <bank-settings-form :settings="bankSettings" :payment-settings="paymentSettings"></bank-settings-form>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    // Add settings props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Payment Settings') + ' - ' + pageProps.general.app_name
})
</script>
