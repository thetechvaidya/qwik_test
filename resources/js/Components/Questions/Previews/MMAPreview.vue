<template>
    <div class="bg-white shadow px-4 py-5 border-b-4 border-gray-800 mb-6">
        <h5 class="inline-block bg-green-100 rounded-sm px-2 py-1 mb-4 text-xs leading-3 text-green-700">{{ question.skill }}</h5>
        <div class="q-data mb-4">
            <div v-if="questionError" class="text-sm text-red-500 bg-red-100 p-3 rounded-sm">{{ questionError }}</div>
            <div v-else-if="isQuestionProcessing" class="text-sm">Sanitizing...</div>
            <div v-else class="text-sm" v-html="sanitizedQuestionHtml"></div>
        </div>
        <div v-show="!collapse" :id="question.code+'_options'">
            <ul v-for="(option, index) in question.options" class="q-option">
                <li class="relative flex items-center mb-3 cursor-pointer p-3 rounded-sm border border-gray-200">
                    <div class="h-6 w-6 text-sm flex rounded-full items-center justify-center bg-gray-100 ">{{ index+1 }}</div>
                    <div class="text-sm font-normal ltr:ml-4 rtl:mr-4" v-html="sanitizedOptionsHtml[index]"></div>
                    <div v-if="question.correct_answer.includes(index+1)" class="absolute ltr:right-2 rtl:left-2 text-green-500">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    </div>
                </li>
            </ul>
        </div>
        <a class="qt-link-success text-sm mb-4" @click="collapse = !collapse">{{ collapse ? __('View Options') : __('Hide Options') }}</a>
        <ul class="mt-5">
            <li class="text-gray-600 flex text-sm items-center mb-4">
                <span class="font-semibold ">{{ __('Question Type') }}:</span>
                <span class="ltr:ml-2 rtl:mr-2">{{ question.question_type_name }}</span>
            </li>
            <li class="text-gray-600 flex text-sm items-center mb-4">
                <span class="font-semibold">{{ __('Difficulty Level') }}:</span>
                <span class="ltr:ml-2 rtl:mr-2">{{ question.difficulty }}</span>
            </li>
            <li class="text-gray-600 flex text-sm items-center mb-4">
                <span class="font-semibold">{{ __('Marks/Points') }}:</span>
                <span class="ltr:ml-2 rtl:mr-2">{{ question.marks }} XP</span>
            </li>
            <li class="text-gray-600 flex text-sm items-center mb-4">
                <span class="font-semibold">{{ __('Attachment') }}:</span>
                <span class="ltr:ml-2 rtl:mr-2">{{ __(question.attachment) }}</span>
            </li>
        </ul>
        <div class="mt-4 flex justify-between items-center">
            <h5 class="inline-block bg-gray-100 rounded-sm px-2 py-1 text-xs leading-3 text-gray-700">{{ question.code }}</h5>
            <slot name="action"></slot>
        </div>
    </div>
</template>
<script>
    import { ref, toRefs, watch, computed } from 'vue';
    import { useSanitizedHtml, sanitizeHtml } from '../../../composables/useSanitizedHtml';

    export default {
        name: "MMAPreview",
        props: {
            question: Object,
        },
        setup(props) {
            const { question } = toRefs(props);

            const questionContent = computed(() => question.value.question);
            const {
              sanitizedHtml: sanitizedQuestionHtml,
              error: questionError,
              isProcessing: isQuestionProcessing
            } = useSanitizedHtml(questionContent);

            const sanitizedOptionsHtml = computed(() => {
                if (!Array.isArray(question.value?.options)) {
                    return [];
                }
                return question.value.options.map(option => sanitizeHtml(option?.option || ''));
            });

            return {
                collapse: ref(true),
                sanitizedQuestionHtml,
                questionError,
                isQuestionProcessing,
                sanitizedOptionsHtml,
            };
        },
        watch: {
            'question.question': {
                handler() {
                    this.$nextTick(() => {
                        if (window.renderMathInElement) {
                            window.renderMathInElement(this.$el);
                        }
                    });
                },
                immediate: true,
            },
        },
    }
</script>
