<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Categories') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Category') }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="data"
                        dataKey="id"
                        lazy
                        paginator
                        :rows="10"
                        :totalRecords="totalRecords"
                        :rowsPerPageOptions="[10, 20, 50]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        sortMode="single"
                        filterDisplay="row"
                        v-model:filters="filters"
                        :globalFilterFields="['code', 'name', 'status']"
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        :class="{ 'rtl': $page.props.rtl }"
                    >
                        <Column v-for="column in columns" :key="column.field" :field="column.field" :header="column.label" :sortable="column.sortable" :filterField="column.filterKey">
                            <template #filter="{ filterModel, filterCallback }" v-if="column.filterKey">
                                <InputText v-model="filterModel.value" @input="filterCallback()" placeholder="Search..." />
                            </template>
                            <template #body="slotProps">
                                <!-- Code Column -->
                                <div v-if="column.field === 'code'">
                                    <Tag
                                        :key="slotProps.data.id || slotProps.index"
                                        :value="slotProps.data.code"
                                        icon="pi pi-copy"
                                        class="w-full p-mr-2 text-sm cursor-pointer"
                                        @click="copyCode(slotProps.data.code)"
                                    ></Tag>
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="column.field === 'status'">
                                    <span
                                        :class="[slotProps.data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                        >{{ __(slotProps.data.status) }}</span
                                    >
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="column.field === 'actions'">
                                    <ActionsDropdown :key="slotProps.data.id || slotProps.index">
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    editForm = true;
                                                    currentId = slotProps.data.id;
                                                "
                                                >{{ __('Edit') }}</button
                                            >
                                            <button class="action-item" @click="deleteCategory(slotProps.data.id)">{{ __('Delete') }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Remaining Columns -->
                                <span v-else>
                                    {{ slotProps.data[column.field] }}
                                </span>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Category') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <CategoryForm
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Category')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <CategoryForm
                            :edit-flag="editForm"
                            :category-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Category')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed, onBeforeUnmount } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Button from 'primevue/button'
import Drawer from 'primevue/drawer'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import CategoryForm from '@/Components/Forms/CategoryForm'
import Chip from 'primevue/chip'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable'
import ActionsDropdown from '@/Components/ActionsDropdown'

const props = defineProps({
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Reactive state
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Filters
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    name: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['categories'],
    routeName: 'categories.index',
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
    ],
})

// Computed properties
const title = computed(() => {
    return __('Categories') + ' - ' + pageProps.general.app_name
})

// Methods
const deleteCategory = id => {
    if (window.$confirm && window.$confirm.require) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('categories.destroy', { category: id }), {
                    onSuccess: () => {
                        if (window.$toast && window.$toast.add) {
                            window.$toast.add({
                                severity: 'info',
                                summary: __('Confirmed'),
                                detail: __('Record deleted'),
                                life: 3000,
                            })
                        }
                    },
                    onError: () => {
                        if (window.$toast && window.$toast.add) {
                            window.$toast.add({
                                severity: 'error',
                                summary: __('Error'),
                                detail: __('Failed to delete category'),
                                life: 3000,
                            })
                        }
                    },
                })
            },
            reject: () => {
                // User cancelled
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
    
    // Cancel any pending confirmation dialogs
    if (window.$confirm && window.$confirm.close) {
        window.$confirm.close()
    }
})
</script>
