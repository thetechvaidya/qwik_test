<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Razorpay Settings') }}
        </template>

        <template #form>
            <!-- Enable Razorpay -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_razorpay" :value="__('Enable Razorpay')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_razorpay" v-model="form.enable_razorpay" />
                </div>
                <arc-input-error :message="form.errors.enable_razorpay" class="mt-2" />
            </div>

            <!-- Key ID -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="key_id" :value="__('Razorpay Key Id')" />
                <arc-input id="key_id" v-model="form.key_id" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.key_id" class="mt-2" />
            </div>

            <!-- Key Secret -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="key_secret" :value="__('Razorpay Key Secret')" />
                <arc-input id="key_secret" v-model="form.key_secret" type="password" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.key_secret" class="mt-2" />
            </div>

            <!-- Webhook URL -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="webhook_url" :value="__('Razorpay Webhook URL')" />
                <arc-input
                    id="webhook_url"
                    v-model="webhookURL"
                    type="text"
                    class="mt-1 block w-full bg-gray-200"
                    readonly="readonly"
                />
            </div>

            <!-- Webhook Secret -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="webhook_secret" :value="__('Razorpay Webhook Secret')" />
                <arc-input
                    id="webhook_secret"
                    v-model="form.webhook_secret"
                    type="password"
                    class="mt-1 block w-full"
                />
                <arc-input-error :message="form.errors.webhook_secret" class="mt-2" />
            </div>
        </template>

        <template #actions>
            <arc-action-message :on="form.recentlySuccessful" class="mr-3"> {{ __('Saved') }}. </arc-action-message>

            <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                {{ __('Save') }}
            </arc-button>
        </template>
    </arc-form-section>
</template>
<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ToggleSwitch from 'primevue/toggleswitch'

// Props
const props = defineProps({
    settings: Object,
    paymentSettings: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Razorpay Settings Form') + ' - ' + pageProps.general.app_name
})

const webhookURL = computed(() => {
    return route('razorpay.webhook')
})

// Form handling
const form = useForm({
    enable_razorpay: props.settings?.enable_razorpay || false,
    key_id: props.settings?.key_id || '',
    key_secret: props.settings?.key_secret || '',
    webhook_secret: props.settings?.webhook_secret || '',
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.razorpay.update'), {
        errorBag: 'updateRazorpaySettings',
        preserveScroll: true,
    })
}
</script>
