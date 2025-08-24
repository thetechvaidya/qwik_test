<template>
    <app-layout>
        <template #header>
            <div class="flex items-center">
                <back-button />
                <h1 class="app-heading">{{ practiceSet.title }} {{ __('Analysis') }}</h1>
            </div>
        </template>
        <template #actions>
            <Link
                v-if="session.status !== 'completed'"
                :href="route('go_to_practice', { practiceSet: practiceSet.slug, session: session.code })"
            >
                <span class="qt-btn qt-btn-sm qt-btn-success">{{ __('Resume Practice') }}</span>
            </Link>
        </template>

        <Head :title="title" />

        <div class="py-8">
            <div class="w-full flex flex-col justify-center items-center">
                <div
                    v-if="practiceSet.allow_rewards && session.status !== 'completed'"
                    class="w-full font-mono px-4 py-2 border border-green-200 bg-green-100 text-green-600 rounded text-sm mb-4"
                >
                    {{ __('finish_points_message') }}
                </div>
                <div class="w-full card mb-6">
                    <div class="card-body">
                        <div class="flex gap-4 justify-between border-b border-gray-100 items-center h-16 px-4 py-4">
                            <div class="flex items-center gap-2">
                                <svg
                                    class="w-7 h-7"
                                    xmlns="http://www.w3.org/2000/svg"
                                    x="0px"
                                    y="0px"
                                    width="300px"
                                    height="300px"
                                    viewBox="0 0 300 300"
                                    enable-background="new 0 0 300 300"
                                    xml:space="preserve"
                                >
                                    <g>
                                        <ellipse fill="#FFC843" cx="149.833" cy="149.501" rx="147.833" ry="146.166" />
                                        <ellipse fill="#D38700" cx="150" cy="150.168" rx="113.667" ry="113.833" />
                                        <polygon
                                            fill="#FFC843"
                                            points="192.716,211.945 151.021,190.203 109.476,212.222 117.27,165.852 83.489,133.142 129.999,126.226
                                                                                    150.667,83.991 171.618,126.086 218.172,132.693 184.611,165.626"
                                        />
                                    </g>
                                </svg>
                                <h4
                                    v-if="session.status === 'completed' && allowRewards"
                                    class="font-semibold text-sm"
                                    >{{ __('Points Earned') }}</h4
                                >
                                <h4 v-else class="font-semibold text-sm">{{ __('Score') }}</h4>
                            </div>
                            <div class="text-sm">{{ session.total_points_earned }} XP</div>
                        </div>
                        <div class="flex gap-4 justify-between border-b border-gray-100 items-center h-16 px-4 py-4">
                            <div class="flex items-center gap-2">
                                <img class="w-7 h-7" :src="$page.props.appUrl + 'images/darts.png'" alt="Accuracy" />
                                <h4 class="font-semibold text-sm">{{ __('Accuracy') }}</h4>
                            </div>
                            <div class="text-sm">{{ analytics.accuracy }}%</div>
                        </div>
                        <div
                            class="grid grid-cols-1 sm:grid-cols-2 gap-4 border-b border-gray-100 justify-center items-center px-4 py-4"
                        >
                            <div class="flex gap-4 sm:justify-center items-center">
                                <div class="w-28">
                                    <doughnut-chart
                                        id="status"
                                        :key="'status'"
                                        :chart-data="statusChartData"
                                        :element-text="totalAnswered"
                                    />
                                </div>
                                <div class="flex flex-col gap-2 justify-center">
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-green-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.correct_answered_questions }} {{ __('Correct') }}
                                    </div>
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-red-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.wrong_answered_questions }} {{ __('Wrong') }}
                                    </div>
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-gray-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.unanswered_questions }} {{ __('Unanswered') }}
                                    </div>
                                </div>
                            </div>
                            <div class="flex gap-4 sm:justify-center items-center">
                                <div class="w-28">
                                    <doughnut-chart
                                        id="time_spent"
                                        :key="'time_spent'"
                                        :chart-data="timeSpentChartData"
                                        :element-text="totalTimeSpent"
                                    />
                                </div>
                                <div class="flex flex-col gap-2 justify-center">
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-green-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.time_taken_for_correct_answered.detailed_readable }}
                                        {{ __('Correct') }}
                                    </div>
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-red-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.time_taken_for_wrong_answered.detailed_readable }}
                                        {{ __('Wrong') }}
                                    </div>
                                    <div class="flex gap-2 items-center text-xs">
                                        <svg
                                            class="w-5 h-5 text-gray-400"
                                            fill="none"
                                            stroke="currentColor"
                                            viewBox="0 0 24 24"
                                            xmlns="http://www.w3.org/2000/svg"
                                        >
                                            <path
                                                stroke-linecap="round"
                                                stroke-linejoin="round"
                                                stroke-width="2"
                                                d="M15 12H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"
                                            ></path>
                                        </svg>
                                        {{ analytics.time_taken_for_other.detailed_readable }} {{ __('Other') }}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="flex gap-4 justify-between items-center h-16 px-4 py-4">
                            <div class="flex items-center gap-2">
                                <img class="w-7 h-7" :src="$page.props.appUrl + 'images/clock.png'" alt="Speed" />
                                <h4 class="font-semibold text-sm">{{ __('Avg. Speed') }}</h4>
                            </div>
                            <div class="text-sm">{{ analytics.speed }} que/hr</div>
                        </div>
                    </div>
                </div>
            </div>
            <div v-if="session.status === 'completed'">
                <h2 class="text-lg font-semibold leading-tight text-gray-800 mb-6">{{ __('Solutions') }}</h2>
                <div class="w-full card">
                    <div class="w-full card-body lg:flex flex-wrap">
                        <div class="py-4 lg:w-1/3 w-full md:ltr:pr-6 md:rtl:pl-6">
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
                            <ul v-else class="my-6 flex flex-wrap justify-center items-center gap-2">
                                <li
                                    v-for="(question, index) in questions"
                                    :key="question.code"
                                    @click="jumpToQuestion(index)"
                                >
                                    <practice-question-chip
                                        :sno="index + 1"
                                        :is_correct="question.is_correct"
                                        :status="question.status"
                                        :active="current_question === index"
                                    ></practice-question-chip>
                                </li>
                            </ul>
                        </div>
                        <div
                            class="py-4 lg:w-2/3 w-full md:ltr:pl-6 md:rtl:pr-6 sm:ltr:border-l sm:rtl:border-r border-gray-200"
                        >
                            <div v-if="loading" class="w-full sm:w-2/3">
                                <div class="card card-body">
                                    <PracticeQuestionShimmer class="w-full"></PracticeQuestionShimmer>
                                </div>
                            </div>
                            <div v-else>
                                <div v-for="(question, index) in questions" :key="question.id">
                                    <div v-show="current_question === index" :id="question.code">
                                        <div class="flex justify-between items-center mb-6">
                                            <div
                                                class="font-mono px-2 py-1 inline-block bg-qt-option text-white rounded text-sm mb-2"
                                            >
                                                {{ __('Time Spent') }}: {{ question.time_taken.detailed_readable }}
                                            </div>
                                            <div
                                                v-if="question.status === 'answered'"
                                                :class="question.is_correct ? 'bg-green-400' : 'bg-red-400'"
                                                class="font-mono px-2 py-1 inline-block text-white rounded text-sm mb-2"
                                            >
                                                <span v-if="question.is_correct"
                                                    >+{{ question.points_earned }} {{ __('Points') }}</span
                                                >
                                                <span v-if="!question.is_correct">{{ __('No Points') }}</span>
                                            </div>
                                            <div
                                                v-else
                                                class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2"
                                            >
                                                {{ __('Not Answered') }}
                                            </div>
                                        </div>
                                        <practice-question-card
                                            :key="question.card"
                                            :question="question"
                                            :sno="index + 1"
                                            :total-questions="practiceSet.total_questions"
                                        ></practice-question-card>
                                        <div
                                            v-if="question.questionType === 'MSA' || question.questionType === 'TOF'"
                                            class="mt-4"
                                        >
                                            <MSASolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </MSASolution>
                                        </div>
                                        <div v-if="question.questionType === 'MMA'" class="mt-4">
                                            <MMASolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </MMASolution>
                                        </div>
                                        <div v-if="question.questionType === 'MTF'" class="mt-4">
                                            <MTFSolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </MTFSolution>
                                        </div>
                                        <div v-if="question.questionType === 'ORD'" class="mt-4">
                                            <ORDSolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </ORDSolution>
                                        </div>
                                        <div v-if="question.questionType === 'FIB'" class="mt-4">
                                            <FIBSolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </FIBSolution>
                                        </div>
                                        <div v-if="question.questionType === 'SAQ'" class="mt-4">
                                            <SAQSolution
                                                :key="question.code"
                                                :parent-qid="question.code"
                                                :is-correct="question.is_correct"
                                                :status="question.status"
                                                :parent-options="question.options"
                                                :parent-answer="question.user_answer"
                                                :correct-answer="question.ca"
                                            >
                                            </SAQSolution>
                                        </div>
                                        <div class="mt-4">
                                            <practice-solution-card :question="question"></practice-solution-card>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>

<script setup>
import { ref, computed, onMounted } from 'vue'
import { Head, Link, usePage } from '@inertiajs/vue3'
import AppLayout from '@/Layouts/AppLayout.vue'
import DoughnutChart from '@/Charts/DoughnutChart'
import RewardsBadge from '@/Components/RewardsBadge'
import PracticeQuestionCard from '@/Components/Cards/PracticeQuestionCard'
import PracticeQuestionChip from '@/Components/Cards/PracticeQuestionChip'
import NavigationQuestionCardShimmer from '@/Components/Shimmers/NavigationQuestionCardShimmer'
import PracticeQuestionShimmer from '@/Components/Shimmers/PracticeQuestionShimmer'
import PracticeSolutionCard from '@/Components/Cards/PracticeSolutionCard'
import SAQSolution from '@/Components/Questions/Solutions/SAQSolution'
import FIBSolution from '@/Components/Questions/Solutions/FIBSolution'
import ORDSolution from '@/Components/Questions/Solutions/ORDSolution'
import MTFSolution from '@/Components/Questions/Solutions/MTFSolution'
import MSASolution from '@/Components/Questions/Solutions/MSASolution'
import MMASolution from '@/Components/Questions/Solutions/MMASolution'
import BackButton from '@/Components/BackButton'
import axios from 'axios'
import { useTranslate } from '@/composables/useTranslate'
import { useChartData } from '@/composables/useChartData'

const props = defineProps({
    practiceSet: Object,
    session: Object,
    analytics: Object,
    allowRewards: Boolean,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()

const loading = ref(false)
const questions = ref([])
const current_question = ref(0)

const { createDoughnutChart, colorSchemes } = useChartData()

const statusChart = createDoughnutChart({
    labels: ['Correct', 'Wrong', 'Unanswered'],
    values: [
        props.analytics.correct_answered_questions,
        props.analytics.wrong_answered_questions,
        props.analytics.unanswered_questions,
    ],
    colors: ['rgb(52, 211, 153)', 'rgb(248, 113, 113)', 'rgb(156, 163, 175)'],
})

const timeSpentChart = createDoughnutChart({
    labels: ['Correct', 'Wrong', 'Other'],
    values: [
        props.analytics.time_taken_for_correct_answered.seconds,
        props.analytics.time_taken_for_wrong_answered.seconds,
        props.analytics.time_taken_for_other.seconds,
    ],
    colors: ['rgb(52, 211, 153)', 'rgb(248, 113, 113)', 'rgb(156, 163, 175)'],
})

// Chart data for template
const statusChartData = statusChart.data
const timeSpentChartData = timeSpentChart.data

const title = computed(() => props.practiceSet.title + ' ' + __('Analysis') + ' - ' + pageProps.general.app_name)
const totalAnswered = computed(
    () => `${props.analytics.answered_questions}/${props.analytics.total_questions} Answered`
)
const totalTimeSpent = computed(() => `${props.analytics.total_time_taken.detailed_readable} Spent`)

const jumpToQuestion = questionID => {
    current_question.value = questionID
}

const fetchQuestions = async () => {
    loading.value = true
    try {
        const response = await axios.get(
            route('fetch_practice_set_solutions', {
                practiceSet: props.practiceSet.slug,
                session: props.session.code,
            })
        )
        const data = response.data
        questions.value = data.questions
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    if (props.session.status === 'completed') {
        fetchQuestions()
    }
})
</script>
