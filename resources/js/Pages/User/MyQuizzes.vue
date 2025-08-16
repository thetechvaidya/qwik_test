<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Quizzes') }}</h1>
        </template>
        <div class="w-full my-6">
            <progress-navigator :steps="steps"></progress-navigator>
        </div>
        <div class="card">
            <div class="card-body">
                <vue-good-table
mode="remote" @on-page-change="onPageChange" @on-column-filter="onColumnFilter" :pagination-options="options"
                                @on-per-page-change="onPerPageChange" :columns="columns"
                    :total-rows="quizSessions.meta.pagination.total"
                    :rows="quizSessions.data"
                    :rtl="$page.props.rtl"
                    :line-numbers="true"
                >
                    <template v-slot:table-row="props" >
                        <!-- Status Column -->
                        <div v-if="props.column.field === 'status'">
                            <span
                                :class="[
                                    props.row.status === 'Passed' ? 'badge-success' : 'badge-danger',
                                    'badge-sm uppercase text-xs',
                                ]"
                                >{{ __(props.row.status) }}</span
                            >
                        </div>

                        <!-- Actions Column -->
                        <div v-else-if="props.column.field === 'actions'" class="py-2">
                            <Link
                                class="qt-btn qt-btn-sm qt-btn-success"
                                :href="route('quiz_results', { quiz: props.row.slug, session: props.row.id })"
                            >
                                {{ __('Results') }}
                            </Link>
                        </div>

                        <!-- Remaining Columns -->
                        <span v-else>
                            {{ props.formattedRow[props.column.field] }}
                        </span>
                    </template>

                    <template v-slot:emptystate>
<div>
                        <no-data-table></no-data-table>
                    </div>
</template>
                </vue-good-table>
            </div>
        </div>
    </app-layout>
</template>

<script>
import AppLayout from '@/Layouts/AppLayout.vue'
import EmptyStudentCard from '@/Components/Cards/EmptyStudentCard'
import ProgressNavigator from '@/Components/Stepper/ProgressNavigator'
import NoDataTable from '@/Components/NoDataTable'

export default {
    components: {
        AppLayout,
        EmptyStudentCard,
        ProgressNavigator,
        NoDataTable,
    },
    props: {
        quizSessions: Object,
        steps: Array,
        errors: Object,
    },
    data() {
        return {
            columns: [
                {
                    label: this.__('Quiz') + ' ' + this.__('Name'),
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
                perPage: this.quizSessions.meta.pagination.per_page,
                setCurrentPage: this.quizSessions.meta.pagination.current_page,
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
                return this.__('My Quizzes')+' - ' + this.$page.props.general.app_name;
            }
        },
        methods: {
            updateParams(newProps) {
                this.serverParams = Object.assign({}, this.serverParams, newProps);
            },
            onPageChange(params) {
                this.updateParams({page: params.currentPage});
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
                }

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
            }
        },
    },
}
</script>
