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
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcSectionBorder from '@/Components/SectionBorder.vue'
import PaymentSettingsForm from '@/Pages/Admin/Settings/PaymentSettingsForm.vue'
import PaypalSettingsForm from '@/Pages/Admin/Settings/PaypalSettingsForm.vue'
import StripeSettingsForm from '@/Pages/Admin/Settings/StripeSettingsForm.vue'
import RazorpaySettingsForm from '@/Pages/Admin/Settings/RazorpaySettingsForm.vue'
import BankSettingsForm from '@/Pages/Admin/Settings/BankSettingsForm.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    paymentSettings: Object,
    paymentProcessors: Array,
    currencies: Array,
    paypalSettings: Object,
    stripeSettings: Object,
    razorpaySettings: Object,
    bankSettings: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Payment Settings') + ' - ' + pageProps.general.app_name
})
</script>
