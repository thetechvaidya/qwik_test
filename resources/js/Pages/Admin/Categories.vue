<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Categories') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Category') }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="categories.meta.pagination.total"
                        :rows="categories.data"
                        :rtl="$page.props.rtl"
                        @on-page-change="onPageChange"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                        @on-search="onSearch"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag
                                    :value="props.row.code"
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="copyCode(props.row.code)"
                                ></Tag>
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
                                        <button
                                            class="action-item"
                                            @click="
                                                editForm = true
                                                currentId = props.row.id
                                            "
                                            >{{ __('Edit') }}</button
                                        >
                                        <button class="action-item" @click="deleteCategory(props.row.id)">{{
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
                                        {{ __('New') }} {{ __('Category') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <CategoryForm
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Category')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <CategoryForm
                            :edit-flag="editForm"
                            :category-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Category')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Button from 'primevue/button'
import Drawer from 'primevue/drawer'
import CategoryForm from '@/Components/Forms/CategoryForm'
import Chip from 'primevue/chip'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable'
import ActionsDropdown from '@/Components/ActionsDropdown'

const props = defineProps({
    categories: Object,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Server table composable
const { onPageChange, onPerPageChange, onColumnFilter, onSearch, tableParams } = useServerTable({
    page: props.categories.meta.pagination.current_page || 1,
    perPage: props.categories.meta.pagination.per_page || 10,
    resourceKeys: ['categories'],
    paramMap: {
        page: 'page',
        perPage: 'per_page',
        search: 'search',
        sortBy: 'sortBy',
        sortOrder: 'sortOrder',
        filterPrefix: '',
    },
})

// Reactive state
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Table columns
const columns = reactive([
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
        label: __('Name'),
        field: 'name',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Name'),
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
])

// Computed properties
const title = computed(() => {
    return __('Categories') + ' - ' + pageProps.general.app_name
})

// Methods
const deleteCategory = id => {
    if (window.$confirm && window.$confirm.require) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('categories.destroy', { category: id }), {
                    onSuccess: () => {
                        if (window.$toast && window.$toast.add) {
                            window.$toast.add({
                                severity: 'info',
                                summary: __('Confirmed'),
                                detail: __('Record deleted'),
                                life: 3000,
                            })
                        }
                    },
                    onError: () => {
                        if (window.$toast && window.$toast.add) {
                            window.$toast.add({
                                severity: 'error',
                                summary: __('Error'),
                                detail: __('Failed to delete category'),
                                life: 3000,
                            })
                        }
                    },
                })
            },
            reject: () => {
                // User cancelled
            },
        })
    }
}
</script>
