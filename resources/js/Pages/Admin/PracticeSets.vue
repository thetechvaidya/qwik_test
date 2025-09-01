<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Practice Sets') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('admin.practice-sets.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Practice Set') }}
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
                        :globalFilterFields="['code', 'title', 'category']"
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false" filterField="code">
                            <template #body="{ data, index }">
                                <Tag
                                    :key="data.id || index"
                                    severity="info"
                                    :value="data.code"
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 mb-2 text-xs cursor-pointer"
                                    @click="handleCopyClick(data.code)"
                                />
                            </template>
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="__('Search by Code')"
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="title" :header="__('Title')" :sortable="false" filterField="title">
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="__('Search by Title')"
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="category" :header="__('Category')" :sortable="false" filterField="category">
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="__('Search by Category')"
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="{ data }">
                                <span :class="[data.status ? 'badge-success' : 'badge-danger', 'badge']">
                                    {{ data.status ? __('Published') : __('Draft') }}
                                </span>
                            </template>
                        </Column>

                        <Column field="actions" :header="__('Actions')" :sortable="false">
                            <template #body="{ data, index }">
                                <ActionsDropdown :key="data.id || index">
                                    <template #actions>
                                        <button class="action-item" @click="goToAnalytics(data.id)">{{ 
                                            __('Analytics')
                                        }}</button>
                                        <button class="action-item" @click="editPracticeSet(data.id)">{{ 
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deletePracticeSet(data.id)">{{ 
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <Link :href="route('admin.practice-sets.create')" class="qt-btn-sm qt-btn-primary">
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
import { ref, computed } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { FilterMatchMode } from '@primevue/core/api'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Tag from 'primevue/tag'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'



// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
    category: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.CONTAINS }
})
// Server table configuration
const {
    data,
    columns,
    totalRecords,
    tableLoading,
    onPage,
    onSort,
    onFilter,
} = useServerTable({
    resourceKeys: ['practiceSets'],
    routeName: 'admin.practice-sets.index',
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
                enabled: true,
                placeholder: 'Search by category',
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

// Computed
const title = computed(() => {
    return __('Practice Sets') + ' - ' + pageProps.general.app_name
})

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Practice set code copied to clipboard!'))
}

const goToAnalytics = id => {
    router.visit(route('admin.practice-sets.analytics', id))
}

const editPracticeSet = id => {
    router.visit(route('admin.practice-sets.edit', id))
}

const deletePracticeSet = id => {
    confirm.require({
        message: __(
            'Are you sure you want to delete this practice set? This action will permanently remove all associated questions and sessions.'
        ),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.practice-sets.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Practice set deleted successfully'),
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
        },
    })
}
</script>
