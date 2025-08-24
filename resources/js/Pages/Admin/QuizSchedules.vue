<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Quiz') }} {{ __('Schedules') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? quiz.title : 'New Quiz'"
                    ></p>
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-end items-center mb-6">
                        <button class="qt-btn qt-btn-success" @click="createForm = true">
                            {{ __('New') }} {{ __('Schedule') }}
                        </button>
                    </div>
                    <DataTable
                        :value="data"
                        :totalRecords="totalRecords"
                        :loading="tableLoading"
                        lazy
                        paginator
                        :rows="10"
                        :rowsPerPageOptions="[10, 25, 50, 100]"
                        paginatorTemplate="FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown"
                        currentPageReportTemplate="Showing {first} to {last} of {totalRecords} entries"
                        sortMode="single"
                        filterDisplay="row"
                        v-model:filters="filters"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                    >
                        <Column v-for="col in columns" :key="col.field" :field="col.field" :header="col.label" :sortable="col.field !== 'actions'">
                            <template #filter="{ filterModel, filterCallback }" v-if="col.filterOptions?.enabled">
                                <InputText
                                    v-if="!col.filterOptions.filterDropdownItems"
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="col.filterOptions.placeholder"
                                    class="p-column-filter"
                                />
                                <Select
                                    v-else
                                    v-model="filterModel.value"
                                    :options="col.filterOptions.filterDropdownItems"
                                    optionLabel="text"
                                    optionValue="value"
                                    :placeholder="col.filterOptions.placeholder"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                />
                            </template>
                            <template #body="slotProps">
                                <!-- Code Column -->
                                <div v-if="slotProps.field === 'code'">
                                    <Tag
                                        :value="slotProps.data.code"
                                        icon="pi pi-copy"
                                        class="w-full p-mr-2 text-sm cursor-pointer"
                                        @click="handleCopyClick(slotProps.data.code)"
                                    />
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="slotProps.field === 'status'">
                                    <span
                                        :class="[slotProps.data.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                        >{{ __(slotProps.data.status) }}</span
                                    >
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="slotProps.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button class="action-item" @click="goToAnalytics(slotProps.data.id)">{{ 
                                                __('Analytics')
                                            }}</button>
                                            <button
                                                class="action-item"
                                                @click="
                                                    editForm = true;
                                                    currentId = slotProps.data.id;
                                                "
                                                >{{ __('Edit') }}</button
                                            >
                                            <button class="action-item" @click="deleteSchedule(slotProps.data.id)">{{ 
                                                __('Delete')
                                            }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>

                                <!-- Default Column -->
                                <span v-else>
                                    {{ slotProps.data[slotProps.field] }}
                                </span>
                            </template>
                        </Column>

                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Schedule') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <QuizScheduleForm
                            :form-errors="errors"
                            :user-groups="userGroups"
                            :quiz-id="quiz.id"
                            :title="__('New') + ' ' + __('Schedule')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <QuizScheduleForm
                            :edit-flag="editForm"
                            :quiz-schedule-id="currentId"
                            :form-errors="errors"
                            :quiz-id="quiz.id"
                            :user-groups="userGroups"
                            :title="__('Edit') + ' ' + __('Schedule')"
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
import { FilterMatchMode } from '@primevue/core/api'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import NoDataTable from '@/Components/NoDataTable.vue'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper.vue'
import QuizScheduleForm from '@/Components/Forms/QuizScheduleForm.vue'

// Props
const props = defineProps({
    quiz: {
        type: Object,
        required: true,
    },
    quizSchedules: {
        type: Object,
        required: true,
    },
    userGroups: {
        type: Array,
        default: () => [],
    },
    steps: {
        type: Array,
        default: () => [],
    },
    editFlag: {
        type: Boolean,
        default: false,
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

// Initialize filters for DataTable
const filters = ref({
    quiz: { value: null, matchMode: FilterMatchMode.CONTAINS },
    type: { value: null, matchMode: FilterMatchMode.EQUALS },
    status: { value: null, matchMode: FilterMatchMode.EQUALS }
})
// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Quiz Schedules') + ' - ' + pageProps.general.app_name
})

// Server table composable
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    resourceKeys: ['quizSchedules'],
    routeName: 'admin.quiz-schedules.index',
    columns: [
        {
            label: __('Code'),
            field: 'code',
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by code'),
            },
        },
        {
            label: __('Quiz'),
            field: 'quiz',
            filterOptions: {
                enabled: true,
                placeholder: __('Filter by quiz'),
            },
        },
        {
            label: __('Type'),
            field: 'type',
            filterOptions: {
                enabled: true,
                filterDropdownItems: [
                    { value: 'Fixed', text: __('Fixed') },
                    { value: 'Flexible', text: __('Flexible') },
                ],
                placeholder: __('Filter by type'),
            },
        },
        {
            label: __('Starts At'),
            field: 'starts_at',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: __('Ends At'),
            field: 'ends_at',
            filterOptions: {
                enabled: false,
            },
        },
        {
            label: __('Status'),
            field: 'status',
            filterOptions: {
                enabled: true,
                filterDropdownItems: [
                    { value: 'Active', text: __('Active') },
                    { value: 'Inactive', text: __('Inactive') },
                    { value: 'Expired', text: __('Expired') },
                ],
                placeholder: __('Filter by status'),
            },
        },
        {
            label: __('Actions'),
            field: 'actions',
            filterOptions: {
                enabled: false,
            },
        },
    ],
    initialParams: {
        page: 1,
        perPage: props.quizSchedules.meta.pagination.per_page || 10,
    },
})

// Methods
const handleCopyClick = code => {
    copyCode(code, __('Quiz schedule code copied to clipboard!'))
}

const goToAnalytics = id => {
    router.visit(route('admin.quiz-schedule.analytics', id))
}

const deleteSchedule = id => {
    confirm.require({
        message: __('Are you sure you want to delete this quiz schedule?'),
        header: __('Confirmation'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        accept: () => {
            router.delete(route('admin.quiz-schedules.destroy', id), {
                preserveScroll: true,
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Quiz schedule deleted successfully'),
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
