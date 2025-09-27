<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Questions') }}</h4>
        </template>
        <template #actions>
            <div class="flex gap-4 items-center">
                <Link :href="route('initiate_import_questions')" class="qt-btn qt-btn-primary">
                    {{ __('Import Questions') }}
                </Link>
                <ArcDropdown align="right" width="48">
                    <template #trigger>
                        <button class="qt-btn qt-btn-success"> 
                            {{ __('New') }} {{ __('Question') }} 
                        </button>
                    </template>
                    <template #content>
                        <div v-if="!questionTypes || questionTypes.length === 0" class="px-4 py-3 text-sm">
                            <div class="text-gray-500 mb-2">{{ __('No question types available') }}</div>
                            <Link 
                                :href="route('question_types.index')" 
                                class="text-blue-600 hover:text-blue-800 text-xs underline"
                            >
                                {{ __('Manage Question Types') }}
                            </Link>
                        </div>
                        <template v-for="questionType in questionTypes" :key="questionType.code">
                            <button 
                                class="dropdown-link w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors flex items-center"
                                @click="createQuestion(questionType.code)"
                            >
                                <i class="pi pi-plus-circle mr-2 text-green-600"></i>
                                {{ questionType.text || questionType.name }}
                            </button>
                        </template>
                    </template>
                </ArcDropdown>
            </div>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <!-- Modern Enhanced Data Table -->
            <ModernDataTable
                :data="questions.data"
                :columns="tableColumns"
                :loading="tableLoading"
                :total-records="questions.meta?.pagination?.total || 0"
                :rows="tableRows"
                :first="tableFirst"
                :lazy="true"
                :show-global-search="true"
                :global-filter-fields="['code', 'question', 'section', 'skill', 'topic']"
                :search-placeholder="__('Search questions...')"
                :empty-message="__('No questions found')"
                :empty-description="__('Create your first question to get started')"
                :exportable="true"
                :export-filename="'questions'"
                :state-storage="'session'"
                :state-key="'admin_questions_table'"
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

                <template #body-question="{ data }">
                    <div class="max-w-md">
                        <div
                            class="py-2 px-3 bg-gray-50 rounded-lg border-l-4 border-blue-500 text-sm leading-relaxed line-clamp-3"
                            v-html="sanitizedAndValidatedQuestion(data.question)"
                            :title="getPlainTextQuestion(data.question)"
                        ></div>
                    </div>
                </template>

                <template #body-questionType="{ data }">
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium bg-purple-100 text-purple-800">
                        <i class="pi pi-tag mr-1"></i>
                        {{ data.questionType }}
                    </span>
                </template>

                <template #body-status="{ data }">
                    <span
                        :class="[
                            data.status === 1 
                                ? 'bg-green-100 text-green-800 border-green-200' 
                                : 'bg-red-100 text-red-800 border-red-200',
                            'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium border'
                        ]"
                    >
                        <i :class="[data.status === 1 ? 'pi pi-check-circle' : 'pi pi-times-circle', 'mr-1']"></i>
                        {{ data.status === 1 ? __('Active') : __('Inactive') }}
                    </span>
                </template>

                <template #body-actions="{ data }">
                    <div class="flex items-center justify-center gap-1">
                        <Button
                            icon="pi pi-eye"
                            @click="openPreview(data.id)"
                            size="small"
                            severity="info"
                            :title="__('Preview')"
                        />
                        <Button
                            icon="pi pi-pencil"
                            @click="editQuestion(data.id)"
                            size="small"
                            severity="success"
                            :title="__('Edit')"
                        />
                        <Button
                            icon="pi pi-trash"
                            @click="deleteQuestion(data.id)"
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
                            :label="__('Create Question')"
                            icon="pi pi-plus"
                            @click="showQuestionTypeMenu = true"
                            severity="primary"
                        />
                        <Button
                            :label="__('Import Questions')"
                            icon="pi pi-upload"
                            @click="$inertia.visit(route('initiate_import_questions'))"
                            severity="secondary"
                        />
                    </div>
                </template>
            </ModernDataTable>

            <!-- Question Type Selection Menu -->
            <Menu
                v-model:visible="showQuestionTypeMenu"
                :model="questionTypeMenuItems"
                :popup="true"
                ref="questionTypeMenu"
            />

            <!-- Question Preview Drawer -->
            <Drawer 
                v-model:visible="showPreview" 
                position="right" 
                class="p-drawer-lg"
                :dismissable="true"
                :close-on-escape="true"
                @hide="closePreview"
            >
                <template #header>
                    <div class="flex items-center gap-2">
                        <i class="pi pi-eye text-blue-600"></i>
                        <span class="font-semibold">{{ __('Question Preview') }}</span>
                    </div>
                </template>
                
                <QuestionPreview
                    v-if="showPreview && currentQuestionId"
                    :question-id="currentQuestionId"
                    @close="closePreview"
                />
            </Drawer>
        </div>
        
        <!-- Debug Component -->
        <QuestionTypesDebug :question-types="questionTypes" />
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch, onBeforeUnmount } from 'vue';
import { Head, Link, usePage, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import ArcDropdown from '@/Components/Dropdown.vue';
import ModernDataTable from '@/Components/DataTable/ModernDataTable.vue';
import QuestionPreview from '@/Pages/Admin/Question/Preview.vue';
import Button from 'primevue/button';
import Drawer from 'primevue/drawer';
import Menu from 'primevue/menu';
import { useTranslate } from '@/composables/useTranslate';
import { useModernDataTable } from '@/composables/useModernDataTable';
import { useCopy } from '@/composables/useCopy';
import { useMathRender } from '@/composables/useMathRender';
import { useConfirmToast } from '@/composables/useConfirmToast';
import { sanitizeHtml, validateContent } from '@/utils/security';
import { textColumn, statusColumn, codeColumn, actionsColumn } from '@/Components/DataTable/columns';
import QuestionTypesDebug from '@/Components/Debug/QuestionTypesDebug.vue';

// Props
const props = defineProps({
    questionTypes: { type: Array, default: () => [] },
    questions: { type: Object, default: () => ({ data: [], meta: { pagination: { per_page: 10 } } }) },
    sections: { type: Array, default: () => [] },
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyToClipboard } = useCopy()
const { renderMathInTable } = useMathRender()
const { confirm, toast } = useConfirmToast()

// Enhanced Table Configuration
const tableColumns = computed(() => [
    codeColumn('code', {
        header: __('Code'),
        filterPlaceholder: __('Search code...'),
        style: { width: '140px' },
        responsivePriority: 1
    }),
    textColumn('question', {
        header: __('Question'),
        filterPlaceholder: __('Search questions...'),
        style: { maxWidth: '400px' },
        responsivePriority: 2
    }),
    textColumn('questionType', {
        header: __('Type'),
        filterField: 'question_type',
        filterOptions: {
            type: 'dropdown',
            options: (props.questionTypes || []).map(t => ({ 
                label: t.text || t.name, 
                value: t.code 
            })),
            optionLabel: 'label',
            optionValue: 'value',
            placeholder: __('Filter by type...')
        },
        style: { width: '150px' },
        responsivePriority: 4
    }),
    textColumn('section', {
        header: __('Section'),
        filterPlaceholder: __('Search sections...'),
        style: { width: '150px' },
        responsivePriority: 5
    }),
    textColumn('skill', {
        header: __('Skill'),
        filterPlaceholder: __('Search skills...'),
        style: { width: '150px' },
        responsivePriority: 6
    }),
    textColumn('topic', {
        header: __('Topic'),
        filterPlaceholder: __('Search topics...'),
        style: { width: '150px' },
        responsivePriority: 7
    }),
    statusColumn('status', {
        header: __('Status'),
        statusOptions: [
            { label: __('Active'), value: 1 },
            { label: __('Inactive'), value: 0 }
        ],
        style: { width: '120px' },
        responsivePriority: 3
    }),
    {
        field: 'actions',
        header: __('Actions'),
        sortable: false,
        style: { width: '140px', textAlign: 'center' },
        responsivePriority: 8
    }
])

// Modern DataTable state
const tableLoading = ref(false)
const tableRows = ref(props.questions?.meta?.pagination?.per_page || 10)
const tableFirst = ref(0)
const showPreview = ref(false)
const currentQuestionId = ref(null)
const showQuestionTypeMenu = ref(false)
const questionTypeMenu = ref(null)

// Question Type Menu Items
const questionTypeMenuItems = computed(() => {
    if (!props.questionTypes || props.questionTypes.length === 0) {
        return [{
            label: __('No question types available'),
            icon: 'pi pi-exclamation-triangle',
            disabled: true,
            command: () => {
                toast.add({
                    severity: 'warn',
                    summary: __('Warning'),
                    detail: __('Please create question types first'),
                    life: 3000
                })
            }
        }]
    }
    
    return (props.questionTypes || []).map(type => ({
        label: type.text || type.name,
        icon: 'pi pi-plus-circle',
        command: () => createQuestion(type.code)
    }))
})

const title = computed(() => {
    return __('Questions') + ' - ' + pageProps.general.app_name
});

// Enhanced Security and Content Handling
const sanitizedAndValidatedQuestion = (question) => {
    if (!validateContent(question)) {
        console.warn('Invalid content detected:', question);
        return 'Invalid content';
    }
    return sanitizeHtml(question);
};

// Helper function to get plain text from HTML
const getPlainTextQuestion = (htmlContent) => {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;
    return tempDiv.textContent || tempDiv.innerText || '';
};

// Event Handlers for Modern DataTable
const onPageChange = (event) => {
    tableFirst.value = event.first
    tableRows.value = event.rows
    loadQuestionsData()
}

const onSortChange = (event) => {
    loadQuestionsData({
        sortField: event.sortField,
        sortOrder: event.sortOrder
    })
}

const onFilterChange = (event) => {
    tableFirst.value = 0 // Reset to first page
    loadQuestionsData({
        filters: event.filters
    })
}

const onGlobalFilterChange = (value) => {
    tableFirst.value = 0 // Reset to first page
    loadQuestionsData({
        globalFilter: value
    })
}

const onRowClick = (event) => {
    // Optional: Open preview on row click
    // openPreview(event.data.id)
}

// Data Loading
const loadQuestionsData = async (params = {}) => {
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
        
        await router.get(route('questions.index'), queryParams, {
            preserveState: true,
            preserveScroll: true,
            only: ['questions', 'questionTypes', 'sections'],
            onFinish: () => {
                tableLoading.value = false
            }
        })
    } catch (error) {
        tableLoading.value = false
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load questions'),
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

// Question Management Methods
const openPreview = (id) => {
    currentQuestionId.value = id
    showPreview.value = true
}

const closePreview = () => {
    showPreview.value = false
    currentQuestionId.value = null
}

const createQuestion = (questionType) => {
    try {
        router.get(route('questions.create', { question_type: questionType }))
    } catch (error) {
        console.error('Error creating question:', error)
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to create question'),
            life: 3000
        })
    }
}

const editQuestion = (id) => {
    try {
        router.get(route('questions.edit', { question: id }))
    } catch (error) {
        console.error('Error editing question:', error)
        toast.add({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to edit question'),
            life: 3000
        })
    }
}

const deleteQuestion = async (id) => {
    const confirmed = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this question? This action cannot be undone.'),
        icon: 'pi pi-exclamation-triangle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })
    
    if (!confirmed) return
    
    router.delete(route('questions.destroy', { question: id }), {
        onSuccess: () => {
            toast.add({
                severity: 'success',
                summary: __('Success'),
                detail: __('Question deleted successfully'),
                life: 3000
            })
            loadQuestionsData()
        },
        onError: () => {
            toast.add({
                severity: 'error',
                summary: __('Error'),
                detail: __('Failed to delete question'),
                life: 3000
            })
        }
    })
}

// Table Utility Methods
const refreshTable = () => {
    loadQuestionsData()
}

const exportTable = () => {
    // This will be handled by the ModernDataTable component
    // The component will export the current table data as CSV
}

// Debug function to check question types
const debugQuestionTypes = () => {
    console.log('Question Types Debug:', {
        questionTypes: props.questionTypes,
        length: props.questionTypes?.length,
        firstType: props.questionTypes?.[0]
    })
    
    toast.add({
        severity: 'info',
        summary: __('Debug Info'),
        detail: __('Check console for question types data'),
        life: 3000
    })
}

// Initialize component
onMounted(() => {
    // Debug question types on mount
    if (import.meta.env.DEV) {
        debugQuestionTypes()
    }
})
</script>
