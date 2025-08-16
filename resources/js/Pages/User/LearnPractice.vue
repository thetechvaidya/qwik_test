<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AppLayout from '@/Layouts/AppLayout.vue'
import PracticeCategoryCard from '@/Components/Cards/PracticeCategoryCard.vue'
import SectionHeader from '@/Components/SectionHeader.vue'
import { useTranslate } from '@/composables/useTranslate'

const props = defineProps({
    category: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()

const title = computed(() => {
    return __('Learn & Practice') + ' ' + props.category.name + ' - ' + pageProps.general.app_name
})
</script>

<template>
    <app-layout>
        <Head :title="title" />

        <template #header>
            <h1 class="app-heading">{{ __('Learn & Practice') }} {{ category.name }}</h1>
        </template>

        <div class="py-8">
            <div class="flex flex-col justify-center items-center">
                <div class="w-full">
                    <div class="flex flex-col gap-4 justify-center">
                        <practice-category-card :category="category"></practice-category-card>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>
