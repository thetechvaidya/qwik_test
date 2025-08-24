<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ practiceSet.title }} - {{ __('Detailed Report') }}</h4>
        </template>
        <template #actions>
            <a
                :href="route('practice-sets.export_report', { practice_set: practiceSet.id })"
                target="_blank"
                class="qt-btn qt-btn-primary"
            >
                {{ __('Download Report') }}
            </a>
            <Link
                :href="route('practice-sets.overall_report', { practice_set: practiceSet.id })"
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
                                            slotProps.data.status === 'Completed' ? 'badge-success' : 'badge-warning',
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
                                                    :href="route('practice_session_results', {practice_set: slotProps.data.slug, session: slotProps.data.id})"
                                                    class="action-item"
                                                    >{{ __('View Performance') }}</Link
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
    practiceSet: Object,
    schedule: Object,
    practiceSetSessions: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { confirm, toast } = useConfirmToast()

// Computed
const title = computed(() => {
    return __('Practice Set/ Detailed Report') + ' - ' + pageProps.general.app_name
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
    resourceKeys: ['practiceSetSessions'],
    routeName: 'practice-sets.detailed_report',
    routeParams: { practice_set: props.practiceSet.id, ...(props.schedule ? { schedule: props.schedule.id } : {}) },
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
                { label: __('Completed'), value: 'Completed' },
                { label: __('In Progress'), value: 'In Progress' },
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
            router.delete(route('practice_set_sessions.destroy', sessionId), {
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
                        detail: __('Session deleted successfully'),
                        life: 3000,
                    })
                },
            })
        },
    })
}
</script>
