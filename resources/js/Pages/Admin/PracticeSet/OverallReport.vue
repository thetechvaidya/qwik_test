<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Practice Set Report') }}</h4>
        </template>
        <template #actions>
            <Link
                :href="route('practice-sets.detailed_report', { practice_set: practiceSet.id })"
                class="qt-btn qt-btn-success"
            >
                {{ __('Detailed Report') }}
            </Link>
        </template>

        <div class="py-8">
            <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
                <div class="bg-white shadow rounded-lg w-full overflow-hidden">
                    <div class="grid sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
                        <admin-test-stat-card
                            :title="__('Total Attempts')"
                            :count="stats.total_attempts"
                        ></admin-test-stat-card>
                        <admin-test-stat-card
                            :title="__('Unique Attempt')"
                            :count="stats.unique_test_takers"
                        ></admin-test-stat-card>
                        <admin-test-stat-card
                            :title="__('Avg. Time Spent')"
                            :count="stats.avg_time.detailed_readable"
                        ></admin-test-stat-card>
                        <admin-test-stat-card :title="__('Avg. Score')" :count="stats.avg_score"></admin-test-stat-card>
                        <admin-test-stat-card
                            :title="__('High Score')"
                            :count="stats.high_score"
                        ></admin-test-stat-card>
                        <admin-test-stat-card :title="__('Low Score')" :count="stats.low_score"></admin-test-stat-card>
                        <admin-test-stat-card
                            :title="__('Avg. Accuracy')"
                            :count="stats.avg_accuracy"
                        ></admin-test-stat-card>
                        <admin-test-stat-card :title="__('Avg. Speed')" :count="stats.avg_speed"></admin-test-stat-card>
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

// Props
const props = defineProps({
    // Add report data props
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Practice Set/ Overall Report') + ' - ' + pageProps.general.app_name
})

// Initialize any chart or data visualization
onMounted(() => {
    // Add initialization logic
})
</script>
