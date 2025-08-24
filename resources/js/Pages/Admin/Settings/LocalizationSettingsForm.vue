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
                    :reduce="dir => dir.id"
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
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'

// Props
const props = defineProps({
    settings: Object,
    errors: Object,
    languages: {
        type: Array,
        default: () => []
    },
    directions: {
        type: Array,
        default: () => [
            { id: 'ltr', name: 'Left to Right (LTR)' },
            { id: 'rtl', name: 'Right to Left (RTL)' }
        ]
    },
    timezones: {
        type: Array,
        default: () => []
    }
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Reactive data
const languages = computed(() => props.languages)
const directions = computed(() => props.directions)
const timezones = computed(() => props.timezones)

// Computed
const title = computed(() => {
    return __('Settings/ Localization Settings Form') + ' - ' + pageProps.general.app_name
})

// Form handling
const form = useForm({
    default_locale: props.settings?.default_locale || '',
    default_direction: props.settings?.default_direction || 'ltr',
    default_timezone: props.settings?.default_timezone || ''
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.localization.update'), {
        onSuccess: () => {
            // Handle success
        },
        onError: () => {
            // Handle error
        }
    })
}
</script>
