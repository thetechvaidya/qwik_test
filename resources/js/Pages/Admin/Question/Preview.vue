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
            <div class="grid grid-cols-1 gap-4 flex-wrap" v-if="safeQuestion">
                <template v-if="safeQuestion.question_type === 'MSA'">
                    <MSAPreview :question="safeQuestion"></MSAPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'MMA'">
                    <MMAPreview :question="safeQuestion"></MMAPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'TOF'">
                    <TOFPreview :question="safeQuestion"></TOFPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'FIB'">
                    <FIBPreview :question="safeQuestion"></FIBPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'MTF'">
                    <MTFPreview :question="safeQuestion"></MTFPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'ORD'">
                    <ORDPreview :question="safeQuestion"></ORDPreview>
                </template>
                <template v-if="safeQuestion.question_type === 'SAQ'">
                    <SAQPreview :question="safeQuestion"></SAQPreview>
                </template>
            </div>
            <div v-else class="text-red-500 p-4">
                Invalid content detected.
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { Head, usePage } from '@inertiajs/vue3';
import { useTranslate } from '@/composables/useTranslate';
import { sanitizeHtml, validateContent } from '@/utils/security';
import MSAPreview from '@/Components/Questions/Previews/MSAPreview.vue';
import MMAPreview from '@/Components/Questions/Previews/MMAPreview.vue';
import TOFPreview from '@/Components/Questions/Previews/TOFPreview.vue';
import FIBPreview from '@/Components/Questions/Previews/FIBPreview.vue';
import MTFPreview from '@/Components/Questions/Previews/MTFPreview.vue';
import ORDPreview from '@/Components/Questions/Previews/ORDPreview.vue';
import SAQPreview from '@/Components/Questions/Previews/SAQPreview.vue';
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer.vue';

// Props
const props = defineProps({
    questionId: {
        type: Number,
        required: true,
    },
    title: {
        type: String,
        default: 'Question Preview',
    },
});

// Composables
const { __ } = useTranslate();
const { props: pageProps } = usePage();

// State
const loading = ref(true);
const question = ref(null);
const safeQuestion = ref(null);

// Fetch question data
const fetchQuestion = async () => {
    try {
        const response = await axios.get(route('questions.show', { question: props.questionId }));
        const rawQuestion = response.data.data;

        if (validateContent(rawQuestion.question)) {
            const sanitizedQuestion = {
                ...rawQuestion,
                question: sanitizeHtml(rawQuestion.question),
            };
            question.value = sanitizedQuestion;
            safeQuestion.value = sanitizedQuestion;
        } else {
            console.error('Invalid content detected in question:', rawQuestion.id);
            safeQuestion.value = null;
        }
    } catch (error) {
        console.error('Failed to fetch question:', error);
    } finally {
        loading.value = false;
    }
};

onMounted(fetchQuestion);

watch(() => props.questionId, fetchQuestion);
</script>
