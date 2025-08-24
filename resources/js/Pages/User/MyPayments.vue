<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Payments') }}</h1>
        </template>
        <div class="card mt-10">
            <div class="card-body">
                <DataTable
                    :value="payments.data"
                    :totalRecords="payments.meta.pagination.total"
                    :loading="false"
                    lazy
                    paginator
                    :rows="payments.meta.pagination.per_page"
                    :first="(payments.meta.pagination.current_page - 1) * payments.meta.pagination.per_page"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                    currentPageReportTemplate="{first} to {last} of {totalRecords}"
                    @page="onPageChange"
                    @filter="onColumnFilter"
                    filterDisplay="row"
                >
                    <Column field="payment_id" :header="__('Payment') + ' ' + __('ID')" :sortable="false"></Column>

                    <Column field="plan" :header="__('Plan')" :sortable="false"></Column>

                    <Column field="amount" :header="__('Amount')" :sortable="false"></Column>

                    <Column field="date" :header="__('Date')" :sortable="false"></Column>

                    <Column field="method" :header="__('Method')" :sortable="false"></Column>

                    <Column field="status" :header="__('Status')" :sortable="false">
                        <template #body="slotProps">
                            <span
                                :class="[
                                    slotProps.data.status === 'success' ? 'badge-success' : 'badge-danger',
                                    'badge-sm uppercase text-xs',
                                ]"
                            >
                                {{ __(slotProps.data.status) }}
                            </span>
                        </template>
                    </Column>

                    <Column field="actions" :header="__('Actions')" :sortable="false" style="width: 11rem">
                        <template #body="slotProps">
                            <div class="py-2">
                                <a
                                    v-if="enable_invoice"
                                    class="qt-btn qt-btn-sm qt-btn-success"
                                    target="_blank"
                                    :href="route('download_invoice', { id: slotProps.data.payment_id })"
                                >
                                    {{ __('Invoice') }}
                                </a>
                            </div>
                        </template>
                    </Column>

                    <template #empty>
                        <div>
                            <no-data-table></no-data-table>
                        </div>
                    </template>
                </DataTable>
            </div>
        </div>
    </app-layout>
</template>

<script>
import AppLayout from '@/Layouts/AppLayout.vue'
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard'
import NoDataTable from '@/Components/NoDataTable'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'

export default {
    components: {
        AppLayout,
        EmptyStudentCard,
        NoDataTable,
        DataTable,
        Column,
    },
    props: {
        payments: Object,
        steps: Array,
        errors: Object,
        enable_invoice: {
            type: Boolean,
            default: false,
        },
    },
    data() {
        return {
            columns: [
                {
                    label: this.__('Payment') + ' ' + this.__('ID'),
                    field: 'payment_id',
                    sortable: false,
                },
                {
                    label: this.__('Plan'),
                    field: 'plan',
                    sortable: false,
                },
                {
                    label: this.__('Amount'),
                    field: 'amount',
                    sortable: false,
                },
                {
                    label: this.__('Date'),
                    field: 'date',
                    sortable: false,
                },
                {
                    label: this.__('Method'),
                    field: 'method',
                    sortable: false,
                },
                {
                    label: this.__('Status'),
                    field: 'status',
                    sortable: false,
                },
                {
                    label: this.__('Actions'),
                    field: 'actions',
                    width: '11rem',
                    sortable: false,
                },
            ],
            options: {
                enabled: true,
                mode: 'pages',
                perPage: this.payments.meta.pagination.per_page,
                setCurrentPage: this.payments.meta.pagination.current_page,
                perPageDropdown: [10, 20, 50, 100],
                dropdownAllowAll: false,
            },
            serverParams: {
                columnFilters: {},
                sort: {
                    field: '',
                    type: '',
                },
                page: 1,
                perPage: 10,
            },
        }
    },
    computed: {
        title() {
            return this.__('My Payments') + ' - ' + this.$page.props.general.app_name
        },
    },
    methods: {
        updateParams(newProps) {
            this.serverParams = Object.assign({}, this.serverParams, newProps)
        },
        onPageChange(event) {
            this.updateParams({ page: Math.floor(event.first / event.rows) + 1 })
            this.loadItems()
        },
        onPerPageChange(params) {
            this.updateParams({ perPage: params.currentPerPage })
            this.loadItems()
        },
        onSortChange(params) {
            this.updateParams({
                sort: [
                    {
                        type: params.sortType,
                        field: this.columns[params.columnIndex].field,
                    },
                ],
            })
            this.loadItems()
        },
        onColumnFilter(params) {
            this.updateParams(params)
            this.serverParams.page = 1
            this.loadItems()
        },
        getQueryParams() {
            let data = {
                page: this.serverParams.page,
                perPage: this.serverParams.perPage,
            }

            for (const [key, value] of Object.entries(this.serverParams.columnFilters)) {
                if (value) {
                    data[key] = value
                }
            }

            return data
        },
        loadItems() {
            this.$inertia.get(route(route().current()), this.getQueryParams(), {
                replace: false,
                preserveState: true,
                preserveScroll: true,
            })
        },
    },
    metaInfo() {
        return {
            title: this.title,
        }
    },
}
</script>
