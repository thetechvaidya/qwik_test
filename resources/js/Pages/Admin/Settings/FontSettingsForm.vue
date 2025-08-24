<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Font Settings') }}
        </template>

        <template #form>
            <!-- Mail Host -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="default_font" :value="__('Default Font Name')" />
                <arc-input
                    id="default_font"
                    v-model="form.default_font"
                    type="text"
                    class="mt-1 block w-full"
                    placeholder="E.g. Roboto"
                />
                <arc-input-error :message="form.errors.default_font" class="mt-2" />
            </div>

            <!-- User Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="default_font_url" :value="__('Default Font URL')" />
                <arc-input
                    id="default_font_url"
                    v-model="form.default_font_url"
                    type="text"
                    class="mt-1 block w-full"
                />
                <arc-input-error :message="form.errors.default_font_url" class="mt-2" />
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
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'

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
    return __('Settings/ Font Settings Form') + ' - ' + pageProps.general.app_name
})

// Form handling
const form = useForm({
    default_font: props.settings?.default_font || '',
    default_font_url: props.settings?.default_font_url || '',
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.font.update'), {
        errorBag: 'updateFontSettings',
        preserveScroll: true,
    })
}
</script>
