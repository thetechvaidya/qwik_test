<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Lessons') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('lessons.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Lesson') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="data"
                        dataKey="id"
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
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false" filterField="code">
                            <template #body="{ data, index }">
                                <Tag
                                    :key="data.id || index"
                                    :value="data.code"
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="copyCode(data.code)"
                                >
                                    <i class="pi pi-copy mr-2" />{{ data.code }}
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

                        <Column field="title" :header="__('Title')" :sortable="false" filterField="title">
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

                        <Column field="status" :header="__('Status')" :sortable="false" filterField="status">
                            <template #body="{ data }">
                                <span
                                    :class="[data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(data.status) }}</span
                                >
                            </template>
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @keydown.enter="filterCallback()"
                                    placeholder="Search Status..."
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="actions" :header="__('Actions')" :sortable="false">
                            <template #body="{ data, index }">
                                <ActionsDropdown :key="data.id || index">
                                    <template #actions>
                                        <button class="action-item" @click="editLesson(data.id)">{{ 
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteLesson(data.id)">{{ 
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable />
                        </template>
                    </DataTable>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { useMathRender } from '@/composables/useMathRender'

// Props
const props = defineProps({})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.CONTAINS }
})
const { confirm, toast } = useConfirmToast()
const { renderMath } = useMathRender()

// Table configuration
const columns = [
    {
        label: __('Code'),
        field: 'code',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Code'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Title'),
        field: 'title',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Title'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Section'),
        field: 'section',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Section'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Skill'),
        field: 'skill',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Skill'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Topic'),
        field: 'topic',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Topic'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Status'),
            filterValue: null,
            filterDropdownItems: [
                { value: 1, text: __('Active') },
                { value: 0, text: __('In-active') },
            ],
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '200px',
        tdClass: 'text-center',
    },
]

const options = reactive({
    enabled: true,
    mode: 'pages',
    perPage: props.lessons.meta.pagination.per_page,
    setCurrentPage: props.lessons.meta.pagination.current_page,
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})

// Server table composable
const {
    data,
    columns: serverColumns,
    totalRecords,
    tableLoading,
    onPage,
    onSort,
    onFilter,
    deleteLesson: deleteServerLesson,
} = useServerTable(route('lessons.index'), {
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
    onSuccess: () => {
        renderMath()
    },
})

// Computed
const title = computed(() => {
    return __('Lessons') + ' - ' + pageProps.general.app_name
})

// Methods
const editLesson = id => {
    router.get(route('lessons.edit', { lesson: id }))
}

const deleteLesson = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('lessons.destroy', { lesson: id }), {
            onSuccess: () => {
                toast({
                    severity: 'info',
                    summary: __('Confirmed'),
                    detail: __('Record deleted'),
                    life: 3000,
                })
            },
            onError: () => {
                toast({
                    severity: 'error',
                    summary: __('Error'),
                    detail: __('Something went wrong'),
                    life: 3000,
                })
            },
        })
    }
}

// Initialize math rendering
onMounted(() => {
    renderMath()
})
</script>
