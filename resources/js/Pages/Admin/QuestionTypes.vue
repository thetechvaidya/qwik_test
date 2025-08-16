<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Question Types') }}</h4>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="questionTypes.meta.pagination.total"
                        :rows="questionTypes.data"
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
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="handleCopyClick(props.row.code)"
                                />
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    class="text-sm"
                                    :class="[props.row.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(props.row.status) }}</span
                                >
                            </div>

                            <!-- Remaining Columns -->
                            <span v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </span>
                        </template>
                    </vue-good-table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Tag from 'primevue/tag'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'

// Props
const props = defineProps({
    questionTypes: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Table configuration
const columns = [
    {
        label: __('Code'),
        field: 'code',
        filterOptions: {
            enabled: true,
            placeholder: __('Search by Code'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Name'),
        field: 'name',
        filterOptions: {
            enabled: true,
            placeholder: __('Search by Name'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by Status'),
            filterValue: null,
            filterDropdownItems: [
                { value: 1, text: __('Active') },
                { value: 0, text: __('In-active') },
            ],
        },
    },
]

const options = reactive({
    enabled: true,
    mode: 'pages',
    perPage: props.questionTypes.meta.pagination.per_page,
    setCurrentPage: props.questionTypes.meta.pagination.current_page,
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})

// Server table composable
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange } = useServerTable({
    resourceKeys: ['questionTypes'],
    routeName: 'question-types.index',
})

// Computed
const title = computed(() => {
    return __('Question Types') + ' - ' + pageProps.general.app_name
})

// Methods
const handleCopyClick = code => {
    copyCode(code)
}
</script>
