<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">
                {{ __('General Settings') }}
            </h4>
        </template>

        <div>
            <div class="max-w-7xl mx-auto py-10 sm:px-6 lg:px-8">
                <SiteSettingsForm :settings="siteSettings" />
                <ArcSectionBorder />
                <SiteLogoForm :settings="siteSettings" />
                <ArcSectionBorder />
                <SiteWhiteLogoForm :settings="siteSettings" />
                <ArcSectionBorder />
                <SiteFaviconForm :settings="siteSettings" />
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcSectionBorder from '@/Components/SectionBorder.vue'
import SiteSettingsForm from '@/Pages/Admin/Settings/SiteSettingsForm.vue'
import SiteLogoForm from '@/Pages/Admin/Settings/SiteLogoForm.vue'
import SiteFaviconForm from '@/Pages/Admin/Settings/SiteFaviconForm.vue'
import SiteWhiteLogoForm from '@/Pages/Admin/Settings/SiteWhiteLogoForm.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
defineProps({
    siteSettings: Object,
})

// Composables
const { __ } = useTranslate()
const { props } = usePage()

// Computed properties
const title = computed(() => {
    return __('General Settings') + ' - ' + props.general.app_name
})
</script>
