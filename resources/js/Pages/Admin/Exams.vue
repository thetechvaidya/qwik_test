<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Exams') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('exams.create')" class="qt-btn qt-btn-success"> {{ __('New') }} {{ __('Exam') }} </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="data"
                        :lazy="true"
                        :paginator="true"
                        :rows="10"
                        :totalRecords="totalRecords"
                        :rowsPerPageOptions="[10, 20, 50, 100]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        sortMode="single"
                        filterDisplay="row"
                        v-model:filters="filters"
                        :globalFilterFields="['code', 'title']"
                        :loading="tableLoading"
                        dataKey="id"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false">
                            <template #body="{ data, index }">
                                <Tag
                                    :key="`code-${data.id || index}`"
                                    severity="info"
                                    class="w-full mr-2 mb-2 text-xs cursor-pointer"
                                    @click="copyCode(data.code)"
                                >
                                    <i class="pi pi-copy mr-2" />
                                    {{ data.code }}
                                </Tag>
                            </template>
                            <template #filter="{ filterModel }">
                                <InputText v-model="filterModel.value" type="text" :placeholder="__('Search by code')" />
                            </template>
                        </Column>

                        <Column field="title" :header="__('Title')" :sortable="false">
                            <template #filter="{ filterModel }">
                                <InputText v-model="filterModel.value" type="text" :placeholder="__('Search by title')" />
                            </template>
                        </Column>

                        <Column field="category" :header="__('Category')" :sortable="false"></Column>
                        <Column field="type" :header="__('Type')" :sortable="false"></Column>
                        <Column field="questions" :header="__('Questions')" :sortable="false"></Column>

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="slotProps">
                                <span
                                    :class="[
                                        slotProps.data.status === 'Published' ? 'badge-success' : 'badge-danger',
                                        'badge',
                                    ]"
                                    >{{ __(slotProps.data.status) }}</span
                                >
                            </template>
                        </Column>

                        <Column field="actions" :header="__('Actions')" :sortable="false">
                            <template #body="{ data, index }">
                                <ActionsDropdown :key="`actions-${data.id || index}`">
                                    <template #actions>
                                        <button class="action-item" @click="goToAnalytics(data.id)">{{ __('Analytics') }}</button>
                                        <button class="action-item" @click="goToSchedules(data.id)">{{ __('Schedules') }}</button>
                                        <button class="action-item" @click="editExam(data.id)">{{ __('Edit') }}</button>
                                        <button class="action-item" @click="deleteExam(data.id)">{{ __('Delete') }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <Link :href="route('exams.create')" class="qt-btn-sm qt-btn-primary">
                                        {{ __('Create') }}
                                    </Link>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref, reactive } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import Tag from 'primevue/tag'
// Removed unused Button import
import { useConfirmToast } from '@/composables/useConfirmToast'
import NoDataTable from '@/Components/NoDataTable.vue'
import { codeColumn, textFilterColumn, dropdownFilterColumn, statusColumn } from '@/tables/columns'

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Filters
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})

// Server table configuration
const {
    data,
    columns: tableColumns,
    totalRecords,
    tableLoading,
    onPage,
    onSort,
    onFilter,
    deleteExam: deleteServerExam,
} = useServerTable(route('exams.index'), {
    columns: [
        {
            label: 'Code',
            field: 'code',
            filterOptions: {
                enabled: true,
                placeholder: 'Search by code',
            },
        },
        {
            label: 'Title',
            field: 'title',
            filterOptions: {
                enabled: true,
                placeholder: 'Search by title',
            },
        },
        {
            label: 'Category',
            field: 'category',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: 'Type',
            field: 'type',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: 'Questions',
            field: 'questions',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: 'Status',
            field: 'status',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: 'Actions',
            field: 'actions',
            filterOptions: {
                enabled: false,
            },
        },
    ],
})

const title = computed(() => {
    return __('Exams') + ' - ' + pageProps.general.app_name
})

const editExam = id => {
    router.get(route('exams.edit', { exam: id }))
}

const goToSchedules = id => {
    router.get(route('exams.schedules.index', { exam: id }))
}

const goToAnalytics = id => {
    router.get(route('exams.overall_report', { exam: id }))
}

const deleteExam = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('This will remove all the user sessions. Do you want to delete this exam?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })
    if (!ok) return
    router.delete(route('exams.destroy', { exam: id }), {
        onSuccess: async () => {
            toast({ severity: 'info', summary: __('Confirmed'), detail: __('Record deleted'), life: 3000 })

            // Handle empty page after deletion
            const itemsOnCurrentPage = props.exams.data.length
            const currentPage = serverParams.value.page
            const prevPage = Math.max(1, currentPage - 1)

            if (itemsOnCurrentPage === 1 && currentPage > 1) {
                // Navigate to previous page if current page will be empty
                router.visit(route('admin.exams.index', { ...serverParams.value, page: prevPage }))
            } else {
                // Refresh table data after deletion - preserveState=true maintains filters/pagination
                // Note: Use loadItems(false) if UI artifacts persist after delete operations
                await loadItems()
            }
        },
        onError: () => {
            toast({ severity: 'error', summary: __('Error'), detail: __('Failed to delete exam'), life: 3000 })
        },
    })
}

// Expose loadItems for external table refreshing
defineExpose({
    loadItems,
    refreshTable: loadItems, // Alias for clarity
})
</script>
