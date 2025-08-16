<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Quiz Types') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Quiz Type') }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="quizTypes.meta.pagination.total"
                        :rows="quizTypes.data"
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
                                <span :class="[props.row.status ? 'badge-success' : 'badge-danger', 'badge']">{{
                                    props.row.status ? __('Active') : __('In-active')
                                }}</span>
                            </div>

                            <!-- Actions Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button
                                            class="action-item"
                                            @click="
                                                editForm = true
                                                currentId = props.row.id
                                                currentRecord = props.row
                                            "
                                            >Edit</button
                                        >
                                        <button class="action-item" @click="deleteRecord(props.row.id)">Delete</button>
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
                                        {{ __('New') }} {{ __('Quiz Type') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

                    <!-- Sidebar Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <create-form :title="__('Create') + ' ' + __('Quiz Type')" @close="createForm = false" />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <edit-form
                            :current-id="currentId"
                            :initial-data="currentRecord"
                            :title="__('Edit') + ' ' + __('Quiz Type')"
                            @close="editForm = false"
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
import CreateForm from '@/Components/Admin/QuizTypes/CreateForm.vue'
import EditForm from '@/Components/Admin/QuizTypes/EditForm.vue'

// Props
const props = defineProps({
    quizTypes: {
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
const { columns, options, onPageChange, onPerPageChange, onColumnFilter } = useServerTable()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)
const currentRecord = ref({})

// Computed
const title = computed(() => {
    return __('Quiz Types') + ' - ' + pageProps.general.app_name
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
        label: __('Name'),
        field: 'name',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by name'),
        },
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: true,
        filterOptions: {
            enabled: true,
            filterDropdownItems: [
                { value: true, text: __('Active') },
                { value: false, text: __('In-active') },
            ],
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
    copyCode(code, __('Quiz type code copied to clipboard!'))
}

const deleteRecord = id => {
    confirm.require({
        message: __('Are you sure you want to delete this quiz type?'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.quiz-types.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Quiz type deleted successfully'),
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
