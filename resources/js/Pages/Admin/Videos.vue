<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Videos') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('videos.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Video') }}
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

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="{ data }">
                                <span
                                    :class="[data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(data.status) }}</span
                                >
                            </template>
                        </Column>

                        <Column field="actions" :header="__('Actions')" :sortable="false">
                            <template #body="{ data, index }">
                                <ActionsDropdown :key="data.id || index">
                                    <template #actions>
                                        <button class="action-item" @click="editVideo(data.id)">{{ 
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteVideo(data.id)">{{ 
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
import { computed, ref, onBeforeUnmount } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'



const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
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
    deleteVideo: deleteServerVideo,
} = useServerTable(route('videos.index'), {
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
    return __('Videos') + ' - ' + pageProps.general.app_name
})

const editVideo = id => {
    router.get(route('videos.edit', { video: id }))
}

const deleteVideo = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('videos.destroy', { video: id }), {
                    onSuccess: () => {
                        if (window.$toast) {
                            window.$toast.add({
                                severity: 'info',
                                summary: __('Confirmed'),
                                detail: __('Record deleted'),
                                life: 3000,
                            })
                        }
                    },
                })
            },
            reject: () => {
                // Do nothing on reject
            },
        })
    }
}

// Cleanup on component unmount to prevent DOM manipulation errors
onBeforeUnmount(() => {
    // Reset filters
    filters.value = {
        code: { value: null, matchMode: FilterMatchMode.CONTAINS },
        title: { value: null, matchMode: FilterMatchMode.CONTAINS },
        status: { value: null, matchMode: FilterMatchMode.CONTAINS }
    }
    
    // Close any pending confirmation dialogs
    if (window.PrimeVue && window.PrimeVue.confirmDialog) {
        window.PrimeVue.confirmDialog.close()
    }
})
</script>
