<template>
    <Head :title="title" />
    <arc-action-section>
        <template #title>
            {{ __('Debug Mode') }}
        </template>

        <template #content>
            <div class="max-w-xl text-sm text-gray-600">
                {{ __('Enabling debug mode will expose sensitive data.') }}
            </div>

            <div class="flex flex-col mt-5">
                <!-- Enable/Disable Debug Mode -->
                <div class="flex gap-6 mb-4">
                    <arc-label for="debug_mode">
                        {{ __('Debug Mode') }} ({{ debugMode ? __('Enabled') : __('Disabled') }})
                    </arc-label>
                    <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch id="debug_mode" v-model="mode" />
                    </div>
                </div>
                <arc-confirms-password @confirmed="updateMode">
                    <arc-button type="button" :class="{ 'opacity-25': loading }" :disabled="loading">
                        {{ __('Save') }}
                    </arc-button>
                </arc-confirms-password>
            </div>
        </template>
    </arc-action-section>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ToggleSwitch from 'primevue/toggleswitch'

// Props
const props = defineProps({
    settings: Object,
    errors: Object,
    debugMode: {
        type: Boolean,
        default: false
    }
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Reactive variables
const mode = ref(props.debugMode)
const loading = ref(false)

// Computed
const title = computed(() => {
    return __('Settings/ Debug Mode Form') + ' - ' + pageProps.general.app_name
})

const debugMode = computed(() => props.debugMode)

// Form handling
const form = useForm({
    debug_mode: props.debugMode
})

// Methods
const updateMode = () => {
    loading.value = true
    form.debug_mode = mode.value
    
    form.post(route('admin.settings.debug-mode.update'), {
        onSuccess: () => {
            loading.value = false
        },
        onError: () => {
            loading.value = false
        }
    })
}

const updateSettings = () => {
    // Add form submission logic
}
</script>
