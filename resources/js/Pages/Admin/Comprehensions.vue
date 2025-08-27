<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Comprehensions') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Comprehension') }}
            </button>
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
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column field="code" :header="__('Code')" :sortable="false" filterField="code">
                            <template #body="{ data }">
                                <Tag
                                    :value="data.code"
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="copyCode(data.code)"
                                />
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

                        <Column field="body" :header="__('Body')" :sortable="false">
                            <template #body="{ data }">
                                <div v-html="data.body"></div>
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
                            <template #body="{ data }">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button
                                            class="action-item"
                                            @click="
                                editForm = true;
                                currentId = data.id;
                            "
                                            >{{ __('Edit') }}</button
                                        >
                                        <button class="action-item" @click="deleteComprehension(data.id)">{{ 
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

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <ComprehensionForm
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Comprehension')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <ComprehensionForm
                            v-model:edit-flag="editForm"
                            :comprehension-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Comprehension')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref, onBeforeUnmount } from 'vue'
import { Head, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import ComprehensionForm from '@/Components/Forms/ComprehensionForm'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import ActionsDropdown from '@/Components/ActionsDropdown'
import NoDataTable from '@/Components/NoDataTable.vue'

const props = defineProps({
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    title: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.CONTAINS }
})

// State
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['comprehensions'],
    routeName: 'comprehensions.index',
    columns: [
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
        },
        {
            label: __('Body'),
            field: 'body',
            sortable: false,
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
                    { value: 1, text: __('Published') },
                    { value: 0, text: __('Draft') },
                ],
            },
        },
        {
            label: __('Actions'),
            field: 'actions',
            sortable: false,
        },
    ],
})

const title = computed(() => {
    return __('Comprehensions') + ' - ' + pageProps.general.app_name
})

const deleteComprehension = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('comprehensions.destroy', { comprehension: id }), {
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
    // Reset reactive state
    createForm.value = false
    editForm.value = false
    currentId.value = null
    
    // Reset filters
    filters.value = {
        code: { value: null, matchMode: FilterMatchMode.CONTAINS },
        title: { value: null, matchMode: FilterMatchMode.CONTAINS },
        status: { value: null, matchMode: FilterMatchMode.CONTAINS }
    }
    
    // Cancel any pending confirmation dialogs
    if (window.$confirm && window.$confirm.close) {
        window.$confirm.close()
    }
})
</script>
