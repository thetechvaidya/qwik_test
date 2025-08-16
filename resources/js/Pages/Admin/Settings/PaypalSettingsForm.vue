<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('PayPal Settings') }}
        </template>

        <template #form>
            <!-- Enable PayPal -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_paypal" :value="__('Enable PayPal')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_paypal" v-model="form.enable_paypal" />
                </div>
                <arc-input-error :message="form.errors.enable_paypal" class="mt-2" />
            </div>

            <!-- Client ID -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="client_id" :value="__('Client Id')" />
                <arc-input id="client_id" v-model="form.client_id" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.client_id" class="mt-2" />
            </div>

            <!-- Secret -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="secret" :value="__('Secret')" />
                <arc-input id="secret" v-model="form.secret" type="password" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.secret" class="mt-2" />
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
    return __('Settings/ Paypal Settings Form') + ' - ' + pageProps.general.app_name
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
