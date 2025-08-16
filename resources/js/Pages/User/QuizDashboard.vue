<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('Quizzes') }}</h1>
        </template>

        <div class="py-6">
            <div class="flex flex-col items-center">
                <div class="w-full mb-6">
                    <div class="flex items-center justify-between">
                        <section-header :title="'Browse'"></section-header>
                        <div class="flex ltr:flex-row rtl:flex-row-reverse items-center">
                            <div class="hw-prev text-secondary hover:text-primary cursor-pointer" @click="prev">
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
                                        d="M10 19l-7-7m0 0l7-7m-7 7h18"
                                    ></path>
                                </svg>
                            </div>
                            <div class="hw-next text-secondary hover:text-primary cursor-pointer" @click="next">
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
                                        d="M14 5l7 7m0 0l-7 7m7-7H3"
                                    ></path>
                                </svg>
                            </div>
                        </div>
                    </div>
                    <Swiper
                        ref="mySwiper"
                        class="swiper"
                        :modules="swiperModules"
                        :slides-per-view="slidesPerView"
                        :space-between="spaceBetween"
                        :breakpoints="breakpoints"
                    >
                        <SwiperSlide v-for="quizType in quizTypes" :key="quizType.code">
                            <quiz-type-card :quiz-type="quizType"></quiz-type-card>
                        </SwiperSlide>
                    </Swiper>
                </div>
                <div class="w-full">
                    <section-header :title="'Live Quizzes'">
                        <template #icon>
                            <span class="flex absolute h-3 w-3 top-4 ltr:-right-4 rtl:-left-4">
                                <span
                                    class="animate-ping absolute inline-flex h-full w-full rounded-full bg-secondary opacity-75"
                                ></span>
                                <span class="relative inline-flex rounded-full h-3 w-3 bg-secondary"></span>
                            </span>
                        </template>
                        <template #action>
                            <Link :href="route('live_quizzes')">
                                <span class="text-sm font-semibold text-secondary underline">{{ __('View All') }}</span>
                            </Link>
                        </template>
                    </section-header>
                    <div v-if="quizSchedules.length > 0" class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
                        <template v-for="(quiz, index) in quizSchedules">
                            <quiz-schedule-card :quiz="quiz" :subscription="subscription">
                                <template #action>
                                    <Link
                                        v-if="quiz.paid && !subscription && quiz.redeem"
                                        :href="
                                            route('quiz_schedule_instructions', {
                                                quiz: quiz.slug,
                                                schedule: quiz.code,
                                            })
                                        "
                                    >
                                        <span class="qt-btn qt-btn-sm qt-btn-primary"
                                            >{{ __('Redeem with') }} {{ quiz.redeem }}</span
                                        >
                                    </Link>
                                    <button
                                        v-else-if="quiz.paid && !subscription"
                                        class="qt-btn qt-btn-sm bg-gray-300 inline-flex items-center"
                                        @click="showSubscribeModal"
                                    >
                                        <svg
                                            class="w-4 h-4 mr-1"
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
                                        <span>{{ __('Unlock') }}</span>
                                    </button>
                                    <Link
                                        v-else
                                        :href="
                                            route('quiz_schedule_instructions', {
                                                quiz: quiz.slug,
                                                schedule: quiz.code,
                                            })
                                        "
                                    >
                                        <span class="qt-btn qt-btn-sm qt-btn-primary">{{ __('Start Quiz') }}</span>
                                    </Link>
                                </template>
                            </quiz-schedule-card>
                        </template>
                    </div>
                    <div v-else class="mb-6">
                        <empty-student-card :title="'No Schedules Found'"></empty-student-card>
                    </div>
                </div>
            </div>
        </div>
    </app-layout>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Head, Link, usePage } from '@inertiajs/vue3'
import AppLayout from '@/Layouts/AppLayout.vue'
import QuizCard from '@/Components/Cards/QuizCard'
import QuizScheduleCard from '@/Components/Cards/QuizScheduleCard'
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard'
import SectionHeader from '@/Components/SectionHeader'
import QuizTypeCard from '@/Components/Cards/QuizTypeCard'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { Navigation, FreeMode, Mousewheel, Scrollbar } from 'swiper/modules'
import 'swiper/css'
import 'swiper/css/navigation'
import 'swiper/css/scrollbar'

const props = defineProps({
    quizTypes: Array,
    quizSchedules: Array,
    subscription: {
        type: Boolean,
        default: false,
    },
})

const { props: pageProps } = usePage()
const title = computed(() => `Quiz Dashboard - ${pageProps.general.app_name}`)

const swiperModules = [Navigation, FreeMode, Mousewheel, Scrollbar]
const slidesPerView = 4
const spaceBetween = 10
const breakpoints = {
    1024: { slidesPerView: 4, spaceBetween: 10 },
    768: { slidesPerView: 3, spaceBetween: 10 },
    640: { slidesPerView: 2, spaceBetween: 5 },
    320: { slidesPerView: 2, spaceBetween: 5 },
}

const mySwiper = ref(null)
const swiperInstance = ref(null)
const onSwiper = instance => {
    swiperInstance.value = instance
}
const next = () => {
    if (swiperInstance.value) swiperInstance.value.slideNext()
}
const prev = () => {
    if (swiperInstance.value) swiperInstance.value.slidePrev()
}

const showSubscribeModal = () => {
    // Keep behavior consistent; simple redirect for now
    window.location.assign(route('pricing'))
}
</script>
