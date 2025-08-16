<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Activation Details') }}
        </template>

        <template #form>
            <!-- Purchase Code -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="purchase_code" :value="__('Purchase Code')" />
                <arc-input id="purchase_code" v-model="form.purchase_code" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.purchase_code" class="mt-2" />
            </div>

            <!-- Activation Key -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="activation_key" :value="version" />
                <arc-text-area id="activation_key" v-model="form.activation_key" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.activation_key" class="mt-2" />
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
    return __('Settings/ License Settings Form') + ' - ' + pageProps.general.app_name
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
