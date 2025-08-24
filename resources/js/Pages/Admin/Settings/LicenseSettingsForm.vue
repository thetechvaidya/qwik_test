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
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcTextArea from '@/Components/TextArea.vue'

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

const version = computed(() => {
    return __('Activation Key (Version: ') + (pageProps.general?.app_version || '1.0.0') + ')'
})

// Form handling
const form = useForm({
    purchase_code: props.settings?.purchase_code || '',
    activation_key: props.settings?.activation_key || '',
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.license.update'), {
        errorBag: 'updateLicenseSettings',
        preserveScroll: true,
    })
}
</script>
