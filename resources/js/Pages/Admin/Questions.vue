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
                        <button class="qt-btn qt-btn-success"> {{ __('New') }} {{ __('Question') }} </button>
                    </template>
                    <template #content>
                        <template v-for="questionType in questionTypes" :key="questionType.code">
                            <ArcDropdownLink :href="route('questions.create', { question_type: questionType.code })">
                                {{ questionType.text }}
                            </ArcDropdownLink>
                        </template>
                    </template>
                </ArcDropdown>
            </div>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div ref="tableRoot">
                        <vue-good-table
                            mode="remote"
                            :search-options="tableParams.search"
                            :pagination-options="tableParams.pagination"
                            :columns="columns"
                            :total-rows="questions.meta.pagination.total"
                            :rows="questions.data"
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
                                    <Tag class="w-full mr-2 text-sm cursor-pointer" @click="copyCode(props.row.code)">
                                        <i class="pi pi-copy mr-2" />
                                        {{ props.row.code }}
                                    </Tag>
                                </div>

                                <!-- Question Column - NOTE: DOMPurify configured for KaTeX compatibility and images -->
                                <div v-else-if="props.column.field === 'question'">
                                    <div
                                        class="py-4"
                                        v-html="
                                            DOMPurify.sanitize(props.row.question, {
                                                // KaTeX-compatible configuration to preserve math markup and allow images
                                                ALLOWED_TAGS: [
                                                    'span',
                                                    'div',
                                                    'p',
                                                    'br',
                                                    'strong',
                                                    'em',
                                                    'sup',
                                                    'sub',
                                                    'img',
                                                    'mi',
                                                    'mo',
                                                    'mn',
                                                    'mrow',
                                                    'mfrac',
                                                    'msup',
                                                    'msub',
                                                    'msubsup',
                                                    'munderover',
                                                    'munder',
                                                    'mover',
                                                    'mtext',
                                                    'mspace',
                                                    'ms',
                                                    'mpadded',
                                                    'mphantom',
                                                    'mfenced',
                                                    'menclose',
                                                    'mlongdiv',
                                                    'msqrt',
                                                    'mroot',
                                                    'maction',
                                                    'mstyle',
                                                    'semantics',
                                                    'annotation',
                                                    'annotation-xml',
                                                ],
                                                ALLOWED_ATTR: [
                                                    'class',
                                                    'style',
                                                    'id',
                                                    'title',
                                                    'src',
                                                    'alt',
                                                    'width',
                                                    'height',
                                                    'mathvariant',
                                                    'mathsize',
                                                    'mathcolor',
                                                    'mathbackground',
                                                    'displaystyle',
                                                    'scriptlevel',
                                                ],
                                                ALLOW_DATA_ATTR: true, // Enable data-* attributes properly
                                                ALLOWED_URI_REGEXP:
                                                    /^(?:https?:\/\/|data:image\/(png|jpg|jpeg|gif|svg\+xml);base64,)/,
                                            })
                                        "
                                    ></div>
                                </div>

                                <!-- Status Column -->
                                <div v-else-if="props.column.field === 'status'">
                                    <span
                                        :class="[props.row.status === 1 ? 'badge-success' : 'badge-danger', 'badge']"
                                        >{{ props.row.status === 1 ? __('Active') : __('In-active') }}</span
                                    >
                                </div>

                                <!-- Actions Column -->
                                <div v-else-if="props.column.field === 'actions'">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                                    showPreview = true
                                                    currentId = props.row.id
                                                "
                                                >{{ __('Preview') }}</button
                                            >
                                            <button class="action-item" @click="editQuestion(props.row.id)">{{
                                                __('Edit')
                                            }}</button>
                                            <button class="action-item" @click="deleteQuestion(props.row.id)">{{
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
                                <NoDataTable />
                            </template>
                        </vue-good-table>
                    </div>

                    <!-- Drawer Forms -->
                    <Drawer v-model:visible="showPreview" position="right" class="p-drawer-md">
                        <QuestionPreview
                            :question-id="currentId"
                            :title="__('Question') + ' ' + __('Preview')"
                            @close="showPreview = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, reactive, computed, onMounted, nextTick } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcDropdown from '@/Components/Dropdown.vue'
import ArcDropdownLink from '@/Components/DropdownLink.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'
import QuestionPreview from '@/Pages/Admin/Question/Preview.vue'
import Drawer from 'primevue/drawer'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useMathRender } from '@/composables/useMathRender'
import { useConfirmToast } from '@/composables/useConfirmToast'
import DOMPurify from 'dompurify'
import { codeColumn, statusColumn, textFilterColumn, dropdownFilterColumn } from '@/tables/columns'

// Props
const props = defineProps({
    questionTypes: Array,
    questions: Object,
    sections: Array,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { renderMathInTable, debouncedRenderMath } = useMathRender()
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
            filterDropdownItems: props.questionTypes.map(t => ({ value: t.code, text: t.text ?? t.name })),
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
    loading,
    onPageChange,
    onPerPageChange,
    onColumnFilter,
    onSortChange,
    onSearch,
    tableParams,
    loadItems,
} = useServerTable({
    page: 1,
    perPage: props.questions.meta.pagination.per_page || 10,
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
    onSuccess: async () => {
        await nextTick()
        await renderMathInTable(tableRoot.value)
    },
    onError: (_, message) =>
        toast({ severity: 'error', summary: __('Error'), detail: message || __('Failed to load data'), life: 3000 }),
})

// Reactive state
const showPreview = ref(false)
const currentId = ref(null)
const tableRoot = ref(null)
const title = computed(() => {
    return __('Questions') + ' - ' + pageProps.general.app_name
})

// Initialize math rendering on mount
onMounted(() => {
    renderMathInTable(tableRoot.value)
})

// Methods
const editQuestion = id => {
    router.get(route('questions.edit', { question: id }))
}

const deleteQuestion = async id => {
    const ok = await confirm({
        header: __('Confirm Delete'),
        message: __('Do you want to delete this record?'),
        icon: 'pi pi-info-circle',
        acceptClass: 'p-button-danger',
        rejectLabel: __('Cancel'),
        acceptLabel: __('Delete'),
    })
    if (!ok) return

    const prevPage = serverParams.page
    router.delete(route('questions.destroy', { question: id }), {
        onSuccess: async () => {
            toast({ severity: 'info', summary: __('Confirmed'), detail: __('Record deleted'), life: 3000 })
            // Refresh table data after deletion and re-render math after DOM updates
            // Note: loadItems() defaults to preserveState=true - use loadItems(false) if UI artifacts persist
            await loadItems()
            // If current page becomes empty after deletion, navigate to previous page
            const freshQuestions = usePage().props.questions
            const currentPageCount = freshQuestions?.data?.length ?? 0
            if (currentPageCount === 0 && prevPage > 1) {
                serverParams.page = prevPage - 1
                await loadItems(true)
            }
            await nextTick()
            await renderMathInTable(tableRoot.value)
        },
        onError: () => {
            toast({ severity: 'error', summary: __('Error'), detail: __('Failed to delete question'), life: 3000 })
        },
    })
}

// Expose loadItems for external table refreshing
defineExpose({
    loadItems,
    refreshTable: loadItems, // Alias for clarity
})
</script>
