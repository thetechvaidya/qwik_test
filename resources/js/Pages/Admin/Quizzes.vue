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
                    <DataTable
                        :value="quizzes.data"
                        :lazy="true"
                        :paginator="true"
                        :rows="quizzes.meta.pagination.per_page"
                        :totalRecords="quizzes.meta.pagination.total"
                        :rowsPerPageOptions="[10, 20, 50, 100]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        sortMode="single"
                        filterDisplay="row"
                        :globalFilterFields="['code', 'title']"
                        :loading="tableLoading"
                        v-model:filters="filters"
                        dataKey="id"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false" filterField="code">
                            <template #body="{ data, index }">
                                <Tag
                                    :key="`code-${data.id || index}`"
                                    class="w-full p-mr-2 mb-2 text-xs cursor-pointer"
                                    @click="copyCode(data.code)"
                                >
                                    <i class="pi pi-copy mr-2" />
                                    {{ data.code }}
                                </Tag>
                            </template>
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @keydown.enter="filterCallback()"
                                    placeholder="Search Code..."
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="title" :header="__('Title')" :sortable="true" filterField="title">
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @keydown.enter="filterCallback()"
                                    placeholder="Search Title..."
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="category" :header="__('Category')" :sortable="false" filterField="category">
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @keydown.enter="filterCallback()"
                                    placeholder="Search Category..."
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="quizType" :header="__('Type')" :sortable="false" filterField="quizType">
                            <template #filter="{ filterModel, filterCallback }">
                                <Select
                                    v-model="filterModel.value"
                                    :options="(props.quizTypes || []).map(t => ({ value: t.id || t.value, text: t.name || t.text }))"
                                    optionLabel="text"
                                    optionValue="value"
                                    placeholder="Select Type"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                />
                            </template>
                        </Column>

                        <Column field="questions" :header="__('Questions')" :sortable="false">
                        </Column>

                        <Column field="status" :header="__('Status')" :sortable="false" filterField="status">
                            <template #body="{ data }">
                                <span
                                    :class="[
                                        data.status === 'Published' ? 'badge-success' : 'badge-danger',
                                        'badge',
                                    ]"
                                    >{{ __(data.status) }}</span
                                >
                            </template>
                            <template #filter="{ filterModel, filterCallback }">
                                <Select
                                    v-model="filterModel.value"
                                    :options="[
                                        { value: 'Published', text: __('Published') },
                                        { value: 'Draft', text: __('Draft') }
                                    ]"
                                    optionLabel="text"
                                    optionValue="value"
                                    placeholder="Select Status"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                />
                            </template>
                        </Column>

                        <Column :header="__('Actions')" :sortable="false">
                            <template #body="{ data, index }">
                                <ActionsDropdown :key="`actions-${data.id || index}`">
                                    <template #actions>
                                        <button class="action-item" @click="editQuiz(data.id)">{{ __('Edit') }}</button>
                                        <button class="action-item" @click="goToSchedules(data.id)">{{ __('Schedules') }}</button>
                                        <button class="action-item" @click="goToAnalytics(data.id)">{{ __('Analytics') }}</button>
                                        <button class="action-item" @click="deleteQuiz(data.id)">{{ 
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <Link :href="route('quizzes.create')" class="qt-btn-sm qt-btn-primary">
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
import { computed, reactive, ref } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import { codeColumn, textFilterColumn, dropdownFilterColumn, statusColumn } from '@/tables/columns'
import { FilterMatchMode } from '@primevue/core/api'

const props = defineProps({
    quizzes: Object,
    quizTypes: Array,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
    category: { value: null, matchMode: FilterMatchMode.CONTAINS },
    quizType: { value: null, matchMode: FilterMatchMode.EQUALS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})

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
const { onPage, onSort, onFilter, tableLoading, loadItems } =
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
