<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Question') }} {{ __('Details') }}</h2
                    >
                    <p class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        >{{ questionType.name }} {{ __('Question') }}</p
                    >
                </div>
                <HorizontalStepper :steps="steps" :edit-flag="editFlag"></HorizontalStepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="xl:w-8/12 w-full py-2 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div v-if="!editFlag" class="w-full flex flex-col mb-6">
                                    <label for="skill_id" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Skill')
                                    }}</label>
                                    <Select
                                        id="skill_id"
                                        v-model="v$.form.skill_id.$model"
                                        :options="skills"
                                        optionValue="id"
                                        optionLabel="name"
                                        :placeholder="__('Select Skill')"
                                        filter
                                        showClear
                                        class="w-full"
                                        @filter="searchSkills"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.skill_id.$error && v$.form.skill_id.required?.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Skill') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="question" class="pb-2 font-semibold text-gray-800 text-sm">{{
                                        __('Question')
                                    }}</label>
                                    <TiptapEditor
                                        v-model="form.question"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: $page.props.rtl,
                                            height: '200px',
                                        }"
                                        :invalid="errors.question"
                                        :placeholder="__('Enter question text...')"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.question.$error && v$.form.question.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Question') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full bg-green-50 rounded py-4 px-6">
                                    <div v-if="questionType.code === 'MSA'">
                                        <MSAOptions
                                            :parent-options="form.options"
                                            :parent-answer="form.correct_answer"
                                            @modify-options="updateOptions"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'MMA'">
                                        <MMAOptions
                                            :parent-options="form.options"
                                            :parent-answer="form.correct_answer"
                                            @modify-options="updateOptions"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'ORD'">
                                        <ORDOptions
                                            :parent-options="form.options"
                                            :parent-answer="form.correct_answer"
                                            @modify-options="updateOptions"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'MTF'">
                                        <MTFOptions
                                            :parent-options="form.options"
                                            :parent-answer="form.correct_answer"
                                            @modify-options="updateOptions"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'SAQ'">
                                        <SAQOptions
                                            :parent-answer="form.correct_answer"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'LAQ'">
                                        <LAQOptions
                                            :parent-answer="form.correct_answer"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'FIB'">
                                        <FIBOptions
                                            :parent-answer="form.correct_answer"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'EMQ'">
                                        <EMQOptions
                                            :parent-options="form.options"
                                            :parent-answer="form.correct_answer"
                                            @modify-options="updateOptions"
                                            @modify-answer="updateAnswer"
                                        />
                                    </div>
                                    <div v-if="questionType.code === 'TF'">
                                        <TFOptions :parent-answer="form.correct_answer" @modify-answer="updateAnswer" />
                                    </div>
                                </div>
                                <div
                                    v-if="questionType.preferences && questionType.preferences.length > 0"
                                    class="my-6"
                                >
                                    <Preferences
                                        :question-type="questionType"
                                        :edit-flag="editFlag"
                                        :question-preferences="form.preferences"
                                        @modify-preferences="updatePreferences"
                                    />
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mt-8">
                                        <div class="flex items-center gap-2">
                                            <Button
                                                type="submit"
                                                :loading="form.processing"
                                                class="qt-btn qt-btn-primary"
                                            >
                                                {{ editFlag ? __('Update') : __('Create') }}
                                            </Button>
                                        </div>
                                    </div>
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
import { computed, ref, watch } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import TiptapEditor from '@/Components/TiptapEditor'
import Button from 'primevue/button'
import Select from 'primevue/select'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper.vue'
import MSAOptions from '@/Components/Questions/MSAOptions.vue'
import MMAOptions from '@/Components/Questions/MMAOptions.vue'
import ORDOptions from '@/Components/Questions/ORDOptions.vue'
import MTFOptions from '@/Components/Questions/MTFOptions.vue'
import SAQOptions from '@/Components/Questions/SAQOptions.vue'
import LAQOptions from '@/Components/Questions/LAQOptions.vue'
import FIBOptions from '@/Components/Questions/FIBOptions.vue'
import EMQOptions from '@/Components/Questions/MTFOptions.vue' // EMQ uses MTF component for now
import TFOptions from '@/Components/Questions/TOFOptions.vue'
import Preferences from '@/Components/Questions/SAQPreferences.vue'
import axios from 'axios'

const props = defineProps({
    question: Object,
    questionType: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    questionId: Number,
    initialSkills: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    skill_id: props.editFlag ? props.question.skill_id : '',
    question: props.editFlag ? props.question.question : '',
    question_type_id: props.questionType.id,
    options: props.editFlag ? props.question.options : [],
    correct_answer: props.editFlag ? props.question.correct_answer : '',
    preferences: props.editFlag ? props.question.preferences : {},
})

// Local state
const skills = ref(props.initialSkills)
const debounce = ref(null)
const searchAbortController = ref(null)
const submitStatus = ref(null)
const formValidated = ref(false)

// Validation rules with conditional validation based on question type
const validationRules = computed(() => ({
    form: {
        ...(!props.editFlag && {
            skill_id: { required },
        }),
        question: { required },
        question_type_id: { required },
        ...(props.questionType.code !== 'LAQ' &&
            props.questionType.code !== 'FIB' && {
                options: {
                    $each: {
                        option: { required },
                        ...(props.questionType.code === 'MTF' && {
                            pair: { required },
                        }),
                    },
                },
            }),
        ...(props.questionType.code !== 'ORD' &&
            props.questionType.code !== 'MTF' &&
            props.questionType.code !== 'LAQ' &&
            props.questionType.code !== 'FIB' && {
                correct_answer: { required },
            }),
    },
}))

const v$ = useVuelidate(validationRules, { form })

// Computed properties
const title = computed(() => {
    return __('Question Details') + ' - ' + pageProps.general.app_name
})

// Methods
const submitForm = () => {
    v$.value.$touch()
    if (v$.value.$invalid) {
        submitStatus.value = 'ERROR'
    } else {
        submitStatus.value = 'PENDING'
        setTimeout(() => {
            submitStatus.value = 'OK'
            props.editFlag ? update() : create()
        }, 100)
    }
}

const create = () => {
    formValidated.value = true
    form.post(route('questions.store'), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                emit('close', true)
            }
        },
    })
}

const update = () => {
    formValidated.value = true
    form.patch(route('questions.update', { id: props.questionId }), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                emit('close', true)
            }
        },
    })
}

const updateOptions = value => {
    form.options = value
}

const updateAnswer = value => {
    form.correct_answer = value
}

const updatePreferences = value => {
    form.preferences = value
}

const searchSkills = (search, loading) => {
    if (search !== '') {
        loading(true)

        // Cancel previous request
        if (searchAbortController.value) {
            searchAbortController.value.abort()
        }

        searchAbortController.value = new AbortController()

        if (debounce.value) {
            clearTimeout(debounce.value)
        }

        skills.value = []

        debounce.value = setTimeout(() => {
            axios
                .get(route('search_skills', { query: search }), {
                    signal: searchAbortController.value.signal,
                })
                .then(response => {
                    skills.value = response.data.skills
                    loading(false)
                    searchAbortController.value = null
                })
                .catch(error => {
                    if (!axios.isCancel(error)) {
                        console.error('Search skills error:', error)
                    }
                    loading(false)
                    searchAbortController.value = null
                })
        }, 600)
    }
}
</script>
