<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Payments') }}</h4>
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
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        filterDisplay="row"
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
                                        class="w-full mr-2 cursor-pointer"
                                        @click="handleCopyClick(slotProps.data.code)"
                                    />
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="slotProps.field === 'status'">
                                    <span
                                        :class="[
                                            slotProps.data.status === 'success' ? 'badge-success' : 'badge-danger',
                                            'badge uppercase',
                                        ]"
                                        >{{ slotProps.data.status }}</span
                                    >
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="slotProps.field === 'actions'">
                                    <Button
                                        v-if="slotProps.data.status === 'pending' && slotProps.data.method === 'Bank'"
                                        severity="success"
                                        size="small"
                                        class="mr-2"
                                        @click="approvePayment(slotProps.data.id, slotProps.data.code)"
                                    >
                                        {{ __('Authorize') }}
                                    </Button>
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    showDetails = true;
                                                    currentId = slotProps.data.id;
                                                "
                                            >
                                                <i class="pi pi-eye"></i>
                                                {{ __('Details') }}
                                            </button>
                                            <button class="action-item text-red-600" @click="deletePayment(slotProps.data.id)">
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
                                        {{ __('No Payments') }}
                                    </template>
                                </NoDataTable>
                            </div>
                        </template>
                    </DataTable>

                    <!-- Details Drawer -->
                    <Drawer v-model:visible="showDetails" :header="__('Payment Details')" position="right" class="!w-full md:!w-80">
                        <PaymentDetails
                            :errors="errors"
                            :status-types="paymentStatuses"
                            :payment-id="currentId"
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
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Button from 'primevue/button'
import Drawer from 'primevue/drawer'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'
import PaymentDetails from '@/Components/Admin/PaymentDetails.vue'

// Props
const props = defineProps({
    payments: {
        type: Object,
        required: true,
    },
    paymentProcessors: {
        type: Array,
        default: () => [],
    },
    paymentStatuses: {
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
// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['payments'],
    routeName: 'admin.payments.index',
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
            label: __('Plan'),
            field: 'plan',
            sortable: true,
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by plan'),
                filterValue: null,
                trigger: 'enter',
            },
        },
        {
            label: __('User'),
            field: 'user',
            sortable: true,
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by user'),
                filterValue: null,
                trigger: 'enter',
            },
        },
        {
            label: __('Amount'),
            field: 'amount',
            sortable: true,
        },
        {
            label: __('Date'),
            field: 'date',
            sortable: true,
        },
        {
            label: __('Invoice'),
            field: 'invoice_no',
            sortable: false,
        },
        {
            label: __('Method'),
            field: 'method',
            sortable: true,
            filterOptions: {
                enabled: true,
                filterDropdownItems: props.paymentProcessors,
                placeholder: __('Filter by method'),
                filterValue: null,
            },
        },
        {
            label: __('Status'),
            field: 'status',
            sortable: true,
            filterOptions: {
                enabled: true,
                filterDropdownItems: props.paymentStatuses,
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
const showDetails = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Payments') + ' - ' + pageProps.general.app_name
})

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Payment code copied to clipboard!'))
}

const approvePayment = (id, code) => {
    confirm.require({
        message: __('Are you sure you want to approve this bank payment?'),
        header: __('Approve Payment'),
        icon: 'pi pi-check-circle',
        acceptClass: 'p-button-success',
        accept: () => {
            router.patch(
                route('admin.payments.authorize-bank-payment', id),
                {
                    status: 'approved',
                },
                {
                    preserveScroll: true,
                    onSuccess: () => {
                        toast({
                            severity: 'success',
                            summary: __('Success'),
                            detail: __('Payment approved successfully'),
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
                }
            )
        },
    })
}

const deletePayment = id => {
    confirm.require({
        message: __(
            'Are you sure you want to delete this payment? This action will also delete the associated subscription.'
        ),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.payments.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Payment deleted successfully'),
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
