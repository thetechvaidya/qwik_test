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
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="subscriptions.meta.pagination.total"
                        :rows="subscriptions.data"
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
                                    class="w-full p-mr-2 cursor-pointer"
                                    @click="handleCopyClick(props.row.code)"
                                />
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    :class="[
                                        props.row.status === 'active' ? 'badge-success' : 'badge-danger',
                                        'badge uppercase',
                                    ]"
                                    >{{ props.row.status }}</span
                                >
                            </div>

                            <!-- Action Column -->
                            <div v-else-if="props.column.field === 'actions'">
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
                                        <button class="action-item" @click="deleteSubscription(props.row.id)">{{
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
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Subscription') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

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
const { columns, options, onPageChange, onPerPageChange, onColumnFilter } = useServerTable()

// Reactive data
const createForm = ref(false)
const showDetails = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Subscriptions') + ' - ' + pageProps.general.app_name
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
        label: __('Starts'),
        field: 'starts',
        sortable: true,
        type: 'date',
        dateInputFormat: 'yyyy-MM-dd',
        dateOutputFormat: 'MMM dd, yyyy',
    },
    {
        label: __('Ends'),
        field: 'ends',
        sortable: true,
        type: 'date',
        dateInputFormat: 'yyyy-MM-dd',
        dateOutputFormat: 'MMM dd, yyyy',
    },
    {
        label: __('Payment'),
        field: 'payment',
        sortable: false,
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: true,
        filterOptions: {
            enabled: true,
            filterDropdownItems: props.subscriptionStatuses,
            placeholder: __('Filter by status'),
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '100px',
    },
]

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
