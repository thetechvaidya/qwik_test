<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Question') }} {{ __('Solution') }}</h2
                    >
                    <p class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        >{{ questionType.name }} {{ __('Question') }}</p
                    >
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="md:w-8/12 w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="solution" class="pb-2 font-semibold text-gray-800">{{
                                        __('Solution')
                                    }}</label>
                                    <TiptapEditor
                                        v-model="form.solution"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: pageProps.rtl,
                                        }"
                                        :height="'250px'"
                                        :placeholder="__('Enter solution...')"
                                        :invalid="errors.solution"
                                    />
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <div class="flex gap-2 mb-2">
                                        <label for="solution_has_video" class="font-semibold text-gray-800 pb-1">{{
                                            __('Enable Solution Video')
                                        }}</label>
                                    </div>
                                    <SelectButton
                                        id="solution_has_video"
                                        v-model="form.solution_has_video"
                                        :options="choices"
                                        data-key="code"
                                        option-value="code"
                                        option-label="name"
                                    />
                                </div>
                                <div v-if="form.solution_has_video" class="w-full flex flex-col mb-6">
                                    <VideoOptions
                                        id="solution_video"
                                        :parent-options="form.solution_video"
                                        @modify-options="updateVideoOptions"
                                    />
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="hint" class="pb-2 font-semibold text-gray-800">{{ __('Hint') }}</label>
                                    <TiptapEditor
                                        v-model="form.hint"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: pageProps.rtl,
                                            useAutoRenderForMath: true,
                                        }"
                                        :height="'180px'"
                                        :placeholder="__('Enter hint...')"
                                        :invalid="errors.hint"
                                    />
                                </div>
                                <!-- Submit Button -->
                                <div class="w-full flex justify-end my-8">
                                    <Button type="submit" :label="editFlag ? __('Update') : __('Save')" />
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router, useForm } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import Button from 'primevue/button'
import SelectButton from 'primevue/selectbutton'
import TiptapEditor from '@/Components/TiptapEditor.vue'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper.vue'
import VideoOptions from '@/Components/Questions/VideoOptions.vue'

// Props
const props = defineProps({
    question: Object,
    questionType: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    questionId: Number,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    solution: props.editFlag ? props.question.solution : '',
    solution_has_video: props.editFlag ? props.question.solution_has_video : false,
    solution_video: props.editFlag ? props.question.solution_video : null,
    hint: props.editFlag ? props.question.hint : '',
})

// Data
const choices = ref([
    { name: __('Yes'), code: true },
    { name: __('No'), code: false },
])

// Methods
const submitForm = () => {
    if (props.editFlag) {
        form.patch(route('questions.solution.update', { question: props.questionId }))
    } else {
        form.post(route('questions.solution.store', { question: props.questionId }))
    }
}

const updateVideoOptions = (value) => {
    form.solution_video = value
}

// Computed
const title = computed(() => {
    return __('Question/ Solution') + ' - ' + pageProps.general.app_name
})
</script>
