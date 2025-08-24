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
                    <DataTable
                        :value="data"
                        dataKey="id"
                        lazy
                        paginator
                        :rows="10"
                        :totalRecords="totalRecords"
                        :rowsPerPageOptions="[10, 20, 50]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        sortMode="single"
                        filterDisplay="row"
                        :globalFilterFields="['code', 'full_name', 'user_name', 'email', 'role', 'status']"
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        :class="{ 'rtl': $page.props.rtl }"
                    >
                        <!-- Define columns -->
                        <Column v-for="col in columns" :key="col.field" :field="col.field" :header="col.label" :sortable="col.sortable !== false">
                            <template #body="slotProps" v-if="col.field === 'code'">
                                <Tag :key="slotProps.data.id || slotProps.index" class="w-full p-mr-2 cursor-pointer" @click="copyCode(slotProps.data.code)">
                                    <i class="pi pi-copy mr-2" />
                                    {{ slotProps.data.code }}
                                </Tag>
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'status'">
                                <span :class="[slotProps.data.status ? 'badge-success' : 'badge-danger', 'badge']">
                                    {{ slotProps.data.status ? __('Active') : __('In-active') }}
                                </span>
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'actions'">
                                <ActionsDropdown :key="slotProps.data.id || slotProps.index">
                                    <template #actions>
                                        <button class="action-item" @click="openEditForm(slotProps.data)">{{ __('Edit') }}</button>
                                        <button class="action-item" @click="deleteUserWithConfirmation(slotProps.data.id)">{{ __('Delete') }}</button>
                                    </template>
                                </ActionsDropdown>
                            </template>
                            <template #filter="{ filterModel, filterCallback }" v-if="col.filterKey">
                                <InputText v-model="filterModel.value" @input="filterCallback()" :placeholder="col.placeholder || col.label" />
                            </template>
                        </Column>
                        
                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="openCreateForm()">
                                        {{ __('New') }} {{ __('User') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

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
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
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

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['users', 'roles', 'userGroups'],
    routeName: 'users.index',
    columns: [
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
            field: 'full_name',
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('Name'),
                filterValue: null,
                trigger: 'enter',
            },
            sortable: false,
            filterKey: 'name',
        },
        {
            label: __('User Name'),
            field: 'user_name',
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('User Name'),
                filterValue: null,
                trigger: 'enter',
            },
            sortable: false,
        },
        {
            label: __('Email'),
            field: 'email',
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('Email'),
                filterValue: null,
                trigger: 'enter',
            },
            sortable: false,
        },
        {
            label: __('Role'),
            field: 'role',
            filterOptions: {
                enabled: true,
                placeholder: __('Search') + ' ' + __('Role'),
                filterValue: null,
                filterDropdownItems: props.roles.map(role => ({
                    value: role.value ?? role.id,
                    text: role.text ?? role.name,
                })),
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
    ],
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
    const user = data.value.find(u => u.id === id)

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
    const result = await deleteItem(user, null, customConfirmation)
    if (!result) {
        return
    }
}
</script>
