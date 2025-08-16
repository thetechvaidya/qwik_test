<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Top Bar Settings') }}
        </template>

        <template #form>
            <!-- Message -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="message" :value="__('Message')" />
                <arc-text-area id="message" v-model="form.message" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.message" class="mt-2" />
            </div>

            <!-- Button Text -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="button_text" :value="__('Button Text')" />
                <arc-input
                    id="button_text"
                    v-model="form.button_text"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="button_text"
                />
                <arc-input-error :message="form.errors.button_text" class="mt-2" />
            </div>

            <!-- Button Link -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="button_link" :value="__('Button Link')" />
                <arc-input
                    id="button_link"
                    v-model="form.button_link"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="hero_cta_text"
                />
                <arc-input-error :message="form.errors.button_link" class="mt-2" />
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
    return __('Settings/ Top Bar Settings Form') + ' - ' + pageProps.general.app_name
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
