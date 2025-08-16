<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Lessons') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('lessons.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Lesson') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="lessons.meta.pagination.total"
                        :rows="lessons.data"
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
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="copyCode(props.row.code)"
                                >
                                    <i class="pi pi-copy mr-2" />{{ props.row.code }}
                                </Tag>
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    :class="[props.row.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(props.row.status) }}</span
                                >
                            </div>

                            <!-- Actions Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button class="action-item" @click="editLesson(props.row.id)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteLesson(props.row.id)">{{
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
                            <NoDataTable />
                        </template>
                    </vue-good-table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { useMathRender } from '@/composables/useMathRender'

// Props
const props = defineProps({
    lessons: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()
const { renderMath } = useMathRender()

// Table configuration
const columns = [
    {
        label: __('Code'),
        field: 'code',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Code'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Title'),
        field: 'title',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Title'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Section'),
        field: 'section',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Section'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Skill'),
        field: 'skill',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Skill'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Topic'),
        field: 'topic',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Topic'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Status'),
            filterValue: null,
            filterDropdownItems: [
                { value: 1, text: __('Active') },
                { value: 0, text: __('In-active') },
            ],
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '200px',
        tdClass: 'text-center',
    },
]

const options = reactive({
    enabled: true,
    mode: 'pages',
    perPage: props.lessons.meta.pagination.per_page,
    setCurrentPage: props.lessons.meta.pagination.current_page,
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})

// Server table composable
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange } = useServerTable({
    resourceKeys: ['lessons'],
    routeName: 'lessons.index',
    onSuccess: () => {
        renderMath()
    },
})

// Computed
const title = computed(() => {
    return __('Lessons') + ' - ' + pageProps.general.app_name
})

// Methods
const editLesson = id => {
    router.get(route('lessons.edit', { lesson: id }))
}

const deleteLesson = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('lessons.destroy', { lesson: id }), {
            onSuccess: () => {
                toast({
                    severity: 'info',
                    summary: __('Confirmed'),
                    detail: __('Record deleted'),
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
    }
}

// Initialize math rendering
onMounted(() => {
    renderMath()
})
</script>
