<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Exam Types') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New :name', { name: __('Exam Type') }) }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="data"
                        :totalRecords="totalRecords"
                        :loading="tableLoading"
                        lazy
                        paginator
                        :rows="10"
                        :rowsPerPageOptions="[10, 25, 50, 100]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        filterDisplay="row"
                        :globalFilterFields="['code', 'name', 'status']"
                        class="p-datatable-sm"
                    >
                        <Column
                            v-for="col in columns"
                            :key="col.field"
                            :field="col.field"
                            :header="col.header"
                            :sortable="col.sortable"
                            :showFilterMenu="false"
                        >
                            <template #filter="{ filterModel, filterCallback }" v-if="col.filter">
                                <InputText
                                    v-if="col.filter.type === 'text'"
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="col.filter.placeholder"
                                    class="p-column-filter"
                                />
                                <Select
                                    v-else-if="col.filter.type === 'dropdown'"
                                    v-model="filterModel.value"
                                    :options="col.filter.options"
                                    optionLabel="text"
                                    optionValue="value"
                                    :placeholder="col.filter.placeholder"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                >
                                    <template #value="slotProps">
                                        <span v-if="slotProps.value !== null && slotProps.value !== undefined">
                                            {{ col.filter.options.find(option => option.value === slotProps.value)?.text }}
                                        </span>
                                    </template>
                                    <template #option="slotProps">
                                        {{ slotProps.option.text }}
                                    </template>
                                </Select>
                            </template>
                            <template #body="slotProps" v-if="col.field === 'code'">
                                <Tag class="w-full p-mr-2 text-sm cursor-pointer" @click="copyCode(slotProps.data.code)">
                                    <i class="pi pi-copy mr-2" />{{ slotProps.data.code }}
                                </Tag>
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'status'">
                                <Tag
                                    :value="slotProps.data.status ? __('Active') : __('In-active')"
                                    :severity="slotProps.data.status ? 'success' : 'danger'"
                                />
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'actions'">
                                <div class="flex justify-center">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                    editForm = true;
                                    currentId = slotProps.data.id;
                                "
                                            >{{ __('Edit') }}</button>
                                            <button class="action-item" @click="deleteRecord(slotProps.data.id)">{{ __('Delete') }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>
                            </template>
                        </Column>
                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('Create New') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <ExamTypeForm :form-errors="errors" title="New Exam Type" @close="createForm = false" />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <ExamTypeForm
                            v-model:edit-flag="editForm"
                            :exam-type-id="currentId"
                            :form-errors="errors"
                            title="Edit Exam Type"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive, onBeforeUnmount } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ExamTypeForm from '@/Components/Forms/ExamTypeForm.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'

// Props
const props = defineProps({
    examTypes: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    routeName: 'exam-types.index',
    columns: [
        {
            field: 'code',
            header: __('Code'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search by Code')
            }
        },
        {
            field: 'name',
            header: __('Name'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search by Name')
            }
        },
        {
            field: 'status',
            header: __('Status'),
            sortable: false,
            filter: {
                type: 'dropdown',
                options: [
                    { value: 1, text: __('Active') },
                    { value: 0, text: __('In-active') }
                ],
                placeholder: __('Filter by Status')
            }
        },
        {
            field: 'actions',
            header: __('Actions'),
            sortable: false
        }
    ],
    data: props.examTypes
})

// Computed
const title = computed(() => {
    return __('Exam Types') + ' - ' + pageProps.general.app_name + ' Admin'
})

// Methods
const deleteRecord = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('exam-types.destroy', { examType: id }), {
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
