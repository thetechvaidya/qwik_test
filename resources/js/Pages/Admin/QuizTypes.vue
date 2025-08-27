<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Quiz Types') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Quiz Type') }}
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
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        filterDisplay="row"
                        v-model:filters="filters"
                        :rowsPerPageOptions="[10, 25, 50, 100]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        class="p-datatable-sm"
                    >
                        <Column
                            v-for="col in columns"
                            :key="col.field"
                            :field="col.field"
                            :header="col.label"
                            :sortable="col.sortable"
                            :showFilterMenu="false"
                        >
                            <template #filter="{ filterModel, filterCallback }" v-if="col.filterOptions?.enabled">
                                <InputText
                                    v-if="!col.filterOptions.filterDropdownItems"
                                    v-model="filterModel.value"
                                    type="text"
                                    @keydown.enter="filterCallback()"
                                    :placeholder="col.filterOptions.placeholder"
                                    class="p-column-filter"
                                />
                                <Select
                                    v-else
                                    v-model="filterModel.value"
                                    :options="col.filterOptions.filterDropdownItems"
                                    optionLabel="text"
                                    optionValue="value"
                                    :placeholder="col.filterOptions.placeholder"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                />
                            </template>
                            
                            <template #body="slotProps">
                                <!-- Code Column -->
                                <div v-if="slotProps.field === 'code'">
                                    <Tag
                                        :value="slotProps.data.code"
                                        icon="pi pi-copy"
                                        class="w-full p-mr-2 text-sm cursor-pointer"
                                        @click="handleCopyClick(slotProps.data.code)"
                                    />
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="slotProps.field === 'status'">
                                    <span :class="[slotProps.data.status ? 'badge-success' : 'badge-danger', 'badge']">{{ 
                                        slotProps.data.status ? __('Active') : __('In-active')
                                    }}</span>
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="slotProps.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    editForm = true;
                                                    currentId = slotProps.data.id;
                                                    currentRecord = slotProps.data;
                                                "
                                            >
                                                <i class="pi pi-pencil"></i>
                                                {{ __('Edit') }}
                                            </button>
                                            <button class="action-item text-red-600" @click="deleteRecord(slotProps.data.id)">
                                                <i class="pi pi-trash"></i>
                                                {{ __('Delete') }}
                                            </button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Default Column -->
                                <span v-else>{{ slotProps.data[slotProps.field] }}</span>
                            </template>
                        </Column>

                        <template #empty>
                            <div class="text-center py-8">
                                <NoDataTable>
                                    <template #action>
                                        <button class="qt-btn qt-btn-success" @click="createForm = true">
                                            {{ __('New') }} {{ __('Quiz Type') }}
                                        </button>
                                    </template>
                                </NoDataTable>
                            </div>
                        </template>
                    </DataTable>
                </div>
            </div>
        </div>

        <!-- Create Form Drawer -->
        <Drawer v-model:visible="createForm" :header="__('New Quiz Type')" position="right" class="!w-full md:!w-80">
            <CreateForm @close="createForm = false" />
        </Drawer>

        <!-- Edit Form Drawer -->
        <Drawer
            v-model:visible="editForm"
            :header="__('Edit Quiz Type')"
            position="right"
            class="!w-full md:!w-80"
        >
            <EditForm :quiz-type="currentRecord" @close="editForm = false" />
        </Drawer>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, onBeforeUnmount } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { FilterMatchMode } from '@primevue/core/api'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'
import CreateForm from '@/Components/Admin/QuizTypes/CreateForm.vue'
import EditForm from '@/Components/Admin/QuizTypes/EditForm.vue'

// Props
const props = defineProps({
    quizTypes: {
        type: Object,
        required: true,
    },
    errors: {
        type: Object,
        default: () => ({}),
    },
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Initialize filters for DataTable
const filters = ref({
    name: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})
// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['quizTypes'],
    routeName: 'admin.quiz-types.index',
    columns: [
        {
            label: __('Code'),
            field: 'code',
            sortable: true,
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by code'),
                filterValue: null,
                trigger: 'enter',
            },
        },
        {
            label: __('Name'),
            field: 'name',
            sortable: true,
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by name'),
                filterValue: null,
                trigger: 'enter',
            },
        },
        {
            label: __('Status'),
            field: 'status',
            sortable: true,
            filterOptions: {
                enabled: true,
                filterDropdownItems: [
                    { value: true, text: __('Active') },
                    { value: false, text: __('In-active') },
                ],
                placeholder: __('Filter by status'),
                filterValue: null,
            },
        },
        {
            label: __('Actions'),
            field: 'actions',
            sortable: false,
        },
    ],
})

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)
const currentRecord = ref({})

// Computed
const title = computed(() => {
    return __('Quiz Types') + ' - ' + pageProps.general.app_name
})

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Quiz type code copied to clipboard!'))
}

const deleteRecord = id => {
    confirm.require({
        message: __('Are you sure you want to delete this quiz type?'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.quiz-types.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Quiz type deleted successfully'),
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

// Cleanup on component unmount to prevent DOM manipulation errors
onBeforeUnmount(() => {
    createForm.value = false
    editForm.value = false
    currentId.value = null
    currentRecord.value = {}
    
    // Reset filters
    filters.value = {
        name: { value: null, matchMode: FilterMatchMode.CONTAINS },
        status: { value: null, matchMode: FilterMatchMode.EQUALS }
    }
    
    // Close any pending confirmation dialogs
    if (window.PrimeVue && window.PrimeVue.confirmDialog) {
        window.PrimeVue.confirmDialog.close()
    }
})
</script>
