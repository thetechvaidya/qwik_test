<template>
    <app-layout>
        <template #header>
            <h1 class="app-heading">{{ __('My Quizzes') }}</h1>
        </template>
        <div class="w-full my-6">
            <progress-navigator :steps="steps"></progress-navigator>
        </div>
        <div class="card">
            <div class="card-body">
                <ModernDataTable
                    :value="quizSessions.data"
                    :columns="tableColumns"
                    :totalRecords="quizSessions.meta.pagination.total"
                    :loading="tableLoading"
                    :rows="tableRows"
                    :first="tableFirst"
                    :rowsPerPageOptions="[10, 20, 50, 100]"
                    showGridlines
                    stripedRows
                    responsiveLayout="scroll"
                    :globalFilterFields="['name', 'status']"
                    exportFilename="my-quizzes"
                    @page="onPageChange"
                    @sort="onSortChange"
                    @filter="onFilterChange"
                    @global-filter="onGlobalFilterChange"
                    @row-click="onRowClick"
                >
                    <!-- Quiz Name Column -->
                    <template #name="slotProps">
                        <div class="flex items-center">
                            <div class="flex-1 min-w-0">
                                <div class="font-medium text-gray-900 dark:text-white truncate">
                                    {{ slotProps.data.name }}
                                </div>
                            </div>
                        </div>
                    </template>

                    <!-- Completed Column -->
                    <template #completed="slotProps">
                        <div class="text-center">
                            <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium"
                                :class="slotProps.data.completed === 'Yes' ? 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200' : 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200'">
                                {{ __(slotProps.data.completed) }}
                            </span>
                        </div>
                    </template>

                    <!-- Percentage Column -->
                    <template #percentage="slotProps">
                        <div class="text-center">
                            <div class="flex items-center justify-center space-x-2">
                                <span class="font-semibold" 
                                    :class="parseFloat(slotProps.data.percentage) >= 50 ? 'text-green-600 dark:text-green-400' : 'text-red-600 dark:text-red-400'">
                                    {{ slotProps.data.percentage }}%
                                </span>
                            </div>
                        </div>
                    </template>

                    <!-- Score Column -->
                    <template #score="slotProps">
                        <div class="text-center font-medium text-gray-900 dark:text-white">
                            {{ slotProps.data.score }}
                        </div>
                    </template>

                    <!-- Status Column -->
                    <template #status="slotProps">
                        <div class="text-center">
                            <StatusBadge
                                :status="slotProps.data.status"
                                :variant="slotProps.data.status === 'Passed' ? 'success' : 'danger'"
                                size="sm"
                            />
                        </div>
                    </template>

                    <!-- Actions Column -->
                    <template #actions="slotProps">
                        <div class="flex justify-center space-x-2">
                            <Button
                                :label="__('Results')"
                                icon="pi pi-eye"
                                size="small"
                                severity="success"
                                outlined
                                @click="viewResults(slotProps.data)"
                                class="!px-3 !py-1.5 !text-xs"
                            />
                        </div>
                    </template>

                    <!-- Empty State -->
                    <template #empty>
                        <div class="text-center py-12">
                            <i class="pi pi-inbox text-6xl text-gray-300 dark:text-gray-600 mb-4"></i>
                            <h3 class="text-lg font-medium text-gray-900 dark:text-white mb-2">
                                {{ __('No quiz sessions found') }}
                            </h3>
                            <p class="text-gray-500 dark:text-gray-400 mb-6">
                                {{ __('You haven\'t taken any quizzes yet.') }}
                            </p>
                            <Link
                                :href="route('home')"
                                class="qt-btn qt-btn-primary"
                            >
                                {{ __('Browse Quizzes') }}
                            </Link>
                        </div>
                    </template>
                </ModernDataTable>
            </div>
        </div>
    </app-layout>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AppLayout from '@/Layouts/AppLayout.vue'
import ProgressNavigator from '@/Components/Stepper/ProgressNavigator'
import ModernDataTable from '@/Components/DataTable/ModernDataTable.vue'
import Button from 'primevue/button'
import { useToast } from 'primevue/usetoast'
import { textColumn, statusColumn, StatusBadge } from '@/Components/DataTable/columns'

const props = defineProps({
    quizSessions: Object,
    steps: Array,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const toast = useToast()

// Enhanced Table Configuration
const tableColumns = computed(() => [
    textColumn('name', {
        header: __('Quiz') + ' ' + __('Name'),
        filterPlaceholder: __('Search quiz names...'),
        style: { maxWidth: '300px', fontWeight: 'medium' },
        responsivePriority: 1
    }),
    {
        field: 'completed',
        header: __('Completed'),
        sortable: false,
        style: { width: '120px', textAlign: 'center' },
        responsivePriority: 4
    },
    {
        field: 'percentage',
        header: __('Percentage'),
        sortable: false,
        style: { width: '120px', textAlign: 'center' },
        responsivePriority: 2
    },
    {
        field: 'score',
        header: __('Score'),
        sortable: false,
        style: { width: '100px', textAlign: 'center' },
        responsivePriority: 3
    },
    statusColumn('status', {
        header: __('Status'),
        statusOptions: [
            { label: __('Passed'), value: 'Passed' },
            { label: __('Failed'), value: 'Failed' }
        ],
        style: { width: '120px' },
        responsivePriority: 2
    }),
    {
        field: 'actions',
        header: __('Actions'),
        sortable: false,
        style: { width: '120px', textAlign: 'center' },
        responsivePriority: 5
    }
])

// Modern DataTable State
const tableLoading = ref(false)
const tableRows = ref(props.quizSessions?.meta?.pagination?.per_page || 10)
const tableFirst = ref(0)

const title = computed(() => {
    return __('My Quizzes') + ' - ' + pageProps.general.app_name
})

// Event Handlers for Modern DataTable
const onPageChange = (event) => {
    tableFirst.value = event.first
    tableRows.value = event.rows
    loadQuizSessionsData()
}

const onSortChange = (event) => {
    loadQuizSessionsData({
        sortField: event.sortField,
        sortOrder: event.sortOrder
    })
}

const onFilterChange = (event) => {
    tableFirst.value = 0 // Reset to first page
    loadQuizSessionsData({
        filters: event.filters
    })
}

const onGlobalFilterChange = (value) => {
    tableFirst.value = 0 // Reset to first page
    loadQuizSessionsData({
        globalFilter: value
    })
}

const onRowClick = (event) => {
    // Optional: View results on row click
    viewResults(event.data)
}

// Data Loading
const loadQuizSessionsData = async (params = {}) => {
    tableLoading.value = true
    
    try {
        const queryParams = {
            page: Math.floor(tableFirst.value / tableRows.value) + 1,
            per_page: tableRows.value,
            ...params
        }
        
        // Handle sorting
        if (params.sortField && params.sortOrder) {
            queryParams.sort_by = params.sortField
            queryParams.sort_order = params.sortOrder === 1 ? 'asc' : 'desc'
        }
        
        // Handle global search
        if (params.globalFilter) {
            queryParams.search = params.globalFilter
        }
        
        // Handle column filters
        if (params.filters) {
            Object.keys(params.filters).forEach(key => {
                if (key !== 'global' && params.filters[key]?.value) {
                    queryParams[`filter_${key}`] = params.filters[key].value
                }
            })
        }
        
        await router.get(route('my_quizzes'), queryParams, {
            preserveState: true,
            preserveScroll: true,
            only: ['quizSessions'],
            onFinish: () => {
                tableLoading.value = false
            }
        })
    } catch (error) {
        tableLoading.value = false
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load quiz sessions'),
            life: 3000
        })
    }
}

// Quiz Session Actions
const viewResults = (quizSession) => {
    router.get(route('quiz_results', { 
        quiz: quizSession.slug, 
        session: quizSession.id 
    }))
}

const refreshTable = () => {
    loadQuizSessionsData()
}

// Initialize component
onMounted(() => {
    // Component is ready
})
</script>
