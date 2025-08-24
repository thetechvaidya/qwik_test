<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Practice Sessions') }}</h1>
        </template>
        <div class="w-full my-6">
            <progress-navigator :steps="steps"></progress-navigator>
        </div>
        <div class="card">
            <div class="card-body">
                <DataTable
                    :value="practiceSessions.data"
                    :totalRecords="practiceSessions.meta.pagination.total"
                    :rows="practiceSessions.meta.pagination.per_page"
                    :first="(practiceSessions.meta.pagination.current_page - 1) * practiceSessions.meta.pagination.per_page"
                    :lazy="true"
                    :paginator="true"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
                    currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries"
                    @page="onPageChange"
                    @sort="onSortChange"
                    @filter="onColumnFilter"
                    showGridlines
                    stripedRows
                >
                    <Column v-for="col in columns" :key="col.field" :field="col.field" :header="col.label" :sortable="col.sortable">
                        <template #body="slotProps" v-if="col.field === 'status'">
                            <span
                                :class="[
                                    slotProps.data.status === 'Passed' ? 'badge-success' : 'badge-danger',
                                    'badge-sm uppercase text-xs',
                                ]"
                                >{{ slotProps.data.status }}</span
                            >
                        </template>
                        
                        <template #body="slotProps" v-else-if="col.field === 'actions'">
                            <div class="py-2">
                                <Link
                                    class="qt-btn qt-btn-sm qt-btn-success"
                                    :href="
                                        route('practice_session_analysis', {
                                            practiceSet: slotProps.data.slug,
                                            session: slotProps.data.id,
                                        })
                                    "
                                >
                                    {{ __('View Analysis') }}
                                </Link>
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
import ProgressNavigator from '@/Components/Stepper/ProgressNavigator'
import NoDataTable from '@/Components/NoDataTable'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'

export default {
    components: {
        AppLayout,
        EmptyStudentCard,
        ProgressNavigator,
        NoDataTable,
        DataTable,
        Column,
    },
    props: {
        practiceSessions: Object,
        steps: Array,
        errors: Object,
    },
    data() {
        return {
            columns: [
                {
                    label: this.__('Practice Set') + ' ' + this.__('Name'),
                    field: 'name',
                    sortable: false,
                },
                {
                    label: this.__('Completed'),
                    field: 'completed',
                    sortable: false,
                },
                {
                    label: this.__('Total Points Earned'),
                    field: 'total_points_earned',
                    sortable: false,
                },
                {
                    label: this.__('Actions'),
                    field: 'actions',
                    sortable: false,
                },
            ],
            options: {
                enabled: true,
                mode: 'pages',
                perPage: this.practiceSessions.meta.pagination.per_page,
                setCurrentPage: this.practiceSessions.meta.pagination.current_page,
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
            return this.__('My Practice Sessions') + ' - ' + this.$page.props.general.app_name
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
