<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading"> {{ __('Maintenance Settings') }} (v{{ appVersion }}) </h4>
        </template>

        <div>
            <div class="max-w-7xl mx-auto py-10 sm:px-6 lg:px-8">
                <clear-cache-form></clear-cache-form>
                <arc-section-border />
                <expire-schedules-form></expire-schedules-form>
                <arc-section-border />
                <storage-links-form></storage-links-form>
                <arc-section-border />
                <update-app-form></update-app-form>
                <arc-section-border />
                <debug-mode-form :debug-mode="debugMode"></debug-mode-form>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    // Add settings props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Reactive variables
const appVersion = ref(pageProps.general?.app_version || '1.0.0')
const debugMode = ref(pageProps.settings?.debug_mode || false)

// Computed
const title = computed(() => {
    return __('Settings/ Maintenance Settings') + ' - ' + pageProps.general.app_name
})
</script>
