<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Users') }}</h4>
        </template>
        <template #actions>
            <div class="flex gap-4 items-center">
                <Link :href="route('initiate_import_users')" class="qt-btn qt-btn-primary">
                    {{ __('Import Users') }}
                </Link>
                <button class="qt-btn qt-btn-success" @click="openCreateForm()">
                    {{ __('New') }} {{ __('User') }}
                </button>
            </div>
        </template>

        <div class="container mx-auto py-10 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :search-options="tableParams.search"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="users.meta.pagination.total"
                        :rows="users.data"
                        @on-page-change="onPageChange"
                        :rtl="$page.props.rtl"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                        @on-sort-change="onSortChange"
                        @on-search="onSearch"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag class="w-full p-mr-2 cursor-pointer" @click="copyCode(props.row.code)">
                                    <i class="pi pi-copy mr-2" />
                                    {{ props.row.code }}
                                </Tag>
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span :class="[props.row.status ? 'badge-success' : 'badge-danger', 'badge']">{{
                                    props.row.status ? __('Active') : __('In-active')
                                }}</span>
                            </div>

                            <!-- Action Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button class="action-item" @click="openEditForm(props.row)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteUserWithConfirmation(props.row.id)">{{
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
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="openCreateForm()">
                                        {{ __('New') }} {{ __('User') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

                    <!-- Sidebar Forms -->
                    <Drawer v-model:visible="showCreateDrawer" position="right" class="p-drawer-md">
                        <UserForm
                            v-if="showCreateDrawer"
                            :edit-flag="false"
                            :form-errors="errors"
                            :roles="roles"
                            :user-groups="userGroups"
                            :title="__('New') + ' ' + __('User')"
                            @close="closeForm"
                        />
                    </Drawer>
                    <Drawer v-model:visible="showEditDrawer" position="right" class="p-drawer-md">
                        <UserForm
                            v-if="showEditDrawer && editingUserId"
                            :edit-flag="true"
                            :user-id="editingUserId"
                            :form-errors="errors"
                            :roles="roles"
                            :user-groups="userGroups"
                            :title="__('Edit') + ' ' + __('User')"
                            @close="closeForm"
                        />
                    </Drawer>

                    <!-- Typed Deletion Confirmation Modal -->
                    <Dialog
                        v-model:visible="showDeleteConfirm"
                        :header="__('Confirm Deletion')"
                        :modal="true"
                        :closable="false"
                        :style="{ width: '28rem' }"
                    >
                        <div class="space-y-3">
                            <p class="text-sm">
                                {{
                                    __(
                                        "Do you want to delete this account? This action permanently erases the entire user's data, including exam sessions and subscriptions."
                                    )
                                }}
                            </p>
                            <p class="text-sm font-medium">
                                {{ __('Type') }}
                                <code class="px-1 py-0.5 bg-gray-100 rounded">{{ confirmPhrase }}</code>
                                {{ __('to confirm') }}
                            </p>
                            <InputText v-model="deleteConfirmText" :placeholder="__('Enter confirmation text')" />
                            <div class="flex justify-end gap-2 pt-2">
                                <button class="qt-btn qt-btn-secondary" @click="cancelTypedConfirm">{{
                                    __('Cancel')
                                }}</button>
                                <button
                                    class="qt-btn qt-btn-danger"
                                    :disabled="deleteConfirmText !== confirmPhrase"
                                    @click="acceptTypedConfirm"
                                    >{{ __('Delete') }}</button
                                >
                            </div>
                        </div>
                    </Dialog>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed, defineAsyncComponent } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Drawer from 'primevue/drawer'
const UserForm = defineAsyncComponent(() => import('@/Components/Forms/UserForm.vue'))
import Tag from 'primevue/tag'
import Dialog from 'primevue/dialog'
import InputText from 'primevue/inputtext'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useAdminForm } from '@/composables/useAdminForm'
import { useConfirmToast } from '@/composables/useConfirmToast'
import { codeColumn, statusColumn, textFilterColumn, dropdownFilterColumn } from '@/tables/columns'

// Props
const props = defineProps({
    users: Object,
    errors: Object,
    roles: Array,
    userGroups: Array,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { confirm, toast } = useConfirmToast()
const { copyCode } = useCopy()

// Localized delete confirmation phrase
const confirmPhrase = __('permanently delete')

// Admin form composable - using only for UI state and delete functionality
const {
    showCreateDrawer,
    showEditDrawer,
    editingItem,
    openCreateForm: openCreateFormBase,
    openEditForm: openEditFormBase,
    closeForm,
    deleteItem,
    showErrorToast,
} = useAdminForm({
    // No form configuration needed - UserForm handles its own form state
    deleteUrl: user => route('users.destroy', { user: user.id }),
    // Do not redirect on success; page will refresh table via loadItems
    onDeleteSuccess: async () => {
        await loadItems(true)
    },
    t: __,
})

// Custom form handlers that don't manage form data
const openCreateForm = () => {
    openCreateFormBase() // Just opens the drawer without form data
}

const openEditForm = user => {
    openEditFormBase(user) // Just opens drawer and stores editing item
}

// Alias editingItem as editingUser for template compatibility
const editingUser = editingItem

// Typed deletion confirm state
const showDeleteConfirm = ref(false)
const deleteConfirmText = ref('')
let resolveDeleteConfirm = null
const requestTypedConfirm = () =>
    new Promise(resolve => {
        resolveDeleteConfirm = resolve
        deleteConfirmText.value = ''
        showDeleteConfirm.value = true
    })
const cancelTypedConfirm = () => {
    showDeleteConfirm.value = false
    if (resolveDeleteConfirm) resolveDeleteConfirm(false)
    resolveDeleteConfirm = null
}
const acceptTypedConfirm = () => {
    const ok = deleteConfirmText.value === confirmPhrase
    showDeleteConfirm.value = false
    if (resolveDeleteConfirm) resolveDeleteConfirm(ok)
    resolveDeleteConfirm = null
}

// Table columns configuration - moved up to pass to useServerTable
const columns = reactive([
    codeColumn(__, { width: '11rem', trigger: 'enter' }),
    textFilterColumn(__, {
        label: 'Name',
        field: 'full_name',
        placeholderLabel: 'Name',
        trigger: 'enter',
        sortable: false,
        filterKey: 'name',
    }),
    textFilterColumn(__, {
        label: 'User Name',
        field: 'user_name',
        placeholderLabel: 'User Name',
        trigger: 'enter',
        sortable: false,
        filterKey: 'user_name',
    }),
    textFilterColumn(__, {
        label: 'Email',
        field: 'email',
        placeholderLabel: 'Email',
        trigger: 'enter',
        sortable: false,
    }),
    dropdownFilterColumn(__, {
        label: 'Role',
        field: 'role',
        items: props.roles.map(role => ({
            // Handle both formats: { value, text } or { id, name } for API flexibility
            value: role.value ?? role.id,
            text: role.text ?? role.name,
        })),
        filterKey: 'role',
        sortable: false,
    }),
    statusColumn(__, { width: '11rem' }),
    { label: __('Actions'), field: 'actions', sortable: false, width: '12rem' },
])

// Server table composable
const {
    serverParams,
    loading: tableLoading,
    onPageChange,
    onPerPageChange,
    onColumnFilter,
    onSortChange,
    onSearch,
    tableParams,
    loadItems,
} = useServerTable({
    page: 1,
    perPage: props.users.meta.pagination.per_page || 10,
    columns: columns, // Pass columns configuration
    resourceKeys: ['users', 'roles', 'userGroups'],
    routeName: 'users.index',
    labels: {
        pagination: { firstLabel: __('First'), lastLabel: __('Last'), nextLabel: __('Next'), prevLabel: __('Prev') },
        search: { placeholder: __('Search') + ' ' + __('records') + '...' },
    },
    searchDebounceMs: 0,
    searchTrigger: 'enter',
    paramMap: {
        page: 'page',
        perPage: 'per_page',
        search: 'search',
        sortBy: 'sortBy',
        sortOrder: 'sortOrder',
        filterPrefix: '',
    },
    onError: (_, message) =>
        toast({ severity: 'error', summary: __('Error'), detail: message || __('Failed to load data'), life: 3000 }),
})

// Computed properties
const title = computed(() => {
    return __('Users') + ' - ' + pageProps.general.app_name
})

const editingUserId = computed(() => {
    return editingUser.value && editingUser.value.id
})

const deleteUserWithConfirmation = async id => {
    // Find the user object for useAdminForm deleteItem method
    const user = props.users.data.find(u => u.id === id)

    if (!user) {
        console.error('User not found for deletion')
        return
    }

    // Create custom confirmation function using useConfirmToast service
    const customConfirmation = async () => {
        // Ask simple confirm first
        const ok = await confirm({
            header: __('Confirm Deletion'),
            message: __(
                "Do you want to delete this account? This action permanently erases the entire user's data, including exam sessions and subscriptions."
            ),
            icon: 'pi pi-exclamation-triangle',
            acceptClass: 'p-button-danger',
            acceptLabel: __('Continue'),
            rejectLabel: __('Cancel'),
        })
        if (!ok) return false
        // Then require typed confirmation in modal
        const typed = await requestTypedConfirm()
        if (!typed) {
            showErrorToast(__('The entered confirmation text is invalid.'))
        }
        return !!typed
    }

    // Use useAdminForm deleteItem with custom confirmation - it will use the configured deleteUrl
    const prevPage = serverParams.page
    const result = await deleteItem(user, null, customConfirmation)
    if (!result) {
        return
    }
    // After deletion, refresh table while preserving filters and pagination
    // Note: loadItems(true) preserves UI state - use loadItems(false) if artifacts persist
    await loadItems(true)
    // If current page becomes empty after deletion, navigate to previous page using fresh inertia props
    const freshUsers = usePage().props.users
    const currentPageCount = freshUsers?.data?.length ?? 0
    if (currentPageCount === 0 && prevPage > 1) {
        serverParams.page = prevPage - 1
        await loadItems(true)
    }
}

// Expose loadItems for external table refreshing
defineExpose({
    loadItems,
    refreshTable: loadItems, // Alias for clarity
})
</script>
