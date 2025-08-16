<template>
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Site Settings') }}
        </template>

        <template #form>
            <!-- App Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="app_name" :value="__('Site Name')" />
                <arc-input
                    id="app_name"
                    v-model="form.app_name"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="app_name"
                />
                <arc-input-error :message="form.errors.app_name" class="mt-2" />
            </div>

            <!-- Tag Line -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="tag_line" :value="__('Tag Line')" />
                <arc-input
                    id="tag_line"
                    v-model="form.tag_line"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="tag_line"
                />
                <arc-input-error :message="form.errors.tag_line" class="mt-2" />
            </div>

            <!-- SEO Description -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="seo_description" :value="__('SEO Description')" />
                <arc-text-area id="seo_description" v-model="form.seo_description" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.seo_description" class="mt-2" />
            </div>

            <!-- Enable Registration -->
            <div class="p-4 bg-blue-50 rounded col-span-6 sm:col-span-4">
                <arc-label for="can_register" :value="__('Enable User Registration')" />
                <div class="flex justify-between items-center my-2">
                    <span class="text-sm text-blue-700">{{ form.can_register ? __('Enabled') : __('Disabled') }}</span>
                    <ToggleSwitch id="can_register" v-model="form.can_register" />
                </div>
                <arc-input-error :message="form.errors.can_register" class="mt-2" />
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
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcTextArea from '@/Components/TextArea.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcSecondaryButton from '@/Components/SecondaryButton.vue'
import ToggleSwitch from 'primevue/toggleswitch'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    settings: Object,
})

// Composables
const { __ } = useTranslate()

// Form initialization
const form = useForm({
    app_name: props.settings.app_name,
    tag_line: props.settings.tag_line,
    seo_description: props.settings.seo_description,
    can_register: !!Number(props.settings.can_register),
})

// Methods
const updateSettings = () => {
    form.post(route('update_site_settings'), {
        errorBag: 'updateSiteSettings',
        preserveScroll: true,
    })
}
</script>
