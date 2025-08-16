<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Feature Settings') }}
        </template>

        <template #form>
            <!-- Feature Title -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="title" :value="__('Title')" />
                <arc-input id="title" v-model="form.title" type="text" class="mt-1 block w-full" autocomplete="title" />
                <arc-input-error :message="form.errors.title" class="mt-2" />
            </div>

            <!-- Feature Subtitle -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="subtitle" :value="__('Subtitle')" />
                <arc-text-area id="subtitle" v-model="form.subtitle" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.subtitle" class="mt-2" />
            </div>

            <div v-for="feature in features" class="p-4 bg-gray-50 rounded-md col-span-6 sm:sol-span-4">
                <div class="col-span-12 py-3 font-bold border-b border-gray-200">
                    <span>{{ __('Feature') }} {{ feature }}</span>
                </div>
                <!-- Feature 1 Caption -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'feature' + feature + '_caption'" :value="__('Caption')" />
                    <arc-input
                        :id="'feature' + feature + '_caption'"
                        v-model="form['feature' + feature + '_caption']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['feature' + feature + '_caption']" class="mt-2" />
                </div>

                <!-- Feature 1 Description -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'feature' + feature + '_description'" :value="__('Description')" />
                    <arc-text-area
                        :id="'feature' + feature + '_description'"
                        v-model="form['feature' + feature + '_description']"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['feature' + feature + '_description']" class="mt-2" />
                </div>

                <!-- Feature 1 Icon URL -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'feature' + feature + '_icon_url'" :value="__('Icon URL') + ' (100x100)'" />
                    <arc-input
                        :id="'feature' + feature + '_icon_url'"
                        v-model="form['feature' + feature + '_icon_url']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['feature' + feature + '_icon_url']" class="mt-2" />
                </div>
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
    return __('Settings/ Feature Settings Form') + ' - ' + pageProps.general.app_name
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
