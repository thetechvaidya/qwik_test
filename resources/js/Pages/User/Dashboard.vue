<template>
    <app-layout>
        <Head :title="title" />
        <template #header>
            <h1 class="app-heading">{{ __('Dashboard') }}</h1>
        </template>

        <!-- Modern Onboarding Experience -->
        <div v-if="needsSyllabusSelection" class="py-8">
            <div class="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8">
                <!-- Welcome Section -->
                <div class="text-center mb-12">
                    <div class="mx-auto h-20 w-20 bg-gradient-to-br from-indigo-600 via-purple-600 to-pink-600 rounded-3xl flex items-center justify-center shadow-xl mb-6">
                        <i class="pi pi-graduation-cap text-white text-3xl"></i>
                    </div>
                    <h2 class="text-4xl font-bold bg-gradient-to-r from-indigo-600 via-purple-600 to-pink-600 bg-clip-text text-transparent mb-4">
                        {{ __('Welcome to Your Learning Journey!') }}
                    </h2>
                    <p class="text-xl text-gray-600 max-w-2xl mx-auto">
                        {{ __('Choose your study category to get started with personalized quizzes, practice sessions, and track your progress.') }}
                    </p>
                </div>

                <!-- Category Selection -->
                <div class="mb-12">
                    <h3 class="text-2xl font-semibold text-gray-900 text-center mb-8">{{ __('Select Your Study Category') }}</h3>
                    <div v-if="categories.length > 0" class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
                        <div
                            v-for="category in categories"
                            :key="category.code"
                            class="group relative bg-white rounded-2xl shadow-lg hover:shadow-2xl transition-all duration-300 cursor-pointer transform hover:-translate-y-2 border border-gray-100 hover:border-indigo-200"
                            @click="updateSyllabus(category.code)"
                        >
                            <div class="p-8 text-center">
                                <div class="w-16 h-16 bg-gradient-to-br from-indigo-100 to-purple-100 rounded-2xl flex items-center justify-center mx-auto mb-4 group-hover:from-indigo-600 group-hover:to-purple-600 transition-all duration-300">
                                    <i class="pi pi-book text-2xl text-indigo-600 group-hover:text-white transition-colors duration-300"></i>
                                </div>
                                <h4 class="text-xl font-semibold text-gray-900 mb-3 group-hover:text-indigo-600 transition-colors duration-300">
                                    {{ category.name }}
                                </h4>
                                <div class="inline-flex items-center px-3 py-1 rounded-full text-sm font-medium bg-gray-100 text-gray-700 group-hover:bg-indigo-100 group-hover:text-indigo-700 transition-all duration-300">
                                    {{ category.category }} • {{ category.type }}
                                </div>
                            </div>
                            <div class="absolute inset-0 bg-gradient-to-br from-indigo-600 to-purple-600 rounded-2xl opacity-0 group-hover:opacity-5 transition-opacity duration-300"></div>
                        </div>
                    </div>
                    <div v-else class="text-center py-12">
                        <div class="text-gray-500 text-lg">{{ __('No categories available at the moment.') }}</div>
                    </div>
                </div>

                <!-- Features Preview -->
                <div class="grid grid-cols-1 md:grid-cols-3 gap-8 mb-12">
                    <div class="text-center">
                        <div class="w-12 h-12 bg-green-100 rounded-xl flex items-center justify-center mx-auto mb-4">
                            <i class="pi pi-chart-line text-green-600 text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">{{ __('Track Progress') }}</h4>
                        <p class="text-gray-600">{{ __('Monitor your learning journey with detailed analytics and progress reports.') }}</p>
                    </div>
                    <div class="text-center">
                        <div class="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center mx-auto mb-4">
                            <i class="pi pi-clock text-blue-600 text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">{{ __('Scheduled Tests') }}</h4>
                        <p class="text-gray-600">{{ __('Never miss important exams with our integrated calendar and notifications.') }}</p>
                    </div>
                    <div class="text-center">
                        <div class="w-12 h-12 bg-purple-100 rounded-xl flex items-center justify-center mx-auto mb-4">
                            <i class="pi pi-users text-purple-600 text-xl"></i>
                        </div>
                        <h4 class="text-lg font-semibold text-gray-900 mb-2">{{ __('Practice Sessions') }}</h4>
                        <p class="text-gray-600">{{ __('Improve your skills with interactive practice sessions and instant feedback.') }}</p>
                    </div>
                </div>
            </div>
        </div>

        <!-- Regular Dashboard -->
        <div v-else class="py-6">
            <div class="w-full gap-4 md:gap-6 flex flex-col flex-col-reverse md:flex-row">
                <div class="w-full md:w-2/3">
                    <section-header :title="'Continue Practice'"></section-header>
                    <div v-if="practiceSessions.length > 0" class="grid grid-cols-1 mb-6">
                        <template v-for="(practiceSession, index) in practiceSessions" :key="practiceSession.code">
                            <practice-session-card :practice-session="practiceSession">
                                <template #action>
                                    <Link :href="route('init_practice_set', { slug: practiceSession.slug })">
                                        <span class="qt-btn qt-btn-sm qt-btn-primary">{{ __('Resume Practice') }}</span>
                                    </Link>
                                </template>
                            </practice-session-card>
                        </template>
                    </div>
                    <div v-else class="mb-6">
                        <empty-student-card :title="__('No Practice Sessions Found')">
                            <template #action>
                                <Link :href="route('learn_practice')">
                                    <span class="qt-btn qt-btn-sm qt-btn-primary">{{ __('Start Practice') }}</span>
                                </Link>
                            </template>
                        </empty-student-card>
                    </div>
                </div>
                <div class="w-full md:w-1/3">
                    <section-header :title="'Test Schedules'"></section-header>
                    <div class="card">
                        <v-calendar
                            class="border-0"
                            :attributes="attrs"
                            :rows="calendarRows"
                            :min-date="minDate"
                            :max-date="maxDate"
                            title-position="left"
                            is-expanded
                        >
                            <template #day-popover="{ day, dayTitle, attributes }">
                                <div>
                                    <div class="text-xs text-gray-300 font-semibold text-center">
                                        {{ dayTitle }}
                                    </div>
                                    <div v-for="attr in attributes" :key="attr.key" class="py-1">
                                        <Link
                                            v-if="attr.customData.entity === 'quiz'"
                                            :href="
                                                route('quiz_schedule_instructions', {
                                                    quiz: attr.customData.slug,
                                                    schedule: attr.customData.code,
                                                })
                                            "
                                        >
                                            <span class="hover:underline"
                                                >{{ attr.customData.title }} ({{ attr.customData.type }})</span
                                            >
                                        </Link>
                                        <Link
                                            v-else
                                            :href="
                                                route('exam_schedule_instructions', {
                                                    exam: attr.customData.slug,
                                                    schedule: attr.customData.code,
                                                })
                                            "
                                        >
                                            <span class="hover:underline"
                                                >{{ attr.customData.title }} ({{ attr.customData.type }})</span
                                            >
                                        </Link>
                                    </div>
                                </div>
                            </template>
                        </v-calendar>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>

<script setup>
import { computed, toRef } from 'vue'
import { Head } from '@inertiajs/vue3'
import { usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AppLayout from '@/Layouts/AppLayout.vue'
// Removed unused SubCategoryCard
import PracticeSessionCard from '@/Components/Cards/PracticeSessionCard.vue'
// Removed unused QuizScheduleCard
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard.vue'
import SectionHeader from '@/Components/SectionHeader.vue'

// Props
const props = defineProps({
    practiceSessions: Array,
    quizSchedules: Array,
    minDate: String,
    maxDate: String,
    scheduleCalendar: Array,
    needsSyllabusSelection: {
        type: Boolean,
        default: false
    },
    categories: {
        type: Array,
        default: () => []
    }
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Reactive data
const attrs = toRef(props, 'scheduleCalendar')

// Computed properties
const title = computed(() => {
    return __('User Dashboard') + ' - ' + pageProps.general.app_name
})

const calendarRows = computed(() => {
    return pageProps.isMobile ? 1 : 2
})

const updateSyllabus = (categoryCode) => {
    router.post(route('update_syllabus'), {
        category: categoryCode
    }, {
        preserveScroll: true,
        onSuccess: () => {
            // Refresh the page to load dashboard with selected syllabus
            window.location.reload();
        }
    });
}
</script>

<style scoped>
.vc-container {
    border: 0 !important;
}
</style>
