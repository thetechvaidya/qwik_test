<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Plans') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true"> {{ __('New') }} {{ __('Plan') }} </button>
        </template>

        <div class="container mx-auto py-10 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="plans.data"
                        :lazy="tableParams.lazy"
                        :paginator="tableParams.paginator"
                        :rows="tableParams.rows"
                        :totalRecords="plans.meta.pagination.total"
                        :rowsPerPageOptions="tableParams.rowsPerPageOptions"
                        :paginatorTemplate="tableParams.paginatorTemplate"
                        :currentPageReportTemplate="tableParams.currentPageReportTemplate"
                        :sortMode="tableParams.sortMode"
                        :filterDisplay="tableParams.filterDisplay"
                        :globalFilterFields="tableParams.globalFilterFields"
                        :loading="tableLoading"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        :class="{ 'rtl': pageProps.rtl }"
                    >
                        <Column v-for="column in columns" :key="column.field" :field="column.field" :header="column.label" :sortable="column.sortable" :filterField="column.filterKey">
                            <template #filter="{ filterModel, filterCallback }" v-if="column.filterKey">
                                <InputText v-model="filterModel.value" @input="filterCallback()" placeholder="Search..." />
                            </template>
                            <template #body="slotProps">
                                <!-- Code Column -->
                                <div v-if="column.field === 'code'">
                                    <Tag
                                        :value="slotProps.data.code"
                                        class="w-full p-mr-2 cursor-pointer"
                                        @click="copyCode(slotProps.data.code)"
                                    >
                                        <i class="pi pi-copy mr-2" />{{ slotProps.data.code }}
                                    </Tag>
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="column.field === 'status'">
                                    <span :class="[slotProps.data.status ? 'badge-success' : 'badge-danger', 'badge']">{{ slotProps.data.status ? __('Active') : __('In-active') }}</span>
                                </div>

                                <!-- Action Column -->
                                <div v-else-if="column.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    editForm = true;
                                                    currentId = slotProps.data.id;
                                                "
                                                >{{ __('Edit') }}</button
                                            >
                                            <button class="action-item" @click="deletePlan(slotProps.data.id)">{{ __('Delete') }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Remaining Columns -->
                                <span v-else>
                                    {{ slotProps.data[column.field] }}
                                </span>
                            </template>
                        </Column>
                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Plan') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <PlanForm
                            :form-errors="errors"
                            :sub-categories="subCategories"
                            :features="features"
                            :title="__('New') + ' ' + __('Plan')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <PlanForm
                            v-model:edit-flag="editForm"
                            :sub-categories="subCategories"
                            :plan-id="currentId"
                            :features="features"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Plan')"
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
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import PlanForm from '@/Components/Forms/PlanForm.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'

// Props
const props = defineProps({
    plans: Object,
    errors: Object,
    subCategories: Array,
    features: Array,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

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
        label: __('Duration'),
        field: 'duration',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Duration'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Price') + '/' + __('Month'),
        field: 'price',
        sortable: false,
    },
    {
        label: __('Category'),
        field: 'category',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Category'),
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
    perPage: props.plans.meta.pagination.per_page,
    setCurrentPage: props.plans.meta.pagination.current_page,
    perPageDropdown: [10, 20, 50, 100],
    dropdownAllowAll: false,
})

// Server table composable
const { onPage, onSort, onFilter, tableLoading } = useServerTable({
    resourceKeys: ['plans', 'subCategories', 'features'],
    routeName: 'plans.index',
})

// Computed
const title = computed(() => {
    return __('Plans') + ' - ' + pageProps.general.app_name
})

// Methods
const deletePlan = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __(
            'This action will remove all associated payments & subscriptions. Do you want to delete this plan?'
        ),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })

    if (ok) {
        router.delete(route('plans.destroy', { plan: id }), {
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
