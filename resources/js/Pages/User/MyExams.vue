<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Exams') }}</h1>
        </template>
        <div class="w-full my-6">
            <progress-navigator :steps="steps"></progress-navigator>
        </div>
        <div class="card">
            <div class="card-body">
                <DataTable
                    :value="examSessions.data"
                    :totalRecords="examSessions.meta.pagination.total"
                    :loading="false"
                    lazy
                    paginator
                    :rows="examSessions.meta.pagination.per_page"
                    :first="(examSessions.meta.pagination.current_page - 1) * examSessions.meta.pagination.per_page"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                    currentPageReportTemplate="{first} to {last} of {totalRecords}"
                    @page="onPageChange"
                    @filter="onColumnFilter"
                    filterDisplay="row"
                    showGridlines
                >
                    <Column field="name" :header="__('Exam') + ' ' + __('Name')" :sortable="false"></Column>

                    <Column field="completed" :header="__('Completed')" :sortable="false"></Column>

                    <Column field="percentage" :header="__('Percentage')" :sortable="false"></Column>

                    <Column field="score" :header="__('Score')" :sortable="false"></Column>

                    <Column field="status" :header="__('Status')" :sortable="false">
                        <template #body="slotProps">
                            <span
                                :class="[
                                    slotProps.data.status === 'Passed' ? 'badge-success' : 'badge-danger',
                                    'badge-sm uppercase text-xs',
                                ]"
                            >
                                {{ __(slotProps.data.status) }}
                            </span>
                        </template>
                    </Column>

                    <Column field="actions" :header="__('Actions')" :sortable="false">
                        <template #body="slotProps">
                            <div class="py-2">
                                <Link
                                    class="qt-btn qt-btn-sm qt-btn-success"
                                    :href="route('exam_results', { exam: slotProps.data.slug, session: slotProps.data.id })"
                                >
                                    {{ __('Results') }}
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
        examSessions: Object,
        steps: Array,
        errors: Object,
    },
    data() {
        return {
            columns: [
                {
                    label: this.__('Exam') + ' ' + this.__('Name'),
                    field: 'name',
                    sortable: false,
                },
                {
                    label: this.__('Completed'),
                    field: 'completed',
                    sortable: false,
                },
                {
                    label: this.__('Percentage'),
                    field: 'percentage',
                    sortable: false,
                },
                {
                    label: this.__('Score'),
                    field: 'score',
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
                },
            ],
            options: {
                enabled: true,
                mode: 'pages',
                perPage: this.examSessions.meta.pagination.per_page,
                setCurrentPage: this.examSessions.meta.pagination.current_page,
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
        };
    },
    computed: {
        title() {
            return this.__('My Exams')+' - ' + this.$page.props.general.app_name;
        }
    },
    methods: {
        updateParams(newProps) {
            this.serverParams = Object.assign({}, this.serverParams, newProps);
        },
        onPageChange(event) {
            this.updateParams({page: Math.floor(event.first / event.rows) + 1});
            this.loadItems();
        },
        onPerPageChange(params) {
            this.updateParams({perPage: params.currentPerPage});
            this.loadItems();
        },
        onSortChange(params) {
            this.updateParams({
                sort: [{
                    type: params.sortType,
                    field: this.columns[params.columnIndex].field,
                }],
            });
            this.loadItems();
        },
        onColumnFilter(params) {
            this.updateParams(params);
            this.serverParams.page = 1;
            this.loadItems();
        },
        getQueryParams() {
            let data = {
                'page': this.serverParams.page,
                'perPage': this.serverParams.perPage
            };

            for (const [key, value] of Object.entries(this.serverParams.columnFilters)) {
                if (value) {
                    data[key] = value;
                }
            }

            return data;
        },
        loadItems() {
            this.$inertia.get(route(route().current()), this.getQueryParams(), {
                replace: false,
                preserveState: true,
                preserveScroll: true,
            });
        },
    },
    metaInfo() {
        return {
            title: this.title
        };
    },
}
</script>
