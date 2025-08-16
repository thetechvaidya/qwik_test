<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Stripe Settings') }}
        </template>

        <template #form>
            <!-- Enable Stripe -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_stripe" :value="__('Enable Stripe')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_stripe" v-model="form.enable_stripe" />
                </div>
                <arc-input-error :message="form.errors.enable_stripe" class="mt-2" />
            </div>

            <!-- Api Key -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="api_key" :value="__('Api Key')" />
                <arc-input id="api_key" v-model="form.api_key" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.api_key" class="mt-2" />
            </div>

            <!-- Secret Key -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="secret_key" :value="__('Secret Key')" />
                <arc-input id="secret_key" v-model="form.secret_key" type="password" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.secret_key" class="mt-2" />
            </div>

            <!-- Webhook URL -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="webhook_url" :value="__('Stripe Webhook URL')" />
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
                <arc-label for="webhook_secret" :value="__('Stripe Webhook Secret')" />
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
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'

// Props
const props = defineProps({
    settings: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Stripe Settings Form') + ' - ' + pageProps.general.app_name
})

// Form handling
const form = useForm({
    // Add form fields based on original file
})

// Methods
const updateSettings = () => {
    // Add form submission logic
}
</script>
