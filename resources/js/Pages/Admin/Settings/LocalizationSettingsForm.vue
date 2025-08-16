<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Localization Settings') }}
        </template>

        <template #form>
            <!-- Default Locale -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="locale" :value="__('Default Locale')" />
                <v-select
                    id="locale"
                    v-model="form.default_locale"
                    :options="languages"
                    :reduce="lang => lang.id"
                    label="name"
                    placeholder="Select a Locale"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.default_locale" class="mt-2" />
            </div>
            <div class="col-span-6 sm:col-span-4">
                <p
                    v-if="form.default_locale"
                    class="font-mono px-2 py-1 inline-block bg-blue-100 text-gray-600 rounded text-sm"
                >
                    <strong>"{{ form.default_locale }}.json"</strong> {{ __('language_file_message') }}
                </p>
            </div>
            <!-- Default Direction -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="direction" :value="__('Default Direction')" />
                <v-select
                    id="direction"
                    v-model="form.default_direction"
                    :options="directions"
                    :reduce="lang => lang.id"
                    label="name"
                    placeholder="Select a Direction"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.default_direction" class="mt-2" />
            </div>
            <!-- Default Timezone -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="timezone" :value="__('Default Timezone')" />
                <v-select
                    id="timezone"
                    v-model="form.default_timezone"
                    :options="timezones"
                    placeholder="Select a Timezone"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.default_timezone" class="mt-2" />
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
    return __('Settings/ Localization Settings Form') + ' - ' + pageProps.general.app_name
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
