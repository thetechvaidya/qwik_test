<template>
    <ArcFormSection @submitted="updateSettings">
        <template #title>
            {{ __('Payment Settings') }}
        </template>

        <template #form>
            <!-- Default Payment Gateway -->
            <div class="col-span-6 sm:col-span-4">
                <ArcLabel for="default_payment_processor" :value="__('Default Payment Processor')" />
                <v-select
                    id="locale"
                    v-model="form.default_payment_processor"
                    :options="paymentProcessors"
                    :reduce="payment => payment.code"
                    label="name"
                    :placeholder="__('Select a Processor')"
                    :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                />
                <ArcInputError :message="form.errors.default_payment_processor" class="mt-2" />
            </div>

            <!-- Default Currency -->
            <div class="col-span-6 sm:col-span-4">
                <ArcLabel for="default_currency" :value="__('Currency')" />
                <v-select
                    id="default_currency"
                    v-model="form.default_currency"
                    :options="currencies"
                    :reduce="currency => currency.code"
                    label="name"
                    :placeholder="__('Select a Currency')"
                    :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                />
                <ArcInputError :message="form.errors.default_currency" class="mt-2" />
            </div>

            <!-- Currency Symbol -->
            <div class="col-span-6 sm:col-span-4">
                <ArcLabel for="currency_symbol" :value="__('Currency Symbol')" />
                <ArcInput id="currency_symbol" v-model="form.currency_symbol" type="text" class="mt-1 block w-full" />
                <ArcInputError :message="form.errors.currency_symbol" class="mt-2" />
            </div>

            <!-- Currency Symbol Position -->
            <div class="col-span-6 sm:col-span-4">
                <ArcLabel for="currency_symbol_position" :value="__('Currency Symbol Position')" />
                <v-select
                    id="currency_symbol_position"
                    v-model="form.currency_symbol_position"
                    :options="positions"
                    :reduce="position => position.id"
                    label="name"
                    :placeholder="__('Select Position')"
                    :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                />
                <ArcInputError :message="form.errors.currency_symbol_position" class="mt-2" />
            </div>
        </template>

        <template #actions>
            <ArcActionMessage :on="form.recentlySuccessful" class="mr-3"> {{ __('Saved') }}. </ArcActionMessage>

            <ArcButton :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                {{ __('Save') }}
            </ArcButton>
        </template>
    </ArcFormSection>
</template>

<script setup>
import { ref } from 'vue'
import { useForm, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcActionMessage from '@/Components/ActionMessage'
import ArcButton from '@/Components/Button'
import ArcFormSection from '@/Components/FormSection'
import ArcInput from '@/Components/Input'
import ArcInputError from '@/Components/InputError'
import ArcLabel from '@/Components/Label'
import ArcSecondaryButton from '@/Components/SecondaryButton'
import ArcTextArea from '@/Components/TextArea'
import ToggleSwitch from 'primevue/toggleswitch'

const props = defineProps({
    settings: Object,
    paymentProcessors: Array,
    currencies: Array,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    default_payment_processor: props.settings.default_payment_processor,
    default_currency: props.settings.default_currency,
    currency_symbol: props.settings.currency_symbol,
    currency_symbol_position: props.settings.currency_symbol_position,
})

// Local data
const positions = ref([
    { id: 'left', name: 'Left' },
    { id: 'right', name: 'Right' },
])

// Methods
const updateSettings = () => {
    form.post(route('update_payment_settings'), {
        errorBag: 'updatePaymentSettings',
        preserveScroll: true,
    })
}
</script>
