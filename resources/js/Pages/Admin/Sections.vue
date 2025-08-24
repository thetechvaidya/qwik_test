<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Sections') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Section') }}
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
                        :rowsPerPageOptions="[5, 10, 20, 50]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        filterDisplay="row"
                        v-model:filters="filters"
                        :globalFilterFields="['code', 'name', 'status']"
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
                                />
                            </template>
                            
                            <template #body="slotProps">
                                <!-- Code Column -->
                                <div v-if="col.field === 'code'">
                                    <Tag
                                        :value="slotProps.data.code"
                                        icon="pi pi-copy"
                                        class="w-full p-mr-2 text-sm cursor-pointer"
                                        @click="copyCode(slotProps.data.code)"
                                    />
                                </div>
                                
                                <!-- Status Column -->
                                <div v-else-if="col.field === 'status'">
                                    <span :class="[slotProps.data.status ? 'badge-success' : 'badge-danger', 'badge']">
                                        {{ slotProps.data.status ? __('Active') : __('In-active') }}
                                    </span>
                                </div>
                                
                                <!-- Actions Column -->
                                <div v-else-if="col.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    editForm = true;
                                                    currentId = slotProps.data.id;
                                                "
                                                >{{ __('Edit') }}</button
                                            >
                                            <button class="action-item" @click="deleteSection(slotProps.data.id)">{{ __('Delete') }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>
                                
                                <!-- Default Column -->
                                <span v-else>
                                    {{ slotProps.data[col.field] }}
                                </span>
                            </template>
                        </Column>
                        
                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Section') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Sidebar Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <SectionForm
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Section')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <SectionForm
                            v-model:edit-flag="editForm"
                            :section-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Section')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import { Head, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { FilterMatchMode } from '@primevue/core/api'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import SectionForm from '@/Components/Forms/SectionForm.vue'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

const props = defineProps({
    sections: Object,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Initialize filters for DataTable
const filters = ref({
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    name: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})

// State
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    columns: [
        {
            field: 'code',
            header: __('Code'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search') + ' ' + __('Code')
            }
        },
        {
            field: 'name',
            header: __('Name'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search') + ' ' + __('Name')
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
                placeholder: __('Search') + ' ' + __('Status')
            }
        },
        {
            field: 'actions',
            header: __('Actions'),
            sortable: false
        }
    ],
    data: props.sections
})

const title = computed(() => {
    return __('Sections') + ' - ' + pageProps.general.app_name
})

const deleteSection = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('sections.destroy', { section: id }), {
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
</script>
