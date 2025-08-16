<template>
    <Head :title="title" />
    <app-layout>
        <template #header>
            <div class="flex items-center">
                <back-button />
                <h1 class="app-heading">{{ quiz.title }} {{ __('Solutions') }}</h1>
            </div>
        </template>

        <div class="w-full mt-8">
            <progress-navigator :steps="steps"></progress-navigator>
        </div>

        <div class="py-8">
            <div v-if="quiz.settings.hide_solutions" class="mb-6">
                <empty-student-card :title="__('No Solutions Found or Solutions Hidden')"></empty-student-card>
            </div>
            <div v-else>
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
                                    <exam-result-question-chip
                                        :sno="index + 1"
                                        :is_correct="question.is_correct"
                                        :status="question.status"
                                        :active="current_question === index"
                                    ></exam-result-question-chip>
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
                                                v-if="
                                                    question.status === 'answered' ||
                                                    question.status === 'answered_mark_for_review'
                                                "
                                                :class="question.is_correct ? 'bg-green-400' : 'bg-red-400'"
                                                class="font-mono px-2 py-1 inline-block text-white rounded text-sm mb-2"
                                            >
                                                <span v-if="question.is_correct"
                                                    >+{{ question.marks_earned }} {{ __('Marks Earned') }}</span
                                                >
                                                <span v-if="!question.is_correct"
                                                    >-{{ question.marks_deducted }} {{ __('Marks Deducted') }}</span
                                                >
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
                                            :question="question"
                                            :sno="index + 1"
                                            :total-questions="quiz.total_questions"
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
import { usePage, Head } from '@inertiajs/vue3'
import axios from 'axios'
import AppLayout from '@/Layouts/AppLayout.vue'
import RewardsBadge from '@/Components/RewardsBadge.vue'
import MSASolution from '@/Components/Questions/Solutions/MSASolution.vue'
import PracticeQuestionCard from '@/Components/Cards/PracticeQuestionCard.vue'
import ExamResultQuestionChip from '@/Components/Cards/ExamResultQuestionChip.vue'
import NavigationQuestionCardShimmer from '@/Components/Shimmers/NavigationQuestionCardShimmer.vue'
import PracticeQuestionShimmer from '@/Components/Shimmers/PracticeQuestionShimmer.vue'
import PracticeSolutionCard from '@/Components/Cards/PracticeSolutionCard.vue'
import MMASolution from '@/Components/Questions/Solutions/MMASolution.vue'
import MTFSolution from '@/Components/Questions/Solutions/MTFSolution.vue'
import ORDSolution from '@/Components/Questions/Solutions/ORDSolution.vue'
import FIBSolution from '@/Components/Questions/Solutions/FIBSolution.vue'
import SAQSolution from '@/Components/Questions/Solutions/SAQSolution.vue'
import BackButton from '@/Components/BackButton.vue'
import ProgressNavigator from '@/Components/Stepper/ProgressNavigator.vue'
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    quiz: Object,
    session: Object,
    steps: Array,
})

// Composables
const { __ } = useTranslate()
const page = usePage()

// Reactive data
const loading = ref(false)
const questions = ref([])
const current_question = ref(0)

// Computed
const title = computed(() => {
    return props.quiz.title + ' ' + __('Solutions') + ' - ' + page.props.general.app_name
})

// Methods
const jumpToQuestion = questionID => {
    current_question.value = questionID
}

const fetchQuestions = async () => {
    loading.value = true
    try {
        const response = await axios.get(
            route('fetch_quiz_solutions', {
                quiz: props.quiz.slug,
                session: props.session.code,
            })
        )

        const data = response.data
        if (data && data.questions) {
            questions.value = data.questions
        } else {
            console.warn('No questions data received from server')
            questions.value = []
        }
    } catch (error) {
        console.error('Failed to fetch quiz solutions:', error)
        questions.value = []

        // Could emit an error event or show toast notification
        // emit('error', 'Failed to load quiz solutions')
    } finally {
        loading.value = false
    }
}

// Lifecycle
onMounted(() => {
    if (!props.quiz.settings.hide_solutions) {
        fetchQuestions()
    }
})
</script>
