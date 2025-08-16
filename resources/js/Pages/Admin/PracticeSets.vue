<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Practice Sets') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('admin.practice-sets.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Practice Set') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="pagination"
                        :columns="columns"
                        :total-rows="practiceSets.meta.pagination.total"
                        :rows="practiceSets.data"
                        :rtl="pageProps.rtl"
                        @on-page-change="onPageChange"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag
                                    severity="info"
                                    :value="props.row.code"
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 mb-2 text-xs cursor-pointer"
                                    @click="handleCopyClick(props.row.code)"
                                />
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span :class="[props.row.status ? 'badge-success' : 'badge-danger', 'badge']">
                                    {{ props.row.status ? __('Published') : __('Draft') }}
                                </span>
                            </div>

                            <!-- Actions Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button class="action-item" @click="goToAnalytics(props.row.id)">{{
                                            __('Analytics')
                                        }}</button>
                                        <button class="action-item" @click="editPracticeSet(props.row.id)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deletePracticeSet(props.row.id)">{{
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
                                    <Link :href="route('admin.practice-sets.create')" class="qt-btn-sm qt-btn-primary">
                                        {{ __('Create') }}
                                    </Link>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import Tag from 'primevue/tag'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'

// Props
const props = defineProps({
    practiceSets: {
        type: Object,
        required: true,
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
const { columns, pagination, onPageChange, onPerPageChange, onColumnFilter } = useServerTable()

// Computed
const title = computed(() => {
    return __('Practice Sets') + ' - ' + pageProps.general.app_name
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
        label: __('Title'),
        field: 'title',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by title'),
        },
    },
    {
        label: __('Slug'),
        field: 'slug',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by slug'),
        },
    },
    {
        label: __('Questions'),
        field: 'questions',
        sortable: false,
    },
    {
        label: __('Sub Category'),
        field: 'subCategory',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by category'),
        },
    },
    {
        label: __('Skill'),
        field: 'skill',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by skill'),
        },
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: true,
        filterOptions: {
            enabled: true,
            filterDropdownItems: [
                { value: true, text: __('Published') },
                { value: false, text: __('Draft') },
            ],
            placeholder: __('Filter by status'),
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '120px',
    },
]

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Practice set code copied to clipboard!'))
}

const goToAnalytics = id => {
    router.visit(route('admin.practice-set.analytics', id))
}

const editPracticeSet = id => {
    router.visit(route('admin.practice-sets.edit', id))
}

const deletePracticeSet = id => {
    confirm.require({
        message: __(
            'Are you sure you want to delete this practice set? This action will permanently remove all associated questions and sessions.'
        ),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.practice-sets.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Practice set deleted successfully'),
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
