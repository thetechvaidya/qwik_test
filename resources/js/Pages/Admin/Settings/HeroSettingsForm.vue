<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Hero Settings') }}
        </template>

        <template #form>
            <!-- Hero Title -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="title" :value="__('Title')" />
                <arc-input id="title" v-model="form.title" type="text" class="mt-1 block w-full" autocomplete="title" />
                <arc-input-error :message="form.errors.title" class="mt-2" />
            </div>

            <!-- Hero Subtitle -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="subtitle" :value="__('Subtitle')" />
                <arc-text-area id="subtitle" v-model="form.subtitle" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.subtitle" class="mt-2" />
            </div>

            <!-- CTA Text -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="cta_text" :value="__('CTA Text')" />
                <arc-input
                    id="cta_text"
                    v-model="form.cta_text"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="cta_text"
                />
                <arc-input-error :message="form.errors.cta_text" class="mt-2" />
            </div>

            <!-- CTA Link -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="cta_link" :value="__('CTA Link')" />
                <arc-input
                    id="cta_link"
                    v-model="form.cta_link"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="cta_link"
                />
                <arc-input-error :message="form.errors.cta_link" class="mt-2" />
            </div>

            <!-- Hero Image Path -->
            <div class="col-span-6 sm:col-span-4">
                <input ref="image" type="file" class="hidden" @change="updateImagePreview" />

                <arc-label for="image" :value="__('Image')" />

                <div v-show="!imagePreview" class="mt-2">
                    <img :src="pageProps.assetUrl + settings.image_path" alt="Hero Image" class="h-64 object-cover" />
                </div>

                <!-- New Hero Image Preview -->
                <div v-show="imagePreview" class="mt-2">
                    <span
                        class="block h-64"
                        :style="
                            'background-size: contain; background-repeat: no-repeat; background-position: center center; background-image: url(\'' +
                            imagePreview +
                            '\');'
                        "
                    >
                    </span>
                </div>

                <arc-secondary-button
                    class="mt-2 ltr:mr-2 rtl:ml-2"
                    type="button"
                    @click.native.prevent="selectNewImage"
                >
                    {{ __('Select A New Image') }}
                </arc-secondary-button>

                <arc-input-error :message="form.errors.hero_image_path" class="mt-2" />
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
    return __('Settings/ Hero Settings Form') + ' - ' + pageProps.general.app_name
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
