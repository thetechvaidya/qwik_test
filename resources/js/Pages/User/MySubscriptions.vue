<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Subscriptions') }}</h1>
        </template>
        <div class="card mt-10">
            <div class="card-body">
                <DataTable
                    :value="subscriptions.data"
                    :totalRecords="subscriptions.meta.pagination.total"
                    :loading="false"
                    lazy
                    paginator
                    :rows="subscriptions.meta.pagination.per_page"
                    :first="(subscriptions.meta.pagination.current_page - 1) * subscriptions.meta.pagination.per_page"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                    currentPageReportTemplate="{first} to {last} of {totalRecords}"
                    @page="onPageChange"
                    @filter="onColumnFilter"
                    filterDisplay="row"
                >
                    <Column field="plan" :header="__('Plan')" :sortable="false">
                        <template #body="slotProps">
                            <span>{{ slotProps.data.plan }}</span><br />
                            <span class="text-xs text-gray-400">{{ slotProps.data.payment }}</span>
                        </template>
                    </Column>

                    <Column field="starts" :header="__('Starts')" :sortable="false"></Column>

                    <Column field="ends" :header="__('Ends')" :sortable="false"></Column>

                    <Column field="features" :header="__('Feature Access')" :sortable="false">
                        <template #body="slotProps">
                            <ul>
                                <li v-for="feature in slotProps.data.features" :key="feature.code" class="text-sm">
                                    - {{ __(feature.name) }}
                                </li>
                            </ul>
                        </template>
                    </Column>

                    <Column field="status" :header="__('Status')" :sortable="false">
                        <template #body="slotProps">
                            <span
                                :class="[
                                    slotProps.data.status === 'active' ? 'badge-success' : 'badge-danger',
                                    'badge-sm uppercase text-xs',
                                ]"
                            >
                                {{ __(slotProps.data.status) }}
                            </span>
                        </template>
                    </Column>

                    <Column field="actions" :header="__('Actions')" :sortable="false" style="width: 12rem">
                        <template #body="slotProps">
                            <div class="py-2">
                                <button
                                    v-if="slotProps.data.canCancel"
                                    type="button"
                                    class="qt-btn qt-btn-sm qt-btn-danger"
                                    @click="cancelSubscription(slotProps.data.id)"
                                >
                                    {{ __('Cancel') }}
                                </button>
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
import Swal from 'sweetalert2'
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
        subscriptions: Object,
        steps: Array,
        errors: Object,
    },
    data() {
        return {
            columns: [
                {
                    label: this.__('Plan'),
                    field: 'plan',
                    sortable: false,
                },
                {
                    label: this.__('Starts'),
                    field: 'starts',
                    sortable: false,
                },
                {
                    label: this.__('Ends'),
                    field: 'ends',
                    sortable: false,
                },
                {
                    label: this.__('Feature Access'),
                    field: 'features',
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
                    sortable: false,
                    width: '12rem',
                },
            ],
            options: {
                enabled: true,
                mode: 'pages',
                perPage: this.subscriptions.meta.pagination.per_page,
                setCurrentPage: this.subscriptions.meta.pagination.current_page,
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
            return this.__('My Subscriptions') + ' - ' + this.$page.props.general.app_name
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
        cancelSubscription(id) {
            Swal.fire({
                title: this.__('Are you sure?'),
                text: this.__('Do you want to cancel this subscription?'),
                icon: 'warning',
                showCancelButton: true,
                cancelButtonText: this.__('No'),
                confirmButtonColor: '#d33',
                cancelButtonColor: '#3085d6',
                confirmButtonText: this.__('Yes! Cancel'),
            }).then(result => {
                if (result.isConfirmed) {
                    this.$inertia.post(
                        route('cancel_my_subscription', { id: id }),
                        {},
                        {
                            onSuccess: () => {
                                Swal.fire(this.__('Cancelled'), this.__('Subscription Cancelled'), 'success')
                            },
                        }
                    )
                }
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
