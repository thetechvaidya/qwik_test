<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">
                {{ __('Home Page Settings') }}
            </h4>
        </template>
        <div>
            <div class="max-w-7xl mx-auto py-10 sm:px-6 lg:px-8">
                <HomePageSettingsForm :settings="homePageSettings"></HomePageSettingsForm>
                <ArcSectionBorder />
                <TopBarSettingsForm :settings="topBarSettings"></TopBarSettingsForm>
                <ArcSectionBorder />
                <HeroSettingsForm :settings="heroSettings"></HeroSettingsForm>
                <ArcSectionBorder />
                <FeatureSettingsForm :settings="featureSettings"></FeatureSettingsForm>
                <ArcSectionBorder />
                <CategorySettingsForm :settings="categorySettings"></CategorySettingsForm>
                <ArcSectionBorder />
                <StatSettingsForm :settings="statSettings"></StatSettingsForm>
                <ArcSectionBorder />
                <TestimonialSettingsForm :settings="testimonialSettings"></TestimonialSettingsForm>
                <ArcSectionBorder />
                <CtaSettingsForm :settings="ctaSettings"></CtaSettingsForm>
                <ArcSectionBorder />
                <FooterSettingsForm :settings="footerSettings"></FooterSettingsForm>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcSectionBorder from '@/Components/SectionBorder.vue'
import HomePageSettingsForm from '@/Pages/Admin/Settings/HomePageSettingsForm.vue'
import TopBarSettingsForm from '@/Pages/Admin/Settings/TopBarSettingsForm.vue'
import FeatureSettingsForm from '@/Pages/Admin/Settings/FeatureSettingsForm.vue'
import CtaSettingsForm from '@/Pages/Admin/Settings/CtaSettingsForm.vue'
import HeroSettingsForm from '@/Pages/Admin/Settings/HeroSettingsForm.vue'
import TestimonialSettingsForm from '@/Pages/Admin/Settings/TestimonialSettingsForm.vue'
import StatSettingsForm from '@/Pages/Admin/Settings/StatSettingsForm.vue'
import CategorySettingsForm from '@/Pages/Admin/Settings/CategorySettingsForm.vue'
import FooterSettingsForm from '@/Pages/Admin/Settings/FooterSettingsForm.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
defineProps({
    homePageSettings: Object,
    heroSettings: Object,
    topBarSettings: Object,
    featureSettings: Object,
    ctaSettings: Object,
    testimonialSettings: Object,
    statSettings: Object,
    categorySettings: Object,
    footerSettings: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Home Page Settings') + ' - ' + pageProps.general.app_name
})
</script>
