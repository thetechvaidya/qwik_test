<template>
    <app-layout>
        <Head :title="title" />
        <template #header>
            <h1 class="app-heading">{{ __('Dashboard') }}</h1>
        </template>

        <div class="py-6">
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
import { usePage } from '@inertiajs/vue3'
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
</script>

<style scoped>
.vc-container {
    border: 0 !important;
}
</style>
