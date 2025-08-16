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
                    <vue-good-table
                        mode="remote"
                        :search-options="tableParams.search"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="exams.meta.pagination.total"
                        :rows="exams.data"
                        @on-page-change="onPageChange"
                        :rtl="$page.props.rtl"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                        @on-sort-change="onSortChange"
                        @on-search="onSearch"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag
                                    severity="info"
                                    class="w-full mr-2 mb-2 text-xs cursor-pointer"
                                    @click="copyCode(props.row.code)"
                                >
                                    <i class="pi pi-copy mr-2" />
                                    {{ props.row.code }}
                                </Tag>
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    :class="[
                                        props.row.status === 'Published' ? 'badge-success' : 'badge-danger',
                                        'badge',
                                    ]"
                                    >{{ __(props.row.status) }}</span
                                >
                            </div>

                            <!-- Actions Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button class="action-item" @click="goToAnalytics(props.row.id)">{{
                                            __('Analytics')
                                        }}</button>
                                        <button class="action-item" @click="goToSchedules(props.row.id)">{{
                                            __('Schedules')
                                        }}</button>
                                        <button class="action-item" @click="editExam(props.row.id)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteExam(props.row.id)">{{
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
                            <NoDataTable>
                                <template #action>
                                    <Link :href="route('exams.create')" class="qt-btn-sm qt-btn-primary">
                                        {{ __('Create') }}
                                    </Link>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>
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
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import Tag from 'primevue/tag'
// Removed unused Button import
import { useConfirmToast } from '@/composables/useConfirmToast'
import NoDataTable from '@/Components/NoDataTable.vue'
import { codeColumn, textFilterColumn, dropdownFilterColumn, statusColumn } from '@/tables/columns'

const props = defineProps({
    examTypes: Array,
    exams: Object,
    statusFilters: Array,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Define columns first
const columns = reactive([
    codeColumn(__, { width: '11rem', trigger: 'enter' }),
    textFilterColumn(__, { label: 'Title', field: 'title', placeholderLabel: 'Title', trigger: 'enter' }),
    textFilterColumn(__, { label: 'Category', field: 'category', placeholderLabel: 'Category', trigger: 'enter' }),
    dropdownFilterColumn(__, {
        label: 'Type',
        field: 'examType',
        items: props.examTypes.map(t => ({ value: t.id || t.value, text: t.name || t.text })),
        filterKey: 'exam_type_id',
    }),
    { label: __('Sections'), field: 'sections', sortable: false },
    dropdownFilterColumn(__, {
        label: 'Visibility',
        field: 'is_private',
        items: [
            { value: 1, text: __('Private') },
            { value: 0, text: __('Public') },
        ],
    }),
    dropdownFilterColumn(__, {
        label: 'Status',
        field: 'status',
        items: [
            { value: 'Published', text: __('Published') },
            { value: 'Draft', text: __('Draft') },
        ],
    }),
    { label: __('Actions'), field: 'actions', sortable: false, width: '200px', tdClass: 'text-center' },
])

// Server table configuration
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange, onSearch, tableParams, serverParams, loadItems } =
    useServerTable({
        page: props.exams.meta.pagination.current_page,
        perPage: props.exams.meta.pagination.per_page,
        columns: columns,
        routeName: 'exams.index',
        resourceKeys: ['exams', 'examTypes', 'statusFilters'],
        labels: {
            pagination: {
                firstLabel: __('First'),
                lastLabel: __('Last'),
                nextLabel: __('Next'),
                prevLabel: __('Prev'),
            },
            search: { placeholder: __('Search') + ' ' + __('records') + '...' },
        },
        searchDebounceMs: 0, // Align with trigger 'enter'
        searchTrigger: 'enter',
        paramMap: {
            page: 'page',
            perPage: 'per_page',
            search: 'search',
            sortBy: 'sortBy',
            sortOrder: 'sortOrder',
            filterPrefix: '',
        },
        onError: (_, message) =>
            toast({
                severity: 'error',
                summary: __('Error'),
                detail: message || __('Failed to load data'),
                life: 3000,
            }),
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
