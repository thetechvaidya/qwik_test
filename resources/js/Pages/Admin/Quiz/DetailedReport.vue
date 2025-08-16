<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading"
                >{{ quiz.title }} - {{ schedule !== null ? 'Schedule' : '' }} {{ __('Detailed Report') }}</h4
            >
            <div v-if="schedule !== null" class="text-xs">{{ __('Schedule') }} ID: {{ schedule.code }}</div>
        </template>
        <template #actions>
            <a
                v-if="schedule !== null"
                :href="route('quizzes.export_report', { quiz: quiz.id, schedule: schedule.id })"
                target="_blank"
                class="qt-btn qt-btn-primary"
            >
                {{ __('Download Report') }}
            </a>
            <a
                v-else
                :href="route('quizzes.export_report', { quiz: quiz.id })"
                target="_blank"
                class="qt-btn qt-btn-primary"
            >
                {{ __('Download Report') }}
            </a>
            <Link
                v-if="schedule !== null"
                :href="route('quizzes.overall_report', { quiz: quiz.id, schedule: schedule.id })"
                class="ltr:ml-2 rtl:mr-2 qt-btn qt-btn-success"
            >
                {{ __('Overall Report') }}
            </Link>
            <Link
                v-else
                :href="route('quizzes.overall_report', { quiz: quiz.id })"
                class="ltr:ml-2 rtl:mr-2 qt-btn qt-btn-success"
            >
                {{ __('Overall Report') }}
            </Link>
        </template>

        <div class="py-8">
            <div class="container mx-auto px-4 sm:px-6 lg:px-8">
                <div class="card">
                    <div class="card-body">
                        <vue-good-table
mode="remote" :pagination-options="options" :columns="columns" :total-rows="quizSessions.meta.pagination.total"
                                        :rows="quizSessions.data" :rtl="pageProps.rtl"
                            @on-page-change="onPageChange"
                            @on-column-filter="onColumnFilter"
                            @on-per-page-change="onPerPageChange"
                        >
                            <template #table-row="props">
                                <!-- Status Column -->
                                <div v-if="props.column.field === 'status'">
                                    <span
                                        :class="[
                                            props.row.status === 'Passed' ? 'badge-success' : 'badge-danger',
                                            'badge-sm uppercase text-xs',
                                        ]"
                                        >{{ __(props.row.status) }}</span
                                    >
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="props.column.field === 'actions'" class="py-2">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <Link
:href="route('quiz_session_results', {quiz: props.row.slug, session: props.row.id})"
                                                "
                                                class="action-item"
                                                >{{ __('Results') }}</Link
                                            >
                                            <button class="action-item" @click="deleteSession(props.row.id)">{{
                                                __('Delete')
                                            }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Remaining Columns -->
                                <span v-else>
                                    {{ props.formattedRow[props.column.field] }}
                                </span>
                            </template>

                            <template #emptystate>
                                <NoDataTable></NoDataTable>
                            </template>
                        </vue-good-table>
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
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

// Props
const props = defineProps({
    // Add props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Quiz/ Detailed Report') + ' - ' + pageProps.general.app_name
})

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Composables
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Server table composable
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange } = useServerTable({
    resourceKeys: [], // Add appropriate resource keys
    routeName: '', // Add appropriate route name
})

// Table configuration
const columns = []
const options = reactive({
    enabled: true,
    mode: 'pages',
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})
</script>
