<template>
    <Head :title="title" />
    <arc-action-section>
        <template #title>
            {{ __('Fix Storage Links') }}
        </template>

        <template #content>
            <div class="max-w-xl text-sm text-gray-600">
                {{ __('storage_links_message') }}
            </div>

            <div class="flex items-center mt-5">
                <arc-confirms-password @confirmed="fixStorageLinks">
                    <arc-button type="button" :class="{ 'opacity-25': loading }" :disabled="loading">
                        {{ __('Fix Storage Links') }}
                    </arc-button>
                </arc-confirms-password>
            </div>
        </template>
    </arc-action-section>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import ArcActionSection from '@/Components/ActionSection.vue'
import ArcButton from '@/Components/Button.vue'
import ArcConfirmsPassword from '@/Components/ConfirmsPassword.vue'

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
    return __('Settings/ Storage Links Form') + ' - ' + pageProps.general.app_name
})

// Reactive state
const loading = ref(false)

// Methods
const fixStorageLinks = () => {
    loading.value = true
    
    axios.post(route('admin.settings.storage.fix'))
        .then(() => {
            // Handle success
            loading.value = false
        })
        .catch(() => {
            // Handle error
            loading.value = false
        })
}
</script>
