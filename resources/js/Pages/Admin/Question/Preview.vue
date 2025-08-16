<template>
    <Head :title="title" />
    <div class="overflow-y-auto h-screen px-2">
        <div class="bg-gray-100 py-4 lg:py-4 rounded">
            <div class="container px-6 mx-auto flex ltr:flex-row rtl:flex-row-reverse">
                <div>
                    <h4 class="text-base font-semibold leading-tight text-gray-800">
                        {{ title }}
                    </h4>
                </div>
            </div>
        </div>
        <div v-if="loading" class="my-6 w-11/12 mx-auto xl:w-full xl:mx-0">
            <form-input-shimmer></form-input-shimmer>
            <form-input-shimmer></form-input-shimmer>
            <form-input-shimmer></form-input-shimmer>
        </div>
        <div v-else class="mt-6 w-11/12 mx-auto xl:w-full xl:mx-0">
            <div class="grid grid-cols-1 gap-4 flex-wrap">
                <template v-if="question.question_type === 'MSA'">
                    <MSAPreview :question="question"></MSAPreview>
                </template>
                <template v-if="question.question_type === 'MMA'">
                    <MMAPreview :question="question"></MMAPreview>
                </template>
                <template v-if="question.question_type === 'TOF'">
                    <TOFPreview :question="question"></TOFPreview>
                </template>
                <template v-if="question.question_type === 'FIB'">
                    <FIBPreview :question="question"></FIBPreview>
                </template>
                <template v-if="question.question_type === 'MTF'">
                    <MTFPreview :question="question"></MTFPreview>
                </template>
                <template v-if="question.question_type === 'ORD'">
                    <ORDPreview :question="question"></ORDPreview>
                </template>
                <template v-if="question.question_type === 'SAQ'">
                    <SAQPreview :question="question"></SAQPreview>
                </template>
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    // Add props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Question/ Preview') + ' - ' + pageProps.general.app_name
})
</script>
