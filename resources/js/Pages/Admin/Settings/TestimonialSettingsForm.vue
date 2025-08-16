<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Testimonial Settings') }}
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

            <div v-for="testimonial in testimonials" class="p-4 bg-gray-50 rounded-md col-span-6 sm:sol-span-4">
                <div class="col-span-12 py-3 font-bold border-b border-gray-200">
                    <span>{{ __('Testimonial') }} {{ testimonial }}</span>
                </div>
                <!-- Testimonial Name -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'testimonial' + testimonial + '_name'" :value="__('Name')" />
                    <arc-input
                        :id="'testimonial' + testimonial + '_name'"
                        v-model="form['testimonial' + testimonial + '_name']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['testimonial' + testimonial + '_name']" class="mt-2" />
                </div>

                <!-- Testimonial Designation -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'testimonial' + testimonial + '_designation'" :value="__('Designation')" />
                    <arc-input
                        :id="'testimonial' + testimonial + '_designation'"
                        v-model="form['testimonial' + testimonial + '_designation']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error
                        :message="form.errors['testimonial' + testimonial + '_designation']"
                        class="mt-2"
                    />
                </div>

                <!-- Testimonial Message -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'testimonial' + testimonial + '_message'" :value="__('Message')" />
                    <arc-text-area
                        :id="'testimonial' + testimonial + '_message'"
                        v-model="form['testimonial' + testimonial + '_message']"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['testimonial' + testimonial + '_message']" class="mt-2" />
                </div>

                <!-- Testimonial Image -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'testimonial' + testimonial + '_image'" :value="__('Image')" />
                    <arc-input
                        :id="'testimonial' + testimonial + '_image'"
                        v-model="form['testimonial' + testimonial + '_image']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['testimonial' + testimonial + '_image']" class="mt-2" />
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
    return __('Settings/ Testimonial Settings Form') + ' - ' + pageProps.general.app_name
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
