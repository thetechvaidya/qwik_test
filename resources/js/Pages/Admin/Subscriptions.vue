<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Subscriptions') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('Add') }} {{ __('Manual Subscription') }}
            </button>
        </template>

        <div class="container mx-auto py-10 px-4 sm:px-6 lg:px-8">
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
                        :globalFilterFields="['code', 'plan', 'user', 'status']"
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
                                        class="w-full p-mr-2 cursor-pointer"
                                        @click="handleCopyClick(slotProps.data.code)"
                                    />
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="col.field === 'status'">
                                    <span
                                        :class="[
                                            slotProps.data.status === 'active' ? 'badge-success' : 'badge-danger',
                                            'badge uppercase',
                                        ]"
                                        >{{ slotProps.data.status }}</span
                                    >
                                </div>

                                <!-- Action Column -->
                                <div v-else-if="col.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                    showDetails = true;
                                    currentId = slotProps.data.id;
                                "
                                                >{{ __('Details') }}</button
                                            >
                                            <button class="action-item" @click="deleteSubscription(slotProps.data.id)">{{ __('Delete') }}</button>
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
                                        {{ __('New') }} {{ __('Subscription') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Sidebar Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <SubscriptionForm
                            :errors="errors"
                            :status-types="subscriptionStatuses"
                            :title="__('New') + ' ' + __('Subscription')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="showDetails" position="right" class="p-drawer-md">
                        <SubscriptionDetails
                            :errors="errors"
                            :status-types="subscriptionStatuses"
                            :subscription-id="currentId"
                            :title="__('Subscription') + ' ' + __('Details')"
                            @close="showDetails = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed } from 'vue'
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
import SubscriptionForm from '@/Components/Admin/SubscriptionForm.vue'
import SubscriptionDetails from '@/Components/Admin/SubscriptionDetails.vue'

// Props
const props = defineProps({
    subscriptions: {
        type: Object,
        required: true,
    },
    subscriptionStatuses: {
        type: Array,
        default: () => [],
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
    code: { value: null, matchMode: FilterMatchMode.CONTAINS },
    plan: { value: null, matchMode: FilterMatchMode.CONTAINS },
    user: { value: null, matchMode: FilterMatchMode.CONTAINS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})

// Reactive data
const createForm = ref(false)
const showDetails = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Subscriptions') + ' - ' + pageProps.general.app_name
})

// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    columns: [
        {
            field: 'code',
            header: __('Code'),
            sortable: true,
            filter: {
                type: 'text',
                placeholder: __('Filter by code')
            }
        },
        {
            field: 'plan',
            header: __('Plan'),
            sortable: true,
            filter: {
                type: 'text',
                placeholder: __('Filter by plan')
            }
        },
        {
            field: 'user',
            header: __('User'),
            sortable: true,
            filter: {
                type: 'text',
                placeholder: __('Filter by user')
            }
        },
        {
            field: 'starts',
            header: __('Starts'),
            sortable: true
        },
        {
            field: 'ends',
            header: __('Ends'),
            sortable: true
        },
        {
            field: 'payment',
            header: __('Payment'),
            sortable: false
        },
        {
            field: 'status',
            header: __('Status'),
            sortable: true,
            filter: {
                type: 'dropdown',
                options: props.subscriptionStatuses,
                placeholder: __('Filter by status')
            }
        },
        {
            field: 'actions',
            header: __('Actions'),
            sortable: false
        }
    ],
    data: props.subscriptions
})

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Subscription code copied to clipboard!'))
}

const deleteSubscription = id => {
    confirm.require({
        message: __('Are you sure you want to delete this subscription?'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.subscriptions.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Subscription deleted successfully'),
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
</script>
