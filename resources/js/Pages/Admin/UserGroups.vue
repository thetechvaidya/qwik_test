<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('User Groups') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('User Group') }}
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
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column
                            v-for="col in columns"
                            :key="col.field"
                            :field="col.field"
                            :header="col.label"
                            :sortable="col.sortable"
                        >
                            <template v-if="col.filterOptions?.enabled" #filter="{ filterModel, filterCallback }">
                                <InputText
                                    v-if="!col.filterOptions.filterDropdownItems"
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
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
                                        @click="copyCode(slotProps.data.code)"
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
                                "
                                                >{{ __('Edit') }}</button
                                            >
                                            <button class="action-item" @click="deleteUserGroup(slotProps.data.id)">{{ 
                                                __('Delete')
                                            }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Default Column -->
                                <span v-else>{{ slotProps.data[slotProps.field] }}</span>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('User Group') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <UserGroupForm :form-errors="errors" title="New User Group" @close="createForm = false" />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <UserGroupForm
                            v-model:edit-flag="editForm"
                            :user-group-id="currentId"
                            :form-errors="errors"
                            title="Edit User Group"
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
import UserGroupForm from '@/Components/Forms/UserGroupForm.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

const props = defineProps({
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
    resourceKeys: ['userGroups'],
    routeName: 'user-groups.index',
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
            label: __('Visibility'),
            field: 'visibility',
            sortable: false,
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('Visibility'),
                filterValue: null,
                filterDropdownItems: [
                    { value: 1, text: __('Private') },
                    { value: 0, text: __('Public') },
                ],
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
        },
    ],
})

const title = computed(() => {
    return __('User Groups') + ' - ' + pageProps.general.app_name
})

const deleteUserGroup = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('user-groups.destroy', { user_group: id }), {
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
