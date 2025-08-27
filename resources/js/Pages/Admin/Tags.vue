<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Tags') }}</h4>
        </template>

        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true"> {{ __('New') }} {{ __('Tag') }} </button>
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
                        :globalFilterFields="['name']"
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
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

                        <Column field="status" :header="__('Status')" :sortable="false">
                            <template #body="{ data }">
                                <span
                                    :class="[data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(data.status) }}</span
                                >
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
                                        <button class="action-item" @click="deleteTag(data.id)">{{ 
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
                                        {{ __('New') }} {{ __('Tag') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <TagForm :form-errors="errors" title="New Tag" @close="createForm = false" />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <TagForm
                            v-model:edit-flag="editForm"
                            :tag-id="currentId"
                            :form-errors="errors"
                            title="Edit Tag"
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
import Drawer from 'primevue/drawer'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import TagForm from '@/Components/Forms/TagForm.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { FilterMatchMode } from '@primevue/core/api'

// Props
const props = defineProps({
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { confirm, toast } = useConfirmToast()

// Initialize filters for DataTable
const filters = ref({
    name: { value: null, matchMode: FilterMatchMode.CONTAINS }
})

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['tags'],
    routeName: 'tags.index',
    columns: [
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
            width: '11rem',
        },
        {
            label: __('Actions'),
            field: 'actions',
            sortable: false,
            width: '12rem',
        },
    ],
})

// Computed
const title = computed(() => {
    return __('Tags') + ' - ' + pageProps.general.app_name
})

// Methods
const deleteTag = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('tags.destroy', id), {
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
    
    // Reset filters
    filters.value = {
        name: { value: null, matchMode: FilterMatchMode.CONTAINS }
    }
    
    // Cancel any pending confirmation dialogs
    if (window.$confirm && window.$confirm.close) {
        window.$confirm.close()
    }
})
</script>
