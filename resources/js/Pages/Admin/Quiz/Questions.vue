<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Quiz') }} {{ __('Questions') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? quiz.title : 'New Quiz'"
                    ></p>
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="sm:w-4/12 w-full p-4">
                            <div>
                                <h4 class="py-2 font-semibold flex items-center gap-2 text-gray-800 border-b">
                                    <svg
                                        class="w-5 h-5"
                                        fill="none"
                                        stroke="currentColor"
                                        viewBox="0 0 24 24"
                                        xmlns="http://www.w3.org/2000/svg"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2.586a1 1 0 01-.293.707l-6.414 6.414a1 1 0 00-.293.707V17l-4 4v-6.586a1 1 0 00-.293-.707L3.293 7.293A1 1 0 013 6.586V4z"
                                        ></path>
                                    </svg>
                                    {{ __('Filters') }}
                                </h4>
                                <div class="w-full flex flex-col mt-6">
                                    <label for="code" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Code')
                                    }}</label>
                                    <InputText
id="code" v-model="codeFilter" type="text"
                                        placeholder="Enter Code"
                                        aria-describedby="code-help"
                                    />
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label class="mb-3 text-sm font-semibold text-gray-800">{{ __('Type') }}</label>
                                    <div class="flex flex-col gap-2">
                                        <div
                                            v-for="questionType in questionTypes"
                                            class="p-field-radiobutton items-center"
                                        >
                                            <Checkbox
                                                :id="'q_type' + questionType.id"
                                                v-model="typeFilter"
                                                name="q_type"
                                                :value="questionType.id"
                                            />
                                            <label class="text-sm text-gray-800" :for="'q_type' + questionType.id">{{
                                                questionType.name
                                            }}</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label for="section" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Section')
                                    }}</label>
                                    <InputText
id="section" v-model="sectionFilter" type="text"
                                        placeholder="Enter Section"
                                        aria-describedby="section-help"
                                    />
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label for="skill" class="mb-3 text-sm font-semibold text-gray-800">{{
                                        __('Skill')
                                    }}</label>
                                    <InputText
id="skill" v-model="skillFilter" type="text"
                                        placeholder="Enter Skill"
                                        aria-describedby="skill-help"
                                    />
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label for="topic" class="mb-3 text-sm font-semibold text-gray-800">{{
                                        __('Topic')
                                    }}</label>
                                    <InputText
id="topic" v-model="topicFilter" type="text"
                                        placeholder="Enter Topic"
                                        aria-describedby="topic-help"
                                    />
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label for="tag" class="pb-2 text-sm font-semibold text-gray-800">By Tag</label>
                                    <v-select
id="tag" v-model="tagArray" multiple :options="tags" label="name"
                                        :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                        @search="searchTags"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                </div>
                                <div class="w-full flex flex-col mt-6">
                                    <label class="mb-3 text-sm font-semibold text-gray-800">{{
                                        __('Difficulty Level')
                                    }}</label>
                                    <div class="flex flex-col gap-2">
                                        <div v-for="difficulty in difficultyLevels" class="p-field-radiobutton">
                                            <Checkbox
                                                :id="'difficulty' + difficulty.id"
                                                v-model="difficultyFilter"
                                                name="difficulty"
                                                :value="difficulty.id"
                                            />
                                            <label class="text-sm text-gray-800" :for="'difficulty' + difficulty.id">{{
                                                difficulty.name
                                            }}</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full flex items-center gap-2 my-8">
                                    <button type="button" class="w-full qt-btn qt-btn-primary" @click="resetFilters">{{
                                        __('Reset')
                                    }}</button>
                                    <button
                                        type="button"
                                        class="w-full qt-btn qt-btn-success"
                                        @click="filterQuestions"
                                        >{{ __('Search') }}</button
                                    >
                                </div>
                            </div>
                        </div>
                        <div class="sm:w-8/12 w-full my-4">
                            <div class="my-2 p-4 border border-green-100 shadow-sm rounded-sm bg-green-50">
                                <div class="mb-2 font-semibold"
                                    >{{ __('Currently') }} {{ qEditFlag ? __('Adding') : __('Viewing') }}
                                    {{ __('Questions') }}</div
                                >
                                <div class="flex flex-col sm:flex-row gap-2">
                                    <div
                                        ><a href="#" class="text-sm qt-link-success" @click="viewQuestions()"
                                            >{{ __('View') }} {{ __('Questions') }}</a
                                        ></div
                                    >
                                    <div class="hidden sm:inline-block">|</div>
                                    <div
                                        ><a href="#" class="text-sm qt-link-success" @click="editQuestions()"
                                            >{{ __('Add') }} {{ __('Questions') }}</a
                                        ></div
                                    >
                                </div>
                            </div>
                            <div class="bg-gray-100 rounded p-6">
                                <div v-if="loading" class="grid grid-cols-1 gap-4 flex-wrap">
                                    <admin-question-shimmer></admin-question-shimmer>
                                    <admin-question-shimmer></admin-question-shimmer>
                                    <admin-question-shimmer></admin-question-shimmer>
                                    <admin-question-shimmer></admin-question-shimmer>
                                </div>
                                <div v-else>
                                    <div class="text-sm mb-4">
                                        <span class="text-gray-500 font-normal"
                                            >{{ pagination.total }} {{ __('items_found_message') }}.</span
                                        >
                                    </div>
                                    <div class="grid grid-cols-1 gap-4 flex-wrap">
                                        <template v-for="(question, index) in questions">
                                            <template v-if="question.question_type === 'MSA'">
                                                <MSAPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </MSAPreview>
                                            </template>
                                            <template v-if="question.question_type === 'MMA'">
                                                <MMAPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </MMAPreview>
                                            </template>
                                            <template v-if="question.question_type === 'TOF'">
                                                <TOFPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </TOFPreview>
                                            </template>
                                            <template v-if="question.question_type === 'FIB'">
                                                <FIBPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </FIBPreview>
                                            </template>
                                            <template v-if="question.question_type === 'MTF'">
                                                <MTFPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </MTFPreview>
                                            </template>
                                            <template v-if="question.question_type === 'ORD'">
                                                <ORDPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </ORDPreview>
                                            </template>
                                            <template v-if="question.question_type === 'SAQ'">
                                                <SAQPreview :question="question">
                                                    <template #action>
                                                        <button
class="qt-btn-sm" :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']" ]"
                                                                :disabled="question.disabled"
                                                            @click="qEditFlag ? addQuestion(question.id, index) : removeQuestion(question.id, index)"
                                                            v-html="qEditFlag ? __('Add') : __('Remove')"
                                                        ></button>
                                                    </template>
                                                </SAQPreview>
                                            </template>
                                        </template>
                                        <div v-if="questions.length === 0" class="flex justify-center items-center">
                                            <h4 class="p-4 font-semibold">{{ __('No Questions') }}</h4>
                                        </div>
                                        <div
                                            v-else-if="pagination && !(questions.length === pagination.total)"
                                            class="flex justify-center items-center"
                                        >
                                            <button class="qt-btn qt-btn-success" @click="loadMoreQuestions">{{
                                                __('Load More')
                                            }}</button>
                                        </div>
                                        <div v-else class="flex text-sm justify-center items-center py-4">
                                            {{ __('no_more_data_message') }}
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import InputText from 'primevue/inputtext'
import Checkbox from 'primevue/checkbox'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper.vue'
import MSAPreview from '@/Components/Questions/Previews/MSAPreview.vue'
import MMAPreview from '@/Components/Questions/Previews/MMAPreview.vue'
import TOFPreview from '@/Components/Questions/Previews/TOFPreview.vue'
import FIBPreview from '@/Components/Questions/Previews/FIBPreview.vue'
import MTFPreview from '@/Components/Questions/Previews/MTFPreview.vue'
import ORDPreview from '@/Components/Questions/Previews/ORDPreview.vue'
import SAQPreview from '@/Components/Questions/Previews/SAQPreview.vue'
import AdminQuestionShimmer from '@/Components/Shimmers/AdminQuestionShimmer.vue'

// Props
const props = defineProps({
    quiz: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    questionTypes: Array,
    difficultyLevels: Array,
    tags: Array,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Quiz/ Questions') + ' - ' + pageProps.general.app_name
})

// Reactive data
const loading = ref(false)
const processing = ref(false)
const qEditFlag = ref(false)
const editFlag = ref(props.editFlag)
const quiz = ref(props.quiz || {})
const steps = ref(props.steps || [])
const questions = ref([])
const pagination = ref({})

// Filters
const codeFilter = ref('')
const typeFilter = ref([])
const sectionFilter = ref('')
const skillFilter = ref('')
const topicFilter = ref('')
const tagArray = ref([])
const difficultyFilter = ref([])

// Methods
const viewQuestions = () => {
    qEditFlag.value = false
    loadQuestions()
}

const editQuestions = () => {
    qEditFlag.value = true
    loadQuestions()
}

const resetFilters = () => {
    codeFilter.value = ''
    typeFilter.value = []
    sectionFilter.value = ''
    skillFilter.value = ''
    topicFilter.value = ''
    tagArray.value = []
    difficultyFilter.value = []
}

const filterQuestions = () => {
    loadQuestions()
}

const loadQuestions = () => {
    loading.value = true
    // Implementation for loading questions would go here
    // This would typically make an API call
    setTimeout(() => {
        loading.value = false
    }, 1000)
}

const loadMoreQuestions = () => {
    // Implementation for loading more questions
}

const addQuestion = (questionId, index) => {
    processing.value = true
    // Implementation for adding question to quiz
    setTimeout(() => {
        processing.value = false
    }, 500)
}

const removeQuestion = (questionId, index) => {
    processing.value = true
    // Implementation for removing question from quiz
    setTimeout(() => {
        processing.value = false
    }, 500)
}

const searchTags = (search, loading) => {
    // Implementation for searching tags
}

// Initialize
onMounted(() => {
    loadQuestions()
})
</script>
