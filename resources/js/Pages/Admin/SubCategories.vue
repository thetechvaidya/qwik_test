<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Sub Categories') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Sub Category') }}
            </button>
        </template>

        <div class="container mx-auto py-10 px-4 sm:px-6 lg:px-8">
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
                        :globalFilterFields="['name', 'code']"
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
                                    @input="filterCallback()"
                                    :placeholder="__('Search by Code')"
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="name" :header="__('Name')" :sortable="false" filterField="name">
                            <template #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="__('Search by Name')"
                                    class="p-column-filter"
                                />
                            </template>
                        </Column>

                        <Column field="category" :header="__('Category')" :sortable="false">
                            <template #body="{ data }">
                                {{ data.category ? data.category.name : '' }}
                            </template>
                        </Column>

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="{ data }">
                                <span :class="[data.status ? 'badge-success' : 'badge-danger', 'badge']">{{ 
                                    data.status ? __('Active') : __('In-active')
                                }}</span>
                            </template>
                        </Column>

                        <Column field="actions" :header="__('Actions')" :sortable="false">
                            <template #body="{ data }">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button
                                            class="action-item"
                                            @click="
                                                mapForm = true;
                                                currentId = data.id;
                                            "
                                            >{{ __('Map Sections') }}</button
                                        >
                                        <button
                                            class="action-item"
                                            @click="
                                                editForm = true;
                                                currentId = data.id;
                                            "
                                            >{{ __('Edit') }}</button
                                        >
                                        <button class="action-item" @click="deleteSubCategory(data.id)">{{ 
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Sub Category') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Create and Edit Sidebar Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <SubCategoryForm
                            :categories="categories"
                            :types="types"
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Sub Category')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <SubCategoryForm
                            v-model:edit-flag="editForm"
                            :categories="categories"
                            :types="types"
                            :sub-category-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Sub Category')"
                            @close="editForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="mapForm" position="right" class="p-drawer-md">
                        <SectionMapForm
                            :sub-category-id="currentId"
                            :form-errors="errors"
                            :title="__('Map Sections')"
                            @close="mapForm = false"
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
import SubCategoryForm from '@/Components/Forms/SubCategoryForm.vue'
import SectionMapForm from '@/Components/Forms/SectionMapForm.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

const props = defineProps({
    categories: Array,
    types: Array,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// State
const createForm = ref(false)
const editForm = ref(false)
const mapForm = ref(false)
const currentId = ref(null)

// Filters
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    name: { value: null, matchMode: FilterMatchMode.CONTAINS }
})

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['subCategories'],
    routeName: 'sub-categories.index',
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
            label: __('Name'),
            field: 'name',
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('Name'),
                filterValue: null,
                trigger: 'enter',
            },
            sortable: false,
        },
        {
            label: __('Category'),
            field: 'category',
            sortable: false,
        },
        {
            label: __('Type'),
            field: 'type',
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
                    { value: 1, text: __('Active') },
                    { value: 0, text: __('In-active') },
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
    return __('Sub Categories') + ' - ' + pageProps.general.app_name
})

const deleteSubCategory = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('sub-categories.destroy', { sub_category: id }), {
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
    mapForm.value = false
    currentId.value = null
    
    // Reset filters
    filters.value = {
        code: { value: null, matchMode: FilterMatchMode.CONTAINS },
        name: { value: null, matchMode: FilterMatchMode.CONTAINS }
    }
    
    // Cancel any pending confirmation dialogs
    if (window.$confirm && window.$confirm.close) {
        window.$confirm.close()
    }
})
</script>
