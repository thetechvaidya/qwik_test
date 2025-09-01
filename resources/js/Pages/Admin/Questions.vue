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
                        <div v-if="!questionTypes || questionTypes.length === 0" class="px-4 py-2 text-sm text-gray-500">
                            No question types available
                        </div>
                        <template v-for="questionType in questionTypes" :key="questionType.code">
                            <button 
                                class="dropdown-link w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
                                @click="createQuestion(questionType.code)"
                            >
                                {{ questionType.text }}
                            </button>
                        </template>
                    </template>
                </ArcDropdown>
            </div>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card shadow-lg">
                <div class="card-body p-6">
                    <div ref="tableRoot" class="overflow-x-auto">
                        <DataTable
                            :value="questions.data"
                            dataKey="id"
                            :lazy="tableParams.lazy"
                            :paginator="tableParams.paginator"
                            :rows="tableParams.rows"
                            :totalRecords="questions.meta.pagination.total"
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
                            :class="{ 'rtl': $page.props.rtl }"
                            class="p-datatable-sm shadow-sm border-0"
                            responsiveLayout="scroll"
                            :scrollable="true"
                            scrollHeight="600px"
                            :rowHover="true"
                            stripedRows
                        >
                            <Column v-for="column in columns" :key="column.field" :field="column.field" :header="column.label" :sortable="column.sortable" :filterField="column.filterKey || column.field" :style="column.width ? `width: ${column.width}` : ''" :class="column.headerClass || ''">
                                <template #filter="{ filterModel, filterCallback }" v-if="column.filterOptions?.enabled">
                                    <InputText
                                        :model-value="filterModel ? filterModel.value : ''"
                                        @update:model-value="val => { if (filterModel) filterModel.value = val }"
                                        type="text"
                                        @input="filterCallback()"
                                        :placeholder="column.filterOptions?.placeholder || 'Search...'"
                                        class="p-column-filter border-gray-300 rounded-md text-sm focus:border-blue-500 focus:ring-1 focus:ring-blue-500"
                                    />
                                </template>
                                <template #body="slotProps">
                                    <!-- Code Column -->
                                    <div v-if="column.field === 'code'" class="flex items-center">
                                        <Tag :key="slotProps.data.id || slotProps.index" class="bg-blue-100 text-blue-800 px-3 py-1 rounded-full text-sm cursor-pointer hover:bg-blue-200 transition-colors" @click="copyCode(slotProps.data.code)">
                                            <i class="pi pi-copy mr-2" />
                                            {{ slotProps.data.code }}
                                        </Tag>
                                    </div>

                                    <!-- Question Column - NOTE: DOMPurify configured for KaTeX compatibility and images -->
                                    <div v-else-if="column.field === 'question'" class="max-w-md">
                                        <div
                                            class="py-2 px-3 bg-gray-50 rounded-lg border-l-4 border-blue-500 text-sm leading-relaxed"
                                            v-html="sanitizedAndValidatedQuestion(slotProps.data.question)"
                                        ></div>
                                    </div>

                                    <!-- Status Column -->
                                    <div v-else-if="column.field === 'status'" class="flex items-center">
                                        <span
                                            :class="[
                                                slotProps.data.status === 1 
                                                    ? 'bg-green-100 text-green-800 border-green-200' 
                                                    : 'bg-red-100 text-red-800 border-red-200',
                                                'px-3 py-1 rounded-full text-xs font-medium border'
                                            ]"
                                            >{{ slotProps.data.status === 1 ? __('Active') : __('In-active') }}</span
                                        >
                                    </div>

                                    <!-- Actions Column -->
                                    <div v-else-if="column.field === 'actions'" class="flex items-center justify-center">
                                        <ActionsDropdown :key="slotProps.data.id || slotProps.index">
                                            <template #actions>
                                                <button
                                                    class="action-item flex items-center gap-2 px-3 py-2 text-sm hover:bg-gray-50 transition-colors"
                                                    @click="openPreview(slotProps.data.id)"
                                                    ><i class="pi pi-eye text-blue-500"></i>{{ __('Preview') }}</button
                                                >
                                                <button class="action-item flex items-center gap-2 px-3 py-2 text-sm hover:bg-gray-50 transition-colors" @click="editQuestion(slotProps.data.id)"><i class="pi pi-pencil text-green-500"></i>{{ __('Edit') }}</button>
                                                <button class="action-item flex items-center gap-2 px-3 py-2 text-sm hover:bg-gray-50 transition-colors" @click="deleteQuestion(slotProps.data.id)"><i class="pi pi-trash text-red-500"></i>{{ __('Delete') }}</button>
                                            </template>
                                        </ActionsDropdown>
                                    </div>

                                    <!-- Remaining Columns -->
                                    <div v-else class="px-2 py-1">
                                        <span class="text-sm text-gray-700 font-medium">
                                            {{ slotProps.data[column.field] }}
                                        </span>
                                    </div>
                                </template>
                            </Column>

                            <template #empty>
                                <NoDataTable />
                            </template>
                        </DataTable>
                    </div>

                    <!-- Drawer Forms -->
                    <Drawer 
                        v-model:visible="showPreview" 
                        position="right" 
                        class="p-drawer-md"
                        :dismissable="true"
                        :closeOnEscape="true"
                        @hide="closePreview"
                    >
                        <QuestionPreview
                            v-if="showPreview && currentId && isComponentMounted"
                            :question-id="currentId"
                            :title="__('Question') + ' ' + __('Preview')"
                            @close="closePreview"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick, watch, onBeforeUnmount } from 'vue';
import { Head, Link, usePage, router } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/AdminLayout.vue';
import ArcDropdown from '@/Components/Dropdown.vue';
import ArcDropdownLink from '@/Components/DropdownLink.vue';
import Tag from 'primevue/tag';
import DataTable from 'primevue/datatable';
import Column from 'primevue/column';
import InputText from 'primevue/inputtext';
import NoDataTable from '@/Components/NoDataTable.vue';
import ActionsDropdown from '@/Components/ActionsDropdown.vue';
import QuestionPreview from '@/Pages/Admin/Question/Preview.vue';
import Drawer from 'primevue/drawer';
import { useTranslate } from '@/composables/useTranslate';
import { useServerTable } from '@/composables/useServerTable';
import { useCopy } from '@/composables/useCopy';
import { useMathRender } from '@/composables/useMathRender';
import { useConfirmToast } from '@/composables/useConfirmToast';
import { sanitizeHtml, validateContent } from '@/utils/security';
import { codeColumn, statusColumn } from '@/tables/columns';
import debounce from 'lodash/debounce';

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

// Table columns configuration - Define columns first
const columns = reactive([
    codeColumn(__, { width: '11rem', trigger: 'enter' }),
    {
        label: __('Question'),
        field: 'question',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Question'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Type'),
        field: 'questionType',
        filterKey: 'question_type',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Type'),
            filterValue: null,
            filterDropdownItems: (props.questionTypes || []).map(t => ({ value: t.code, text: t.text ?? t.name })),
        },
    },
    {
        label: __('Section'),
        field: 'section',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Section'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Skill'),
        field: 'skill',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Skill'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    {
        label: __('Topic'),
        field: 'topic',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Topic'),
            filterValue: null,
            trigger: 'enter',
        },
    },
    statusColumn(__),
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
        width: '200px',
        tdClass: 'text-center',
    },
])

// Server table composable - Use columns now that it's defined
const {
    serverParams,
    loading: tableLoading,
    onPage,
    onSort,
    onFilter,
    tableParams,
    loadItems,
} = useServerTable({
    page: 1,
    perPage: props.questions?.meta?.pagination?.per_page || 10,
    resourceKeys: ['questions', 'questionTypes', 'sections'],
    routeName: 'questions.index',
    columns,
    labels: {
        pagination: {
            firstLabel: __('First'),
            lastLabel: __('Last'),
            nextLabel: __('Next'),
            prevLabel: __('Prev'),
        },
        search: { placeholder: __('Search') + ' ' + __('records') + '...' },
    },
    searchDebounceMs: 500, // Debounce search input
    searchTrigger: 'enter',
    paramMap: {
        page: 'page',
        perPage: 'per_page',
        search: 'search',
        sortBy: 'sortBy',
        sortOrder: 'sortOrder',
        filterPrefix: '',
    },
    onSuccess: async () => {
        if (!isComponentMounted.value) return
        await nextTick()
        if (tableRoot.value && isComponentMounted.value) {
            await renderMathInTable(tableRoot.value)
        }
    },
    onError: (_, message) =>
        toast({ severity: 'error', summary: __('Error'), detail: message || __('Failed to load data'), life: 3000 }),
})

// Reactive state
const showPreview = ref(false)
const currentId = ref(null)
const tableRoot = ref(null)
const isComponentMounted = ref(false)
const title = computed(() => {
    return __('Questions') + ' - ' + pageProps.general.app_name
});

// Enhanced Security and Content Handling
const sanitizedAndValidatedQuestion = (question) => {
    if (!validateContent(question)) {
        // Log invalid content for audit
        console.warn('Invalid content detected:', question);
        return 'Invalid content';
    }
    return sanitizeHtml(question);
};

// Performance Optimization: Lazy load images
const lazyLoadImages = () => {
    if (!tableRoot.value) return;
    try {
        const images = tableRoot.value.querySelectorAll('img[data-src]');
        images.forEach(img => {
            if (img && img.dataset && img.dataset.src) {
                img.src = img.dataset.src;
                img.removeAttribute('data-src');
            }
        });
    } catch (error) {
        console.warn('Error in lazy loading images:', error);
    }
};

// Audit Logging for Admin Actions
const logAdminAction = (action, details) => {
    // Replace with a more robust logging service
    console.log(`Admin Action: ${action}`, details);
};

// Initialize math rendering and lazy loading on mount and after data loads
onMounted(() => {
    isComponentMounted.value = true
    
    nextTick(() => {
        if (tableRoot.value && isComponentMounted.value) {
            renderMathInTable(tableRoot.value);
            lazyLoadImages();
        }
    });
});

watch(() => props.questions, () => {
    if (!isComponentMounted.value) return
    nextTick(() => {
        if (tableRoot.value && isComponentMounted.value) {
            renderMathInTable(tableRoot.value);
            lazyLoadImages();
        }
    });
}, { deep: true });

// Copy code functionality
const copyCode = async (code) => {
    if (!isComponentMounted.value || !code) return
    try {
        await copyToClipboard(code)
        logAdminAction('copy_question_code', { code })
        toast({ severity: 'success', summary: __('Success'), detail: __('Code copied to clipboard'), life: 2000 })
    } catch (error) {
        console.error('Error copying code:', error)
        toast({ severity: 'error', summary: __('Error'), detail: __('Failed to copy code'), life: 3000 })
    }
}

// Methods
const openPreview = (id) => {
    if (!isComponentMounted.value || !id) return
    try {
        currentId.value = id
        showPreview.value = true
        logAdminAction('preview_question', { questionId: id })
    } catch (error) {
        console.error('Error opening preview:', error)
        toast({ severity: 'error', summary: __('Error'), detail: __('Failed to open preview'), life: 3000 })
    }
}

const closePreview = () => {
    try {
        showPreview.value = false
        currentId.value = null
    } catch (error) {
        console.warn('Error closing preview:', error)
    }
}

const createQuestion = (questionType) => {
    if (!isComponentMounted.value || !questionType) return
    try {
        logAdminAction('create_question_attempt', { questionType })
        router.get(route('questions.create', { question_type: questionType }))
    } catch (error) {
        console.error('Error creating question:', error)
        toast({ severity: 'error', summary: __('Error'), detail: __('Failed to create question'), life: 3000 })
    }
}

const editQuestion = id => {
    if (!isComponentMounted.value) return
    try {
        logAdminAction('edit_question', { questionId: id });
        router.get(route('questions.edit', { question: id }));
    } catch (error) {
        console.error('Error editing question:', error)
        toast({ severity: 'error', summary: __('Error'), detail: __('Failed to edit question'), life: 3000 })
    }
};

const deleteQuestion = async id => {
    logAdminAction('delete_question', { questionId: id });
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    });
    if (!ok) return;

    const prevPage = serverParams.page;
    router.delete(route('questions.destroy', { question: id }), {
        onSuccess: async () => {
            toast({ severity: 'info', summary: __('Confirmed'), detail: __('Record deleted'), life: 3000 });
            await loadItems();
            const freshQuestions = usePage().props.questions;
            const currentPageCount = freshQuestions?.data?.length ?? 0;
            if (currentPageCount === 0 && prevPage > 1) {
                serverParams.page = prevPage - 1;
                await loadItems(true);
            }
            if (isComponentMounted.value) {
                await nextTick();
                if (tableRoot.value) {
                    await renderMathInTable(tableRoot.value);
                }
            }
        },
        onError: () => {
            toast({ severity: 'error', summary: __('Error'), detail: __('Failed to delete question'), life: 3000 });
        },
    });
};

// Cleanup on component unmount to prevent DOM manipulation errors
onBeforeUnmount(() => {
    try {
        // Mark component as unmounted first
        isComponentMounted.value = false
        
        // Clear reactive state
        showPreview.value = false
        currentId.value = null
        
        // Close any pending confirmation dialogs
        if (window.PrimeVue && window.PrimeVue.confirmDialog) {
            window.PrimeVue.confirmDialog.close()
        }
        
        // Clear table reference last to prevent null access
        if (tableRoot.value) {
            tableRoot.value = null
        }
    } catch (error) {
        console.warn('Error during component cleanup:', error)
    }
})

// Expose loadItems for external table refreshing
defineExpose({
    loadItems,
    refreshTable: loadItems, // Alias for clarity
})
</script>
