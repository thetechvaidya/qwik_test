<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Question Types') }}</h4>
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
                        :globalFilterFields="['code', 'name']"
                        :loading="tableLoading"
                        v-model:filters="filters"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false">
                            <template #body="slotProps">
                                <Tag
                                    :value="slotProps.data.code"
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="handleCopyClick(slotProps.data.code)"
                                />
                            </template>
                            <template #filter="{ filterModel }">
                                <InputText v-model="filterModel.value" type="text" :placeholder="__('Search by code')" />
                            </template>
                        </Column>

                        <Column field="name" :header="__('Name')" :sortable="false">
                            <template #filter="{ filterModel }">
                                <InputText v-model="filterModel.value" type="text" :placeholder="__('Search by name')" />
                            </template>
                        </Column>

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="slotProps">
                                <span
                                    class="text-sm"
                                    :class="[slotProps.data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(slotProps.data.status) }}</span
                                >
                            </template>
                        </Column>
                    </DataTable>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Tag from 'primevue/tag'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'



// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Filters
const filters = ref({
    code: { value: null },
    name: { value: null }
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
    routeName: 'question-types.index',
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
            label: 'Name',
            field: 'name',
            filterOptions: {
                enabled: true,
                placeholder: 'Search by name',
            },
        },
        {
            label: 'Status',
            field: 'status',
            filterOptions: {
                enabled: false,
            },
        },
    ],
})

// Computed
const title = computed(() => {
    return __('Question Types') + ' - ' + pageProps.general.app_name
})

// Methods
const handleCopyClick = code => {
    copyCode(code)
}
</script>
