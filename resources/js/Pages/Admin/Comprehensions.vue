<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Comprehensions') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Comprehension') }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="comprehensions.meta.pagination.total"
                        :rows="comprehensions.data"
                        :rtl="$page.props.rtl"
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
                                    @click="copyCode(props.row.code)"
                                />
                            </div>

                            <!-- Body Column -->
                            <div v-else-if="props.column.field === 'body'" v-html="props.row.body"> </div>

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
                                        <button class="action-item" @click="deleteComprehension(props.row.id)">{{
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </div>

                            <!-- Remaining Columns -->
                            <div v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </div>
                        </template>
                    </vue-good-table>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <ComprehensionForm
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Comprehension')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <ComprehensionForm
                            v-model:edit-flag="editForm"
                            :comprehension-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Comprehension')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import { Head, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ComprehensionForm from '@/Components/Forms/ComprehensionForm'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import ActionsDropdown from '@/Components/ActionsDropdown'

const props = defineProps({
    comprehensions: Object,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// State
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table configuration
const { onPageChange, onPerPageChange, onColumnFilter, tableParams } = useServerTable({
    page: props.comprehensions.meta.pagination.current_page,
    perPage: props.comprehensions.meta.pagination.per_page,
    resourceKeys: ['comprehensions'],
})

const columns = ref([
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
    },
    {
        label: __('Body'),
        field: 'body',
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
                { value: 1, text: __('Published') },
                { value: 0, text: __('Draft') },
            ],
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
    },
])

const title = computed(() => {
    return __('Comprehensions') + ' - ' + pageProps.general.app_name
})

const deleteComprehension = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('comprehensions.destroy', { comprehension: id }), {
                    onSuccess: () => {
                        if (window.$toast) {
                            window.$toast.add({
                                severity: 'info',
                                summary: __('Confirmed'),
                                detail: __('Record deleted'),
                                life: 3000,
                            })
                        }
                    },
                })
            },
            reject: () => {
                // Do nothing on reject
            },
        })
    }
}
</script>
