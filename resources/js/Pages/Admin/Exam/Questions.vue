<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Exam') }} {{ __('Questions') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? exam.title : 'New Exam'"
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
                                        xmlns="http://www.w3.org/2000/svg"
                                        class="h-6 w-6"
                                        fill="none"
                                        viewBox="0 0 24 24"
                                        stroke="currentColor"
                                    >
                                        <path
                                            stroke-linecap="round"
                                            stroke-linejoin="round"
                                            stroke-width="2"
                                            d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
                                        />
                                    </svg>
                                    {{ __('Sections') }}
                                </h4>
                                <ul class="w-full mt-4">
                                    <li
v-for="section in sections" :key="'section_'+section.id" class="my-2 p-2 border border-green-100 shadow-sm rounded-sm"
                                        :class="[section.id === currentSectionId ? 'bg-green-50' : 'bg-white']"
                                    >
                                        <div class="font-semibold">{{ section.section_order }}. {{ section.name }}</div>
                                        <div class="flex flex-col sm:flex-row gap-2">
                                            <div
                                                ><a href="#" class="qt-link-success" @click="editQuestions(section)"
                                                    >{{ __('Add') }} {{ __('Questions') }}</a
                                                ></div
                                            >
                                            <div
                                                ><a href="#" class="qt-link-success" @click="viewQuestions(section)"
                                                    >{{ __('View') }} {{ __('Questions') }}</a
                                                ></div
                                            >
                                        </div>
                                    </li>
                                </ul>
                            </div>
                            <div v-if="currentSection">
                                <h4 class="py-2 font-semibold flex items-center gap-2 text-gray-800 border-b mt-6">
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
                                    <Select
                                        id="tag"
                                        v-model="tagArray"
                                        :options="tags"
                                        optionLabel="name"
                                        optionValue="id"
                                        placeholder="Select tags"
                                        filter
                                        showClear
                                        multiple
                                        class="w-full"
                                        @filter="searchTags"
                                    >
                                        <template #empty>
                                            <span>{{ __('No results were found for this search') }}</span>
                                        </template>
                                    </Select>
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
                        <div v-if="currentSection" class="sm:w-8/12 w-full my-4">
                            <div class="my-2 p-4 border border-green-100 shadow-sm rounded-sm bg-green-50">
                                <div class="font-semibold"
                                    >{{ __('Currently') }} {{ qEditFlag ? __('Adding') : __('Viewing') }}
                                    {{ currentSection.name }} {{ __('Questions') }}</div
                                >
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                                                            class="qt-btn-sm"
                                                            :class="[qEditFlag ? 'qt-btn-success' : 'qt-btn-danger', question.disabled || processing ? 'opacity-25': '']"
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
                        <div v-else class="sm:w-8/12 w-full my-4">
                            <div v-if="!currentSection" class="bg-gray-100 rounded p-6">
                                <div class="flex justify-center items-center">
                                    <h4 class="p-4 font-semibold">{{
                                        __('Please choose a section to add/remove questions')
                                    }}</h4>
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
import Select from 'primevue/select'
import HorizontalStepper from '@/Components/HorizontalStepper.vue'
import AdminQuestionShimmer from '@/Components/AdminQuestionShimmer.vue'
import MSAPreview from '@/Components/MSAPreview.vue'
import MTFPreview from '@/Components/MTFPreview.vue'
import ORDPreview from '@/Components/ORDPreview.vue'
import SAQPreview from '@/Components/SAQPreview.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { debounce } from 'lodash'
import axios from 'axios'

// Props
const props = defineProps({
    exam: Object,
    sections: Array,
    questionTypes: Array,
    difficultyLevels: Array,
    tags: Array,
    steps: Array
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Exam/ Questions') + ' - ' + pageProps.general.app_name
})

// Reactive data
const loading = ref(false)
const processing = ref(false)
const qEditFlag = ref(false)
const editFlag = ref(!!props.exam)
const exam = ref(props.exam || {})
const steps = ref(props.steps || [])
const sections = ref(props.sections || [])
const questions = ref([])
const pagination = ref({})
const currentSection = ref(null)
const currentSectionId = ref(null)
const questionTypes = ref(props.questionTypes || [])
const difficultyLevels = ref(props.difficultyLevels || [])
const tags = ref(props.tags || [])

// Filter data
const codeFilter = ref('')
const typeFilter = ref([])
const skillFilter = ref('')
const topicFilter = ref('')
const tagArray = ref([])
const difficultyFilter = ref([])

// Composables
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Methods
const viewQuestions = (section) => {
    currentSection.value = section
    currentSectionId.value = section.id
    qEditFlag.value = false
    loadQuestions()
}

const editQuestions = (section) => {
    currentSection.value = section
    currentSectionId.value = section.id
    qEditFlag.value = true
    loadQuestions()
}

const resetFilters = () => {
    codeFilter.value = ''
    typeFilter.value = []
    skillFilter.value = ''
    topicFilter.value = ''
    tagArray.value = []
    difficultyFilter.value = []
    filterQuestions()
}

const filterQuestions = () => {
    loadQuestions()
}

const loadQuestions = () => {
    if (!currentSection.value) return
    
    loading.value = true
    const params = {
        section_id: currentSection.value.id,
        code: codeFilter.value,
        type: typeFilter.value,
        skill: skillFilter.value,
        topic: topicFilter.value,
        tags: tagArray.value,
        difficulty: difficultyFilter.value,
        edit_flag: qEditFlag.value
    }
    
    // Add your API call here
    // axios.get('/admin/exam/questions', { params })
    //     .then(response => {
    //         questions.value = response.data.data
    //         pagination.value = response.data.pagination
    //     })
    //     .finally(() => {
    //         loading.value = false
    //     })
    
    loading.value = false
}

const loadMoreQuestions = () => {
    // Add pagination logic here
}

const addQuestion = (questionId, index) => {
    processing.value = true
    // Add question to exam logic
    processing.value = false
}

const removeQuestion = (questionId, index) => {
    processing.value = true
    // Remove question from exam logic
    processing.value = false
}

const searchTags = debounce((event) => {
    const query = event.value || ''
    if (query.length < 2) return
    
    axios.get('/admin/tags/search', {
        params: { q: query }
    }).then(response => {
        tags.value = response.data
    }).catch(error => {
        console.error('Error searching tags:', error)
    })
}, 300)

// Initialize on mount
onMounted(() => {
    // Initialize component
})
</script>
