<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">
                {{ __('License Settings') }}
            </h4>
        </template>

        <div>
            <div class="max-w-7xl mx-auto py-10 sm:px-6 lg:px-8">
                <license-settings-form :settings="licenseSettings" />
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import LicenseSettingsForm from '@/Pages/Admin/Settings/LicenseSettingsForm.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    licenseSettings: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ License Settings') + ' - ' + pageProps.general.app_name
})
</script>
