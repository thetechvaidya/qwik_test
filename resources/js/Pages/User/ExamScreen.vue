<template>
    <exam-layout>
        <Head :title="title" />
        <!-- Title -->
        <template #title>
            <h4 class="font-semibold text-white">{{ exam.title }}</h4>
        </template>

        <!-- Timer -->
        <template #timer>
            <span class="ltr:ml-2 rtl:mr-2">
                <span v-if="examTimer.formattedCurrentTime">{{ examTimer.formattedCurrentTime }}</span>
            </span>
        </template>

        <!-- Actions -->
        <template #actions>
            <div
                v-tooltip.bottom="unsavedCount === 0 ? 'Progress Saved' : 'Some Responses Need to Save'"
                class="flex ltr:flex-row rtl:flex-row-reverse items-center"
            >
                <div
                    :class="[unsavedCount === 0 ? 'bg-green-600' : 'bg-yellow-600']"
                    class="w-2 h-2 rounded-full ltr:mr-2 rtl:mr-2"
                ></div>
                <h5 v-if="sessionManager.isLoading" class="text-sm text-gray-800">{{ __('Saving Progress...') }}</h5>
                <h5 v-else class="text-sm text-gray-800"
                    >{{ answeredInCurrentSection }}/{{ sectionTotalQuestions }} {{ __('Answered') }}</h5
                >
            </div>
            <button
                v-if="exam.settings.list_questions"
                class="text-gray-400 hover:text-gray-800 focus:outline-none"
                @click="
                    questionNavigation.setViewMode(questionNavigation.navigation.viewMode === 'chip' ? 'list' : 'chip')
                "
            >
                <svg
                    v-if="questionNavigation.navigation.viewMode !== 'chip'"
                    class="w-6 h-6"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"
                    ></path>
                </svg>
                <svg
                    v-if="questionNavigation.navigation.viewMode === 'chip'"
                    class="w-6 h-6"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 6h16M4 10h16M4 14h16M4 18h16"
                    ></path>
                </svg>
            </button>
        </template>

        <!-- Sections -->
        <template #sections>
            <div class="hw-prev rtl:flip text-green-600 hover:text-green-800 cursor-pointer" @click="swipeSectionPrev">
                <svg
                    class="w-6 h-6"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path>
                </svg>
            </div>
            <Swiper
                ref="mySwiper"
                class="swiper"
                :modules="swiperModules"
                :slides-per-view="'auto'"
                :free-mode="true"
                :mousewheel="true"
                :scrollbar="{ draggable: true }"
                @swiper="onSwiper"
            >
                <SwiperSlide
                    v-for="(section, index) in sessionManager.session.sections"
                    :key="'exam_section_' + section.id"
                    class="ltr:pr-4 rtl:pl-4"
                >
                    <button
                        v-if="section.id === sessionManager.session.sections[sessionManager.session.current_section].id"
                        v-tooltip.bottom="'Current Section'"
                        class="ease-linear transition-all duration-150 text-sm focus:outline-none flex items-center gap-2 border border-green-800 hover:border-green-600 text-white bg-green-800 hover:bg-green-600 rounded-sm py-2 px-4"
                    >
                        <span
                            class="w-5 h-5 ease-linear transition-all duration-150 rounded-full bg-green-100 text-green-600"
                            >{{ section.sno }}</span
                        >
                        <span>{{ section.name }}</span>
                        <span v-if="exam.settings.disable_section_navigation && sectionTimers[index]">
                            {{ sectionTimers[index].formattedCurrentTime }}
                        </span>
                    </button>
                    <button
                        v-else
                        v-tooltip.bottom="exam.settings.disable_section_navigation ? 'Locked' : 'Unlocked'"
                        :class="{ 'bg-gray-100': exam.settings.disable_section_navigation }"
                        class="group ease-linear transition-all duration-150 text-sm focus:outline-none flex items-center gap-2 bg-white text-green-600 border border-green-600 hover:bg-green-600 hover:text-white rounded-sm py-2 px-4"
                        @click="changeSection(index)"
                    >
                        <span
                            class="w-5 h-5 ease-linear transition-all duration-150 rounded-full bg-green-600 text-green-100 group-hover:bg-green-100 group-hover:text-green-600"
                            >{{ section.sno }}</span
                        >
                        <span>{{ section.name }}</span>
                    </button>
                </SwiperSlide>
            </Swiper>
            <div class="hw-next rtl:flip text-green-600 hover:text-green-800 cursor-pointer" @click="swipeSectionNext">
                <svg
                    class="w-6 h-6"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                >
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path>
                </svg>
            </div>
        </template>

        <!-- Questions -->
        <template #questions>
            <div>
                <ul v-if="loading">
                    <li>
                        <NavigationQuestionCardShimmer></NavigationQuestionCardShimmer>
                    </li>
                    <li>
                        <NavigationQuestionCardShimmer></NavigationQuestionCardShimmer>
                    </li>
                    <li>
                        <NavigationQuestionCardShimmer></NavigationQuestionCardShimmer>
                    </li>
                    <li>
                        <NavigationQuestionCardShimmer></NavigationQuestionCardShimmer>
                    </li>
                </ul>
                <ul
                    v-else
                    class="my-6"
                    :class="{
                        'flex flex-wrap justify-center items-center gap-2':
                            questionNavigation.navigation.viewMode === 'chip',
                    }"
                >
                    <li
                        v-for="(question, index) in sessionManager.session.questions"
                        :key="question.code"
                        @click="jumpToQuestion(index)"
                    >
                        <light-question-card
                            v-if="questionNavigation.navigation.viewMode !== 'chip'"
                            :question="question"
                            :sno="index + 1"
                            :sno="index + 1"
                            :is-correct="question.is_correct"
                            :status="question.status"
                            :active="sessionManager.session.current_question === index"
                        ></light-question-card>
                        <exam-question-chip
                            v-if="questionNavigation.navigation.viewMode === 'chip'"
                            :sno="index + 1"
                            :is-correct="question.is_correct"
                            :status="question.status"
                            :active="sessionManager.session.current_question === index"
                        ></exam-question-chip>
                    </li>
                </ul>
            </div>
        </template>

        <!-- Statistics -->
        <template #stats>
            <div class="w-full h-56 bg-white grid grid-cols-2 bg-white py-4">
                <div class="flex items-center gap-2">
                    <question-chip :sno="sessionManager.answeredCount" :status="'success'"></question-chip>
                    <span class="text-xs">{{ __('Answered') }}</span>
                </div>
                <div class="flex items-center gap-2">
                    <question-chip :sno="questionNavigation.notAnsweredQuestions" :status="'danger'"></question-chip>
                    <span class="text-xs">{{ __('Not Answered') }}</span>
                </div>
                <div class="flex items-center gap-2">
                    <question-chip
                        :sno="questionNavigation.markedForReviewQuestions"
                        :status="'warning'"
                    ></question-chip>
                    <span class="text-xs">{{ __('Marked for Review') }}</span>
                </div>
                <div class="flex items-center gap-2">
                    <question-chip
                        :sno="questionNavigation.answeredMarkForReviewQuestions"
                        :status="'caution'"
                    ></question-chip>
                    <span class="text-xs">{{ __('Answered & Marked for Review') }}</span>
                </div>
                <div class="flex items-center gap-2">
                    <question-chip :sno="questionNavigation.notVisitedQuestions" :status="'default'"></question-chip>
                    <span class="text-xs">{{ __('Not Visited') }}</span>
                </div>
            </div>
        </template>

        <!-- Footer -->
        <template #footer>
            <div class="w-full h-16 flex items-center justify-center bg-white">
                <button
                    v-if="!exam.settings.disable_finish_button"
                    class="w-full focus:outline-none"
                    @click="finishAlert"
                >
                    <finish-button :name="__('Finish Test')"></finish-button>
                </button>
            </div>
        </template>

        <!-- Question & Options -->
        <div ref="scroll2" class="h-screen max-h-screen pt-32 pb-16 overflow-y-auto overflow-x-hidden">
            <div class="mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col justify-center">
                    <div v-if="loading" class="w-full mt-4 py-4 sm:w-2/3">
                        <PracticeQuestionShimmer class="w-full"></PracticeQuestionShimmer>
                    </div>
                    <div v-else class="w-full mt-4 py-4">
                        <div
                            v-for="(question, index) in sessionManager.session.questions"
                            :key="question.id"
                            class="w-full"
                        >
                            <div
                                v-show="sessionManager.session.current_question === index"
                                :id="question.code"
                                class="flex flex-col sm:flex-row gap-4"
                            >
                                <div
                                    v-if="question.attachment_type != null"
                                    class="w-full sm:w-1/3 sm:ltr:border-r sm:rtl:border-l sm:border-gray-300 ltr:pr-4 rtl:pl-4"
                                >
                                    <div v-if="question.attachment_type === 'audio'">
                                        <audio-attachment
                                            :reference="'player_' + question.code"
                                            :options="question.attachment"
                                        ></audio-attachment>
                                    </div>
                                    <div v-if="question.attachment_type === 'video'">
                                        <video-attachment
                                            :reference="'player_' + question.code"
                                            :options="question.attachment"
                                        ></video-attachment>
                                    </div>
                                    <div v-if="question.attachment_type === 'comprehension'">
                                        <comprehension-attachment
                                            :passage="question.attachment"
                                        ></comprehension-attachment>
                                    </div>
                                </div>
                                <div class="w-full sm:w-2/3">
                                    <div>
                                        <quiz-question-card
                                            :key="question.card"
                                            :question="question"
                                            :sno="index + 1"
                                            :total-questions="sectionTotalQuestions"
                                        ></quiz-question-card>
                                        <div
                                            v-if="question.questionType === 'MSA' || question.questionType === 'TOF'"
                                            class="mt-4"
                                        >
                                            <MSAInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </MSAInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'MMA'" class="mt-4">
                                            <MMAInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </MMAInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'MTF'" class="mt-4">
                                            <MTFInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </MTFInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'ORD'" class="mt-4">
                                            <ORDInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </ORDInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'FIB'" class="mt-4">
                                            <FIBInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </FIBInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'SAQ'" class="mt-4">
                                            <SAQInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </SAQInteractiveOptions>
                                        </div>
                                        <div v-if="question.questionType === 'LAQ'" class="mt-4">
                                            <LAQInteractiveOptions
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                @modify-answer="updateAnswer"
                                            >
                                            </LAQInteractiveOptions>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Footer -->
        <div class="w-full h-16 absolute z-30 bottom-0 right-0 border-t border-gray-200 mx-auto bg-white">
            <div class="w-full h-full mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="!loading" class="h-full flex flex-col justify-center items-center">
                    <div class="w-full flex items-center gap-2 justify-between">
                        <div class="flex items-center gap-2">
                            <button class="focus:outline-none" @click="clearAnswer">
                                <clear-button :name="__('Clear Answer')"></clear-button>
                            </button>
                            <button class="focus:outline-none" @click="markForReview">
                                <review-button :name="__('Mark for Review')"></review-button>
                            </button>
                        </div>
                        <div class="flex items-center gap-2">
                            <button class="focus:outline-none" @click="nextQuestion">
                                <next-button :name="nextBtnText"></next-button>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Finish Dialog -->
        <Dialog v-model:visible="displayConfirmation" header="Confirmation" :style="{ width: '350px' }" :modal="true">
            <div class="w-full flex gap-2 items-center mb-2">
                <i class="pi pi-exclamation-triangle mr-3 text-xl text-red-500" />
                <span class="text-base">{{ __('Are you sure you want to finish?') }}</span>
            </div>
            <div class="w-full flex gap-4 sm:justify-center items-center">
                <table class="w-full table-auto">
                    <tbody>
                        <tr>
                            <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">{{
                                __('Answered')
                            }}</td>
                            <td
                                class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-right"
                            >
                                {{
                                    questionNavigation.answeredQuestions +
                                    questionNavigation.answeredMarkForReviewQuestions
                                }}
                            </td>
                        </tr>
                        <tr class="bg-emerald-200">
                            <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">{{
                                __('Not Answered')
                            }}</td>
                            <td
                                class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-right"
                            >
                                {{ questionNavigation.notAnsweredQuestions }}
                            </td>
                        </tr>
                        <tr>
                            <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">{{
                                __('Not Visited')
                            }}</td>
                            <td
                                class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-right"
                            >
                                {{ questionNavigation.notVisitedQuestions }}
                            </td>
                        </tr>
                        <tr>
                            <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">{{
                                __('Marked for Review')
                            }}</td>
                            <td
                                class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-right"
                            >
                                {{ questionNavigation.markedForReviewQuestions }}
                            </td>
                        </tr>
                        <tr>
                            <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">{{
                                __('Answered & Marked for Review')
                            }}</td>
                            <td
                                class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-right"
                            >
                                {{ questionNavigation.answeredMarkForReviewQuestions }}
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
            <template #footer>
                <Button label="No" icon="pi pi-times" class="p-button-text" @click="closeConfirmation" />
                <Button label="Yes" icon="pi pi-check" class="p-button-text" autofocus @click="finishTest" />
            </template>
        </Dialog>
    </exam-layout>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, nextTick } from 'vue'
import { Head } from '@inertiajs/vue3'
import { router } from '@inertiajs/vue3'
import { usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useSessionManager } from '@/composables/useSessionManager'
import { useQuestionNavigation } from '@/composables/useQuestionNavigation'
import { useTimer } from '@/composables/useTimer'
import ExamLayout from '@/Layouts/ExamLayout.vue'
import NextButton from '@/Components/Buttons/NextButton.vue'
import ClearButton from '@/Components/Buttons/ClearButton.vue'
import ReviewButton from '@/Components/Buttons/ReviewButton.vue'
import FinishButton from '@/Components/Buttons/FinishButton.vue'
import MSAInteractiveOptions from '@/Components/Questions/ExamInteract/MSAInteractiveOptions.vue'
import MMAInteractiveOptions from '@/Components/Questions/ExamInteract/MMAInteractiveOptions.vue'
import MTFInteractiveOptions from '@/Components/Questions/ExamInteract/MTFInteractiveOptions.vue'
import ORDInteractiveOptions from '@/Components/Questions/ExamInteract/ORDInteractiveOptions.vue'
import FIBInteractiveOptions from '@/Components/Questions/ExamInteract/FIBInteractiveOptions.vue'
import SAQInteractiveOptions from '@/Components/Questions/ExamInteract/SAQInteractiveOptions.vue'
import LAQInteractiveOptions from '@/Components/Questions/ExamInteract/LAQInteractiveOptions.vue'
import LightQuestionCard from '@/Components/Cards/LightQuestionCard.vue'
import ExamQuestionChip from '@/Components/Cards/ExamQuestionChip.vue'
import QuizQuestionCard from '@/Components/Cards/QuizQuestionCard.vue'
import NavigationQuestionCardShimmer from '@/Components/Shimmers/NavigationQuestionCardShimmer.vue'
import PracticeQuestionShimmer from '@/Components/Shimmers/PracticeQuestionShimmer.vue'
import AudioAttachment from '@/Components/Questions/Attachments/AudioAttachment.vue'
import VideoAttachment from '@/Components/Questions/Attachments/VideoAttachment.vue'
import ComprehensionAttachment from '@/Components/Questions/Attachments/ComprehensionAttachment.vue'
import Dialog from 'primevue/dialog'
import Button from 'primevue/button'
import Tooltip from 'primevue/tooltip'
import QuestionChip from '@/Components/Buttons/QuestionChip.vue'
import Swal from 'sweetalert2'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { FreeMode, Scrollbar, Mousewheel } from 'swiper/modules'
import 'swiper/css'
import 'swiper/css/scrollbar'
import axios from 'axios'

// Define component options including directives
defineOptions({
    directives: {
        tooltip: Tooltip,
    },
})

// Props
const props = defineProps({
    exam: Object,
    examSections: Array,
    session: Object,
    remainingTime: Number,
    answeredQuestions: {
        type: Number,
        default: 0,
    },
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Initialize session manager with exam data
const sessionManager = useSessionManager({
    id: props.session.id,
    current_question: props.session.current_question,
    current_section: props.session.current_section,
    total_time_taken: props.session.total_time_taken,
    sections: props.examSections,
    questions: [],
    status: props.session.status,
    saveEndpoint: route('update_exam_answer', {
        exam: props.exam.slug,
        session: props.session.code,
        section: props.examSections[props.session.current_section || 0]?.id,
    }),
})

// Initialize question navigation
import { toRef } from 'vue'
const questionNavigation = useQuestionNavigation(
    toRef(sessionManager.session, 'questions'),
    toRef(sessionManager.session, 'sections')
)

// Initialize main timer
const examTimer = useTimer({
    duration: props.remainingTime,
    countDown: true,
    autoStart: true,
    onExpire: () => timeUp(),
})

// Section timers for individual sections
const sectionTimers = ref({})
// Elapsed timer increments total and per-question timings
const elapsedTimer = useTimer({
    duration: 0,
    countDown: false,
    autoStart: false,
    onTick: () => {
        const q = sessionManager.session.questions[sessionManager.session.current_question]
        if (q) q.time_taken = (q.time_taken || 0) + 1
        sessionManager.incrementTime(1)
    },
})

// Local state
const loading = ref(true)
const displayConfirmation = ref(false)
const mySwiper = ref(null)
const swiperInstance = ref(null)
const onSwiper = instance => {
    swiperInstance.value = instance
}

// Swiper modules
const swiperModules = [FreeMode, Scrollbar, Mousewheel]

// Computed properties
const title = computed(() => {
    return props.exam.title + ' - ' + pageProps.general.app_name
})

const nextBtnText = computed(() => {
    return sessionManager.session.current_question < sessionManager.session.questions.length - 1
        ? __('Save & Next')
        : __('Save')
})

const sectionTotalQuestions = computed(() => {
    return sessionManager.session.sections[sessionManager.session.current_section]?.total_questions || 0
})

const answeredInCurrentSection = computed(() => {
    const currentSectionIndex = sessionManager.session.current_section
    const sectionStats = questionNavigation.sectionStatistics.value?.[currentSectionIndex]
    return sectionStats ? sectionStats.answeredQuestions : 0
})

// Unsaved count for current section (questions with status 'touched')
const unsavedCount = computed(() => {
    return (sessionManager.session.questions || []).filter(q => q?.status === 'touched').length
})

// Helpers
const sectionStartIndex = sectionIndex => {
    const sections = sessionManager.session.sections || []
    if (!sections.length || sectionIndex <= 0) return 0
    return sections
        .slice(0, sectionIndex)
        .reduce((total, s) => total + (s.questions?.length || s.total_questions || 0), 0)
}

// Methods
const changeSection = async index => {
    await updateStatus()
    await submitAnswer(getPayload())

    if (props.exam.settings.disable_section_navigation) {
        await Swal.fire({
            text: __('Section navigation is disabled.'),
            icon: 'info',
            confirmButtonText: __('Okay'),
        })
    } else {
        // Pause current section timer
        const prevSectionIndex = sessionManager.session.current_section
        const prevTimer = sectionTimers.value[prevSectionIndex]
        if (prevTimer && prevTimer.isActive.value) {
            prevTimer.pauseTimer()
        }

        sessionManager.session.current_section = index
        sessionManager.session.current_question =
            sessionManager.session.sections[sessionManager.session.current_section].current_question || 0
        // Update save endpoint for autosave for new section
        sessionManager.session.saveEndpoint = route('update_exam_answer', {
            exam: props.exam.slug,
            session: props.session.code,
            section: sessionManager.session.sections[index].id,
        })
        await fetchQuestions()
    }
}

const goToNextSection = async index => {
    if (index < sessionManager.session.sections.length) {
        await updateStatus()
        await submitAnswer(getPayload())
        sessionManager.session.current_section = index
        sessionManager.session.current_question = 0
        // Update save endpoint for autosave for new section
        sessionManager.session.saveEndpoint = route('update_exam_answer', {
            exam: props.exam.slug,
            session: props.session.code,
            section: sessionManager.session.sections[index].id,
        })
        await fetchQuestions()
    }
}

const updateStatus = async () => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    if (!currentQuestion) return

    const globalIndex =
        sectionStartIndex(sessionManager.session.current_section) + sessionManager.session.current_question
    const wasMarked = questionNavigation.getQuestionStatus(globalIndex) === 'mark_for_review'
    let newStatus

    if (currentQuestion.status === 'touched' && wasMarked) {
        newStatus = 'answered_mark_for_review'
    } else if (currentQuestion.status === 'touched' || currentQuestion.status === 'answered') {
        newStatus = 'answered'
    } else if (wasMarked) {
        newStatus = 'mark_for_review'
    } else {
        newStatus = 'not_answered'
    }

    currentQuestion.status = newStatus

    // Synchronize with composables via unified API
    sessionManager.setStatus(globalIndex, newStatus, { navigation: questionNavigation })
}

const getPayload = () => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    return {
        question_id: currentQuestion.code,
        user_answer: currentQuestion.user_answer,
        time_taken: currentQuestion.time_taken || 0,
        total_time_taken: sessionManager.session.total_time_taken,
        current_question: sessionManager.session.current_question,
        current_section: sessionManager.session.current_section,
        current_section_total_time_taken:
            sessionManager.session.sections[sessionManager.session.current_section].total_time_taken || 0,
        status: currentQuestion.status,
    }
}

const submitAnswer = async payload => {
    sessionManager.isLoading.value = true
    try {
        await sessionManager.submitAnswer(payload.question_id, payload.user_answer, {
            endpoint: route('update_exam_answer', {
                exam: props.exam.slug,
                session: props.session.code,
                section: sessionManager.session.sections[sessionManager.session.current_section].id,
            }),
            questionIndex: sessionManager.session.current_question,
            extraPayload: {
                time_taken: payload.time_taken,
                total_time_taken: payload.total_time_taken,
                current_question: payload.current_question,
                current_section: payload.current_section,
                current_section_total_time_taken: payload.current_section_total_time_taken,
                status: payload.status,
            },
            onSuccess: () => {},
        })
    } catch (error) {
        console.error('Failed to submit answer:', error)
    } finally {
        sessionManager.isLoading.value = false
    }
}

const finishAlert = async () => {
    await updateStatus()
    await submitAnswer(getPayload())
    displayConfirmation.value = true
}

const closeConfirmation = () => {
    displayConfirmation.value = false
}

const timeUp = async () => {
    await updateStatus()
    await submitAnswer(getPayload())
    finishTest()
}

const finishTest = () => {
    elapsedTimer.stopTimer()
    router.post(
        route('finish_exam_session', {
            exam: props.exam.slug,
            session: props.session.code,
        }),
        {
            total_time_taken: sessionManager.session.total_time_taken,
            questions: sessionManager.session.questions,
        },
        { replace: true }
    )
}

const updateAnswer = value => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    currentQuestion.user_answer = value
    currentQuestion.status = 'touched'

    // Calculate global index for sectioned exams
    const globalIndex =
        sectionStartIndex(sessionManager.session.current_section) + sessionManager.session.current_question

    // Synchronize with composables
    sessionManager.updateAnswer(currentQuestion.code, value, {
        questionIndex: globalIndex,
        autoSave: false,
    })
}

const nextQuestion = async () => {
    await updateStatus()
    await submitAnswer(getPayload())
    if (sessionManager.session.current_question < sessionManager.session.questions.length - 1) {
        sessionManager.session.current_question++
    }
}

const jumpToQuestion = async questionID => {
    await updateStatus()
    await submitAnswer(getPayload())
    sessionManager.session.current_question = questionID
}

const markForReview = async () => {
    const idx = sessionManager.session.current_question
    const currentQuestion = sessionManager.session.questions[idx]
    if (!currentQuestion) return

    const ans = currentQuestion.user_answer
    const hasAnswer = Array.isArray(ans) ? ans.length > 0 : ans !== undefined && ans !== null && ans !== ''

    // Update navigation and session statuses using global index keys
    const globalIndex = sectionStartIndex(sessionManager.session.current_section) + idx
    questionNavigation.toggleMarkForReview(globalIndex, hasAnswer)
    sessionManager.markForReview(globalIndex, currentQuestion.code)

    const newStatus = questionNavigation.getQuestionStatus(globalIndex)
    currentQuestion.status = newStatus
    sessionManager.setStatus(globalIndex, newStatus, { navigation: questionNavigation })

    await submitAnswer(getPayload())
}

const clearAnswer = async () => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    const qType = currentQuestion.questionType
    currentQuestion.user_answer = getClearedAnswer(qType, currentQuestion)
    currentQuestion.status = 'not_answered'
    await updateStatus()
    await submitAnswer(getPayload())
}

const getClearedAnswer = (qType, question) => {
    switch (qType) {
        case 'MTF':
            return {}
        case 'ORD':
            return []
        case 'MMA':
        case 'FIB':
            return []
        case 'SAQ':
        case 'LAQ':
        default:
            return ''
    }
}

const fetchQuestions = async () => {
    loading.value = true
    try {
        const response = await axios.get(
            route('fetch_exam_section_questions', {
                exam: props.exam.slug,
                session: props.session.code,
                section: sessionManager.session.sections[sessionManager.session.current_section].id,
            })
        )

        const data = response.data
        sessionManager.session.questions = data.questions
        // Also attach questions to the current section for section stats
        if (sessionManager.session.sections?.[sessionManager.session.current_section]) {
            sessionManager.session.sections[sessionManager.session.current_section].questions = data.questions
        }
        sessionManager.session.sections[sessionManager.session.current_section].remainingTime = data.remainingTime

        // Initialize section timer if needed
        const currentSectionIndex = sessionManager.session.current_section
        if (!sectionTimers.value[currentSectionIndex] && data.remainingTime) {
            sectionTimers.value[currentSectionIndex] = useTimer({
                duration: data.remainingTime,
                countDown: true,
                autoStart: false,
                onExpire: () => {
                    // Handle section time expiry
                },
            })
        }
        // Try to restore current section timer state if available
        restoreSectionTimerState(currentSectionIndex)

        // Start the current section timer only
        if (sectionTimers.value[currentSectionIndex] && !sectionTimers.value[currentSectionIndex].isActive.value) {
            sectionTimers.value[currentSectionIndex].startTimer()
        }

        // Initialize question statuses for navigation
        const baseStatuses = { ...(sessionManager.session.question_status || {}) }
        const start = sectionStartIndex(sessionManager.session.current_section)
        data.questions.forEach((question, index) => {
            baseStatuses[start + index] = question.status || 'not_visited'
        })
        // Initialize/merge into navigation statuses (global)
        questionNavigation.initializeStatuses(baseStatuses)
        // Keep session's question_status in sync for counters
        sessionManager.session.question_status = { ...baseStatuses }
    } catch (error) {
        console.error('Failed to fetch questions:', error)
    } finally {
        loading.value = false

        // Start timer after successful fetch when session is not completed
        if (props.session.status !== 'completed') {
            startTimer()
        }
    }
}

const startTimer = () => {
    // Guard against double starts
    if (!examTimer.isActive.value) {
        examTimer.startTimer()
    }
    if (!elapsedTimer.isActive.value) {
        elapsedTimer.startTimer()
    }
    sessionManager.startAutoSave()
}

const swipeSectionNext = () => {
    if (swiperInstance.value && typeof swiperInstance.value.slideNext === 'function') {
        swiperInstance.value.slideNext()
    }
}

const swipeSectionPrev = () => {
    if (swiperInstance.value && typeof swiperInstance.value.slidePrev === 'function') {
        swiperInstance.value.slidePrev()
    }
}

// Lifecycle
// Timer persistence keys
const EXAM_TIMER_KEY = computed(() => `exam_timer_${props.session.code}`)
const ELAPSED_TIMER_KEY = computed(() => `exam_elapsed_${props.session.code}`)
const sectionTimerKey = sectionId => `exam_section_${props.session.code}_${sectionId}`

const saveTimers = () => {
    try {
        const basePayload = {
            exam: examTimer.getState(),
            elapsed: elapsedTimer.getState(),
        }
        localStorage.setItem(EXAM_TIMER_KEY.value, JSON.stringify(basePayload))
        // Save each section timer state
        const sections = sessionManager.session.sections || []
        sections.forEach((sec, idx) => {
            const timer = sectionTimers.value[idx]
            if (timer) {
                localStorage.setItem(sectionTimerKey(sec.id), JSON.stringify(timer.getState()))
            }
        })
    } catch (e) {}
}

const restoreSectionTimerState = sectionIndex => {
    try {
        const sec = sessionManager.session.sections?.[sectionIndex]
        if (!sec) return
        const raw = localStorage.getItem(sectionTimerKey(sec.id))
        if (!raw) return
        const payload = JSON.parse(raw)
        if (sectionTimers.value[sectionIndex]) {
            sectionTimers.value[sectionIndex].restoreState(payload)
        }
    } catch (e) {}
}

const restoreTimers = () => {
    try {
        const raw = localStorage.getItem(EXAM_TIMER_KEY.value)
        if (!raw) {
            // Legacy separate elapsed key support
            const elapsedRaw = localStorage.getItem(ELAPSED_TIMER_KEY.value)
            if (elapsedRaw) {
                const el = JSON.parse(elapsedRaw)
                elapsedTimer.restoreState(el)
            }
            return
        }
        const payload = JSON.parse(raw)
        examTimer.restoreState(payload.exam)
        if (payload.elapsed) {
            elapsedTimer.restoreState(payload.elapsed)
        } else {
            const elapsedRaw = localStorage.getItem(ELAPSED_TIMER_KEY.value)
            if (elapsedRaw) {
                const el = JSON.parse(elapsedRaw)
                elapsedTimer.restoreState(el)
            }
        }
    } catch (e) {}
}

// Page lifecycle handlers for BFCache-friendly persistence
const onPageHide = () => {
    try {
        saveTimers()
    } catch (e) {}
    try {
        if (unsavedCount.value > 0 && typeof sessionManager.saveSession === 'function') {
            sessionManager.saveSession()
        }
    } catch (e) {}
}
const onPageShow = e => {
    if (e && e.persisted) {
        try {
            restoreTimers()
        } catch (e) {}
        // Resume timers if needed
        if (!examTimer.isActive.value) examTimer.startTimer()
        if (!elapsedTimer.isActive.value) elapsedTimer.startTimer()
        const idx = sessionManager.session.current_section
        const timer = sectionTimers.value[idx]
        if (timer && !timer.isActive.value) timer.startTimer()
    }
}

onMounted(async () => {
    // Disable right-click context menu (commented out as it was commented in original)
    // document.addEventListener('contextmenu', event => event.preventDefault());

    // Restore timers from storage if available
    restoreTimers()

    await fetchQuestions()

    // Note: startTimer is now called within fetchQuestions after successful load

    // Add pagehide/pageshow listeners for persistence and BFCache
    window.addEventListener('pagehide', onPageHide)
    window.addEventListener('pageshow', onPageShow)
})

onUnmounted(() => {
    saveTimers()
    examTimer.stopTimer()
    elapsedTimer.stopTimer()

    // Cleanup section timers
    Object.values(sectionTimers.value).forEach(timer => {
        if (timer && typeof timer.stopTimer === 'function') {
            timer.stopTimer()
        }
    })

    sessionManager.cleanup()
    window.removeEventListener('pagehide', onPageHide)
    window.removeEventListener('pageshow', onPageShow)
})
</script>

<style scoped>
.confirmation-content {
    display: flex;
    align-items: center;
    justify-content: center;
}

.swiper {
    width: 100%;
}

.swiper-slide {
    width: auto;
    -webkit-box-sizing: border-box;
    box-sizing: border-box;
}
</style>
