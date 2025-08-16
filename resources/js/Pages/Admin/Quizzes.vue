<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Quizzes') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('quizzes.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Quiz') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :search-options="tableParams.search"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="quizzes.meta.pagination.total"
                        :rows="quizzes.data"
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
                                    class="w-full p-mr-2 mb-2 text-xs cursor-pointer"
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
                                        <button class="action-item" @click="editQuiz(props.row.id)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteQuiz(props.row.id)">{{
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
                                    <Link :href="route('quizzes.create')" class="qt-btn-sm qt-btn-primary">
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
import { computed, reactive, ref } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import { codeColumn, textFilterColumn, dropdownFilterColumn } from '@/tables/columns'

const props = defineProps({
    quizzes: Object,
    quizTypes: Array,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Define columns using shared helpers
const columns = reactive([
    codeColumn(__, { width: '11rem', trigger: 'enter' }),
    textFilterColumn(__, { label: 'Title', field: 'title', placeholderLabel: 'Title', trigger: 'enter' }),
    textFilterColumn(__, { label: 'Category', field: 'category', placeholderLabel: 'Category', trigger: 'enter' }),
    dropdownFilterColumn(__, {
        label: 'Type',
        field: 'quizType',
        items: (props.quizTypes || []).map(t => ({ value: t.id || t.value, text: t.name || t.text })),
    }),
    { label: __('Questions'), field: 'questions', sortable: false },
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
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange, onSearch, tableParams, loadItems } =
    useServerTable({
        page: props.quizzes.meta.pagination.current_page,
        perPage: props.quizzes.meta.pagination.per_page,
        columns,
        resourceKeys: ['quizzes'],
        routeName: 'quizzes.index',
        labels: {
            pagination: {
                firstLabel: __('First'),
                lastLabel: __('Last'),
                nextLabel: __('Next'),
                prevLabel: __('Prev'),
            },
            search: { placeholder: __('Search') + ' ' + __('records') + '...' },
        },
        searchDebounceMs: 0,
        searchTrigger: 'enter',
        paramMap: {
            page: 'page',
            perPage: 'perPage',
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
    return __('Quizzes') + ' - ' + pageProps.general.app_name
})

const editQuiz = id => {
    router.get(route('quizzes.edit', { quiz: id }))
}

const goToSchedules = id => {
    router.get(route('quizzes.schedules.index', { quiz: id }))
}

const goToAnalytics = id => {
    router.get(route('quizzes.overall_report', { quiz: id }))
}

const deleteQuiz = async id => {
    // Align with useConfirmToast pattern
    if (!window.$confirm || !window.$toast) {
        // Fallback simple confirm
        const ok = window.confirm(__('This will remove all the user sessions. Do you want to delete this quiz?'))
        if (!ok) return
    } else {
        const ok = await new Promise(resolve => {
            window.$confirm.require({
                header: __('Confirm Delete'),
                message: __('This will remove all the user sessions. Do you want to delete this quiz?'),
                icon: 'pi pi-info-circle',
                acceptClass: 'p-button-danger',
                rejectLabel: __('Cancel'),
                acceptLabel: __('Delete'),
                accept: () => resolve(true),
                reject: () => resolve(false),
            })
        })
        if (!ok) return
    }
    router.delete(route('quizzes.destroy', { quiz: id }), {
        onSuccess: () => {
            if (window.$toast) {
                window.$toast.add({
                    severity: 'info',
                    summary: __('Confirmed'),
                    detail: __('Record deleted'),
                    life: 3000,
                })
            }
            loadItems()
        },
    })
}
</script>
