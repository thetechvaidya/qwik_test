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
                    <vue-good-table
                        mode="remote"
                        :pagination-options="options"
                        :columns="columns"
                        :total-rows="quizSchedules.meta.pagination.total"
                        :rows="quizSchedules.data"
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
                                    icon="pi pi-copy"
                                    class="w-full p-mr-2 text-sm cursor-pointer"
                                    @click="handleCopyClick(props.row.code)"
                                />
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
                                        <button class="action-item" @click="goToAnalytics(props.row.id)">{{
                                            __('Analytics')
                                        }}</button>
                                        <button
                                            class="action-item"
                                            @click="
                                                editForm = true
                                                currentId = props.row.id
                                            "
                                            >{{ __('Edit') }}</button
                                        >
                                        <button class="action-item" @click="deleteSchedule(props.row.id)">{{
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </div>

                            <!-- Remaining Fields Column -->
                            <span v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </span>
                        </template>

                        <template #emptystate>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Schedule') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </vue-good-table>

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
const { columns, options, onPageChange, onPerPageChange, onColumnFilter } = useServerTable()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
    return __('Quiz Schedules') + ' - ' + pageProps.general.app_name
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
        label: __('Quiz'),
        field: 'quiz',
        sortable: true,
        filterOptions: {
            enabled: true,
            placeholder: __('Filter by quiz'),
        },
    },
    {
        label: __('Type'),
        field: 'type',
        sortable: true,
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
        sortable: true,
        type: 'date',
    },
    {
        label: __('Ends At'),
        field: 'ends_at',
        sortable: true,
        type: 'date',
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: true,
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
        sortable: false,
        width: '120px',
    },
]

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
