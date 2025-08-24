<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading"
                >{{ exam.title }} - {{ schedule !== null ? 'Schedule' : '' }} {{ __('Detailed Report') }}</h4
            >
            <div v-if="schedule !== null" class="text-xs">{{ __('Schedule') }} ID: {{ schedule.code }}</div>
        </template>
        <template #actions>
            <a
                v-if="schedule !== null"
                :href="route('exams.export_report', { exam: exam.id, schedule: schedule.id })"
                target="_blank"
                class="qt-btn qt-btn-primary"
            >
                {{ __('Download Report') }}
            </a>
            <a
                v-else
                :href="route('exams.export_report', { exam: exam.id })"
                target="_blank"
                class="qt-btn qt-btn-primary"
            >
                {{ __('Download Report') }}
            </a>
            <Link
                v-if="schedule !== null"
                :href="route('exams.overall_report', { exam: exam.id, schedule: schedule.id })"
                class="ltr:ml-2 rtl:mr-2 qt-btn qt-btn-success"
            >
                {{ __('Overall Report') }}
            </Link>
            <Link
                v-else
                :href="route('exams.overall_report', { exam: exam.id })"
                class="ltr:ml-2 rtl:mr-2 qt-btn qt-btn-success"
            >
                {{ __('Overall Report') }}
            </Link>
        </template>

        <div class="py-8">
            <div class="container mx-auto px-4 sm:px-6 lg:px-8">
                <div class="card">
                    <div class="card-body">
                        <DataTable
                            :value="data"
                            :totalRecords="totalRecords"
                            :loading="tableLoading"
                            lazy
                            paginator
                            :rows="10"
                            :rowsPerPageOptions="[10, 20, 50, 100]"
                            paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                            currentPageReportTemplate="{first} to {last} of {totalRecords}"
                            @page="onPage"
                            @sort="onSort"
                            @filter="onFilter"
                            filterDisplay="row"
                            :globalFilterFields="['user.name']"
                        >
                            <Column
                                v-for="col in columns"
                                :key="col.field"
                                :field="col.field"
                                :header="col.header"
                                :sortable="col.sortable"
                                :showFilterMenu="false"
                            >
                                <template v-if="col.filterable" #filter="{ filterModel, filterCallback }">
                                    <InputText
                                        v-if="col.filterType === 'text'"
                                        v-model="filterModel.value"
                                        type="text"
                                        @input="filterCallback()"
                                        class="p-column-filter"
                                        :placeholder="`Search ${col.header}`"
                                    />
                                    <Select
                        v-else-if="col.filterType === 'dropdown'"
                        v-model="filterModel.value"
                        :options="col.filterOptions"
                        optionLabel="label"
                        optionValue="value"
                        @change="filterCallback()"
                        :placeholder="`Select ${col.header}`"
                        :showClear="true"
                    />
                                </template>

                                <template #body="slotProps" v-if="col.field === 'status'">
                                    <span
                                        :class="[
                                            slotProps.data.status === 'Passed' ? 'badge-success' : 'badge-danger',
                                            'badge-sm uppercase text-xs',
                                        ]"
                                        >{{ __(slotProps.data.status) }}</span
                                    >
                                </template>

                                <template #body="slotProps" v-else-if="col.field === 'actions'">
                                    <div class="py-2">
                                        <ActionsDropdown>
                                            <template #actions>
                                                <Link
                                                    :href="route('exam_session_results', {exam: slotProps.data.slug, session: slotProps.data.id})"
                                                    class="action-item"
                                                    >{{ __('Results') }}</Link
                                                >
                                                <button class="action-item" @click="deleteSession(slotProps.data.id)">{{ __('Delete') }}</button>
                                            </template>
                                        </ActionsDropdown>
                                    </div>
                                </template>
                            </Column>

                            <template #empty>
                                <NoDataTable></NoDataTable>
                            </template>
                        </DataTable>
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
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

// Props
const props = defineProps({
    exam: Object,
    schedule: Object,
    examSessions: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { confirm, toast } = useConfirmToast()

// Computed
const title = computed(() => {
    return __('Exam/ Detailed Report') + ' - ' + pageProps.general.app_name
})

// Server table composable
const {
    data,
    columns,
    totalRecords,
    tableLoading,
    onPage,
    onSort,
    onFilter,
} = useServerTable({
    resourceKeys: ['examSessions'],
    routeName: 'exams.detailed_report',
    routeParams: { exam: props.exam.id, ...(props.schedule ? { schedule: props.schedule.id } : {}) },
    columns: [
        {
            field: 'user.name',
            header: __('User'),
            sortable: true,
            filterable: true,
            filterType: 'text',
        },
        {
            field: 'started_at',
            header: __('Started At'),
            sortable: true,
        },
        {
            field: 'completed_at',
            header: __('Completed At'),
            sortable: true,
        },
        {
            field: 'total_time_taken',
            header: __('Time Taken'),
            sortable: true,
        },
        {
            field: 'total_marks',
            header: __('Total Marks'),
            sortable: true,
        },
        {
            field: 'status',
            header: __('Status'),
            sortable: true,
            filterable: true,
            filterType: 'dropdown',
            filterOptions: [
                { label: __('Passed'), value: 'Passed' },
                { label: __('Failed'), value: 'Failed' },
            ],
        },
        {
            field: 'actions',
            header: __('Actions'),
            sortable: false,
        },
    ],
})

// Methods
const deleteSession = (sessionId) => {
    confirm({
        message: __('Are you sure you want to delete this session?'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        accept: () => {
            router.delete(route('exam_sessions.destroy', sessionId), {
                onSuccess: () => {
                    toast.add({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Session deleted successfully'),
                        life: 3000,
                    })
                },
                onError: () => {
                    toast.add({
                        severity: 'error',
                        summary: __('Error'),
                        detail: __('Failed to delete session'),
                        life: 3000,
                    })
                },
            })
        },
    })
}
</script>
