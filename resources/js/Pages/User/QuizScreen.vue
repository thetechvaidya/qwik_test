<template>
    <Head :title="title" />
    <quiz-layout>
        <!-- Title -->
        <template #title>
            <h4 class="font-semibold text-white">{{ quiz.title }}</h4>
        </template>

        <!-- Timer -->
        <template #timer>
            <span class="ltr:ml-2 rtl:mr-2">
                <span v-if="quizTimer.isActive">
                    {{ quizTimer.formattedCurrentTime }}
                </span>
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
                    >{{ sessionManager.answeredCount }}/{{ quiz.total_questions }} {{ __('Answered') }}</h5
                >
            </div>
            <button
                v-if="quiz.settings.list_questions"
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
            <button
                class="focus:outline-none flex items-center gap-2 text-white text-sm bg-green-800 hover:bg-green-600 rounded-sm py-2 px-4"
            >
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
                        d="M8 11V7a4 4 0 118 0m-4 8v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2z"
                    ></path>
                </svg>
                <span>{{ __('All Questions') }}</span>
            </button>
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
                    <question-chip :sno="questionNavigation.markForReviewQuestions" :status="'warning'"></question-chip>
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
                    v-if="!quiz.settings.disable_finish_button"
                    class="w-full focus:outline-none"
                    @click="finishAlert"
                >
                    <finish-button :name="__('Finish Test')"></finish-button>
                </button>
            </div>
        </template>

        <!-- Question & Options -->
        <div ref="scroll2" class="h-screen max-h-screen pt-32 pb-16 overflow-y-auto">
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
                                            :total-questions="quiz.total_questions"
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
                                {{ questionNavigation.markForReviewQuestions }}
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
    </quiz-layout>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, toRef } from 'vue'
import { Head } from '@inertiajs/vue3'
import { router } from '@inertiajs/vue3'
import { usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useLogger } from '@/composables/useLogger'
import { useSessionManager } from '@/composables/useSessionManager'
import { useQuestionNavigation } from '@/composables/useQuestionNavigation'
import { useTimer } from '@/composables/useTimer'
import QuizLayout from '@/Layouts/QuizLayout.vue'
import PrevButton from '@/Components/Buttons/PrevButton'
import NextButton from '@/Components/Buttons/NextButton'
import ClearButton from '@/Components/Buttons/ClearButton'
import ReviewButton from '@/Components/Buttons/ReviewButton'
import FinishButton from '@/Components/Buttons/FinishButton'
import MSAInteractiveOptions from '@/Components/Questions/ExamInteract/MSAInteractiveOptions'
import MMAInteractiveOptions from '@/Components/Questions/ExamInteract/MMAInteractiveOptions'
import MTFInteractiveOptions from '@/Components/Questions/ExamInteract/MTFInteractiveOptions'
import ORDInteractiveOptions from '@/Components/Questions/ExamInteract/ORDInteractiveOptions'
import FIBInteractiveOptions from '@/Components/Questions/ExamInteract/FIBInteractiveOptions'
import SAQInteractiveOptions from '@/Components/Questions/ExamInteract/SAQInteractiveOptions'
import LAQInteractiveOptions from '@/Components/Questions/ExamInteract/LAQInteractiveOptions'
import LightQuestionCard from '@/Components/Cards/LightQuestionCard'
import ExamQuestionChip from '@/Components/Cards/ExamQuestionChip'
import QuizQuestionCard from '@/Components/Cards/QuizQuestionCard'
import NavigationQuestionCardShimmer from '@/Components/Shimmers/NavigationQuestionCardShimmer'
import PracticeQuestionShimmer from '@/Components/Shimmers/PracticeQuestionShimmer'
import AudioAttachment from '@/Components/Questions/Attachments/AudioAttachment'
import VideoAttachment from '@/Components/Questions/Attachments/VideoAttachment'
import ComprehensionAttachment from '@/Components/Questions/Attachments/ComprehensionAttachment'
import Dialog from 'primevue/dialog'
import Button from 'primevue/button'
import Tooltip from 'primevue/tooltip'

// Define component options including directives
defineOptions({
    directives: {
        tooltip: Tooltip,
    },
})
import QuestionChip from '@/Components/Buttons/QuestionChip'
import axios from 'axios'

// Props
const props = defineProps({
    quiz: Object,
    session: Object,
    remainingTime: Number,
    answeredQuestions: Number,
})

// Composables
const { __ } = useTranslate()
const { logError } = useLogger()
const { props: pageProps } = usePage()

// Initialize session manager with quiz data
const sessionManager = useSessionManager({
    id: props.session.id,
    current_question: props.session.current_question,
    total_time_taken: props.session.total_time_taken,
    questions: [],
    status: props.session.status,
    saveEndpoint: route('update_quiz_answer', { quiz: props.quiz.slug, session: props.session.code }),
})

// Initialize question navigation
const questionNavigation = useQuestionNavigation(
    toRef(sessionManager.session, 'questions'),
    ref([]) // no sections for quiz
)

// Initialize quiz timer (countdown)
const quizTimer = useTimer({
    duration: props.remainingTime,
    countDown: true,
    autoStart: false,
    onExpire: () => finishTest(),
})

// Initialize elapsed timer
const elapsedTimer = useTimer({
    duration: 0,
    countDown: false,
    autoStart: false,
    onTick: () => {
        // Increment time for current question
        const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
        if (currentQuestion) {
            currentQuestion.time_taken = (currentQuestion.time_taken || 0) + 1
        }
        // Increment total time
        sessionManager.incrementTime(1)
    },
})

// Local state
const loading = ref(true)
const displayConfirmation = ref(false)

// Computed properties
const title = computed(() => {
    return props.quiz.title + ' - ' + pageProps.general.app_name
})

const nextBtnText = computed(() => {
    return sessionManager.session.current_question < sessionManager.session.questions.length - 1
        ? __('Save & Next')
        : __('Save')
})

// Unsaved count (questions with status 'touched')
const unsavedCount = computed(() => {
    return (sessionManager.session.questions || []).filter(q => q?.status === 'touched').length
})

// Methods
const updateStatus = () => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    if (!currentQuestion) return

    const wasMarked =
        questionNavigation.getQuestionStatus(sessionManager.session.current_question) === 'mark_for_review'
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
    sessionManager.setStatus(sessionManager.session.current_question, newStatus, { navigation: questionNavigation })
}

const getPayload = () => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    return {
        question_id: currentQuestion.code,
        user_answer: currentQuestion.user_answer,
        time_taken: currentQuestion.time_taken || 0,
        total_time_taken: sessionManager.session.total_time_taken,
        current_question: sessionManager.session.current_question,
        status: currentQuestion.status,
    }
}

const submitAnswer = async payload => {
    sessionManager.isLoading.value = true
    try {
        await sessionManager.submitAnswer(payload.question_id, payload.user_answer, {
            endpoint: route('update_quiz_answer', {
                quiz: props.quiz.slug,
                session: props.session.code,
            }),
            questionIndex: sessionManager.session.current_question,
            extraPayload: {
                time_taken: payload.time_taken,
                total_time_taken: payload.total_time_taken,
                current_question: payload.current_question,
                status: payload.status,
            },
            onSuccess: () => {},
        })
    } catch (error) {
        logError('Failed to submit answer', { error: error.message, questionId: sessionManager.currentQuestion.value?.id })
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

const finishTest = () => {
    router.post(
        route('finish_quiz_session', {
            quiz: props.quiz.slug,
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

    // Synchronize with composables
    sessionManager.updateAnswer(currentQuestion.code, value, {
        questionIndex: sessionManager.session.current_question,
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

    questionNavigation.toggleMarkForReview(idx, hasAnswer)
    sessionManager.markForReview(idx, currentQuestion.code)

    const newStatus = questionNavigation.getQuestionStatus(idx)
    currentQuestion.status = newStatus
    sessionManager.setStatus(idx, newStatus, { navigation: questionNavigation })

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
            route('fetch_quiz_questions', {
                quiz: props.quiz.slug,
                session: props.session.code,
            })
        )

        const data = response.data
        sessionManager.session.questions = data.questions

        // Initialize question statuses for navigation
        const statuses = {}
        data.questions.forEach((question, index) => {
            statuses[index] = question.status || 'not_visited'
        })
        questionNavigation.initializeStatuses(statuses)
        // Keep session's question_status in sync for counters
        sessionManager.session.question_status = { ...statuses }

        if (props.session.status !== 'completed') {
            startTimer()
        }
    } catch (error) {
        logError('Failed to fetch questions', { error: error.message, quizId: props.quiz?.id })
    } finally {
        loading.value = false
    }
}

// Timer persistence keys
const TIMER_STORAGE_KEY = computed(() => `quiz_timer_${props.session.code}`)
const ELAPSED_STORAGE_KEY = computed(() => `quiz_elapsed_${props.session.code}`)

const saveTimers = () => {
    try {
        const payload = {
            timer: quizTimer.getState(),
            elapsed: elapsedTimer.getState(),
        }
        localStorage.setItem(TIMER_STORAGE_KEY.value, JSON.stringify(payload))
    } catch (e) {}
}

const restoreTimers = () => {
    try {
        const raw = localStorage.getItem(TIMER_STORAGE_KEY.value)
        if (!raw) return
        const payload = JSON.parse(raw)
        quizTimer.restoreState(payload.timer)
        elapsedTimer.restoreState(payload.elapsed)
    } catch (e) {}
}

const clearTimers = () => {
    try {
        localStorage.removeItem(TIMER_STORAGE_KEY.value)
    } catch (e) {}
}

const startTimer = () => {
    quizTimer.startTimer()
    elapsedTimer.startTimer()
    sessionManager.startAutoSave()
}

// Lifecycle
onMounted(() => {
    // Store the handler
    const onCtx = e => e.preventDefault()

    // Disable right-click context menu
    document.addEventListener('contextmenu', onCtx)

    // Store handler for cleanup
    document._quizContextHandler = onCtx

    // Restore timers from previous session if any
    restoreTimers()
    fetchQuestions()

    // Persist timers and any unsaved work on pagehide (BFCache-friendly)
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
    // Restore state when returning from BFCache
    const onPageShow = e => {
        if (e && e.persisted) {
            try {
                restoreTimers()
            } catch (e) {}
            // Resume timers if they were running
            if (!quizTimer.isActive.value) quizTimer.startTimer()
            if (!elapsedTimer.isActive.value) elapsedTimer.startTimer()
        }
    }

    window.addEventListener('pagehide', onPageHide)
    window.addEventListener('pageshow', onPageShow)

    // Keep refs for cleanup
    document._quizPageHideHandler = onPageHide
    document._quizPageShowHandler = onPageShow
})

onUnmounted(() => {
    saveTimers()
    quizTimer.stopTimer()
    elapsedTimer.stopTimer()
    sessionManager.cleanup()

    // Remove context menu listener
    if (document._quizContextHandler) {
        document.removeEventListener('contextmenu', document._quizContextHandler)
        delete document._quizContextHandler
    }
    // Remove lifecycle listeners
    if (document._quizPageHideHandler) {
        window.removeEventListener('pagehide', document._quizPageHideHandler)
        delete document._quizPageHideHandler
    }
    if (document._quizPageShowHandler) {
        window.removeEventListener('pageshow', document._quizPageShowHandler)
        delete document._quizPageShowHandler
    }
})
</script>
<style scoped>
.confirmation-content {
    display: flex;
    align-items: center;
    justify-content: center;
}
</style>
