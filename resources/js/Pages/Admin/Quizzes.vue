<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Quizzes') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('quizzes.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Quiz') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <!-- Modern Enhanced Data Table for Quizzes -->
            <ModernDataTable
                :data="quizzes.data"
                :columns="tableColumns"
                :loading="tableLoading"
                :total-records="quizzes.meta?.pagination?.total || 0"
                :rows="tableRows"
                :first="tableFirst"
                :lazy="true"
                :show-global-search="true"
                :global-filter-fields="['code', 'title', 'category', 'quizType']"
                :search-placeholder="__('Search quizzes...')"
                :empty-message="__('No quizzes found')"
                :empty-description="__('Create your first quiz to get started')"
                :exportable="true"
                :export-filename="'quizzes'"
                :state-storage="'session'"
                :state-key="'admin_quizzes_table'"
                :table-style="{ minWidth: '1200px' }"
                :responsive-breakpoint="'768px'"
                data-key="id"
                @page="onPageChange"
                @sort="onSortChange"
                @filter="onFilterChange"
                @global-filter="onGlobalFilterChange"
                @row-click="onRowClick"
            >
                <!-- Custom Actions Slot -->
                <template #actions>
                    <div class="flex items-center gap-2">
                        <Button
                            icon="pi pi-refresh"
                            :label="__('Refresh')"
                            @click="refreshTable"
                            size="small"
                            severity="secondary"
                        />
                        <Button
                            icon="pi pi-download"
                            :label="__('Export')"
                            @click="exportTable"
                            size="small"
                            severity="info"
                        />
                        <Button
                            icon="pi pi-chart-bar"
                            :label="__('Analytics')"
                            @click="goToOverallAnalytics"
                            size="small"
                            severity="warning"
                        />
                    </div>
                </template>

                <!-- Custom Column Body Templates -->
                <template #body-code="{ data }">
                    <div class="flex items-center">
                        <code 
                            class="px-2 py-1 text-xs bg-blue-50 text-blue-800 rounded cursor-pointer hover:bg-blue-100 transition-colors border border-blue-200"
                            @click="copyCode(data.code)"
                            :title="'Click to copy: ' + data.code"
                        >
                            {{ data.code }}
                        </code>
                        <i class="pi pi-copy ml-2 text-gray-400 cursor-pointer hover:text-blue-600 transition-colors" 
                           @click="copyCode(data.code)"
                           title="Copy code"></i>
                    </div>
                </template>

                <template #body-title="{ data }">
                    <div class="flex items-center">
                        <div class="flex-1">
                            <div class="font-semibold text-gray-900 line-clamp-1">{{ data.title }}</div>
                            <div v-if="data.description" class="text-sm text-gray-500 line-clamp-1 mt-1">
                                {{ data.description }}
                            </div>
                        </div>
                    </div>
                </template>

                <template #body-category="{ data }">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-indigo-100 text-indigo-800">
                        <i class="pi pi-folder mr-1"></i>
                        {{ data.category }}
                    </span>
                </template>

                <template #body-quizType="{ data }">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                        <i class="pi pi-tag mr-1"></i>
                        {{ data.quizType }}
                    </span>
                </template>

                <template #body-questions="{ data }">
                    <div class="text-center">
                        <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-gray-100 text-gray-800">
                            <i class="pi pi-question-circle mr-1"></i>
                            {{ data.questions || 0 }}
                        </span>
                    </div>
                </template>

                <template #body-status="{ data }">
                    <span
                        :class="[
                            data.status === 'Published' || data.status === 'published'
                                ? 'bg-green-100 text-green-800 border-green-200' 
                                : 'bg-yellow-100 text-yellow-800 border-yellow-200',
                            'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border'
                        ]"
                    >
                        <i :class="[
                            data.status === 'Published' || data.status === 'published' 
                                ? 'pi pi-check-circle' 
                                : 'pi pi-clock', 
                            'mr-1'
                        ]"></i>
                        {{ __(data.status) }}
                    </span>
                </template>

                <template #body-actions="{ data }">
                    <div class="flex items-center justify-center gap-1">
                        <Button
                            icon="pi pi-pencil"
                            @click="editQuiz(data.id)"
                            size="small"
                            severity="success"
                            :title="__('Edit')"
                        />
                        <Button
                            icon="pi pi-calendar"
                            @click="goToSchedules(data.id)"
                            size="small"
                            severity="info"
                            :title="__('Schedules')"
                        />
                        <Button
                            icon="pi pi-chart-line"
                            @click="goToAnalytics(data.id)"
                            size="small"
                            severity="warning"
                            :title="__('Analytics')"
                        />
                        <Button
                            icon="pi pi-trash"
                            @click="deleteQuiz(data.id)"
                            size="small"
                            severity="danger"
                            :title="__('Delete')"
                        />
                    </div>
                </template>

                <!-- Empty State Actions -->
                <template #emptyActions>
                    <div class="flex gap-2">
                        <Button
                            :label="__('Create Quiz')"
                            icon="pi pi-plus"
                            @click="$inertia.visit(route('quizzes.create'))"
                            severity="primary"
                        />
                        <Button
                            :label="__('View Templates')"
                            icon="pi pi-file"
                            @click="showTemplates"
                            severity="secondary"
                        />
                    </div>
                </template>
            </ModernDataTable>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref, onMounted } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ModernDataTable from '@/Components/DataTable/ModernDataTable.vue'
import Button from 'primevue/button'
import { useToast } from 'primevue/usetoast'
import { textColumn, statusColumn, codeColumn } from '@/Components/DataTable/columns'

const props = defineProps({
    quizzes: Object,
    quizTypes: Array,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyToClipboard } = useCopy()
const { confirm } = useConfirmToast()
const toast = useToast()

// Enhanced Table Configuration
const tableColumns = computed(() => [
    codeColumn('code', {
        header: __('Code'),
        filterPlaceholder: __('Search code...'),
        style: { width: '140px' },
        responsivePriority: 1
    }),
    textColumn('title', {
        header: __('Title'),
        filterPlaceholder: __('Search titles...'),
        style: { maxWidth: '300px', fontWeight: 'medium' },
        responsivePriority: 2
    }),
    textColumn('category', {
        header: __('Category'),
        filterPlaceholder: __('Search categories...'),
        style: { width: '150px' },
        responsivePriority: 4
    }),
    textColumn('quizType', {
        header: __('Type'),
        filterField: 'quiz_type',
        filterOptions: {
            type: 'dropdown',
            options: (props.quizTypes || []).map(t => ({ 
                label: t.name || t.text, 
                value: t.id || t.value 
            })),
            optionLabel: 'label',
            optionValue: 'value',
            placeholder: __('Filter by type...')
        },
        style: { width: '130px' },
        responsivePriority: 5
    }),
    {
        field: 'questions',
        header: __('Questions'),
        sortable: false,
        style: { width: '100px', textAlign: 'center' },
        responsivePriority: 6
    },
    statusColumn('status', {
        header: __('Status'),
        statusOptions: [
            { label: __('Published'), value: 'Published' },
            { label: __('Draft'), value: 'Draft' }
        ],
        style: { width: '120px' },
        responsivePriority: 3
    }),
    {
        field: 'actions',
        header: __('Actions'),
        sortable: false,
        style: { width: '180px', textAlign: 'center' },
        responsivePriority: 7
    }
])

// Modern DataTable state
const tableLoading = ref(false)
const tableRows = ref(props.quizzes?.meta?.pagination?.per_page || 10)
const tableFirst = ref(0)

const title = computed(() => {
    return __('Quizzes') + ' - ' + pageProps.general.app_name
})

// Event Handlers for Modern DataTable
const onPageChange = (event) => {
    tableFirst.value = event.first
    tableRows.value = event.rows
    loadQuizzesData()
}

const onSortChange = (event) => {
    loadQuizzesData({
        sortField: event.sortField,
        sortOrder: event.sortOrder
    })
}

const onFilterChange = (event) => {
    tableFirst.value = 0 // Reset to first page
    loadQuizzesData({
        filters: event.filters
    })
}

const onGlobalFilterChange = (value) => {
    tableFirst.value = 0 // Reset to first page
    loadQuizzesData({
        globalFilter: value
    })
}

const onRowClick = (event) => {
    // Optional: Open quiz details on row click
    // editQuiz(event.data.id)
}

// Data Loading
const loadQuizzesData = async (params = {}) => {
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
        
        await router.get(route('quizzes.index'), queryParams, {
            preserveState: true,
            preserveScroll: true,
            only: ['quizzes', 'quizTypes'],
            onFinish: () => {
                tableLoading.value = false
            }
        })
    } catch (error) {
        tableLoading.value = false
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load quizzes'),
            life: 3000
        })
    }
}

// Copy code functionality
const copyCode = async (code) => {
    try {
        await copyToClipboard(code)
        toast.add({
            severity: 'success',
            summary: __('Success'),
            detail: __('Code copied to clipboard'),
            life: 2000
        })
    } catch (error) {
        console.error('Error copying code:', error)
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to copy code'),
            life: 3000
        })
    }
}

// Quiz Management Methods
const editQuiz = (id) => {
    router.get(route('quizzes.edit', { quiz: id }))
}

const goToSchedules = (id) => {
    router.get(route('quizzes.schedules.index', { quiz: id }))
}

const goToAnalytics = (id) => {
    router.get(route('quizzes.overall_report', { quiz: id }))
}

const goToOverallAnalytics = () => {
    // Navigate to overall analytics page if available
    // router.get(route('admin.analytics.quizzes'))
    toast.add({
        severity: 'info',
        summary: __('Info'),
        detail: __('Overall analytics feature coming soon'),
        life: 3000
    })
}

const deleteQuiz = async (id) => {
    const confirmed = await confirm({
        header: __('Confirm Delete'),
        message: __('This will remove all user sessions. Do you want to delete this quiz?'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })
    
    if (!confirmed) return
    
    router.delete(route('quizzes.destroy', { quiz: id }), {
        onSuccess: () => {
            toast.add({
                severity: 'success',
                summary: __('Success'),
                detail: __('Quiz deleted successfully'),
                life: 3000
            })
            loadQuizzesData()
        },
        onError: () => {
            toast.add({
                severity: 'error',
                summary: __('Error'),
                detail: __('Failed to delete quiz'),
                life: 3000
            })
        }
    })
}

// Table Utility Methods
const refreshTable = () => {
    loadQuizzesData()
}

const exportTable = () => {
    // This will be handled by the ModernDataTable component
    // The component will export the current table data as CSV
}

const showTemplates = () => {
    toast.add({
        severity: 'info',
        summary: __('Info'),
        detail: __('Quiz templates feature coming soon'),
        life: 3000
    })
}

// Initialize component
onMounted(() => {
    // Component is ready
})
</script>
