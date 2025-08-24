<template>
    <Head :title="title" />
    <arc-action-section>
        <template #title>
            {{ __('Clear Cache') }}
        </template>

        <template #content>
            <div class="max-w-xl text-sm text-gray-600">
                {{ __('clear_cache_message') }}
            </div>

            <div class="flex items-center mt-5">
                <arc-confirms-password @confirmed="clearCache">
                    <arc-button type="button" :class="{ 'opacity-25': loading }" :disabled="loading">
                        {{ __('Clear Cache') }}
                    </arc-button>
                </arc-confirms-password>
            </div>
        </template>
    </arc-action-section>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
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

// Reactive variables
const loading = ref(false)

// Computed
const title = computed(() => {
    return __('Settings/ Clear Cache Form') + ' - ' + pageProps.general.app_name
})

// Methods
const clearCache = () => {
    loading.value = true
    router.post(route('admin.settings.clear-cache'), {}, {
        onFinish: () => {
            loading.value = false
        }
    })
}
</script>
