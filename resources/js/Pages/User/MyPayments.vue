<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Payments') }}</h1>
        </template>
        <div class="card mt-10">
            <div class="card-body">
                <ModernDataTable
                    :value="payments.data"
                    :columns="tableColumns"
                    :totalRecords="payments.meta.pagination.total"
                    :loading="tableLoading"
                    :rows="tableRows"
                    :first="tableFirst"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    showGridlines
                    stripedRows
                    responsiveLayout="scroll"
                    :globalFilterFields="['payment_id', 'plan', 'method', 'status']"
                    exportFilename="my-payments"
                    @page="onPageChange"
                    @sort="onSortChange"
                    @filter="onFilterChange"
                    @global-filter="onGlobalFilterChange"
                    @row-click="onRowClick"
                >
                    <!-- Payment ID Column -->
                    <template #payment_id="slotProps">
                        <div class="flex items-center">
                            <span class="font-mono text-sm bg-gray-100 dark:bg-gray-800 px-2 py-1 rounded border">
                                {{ slotProps.data.payment_id }}
                            </span>
                        </div>
                    </template>

                    <!-- Plan Column -->
                    <template #plan="slotProps">
                        <div class="flex items-center">
                            <i class="pi pi-credit-card text-blue-500 mr-2"></i>
                            <span class="font-medium text-gray-900 dark:text-white">
                                {{ slotProps.data.plan }}
                            </span>
                        </div>
                    </template>

                    <!-- Amount Column -->
                    <template #amount="slotProps">
                        <div class="text-right">
                            <span class="font-semibold text-lg text-green-600 dark:text-green-400">
                                {{ slotProps.data.amount }}
                            </span>
                        </div>
                    </template>

                    <!-- Date Column -->
                    <template #date="slotProps">
                        <div class="text-center">
                            <div class="text-sm text-gray-900 dark:text-white">
                                {{ slotProps.data.date }}
                            </div>
                        </div>
                    </template>

                    <!-- Method Column -->
                    <template #method="slotProps">
                        <div class="text-center">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200">
                                <i class="pi pi-credit-card mr-1"></i>
                                {{ slotProps.data.method }}
                            </span>
                        </div>
                    </template>

                    <!-- Status Column -->
                    <template #status="slotProps">
                        <div class="text-center">
                            <StatusBadge
                                :status="slotProps.data.status"
                                :variant="slotProps.data.status === 'success' ? 'success' : 'danger'"
                                size="sm"
                            />
                        </div>
                    </template>

                    <!-- Actions Column -->
                    <template #actions="slotProps">
                        <div class="flex justify-center space-x-2">
                            <Button
                                v-if="enable_invoice"
                                :label="__('Invoice')"
                                icon="pi pi-download"
                                size="small"
                                severity="success"
                                outlined
                                @click="downloadInvoice(slotProps.data.payment_id)"
                                class="!px-3 !py-1.5 !text-xs"
                            />
                            <span v-else class="text-sm text-gray-400 italic">
                                {{ __('No actions available') }}
                            </span>
                        </div>
                    </template>

                    <!-- Empty State -->
                    <template #empty>
                        <div class="text-center py-12">
                            <i class="pi pi-credit-card text-6xl text-gray-300 dark:text-gray-600 mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
                                {{ __('No payments found') }}
                            </h3>
                            <p class="text-gray-500 dark:text-gray-400 mb-6">
                                {{ __('You haven\'t made any payments yet.') }}
                            </p>
                            <Link
                                :href="route('subscription_plans')"
                                class="qt-btn qt-btn-primary"
                            >
                                {{ __('View Plans') }}
                            </Link>
                        </div>
                    </template>
                </ModernDataTable>
            </div>
        </div>
    </app-layout>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AppLayout from '@/Layouts/AppLayout.vue'
import ModernDataTable from '@/Components/DataTable/ModernDataTable.vue'
import Button from 'primevue/button'
import { useToast } from 'primevue/usetoast'
import { textColumn, statusColumn, StatusBadge } from '@/Components/DataTable/columns'

const props = defineProps({
    payments: Object,
    steps: Array,
    errors: Object,
    enable_invoice: {
        type: Boolean,
        default: false,
    },
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const toast = useToast()

// Enhanced Table Configuration
const tableColumns = computed(() => [
    textColumn('payment_id', {
        header: __('Payment') + ' ' + __('ID'),
        filterPlaceholder: __('Search payment ID...'),
        style: { width: '140px', fontFamily: 'monospace' },
        responsivePriority: 1
    }),
    textColumn('plan', {
        header: __('Plan'),
        filterPlaceholder: __('Search plans...'),
        style: { width: '180px', fontWeight: 'medium' },
        responsivePriority: 2
    }),
    {
        field: 'amount',
        header: __('Amount'),
        sortable: true,
        style: { width: '120px', textAlign: 'right' },
        responsivePriority: 3
    },
    {
        field: 'date',
        header: __('Date'),
        sortable: true,
        style: { width: '120px', textAlign: 'center' },
        responsivePriority: 4
    },
    textColumn('method', {
        header: __('Method'),
        filterOptions: {
            type: 'dropdown',
            options: [
                { label: __('Credit Card'), value: 'credit_card' },
                { label: __('PayPal'), value: 'paypal' },
                { label: __('Bank Transfer'), value: 'bank_transfer' },
                { label: __('Stripe'), value: 'stripe' },
                { label: __('Razorpay'), value: 'razorpay' }
            ],
            optionLabel: 'label',
            optionValue: 'value',
            placeholder: __('Filter by method...')
        },
        style: { width: '130px', textAlign: 'center' },
        responsivePriority: 5
    }),
    statusColumn('status', {
        header: __('Status'),
        statusOptions: [
            { label: __('Success'), value: 'success' },
            { label: __('Failed'), value: 'failed' },
            { label: __('Pending'), value: 'pending' },
            { label: __('Cancelled'), value: 'cancelled' }
        ],
        style: { width: '120px' },
        responsivePriority: 2
    }),
    {
        field: 'actions',
        header: __('Actions'),
        sortable: false,
        style: { width: '120px', textAlign: 'center' },
        responsivePriority: 6
    }
])

// Modern DataTable State
const tableLoading = ref(false)
const tableRows = ref(props.payments?.meta?.pagination?.per_page || 10)
const tableFirst = ref(0)

const title = computed(() => {
    return __('My Payments') + ' - ' + pageProps.general.app_name
})

// Event Handlers for Modern DataTable
const onPageChange = (event) => {
    tableFirst.value = event.first
    tableRows.value = event.rows
    loadPaymentsData()
}

const onSortChange = (event) => {
    loadPaymentsData({
        sortField: event.sortField,
        sortOrder: event.sortOrder
    })
}

const onFilterChange = (event) => {
    tableFirst.value = 0 // Reset to first page
    loadPaymentsData({
        filters: event.filters
    })
}

const onGlobalFilterChange = (value) => {
    tableFirst.value = 0 // Reset to first page
    loadPaymentsData({
        globalFilter: value
    })
}

const onRowClick = (event) => {
    // Optional: Show payment details on row click
    if (props.enable_invoice) {
        downloadInvoice(event.data.payment_id)
    }
}

// Data Loading
const loadPaymentsData = async (params = {}) => {
    tableLoading.value = true
    
    try {
        const queryParams = {
            page: Math.floor(tableFirst.value / tableRows.value) + 1,
            per_page: tableRows.value,
            ...params
        }
        
        // Handle sorting
        if (params.sortField && params.sortOrder) {
            queryParams.sort_by = params.sortField
            queryParams.sort_order = params.sortOrder === 1 ? 'asc' : 'desc'
        }
        
        // Handle global search
        if (params.globalFilter) {
            queryParams.search = params.globalFilter
        }
        
        // Handle column filters
        if (params.filters) {
            Object.keys(params.filters).forEach(key => {
                if (key !== 'global' && params.filters[key]?.value) {
                    queryParams[`filter_${key}`] = params.filters[key].value
                }
            })
        }
        
        await router.get(route('my_payments'), queryParams, {
            preserveState: true,
            preserveScroll: true,
            only: ['payments'],
            onFinish: () => {
                tableLoading.value = false
            }
        })
    } catch (error) {
        tableLoading.value = false
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load payments'),
            life: 3000
        })
    }
}

// Payment Actions
const downloadInvoice = (paymentId) => {
    if (!props.enable_invoice) {
        toast.add({
            severity: 'warn',
            summary: __('Warning'),
            detail: __('Invoice download is not available'),
            life: 3000
        })
        return
    }
    
    // Open invoice in new tab
    window.open(route('download_invoice', { id: paymentId }), '_blank')
    
    toast.add({
        severity: 'info',
        summary: __('Success'),
        detail: __('Invoice download started'),
        life: 2000
    })
}

const refreshTable = () => {
    loadPaymentsData()
}

const exportPayments = () => {
    // This will be handled by the ModernDataTable component
    toast.add({
        severity: 'info',
        summary: __('Info'),
        detail: __('Exporting payments data...'),
        life: 2000
    })
}

// Initialize component
onMounted(() => {
    // Component is ready
})
</script>
