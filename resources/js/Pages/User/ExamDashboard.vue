<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('Exams') }}</h1>
        </template>

        <Head :title="title" />
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
                        :modules="modules"
                        :slides-per-view="slidesPerView"
                        :space-between="spaceBetween"
                        :breakpoints="breakpoints"
                    >
                        <SwiperSlide v-for="examType in examTypes" :key="examType.code">
                            <exam-type-card :exam-type="examType" />
                        </SwiperSlide>
                    </Swiper>
                </div>
                <div class="w-full">
                    <section-header :title="'Live Exams'">
                        <template #icon>
                            <span class="flex absolute h-3 w-3 top-4 ltr:-right-4 rtl:-left-4">
                                <span
                                    class="animate-ping absolute inline-flex h-full w-full rounded-full bg-secondary opacity-75"
                                ></span>
                                <span class="relative inline-flex rounded-full h-3 w-3 bg-secondary"></span>
                            </span>
                        </template>
                        <template #action>
                            <Link :href="route('live_exams')">
                                <span class="text-sm font-semibold text-secondary underline">{{ __('View All') }}</span>
                            </Link>
                        </template>
                    </section-header>
                    <div v-if="examSchedules.length > 0" class="grid grid-cols-1 sm:grid-cols-2 gap-4 mb-6">
                        <template v-for="(exam, index) in examSchedules" :key="exam.code">
                            <exam-schedule-card :exam="exam" :subscription="subscription">
                                <template #action>
                                    <Link
                                        v-if="exam.paid && !subscription && exam.redeem"
                                        :href="
                                            route('exam_schedule_instructions', {
                                                exam: exam.slug,
                                                schedule: exam.code,
                                            })
                                        "
                                    >
                                        <span class="qt-btn qt-btn-sm qt-btn-primary"
                                            >{{ __('Redeem with') }} {{ exam.redeem }}</span
                                        >
                                    </Link>
                                    <button
                                        v-else-if="exam.paid && !subscription"
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
                                            route('exam_schedule_instructions', {
                                                exam: exam.slug,
                                                schedule: exam.code,
                                            })
                                        "
                                    >
                                        <span class="qt-btn qt-btn-sm qt-btn-primary">{{ __('Start Exam') }}</span>
                                    </Link>
                                </template>
                            </exam-schedule-card>
                        </template>
                    </div>
                    <div v-else class="mb-6">
                        <empty-student-card :title="'No Schedules Found'" />
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
import ExamCard from '@/Components/Cards/ExamCard'
import ExamScheduleCard from '@/Components/Cards/ExamScheduleCard'
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard'
import SectionHeader from '@/Components/SectionHeader'
import ExamTypeCard from '@/Components/Cards/ExamTypeCard'
import { Swiper, SwiperSlide } from 'swiper/vue'
import { Navigation, FreeMode } from 'swiper/modules'
import 'swiper/css'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    examTypes: Array,
    examSchedules: Array,
    subscription: {
        type: Boolean,
        default: false,
    },
})

const mySwiper = ref(null)
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const modules = [Navigation, FreeMode]
const slidesPerView = 4
const spaceBetween = 10
const breakpoints = {
    1024: { slidesPerView: 4, spaceBetween: 10 },
    768: { slidesPerView: 3, spaceBetween: 10 },
    640: { slidesPerView: 2, spaceBetween: 5 },
    320: { slidesPerView: 2, spaceBetween: 5 },
}

const next = () => {
    if (mySwiper.value?.swiper) mySwiper.value.swiper.slideNext()
}
const prev = () => {
    if (mySwiper.value?.swiper) mySwiper.value.swiper.slidePrev()
}

const showSubscribeModal = () => {
    window.Swal?.fire({
        title: '<strong>' + __('Subscribe to Access') + '</strong>',
        icon: 'warning',
        html: __("You don't have an active plan to see this content. Please subscribe."),
        showCloseButton: true,
        showCancelButton: false,
        focusConfirm: true,
        confirmButtonText: __('See Pricing'),
        confirmButtonAriaLabel: __('See Pricing'),
    }).then(result => {
        if (result.isConfirmed) {
            window.location.assign(route('pricing'))
        }
    })
}

// Expose for template
const examTypes = props.examTypes
const examSchedules = props.examSchedules
const subscription = props.subscription
const title = computed(() => __('Exam Dashboard') + ' - ' + pageProps.general.app_name)
</script>
