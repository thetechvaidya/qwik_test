<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Tags') }}</h4>
        </template>

        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true"> {{ __('New') }} {{ __('Tag') }} </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="tags.meta.pagination.total"
                        :rows="tags.data"
                        :rtl="pageProps.rtl"
                        @on-page-change="onPageChange"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                    >
                        <template #table-row="props">
                            <!-- Status Column -->
                            <div v-if="props.column.field === 'status'">
                                <span
                                    :class="[props.row.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(props.row.status) }}</span
                                >
                            </div>

                            <!-- Actions Column -->
                            <span v-else-if="props.column.field === 'actions'">
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
                                        <button class="action-item" @click="deleteTag(props.row.id)">{{
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </span>

                            <!-- Other Columns -->
                            <span v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </span>
                        </template>

                        <template #emptystate>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Tag') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <TagForm :form-errors="errors" title="New Tag" @close="createForm = false" />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <TagForm
                            v-model:edit-flag="editForm"
                            :tag-id="currentId"
                            :form-errors="errors"
                            title="Edit Tag"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, reactive } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Drawer from 'primevue/drawer'
import TagForm from '@/Components/Forms/TagForm.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useConfirmToast } from '@/composables/useConfirmToast'

// Props
const props = defineProps({
    tags: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { confirm, toast } = useConfirmToast()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Table configuration
const columns = [
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
        width: '11rem',
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '12rem',
    },
]

const options = reactive({
    enabled: true,
    mode: 'pages',
    perPage: props.tags.meta.pagination.per_page,
    setCurrentPage: props.tags.meta.pagination.current_page,
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})

// Server table composable
const { onPageChange, onPerPageChange, onColumnFilter, onSortChange } = useServerTable({
    resourceKeys: ['tags'],
    routeName: 'tags.index',
})

// Computed
const title = computed(() => {
    return __('Tags') + ' - ' + pageProps.general.app_name
})

// Methods
const deleteTag = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('tags.destroy', id), {
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
</script>
