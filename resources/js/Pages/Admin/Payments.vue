<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Payments') }}</h4>
        </template>

        <div class="container mx-auto py-10 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="payments.meta.pagination.total"
                        :rows="payments.data"
                        :rtl="pageProps.rtl"
                        @on-page-change="onPageChange"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag
                                    :value="props.row.code"
                                    icon="pi pi-copy"
                                    class="w-full mr-2 cursor-pointer"
                                    @click="handleCopyClick(props.row.code)"
                                />
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    :class="[
                                        props.row.status === 'success' ? 'badge-success' : 'badge-danger',
                                        'badge uppercase',
                                    ]"
                                    >{{ props.row.status }}</span
                                >
                            </div>

                            <!-- Action Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <Button
                                    v-if="props.row.status === 'pending' && props.row.method === 'Bank'"
                                    severity="success"
                                    size="small"
                                    class="mr-2"
                                    @click="approvePayment(props.row.id, props.row.code)"
                                >
                                    {{ __('Authorize') }}
                                </Button>
                                <ActionsDropdown>
                                    <template #actions>
                                        <button
                                            class="action-item"
                                            @click="
                                                showDetails = true
                                                currentId = props.row.id
                                            "
                                            >{{ __('Details') }}</button
                                        >
                                        <button class="action-item" @click="deletePayment(props.row.id)">{{
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </div>

                            <!-- Remaining Columns -->
                            <span v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </span>
                        </template>
                        <template #emptystate>
                            <NoDataTable>
                                <template #action>
                                    {{ __('No Payments') }}
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

                    <!-- Details Drawer -->
                    <Drawer v-model:visible="showDetails" position="right" class="p-drawer-md">
                        <PaymentDetails
                            :errors="errors"
                            :status-types="paymentStatuses"
                            :payment-id="currentId"
                            :title="__('Payment') + ' ' + __('Details')"
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
const { columns, options, onPageChange, onPerPageChange, onColumnFilter } = useServerTable()

// Reactive data
const showDetails = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Payments') + ' - ' + pageProps.general.app_name
})

// Table configuration
columns.value = [
    {
        label: __('Code'),
        field: 'code',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by code'),
        },
    },
    {
        label: __('Plan'),
        field: 'plan',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by plan'),
        },
    },
    {
        label: __('User'),
        field: 'user',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by user'),
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
        type: 'date',
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
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '150px',
    },
]

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
