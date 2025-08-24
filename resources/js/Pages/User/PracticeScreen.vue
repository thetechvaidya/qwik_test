<template>
    <Head :title="title" />
    <practice-layout>
        <!-- Side Title -->
        <template #title>
            <h4 class="font-semibold text-white">{{ practiceSet.title }}</h4>
        </template>
        <!-- Test Title -->
        <template #actions>
            <h5 class="text-white"
                >{{ sessionManager.answeredCount }}/{{ practiceSet.total_questions }} {{ __('Attempted') }}</h5
            >
            <button
                class="text-gray-400 hover:text-white focus:outline-none"
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

        <template #questions>
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
                    <dark-question-card
                        v-if="questionNavigation.navigation.viewMode !== 'chip'"
                        :question="question"
                        :sno="getQuestionNo(index)"
                        :is-correct="question.is_correct"
                        :status="question.status"
                        :active="sessionManager.session.current_question === index"
                    ></dark-question-card>
                    <practice-question-chip
                        v-if="questionNavigation.navigation.viewMode === 'chip'"
                        :sno="getQuestionNo(index)"
                        :is-correct="question.is_correct"
                        :status="question.status"
                        :active="sessionManager.session.current_question === index"
                    ></practice-question-chip>
                </li>
            </ul>
        </template>

        <template #footer>
            <ul v-if="!loading" class="w-full h-16 flex items-center justify-between bg-gray-800">
                <li class="text-gray-400 hover:text-white cursor-pointer" @click="prevPage">
                    <svg
                        class="w-8 h-8"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M11 15l-3-3m0 0l3-3m-3 3h8M3 12a9 9 0 1118 0 9 9 0 01-18 0z"
                        ></path>
                    </svg>
                </li>
                <li>
                    <span class="text-white"
                        >{{ __('Page') }} {{ pagination.current_page }}/{{ pagination.total_pages }}</span
                    >
                </li>
                <li class="text-gray-400 hover:text-white cursor-pointer" @click="nextPage">
                    <svg
                        class="w-8 h-8"
                        fill="none"
                        stroke="currentColor"
                        viewBox="0 0 24 24"
                        xmlns="http://www.w3.org/2000/svg"
                    >
                        <path
                            stroke-linecap="round"
                            stroke-linejoin="round"
                            stroke-width="2"
                            d="M13 9l3 3m0 0l-3 3m3-3H8m13 0a9 9 0 11-18 0 9 9 0 0118 0z"
                        ></path>
                    </svg>
                </li>
            </ul>
        </template>

        <div class="w-full h-16 fixed sm:absolute z-30 top-0 right-0 mx-auto bg-white">
            <div class="w-full sm:max-w-7xl h-full mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="!loading" class="h-full flex flex-col justify-center items-center">
                    <div
                        class="w-full sm:w-2/3 flex ltr:flex-row rtl:flex-row-reverse items-center ltr:justify-end rtl:justify-start gap-4 sm:gap-0 sm:ltr:justify-between sm:rtl:justify-between"
                    >
                        <rewards-badge
                            v-if="practiceSet.allow_rewards"
                            :points="sessionManager.session.total_points_earned"
                        ></rewards-badge>
                        <div v-else class="h-0 w-0"></div>
                        <button v-if="headerButton === 'finish'" class="focus:outline-none" @click="finishTest">
                            <finish-button :name="__('Finish')"></finish-button>
                        </button>
                        <Link
                            v-if="headerButton === 'close'"
                            :href="
                                route('practice_session_analysis', {
                                    practiceSet: practiceSet.slug,
                                    session: session.code,
                                })
                            "
                        >
                            <finish-button :name="__('Close')"></finish-button>
                        </Link>
                        <button v-if="headerButton === 'pause'" class="focus:outline-none" @click="pauseTest">
                            <pause-button :name="__('Pause')"></pause-button>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <!-- Question & Options -->
        <div ref="scroll2" class="h-screen max-h-screen pt-16 pb-16 overflow-y-auto">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="flex flex-col justify-center items-center">
                    <div v-if="loading" class="w-full sm:w-2/3">
                        <div class="card card-body">
                            <PracticeQuestionShimmer class="w-full"></PracticeQuestionShimmer>
                        </div>
                    </div>
                    <div v-else class="w-full py-2 sm:w-2/3">
                        <div v-for="(question, index) in sessionManager.session.questions" :key="question.id">
                            <div v-show="sessionManager.session.current_question === index" :id="question.code">
                                <practice-question-card
                                    :key="question.card"
                                    :question="question"
                                    :sno="getQuestionNo(index)"
                                    :attachment-type="question.attachment_type"
                                    :attachment="question.attachment"
                                    :total-questions="practiceSet.total_questions"
                                ></practice-question-card>
                                <div
                                    v-if="question.questionType === 'MSA' || question.questionType === 'TOF'"
                                    class="mt-4"
                                >
                                    <MSAInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </MSAInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'MMA'" class="mt-4">
                                    <MMAInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </MMAInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'MTF'" class="mt-4">
                                    <MTFInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </MTFInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'ORD'" class="mt-4">
                                    <ORDInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </ORDInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'FIB'" class="mt-4">
                                    <FIBInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </FIBInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'SAQ'" class="mt-4">
                                    <SAQInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </SAQInteractiveOptions>
                                </div>
                                <div v-if="question.questionType === 'LAQ'" class="mt-4">
                                    <LAQInteractiveOptions
                                        :key="question.code"
                                        :parent-qid="question.code"
                                        :is-correct="question.is_correct"
                                        :status="question.status"
                                        :parent-options="question.options"
                                        :parent-answer="question.user_answer"
                                        :correct-answer="question.ca"
                                        @modify-answer="updateAnswer"
                                    >
                                    </LAQInteractiveOptions>
                                </div>
                                <div v-if="question.status === 'answered'" class="mt-4">
                                    <practice-solution-card :question="question"></practice-solution-card>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="w-full h-16 fixed sm:absolute z-30 bottom-0 right-0 mx-auto bg-white">
            <div class="w-full sm:max-w-7xl h-full mx-auto px-4 sm:px-6 lg:px-8">
                <div v-if="!loading" class="h-full flex flex-col justify-center items-center">
                    <div class="w-full sm:w-2/3 flex items-center justify-between">
                        <button class="focus:outline-none" @click="prevQuestion">
                            <prev-button :name="__('Previous')"></prev-button>
                        </button>
                        <button
                            v-if="footerButton === 'submit'"
                            :class="{ 'opacity-25': sessionManager.isLoading }"
                            :disabled="sessionManager.isLoading"
                            class="focus:outline-none"
                            @click="submitAnswer"
                        >
                            <submit-button :name="__('Submit')"></submit-button>
                        </button>
                        <button v-if="footerButton === 'next'" class="focus:outline-none" @click="nextQuestion">
                            <next-button :name="__('Next')"></next-button>
                        </button>
                    </div>
                </div>
            </div>
        </div>
        <ConfirmDialog></ConfirmDialog>
    </practice-layout>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted, toRef } from 'vue'
import { Head, Link } from '@inertiajs/vue3'
import { router } from '@inertiajs/vue3'
import { usePage } from '@inertiajs/vue3'
import { useConfirm } from 'primevue/useconfirm'
import { useTranslate } from '@/composables/useTranslate'
import { useLogger } from '@/composables/useLogger'
import { useSessionManager } from '@/composables/useSessionManager'
import { useQuestionNavigation } from '@/composables/useQuestionNavigation'
import { useTimer } from '@/composables/useTimer'
import { useCleanup } from '@/composables/useCleanup'
import PracticeLayout from '@/Layouts/PracticeLayout.vue'
import PracticeQuestionCard from '@/Components/Cards/PracticeQuestionCard'
import DarkQuestionCard from '@/Components/Cards/DarkQuestionCard'
import PracticeQuestionChip from '@/Components/Cards/PracticeQuestionChip'
import NavigationQuestionCardShimmer from '@/Components/Shimmers/NavigationQuestionCardShimmer'
import PracticeQuestionShimmer from '@/Components/Shimmers/PracticeQuestionShimmer'
import PrevButton from '@/Components/Buttons/PrevButton'
import NextButton from '@/Components/Buttons/NextButton'
import FinishButton from '@/Components/Buttons/FinishButton'
import SubmitButton from '@/Components/Buttons/SubmitButton'
import PauseButton from '@/Components/Buttons/PauseButton'
import MSAInteractiveOptions from '@/Components/Questions/PracticeInteract/MSAInteractiveOptions'
import MMAInteractiveOptions from '@/Components/Questions/PracticeInteract/MMAInteractiveOptions'
import MTFInteractiveOptions from '@/Components/Questions/PracticeInteract/MTFInteractiveOptions'
import ORDInteractiveOptions from '@/Components/Questions/PracticeInteract/ORDInteractiveOptions'
import FIBInteractiveOptions from '@/Components/Questions/PracticeInteract/FIBInteractiveOptions'
import SAQInteractiveOptions from '@/Components/Questions/PracticeInteract/SAQInteractiveOptions'
import LAQInteractiveOptions from '@/Components/Questions/PracticeInteract/LAQInteractiveOptions'
import PracticeSolutionCard from '@/Components/Cards/PracticeSolutionCard'
import RewardsBadge from '@/Components/RewardsBadge'
import ConfirmDialog from 'primevue/confirmdialog'
import Swal from 'sweetalert2'
import axios from 'axios'

// Props
const props = defineProps({
    practiceSet: Object,
    settings: Object,
    session: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const confirm = useConfirm()
const { logError, logInfo, logUserAction } = useLogger()
const { createTimeout } = useCleanup()

// Initialize session manager with practice data
const sessionManager = useSessionManager({
    id: props.session.id,
    current_question: 0,
    total_time_taken: props.session.total_time_taken,
    questions: [],
    status: props.session.status,
    total_points_earned: props.session.total_points_earned,
    saveEndpoint: null,
})

// Initialize question navigation
const questionNavigation = useQuestionNavigation(
    toRef(sessionManager.session, 'questions'),
    ref([]) // no sections for practice
)

// Initialize elapsed timer
const elapsedTimer = useTimer({
    duration: 0,
    countDown: false,
    autoStart: false,
    onTick: () => {
        sessionManager.session.total_time_taken++
        const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
        if (currentQuestion && currentQuestion.status !== 'answered') {
            currentQuestion.time_taken = (currentQuestion.time_taken || 0) + 1
        }
    },
})

// Local state
const loading = ref(true)
const pagination = ref(null)
const rewardStrings = ['Hurray', 'Yippee', 'Congrats', 'Cheers', 'Yup', 'Precise', 'Delight', 'Glory']

// Computed properties
const title = computed(() => {
    return props.practiceSet.title + ' - ' + pageProps.general.app_name
})

const headerButton = computed(() => {
    if (props.session.status === 'completed') {
        return 'close'
    } else if (
        props.session.status !== 'completed' &&
        sessionManager.answeredCount === props.practiceSet.total_questions
    ) {
        return 'finish'
    } else {
        return 'pause'
    }
})

const footerButton = computed(() => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    if (!currentQuestion) return ''

    const userAnswer = currentQuestion.user_answer
    const answerType = typeCheck(userAnswer)

    if (answerType === 'array' && userAnswer.length !== 0 && currentQuestion.status !== 'answered') {
        return 'submit'
    } else if (answerType === 'string' && userAnswer !== '' && currentQuestion.status !== 'answered') {
        return 'submit'
    } else if (answerType === 'number' && Number.isFinite(userAnswer) && currentQuestion.status !== 'answered') {
        return 'submit'
    } else if (getQuestionNo(sessionManager.session.current_question) !== props.practiceSet.total_questions) {
        return 'next'
    }
    return ''
})

// Methods
const submitAnswer = async () => {
    sessionManager.isLoading.value = true
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]

    try {
        const response = await axios.post(
            route('check_practice_answer', {
                practiceSet: props.practiceSet.slug,
                session: props.session.code,
            }),
            {
                question_id: currentQuestion.code,
                user_answer: currentQuestion.user_answer,
                time_taken: currentQuestion.time_taken || 0,
                total_time_taken: sessionManager.session.total_time_taken,
            }
        )

        const data = response.data
        currentQuestion.is_correct = data.is_correct
        currentQuestion.status = data.status
        currentQuestion.solution = data.solution
        currentQuestion.solution_video = data.solution_video
        currentQuestion.ca = data.ca
        currentQuestion.points_earned = data.points_earned

        if (data.is_correct && data.points_earned !== 0) {
            if (props.practiceSet.allow_rewards && props.settings.show_reward_popup) {
                showPoints(data.points_earned)
            }
            sessionManager.session.total_points_earned = data.total_points_earned
        }
    } catch (error) {
        logError('Failed to submit answer', { error: error.message, questionId: sessionManager.currentQuestion.value?.id })
    } finally {
        sessionManager.isLoading.value = false
    }
}

const pauseTest = () => {
    confirm.require({
        message: __('practice_pause_text'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            router.post(
                route('practice_session_analysis', {
                    practiceSet: props.practiceSet.slug,
                    session: props.session.code,
                }),
                {
                    total_time_taken: sessionManager.session.total_time_taken,
                },
                { replace: true }
            )
        },
        reject: () => {
            // callback to execute when user rejects the action
        },
    })
}

const finishTest = () => {
    router.post(
        route('finish_practice_session', {
            practiceSet: props.practiceSet.slug,
            session: props.session.code,
        }),
        {},
        { replace: true }
    )
}

const updateAnswer = value => {
    const currentQuestion = sessionManager.session.questions[sessionManager.session.current_question]
    currentQuestion.user_answer = value

    // Synchronize with composables
    sessionManager.updateAnswer(currentQuestion.code, value, {
        questionIndex: sessionManager.session.current_question,
        autoSave: false,
    })
}

const prevQuestion = () => {
    if (sessionManager.session.current_question !== 0) {
        sessionManager.session.current_question--
    } else {
        prevPage()
    }
}

const nextQuestion = () => {
    if (sessionManager.session.current_question < sessionManager.session.questions.length - 1) {
        sessionManager.session.current_question++
    } else {
        if (getQuestionNo(sessionManager.session.current_question) < props.practiceSet.total_questions - 1) {
            nextPage()
        }
    }
}

const jumpToQuestion = questionID => {
    sessionManager.session.current_question = questionID
}

// Optional: mark for review support in practice (kept consistent with other screens)
const toggleReviewForCurrent = () => {
    const idx = sessionManager.session.current_question
    const currentQuestion = sessionManager.session.questions[idx]
    if (!currentQuestion) return

    const ans = currentQuestion.user_answer
    const hasAnswer = Array.isArray(ans) ? ans.length > 0 : ans !== undefined && ans !== null && ans !== ''

    questionNavigation.toggleMarkForReview(idx, hasAnswer)
    sessionManager.markForReview(idx)

    const newStatus = questionNavigation.getQuestionStatus(idx)
    currentQuestion.status = newStatus
    sessionManager.setStatus(idx, newStatus, { navigation: questionNavigation })
}

const prevPage = () => {
    if (pagination.value && pagination.value.current_page !== 1) {
        sessionManager.session.current_question = 0
        fetchQuestions(pagination.value.current_page - 1)
    }
}

const nextPage = () => {
    if (pagination.value && pagination.value.current_page < pagination.value.total_pages) {
        sessionManager.session.current_question = 0
        fetchQuestions(pagination.value.current_page + 1)
    }
}

const fetchQuestions = async page => {
    loading.value = true
    try {
        const response = await axios.get(
            route('fetch_practice_questions', {
                practiceSet: props.practiceSet.slug,
                session: props.session.code,
                page: page,
            })
        )

        const data = response.data
        sessionManager.session.questions = data.questions
        pagination.value = data.pagination

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
        logError('Failed to fetch questions', { error: error.message, practiceSetId: props.practiceSet?.id })
    } finally {
        loading.value = false
    }
}

const getQuestionNo = index => {
    if (!pagination.value) return index + 1
    return index + 1 + pagination.value.per_page * (pagination.value.current_page - 1)
}

const typeCheck = value => {
    const return_value = Object.prototype.toString.call(value)
    const type = return_value.substring(return_value.indexOf(' ') + 1, return_value.indexOf(']'))
    return type.toLowerCase()
}

// Ensure clear behavior for ORD returns [] when needed (handled within components typically)

const PRACTICE_ELAPSED_KEY = computed(() => `practice_elapsed_${props.session.code}`)

const saveTimers = () => {
    try {
        localStorage.setItem(PRACTICE_ELAPSED_KEY.value, JSON.stringify(elapsedTimer.getState()))
    } catch (e) {}
}

const restoreTimers = () => {
    try {
        const raw = localStorage.getItem(PRACTICE_ELAPSED_KEY.value)
        if (!raw) return
        const payload = JSON.parse(raw)
        elapsedTimer.restoreState(payload)
    } catch (e) {}
}

const clearTimers = () => {
    try {
        localStorage.removeItem(PRACTICE_ELAPSED_KEY.value)
    } catch (e) {}
}

const startTimer = () => {
    elapsedTimer.startTimer()
    sessionManager.startAutoSave()
}

const showPoints = points => {
    const bonus = new Audio(pageProps.appUrl + '/images/insight.mp3')
    const rewardString = rewardStrings[Math.floor(Math.random() * rewardStrings.length)]

    createTimeout(() => {
        bonus.play()
        Swal.fire({
            title: '<strong>' + points + ' XP</strong>',
            html:
                '<div class="w-full flex flex-col justify-center items-center">' +
                '<img src="' +
                pageProps.appUrl +
                '/images/reward.gif" />' +
                '<span class="">' +
                rewardString +
                "! You've earned " +
                points +
                ' points</span>' +
                '</template>',
            showCloseButton: false,
            focusConfirm: true,
            confirmButtonText:
                '<div class="flex gap-2 justify-center items-center">' +
                '<svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 10h4.764a2 2 0 011.789 2.894l-3.5 7A2 2 0 0115.263 21h-4.017c-.163 0-.326-.02-.485-.06L7 20m7-10V5a2 2 0 00-2-2h-.095c-.5 0-.905.405-.905.905 0 .714-.211 1.412-.608 2.006L7 11v9m7-10h-2M7 20H5a2 2 0 01-2-2v-6a2 2 0 012-2h2.5"></path></svg> Great!' +
                '</template>',
            confirmButtonAriaLabel: 'Thumbs up, great!',
        })
    }, 1000)
}

// Lifecycle
onMounted(() => {
    // Store the handler
    const onCtx = e => e.preventDefault()

    // Disable right-click context menu
    document.addEventListener('contextmenu', onCtx)

    // Store handler for cleanup
    document._practiceContextHandler = onCtx

    // Restore timers
    restoreTimers()

    fetchQuestions(1)

    const onPageHide = () => {
        try {
            saveTimers()
        } catch (e) {}
        try {
            if (typeof sessionManager.saveSession === 'function') {
                sessionManager.saveSession()
            }
        } catch (e) {}
    }
    const onPageShow = e => {
        if (e && e.persisted) {
            try {
                restoreTimers()
            } catch (e) {}
            if (!elapsedTimer.isActive.value) elapsedTimer.startTimer()
        }
    }
    window.addEventListener('pagehide', onPageHide)
    window.addEventListener('pageshow', onPageShow)
    document._practicePageHideHandler = onPageHide
    document._practicePageShowHandler = onPageShow
})

onUnmounted(() => {
    saveTimers()
    elapsedTimer.stopTimer()
    sessionManager.cleanup()

    // Remove context menu listener
    if (document._practiceContextHandler) {
        document.removeEventListener('contextmenu', document._practiceContextHandler)
        delete document._practiceContextHandler
    }
    if (document._practicePageHideHandler) {
        window.removeEventListener('pagehide', document._practicePageHideHandler)
        delete document._practicePageHideHandler
    }
    if (document._practicePageShowHandler) {
        window.removeEventListener('pageshow', document._practicePageShowHandler)
        delete document._practicePageShowHandler
    }
})
</script>
