import { ref, reactive, computed, watch, onMounted, onBeforeUnmount } from 'vue'
import { router } from '@inertiajs/vue3'
import { FilterMatchMode } from '@primevue/core/api'
import { useToast } from 'primevue/usetoast'

/**
 * Enhanced DataTable composable for PrimeVue 4.x
 * Provides modern table functionality with responsive design, filtering, sorting, and pagination
 */
export function useModernDataTable(options = {}) {
    const {
        // Data configuration
        initialData = [],
        dataKey = 'id',
        
        // Server-side configuration
        lazy = false,
        resourceKeys = [],
        routeName = null,
        routeParams = {},
        
        // Pagination
        initialRows = 10,
        rowsPerPageOptions = [10, 25, 50, 100],
        
        // Filtering and sorting
        globalFilterFields = [],
        initialFilters = {},
        sortMode = 'single',
        
        // Responsive configuration
        responsiveBreakpoint = '768px',
        mobileColumnsToShow = 2,
        
        // Event callbacks
        onRowSelect = null,
        onRowClick = null,
        onError = null,
        onSuccess = null,
        
        // State management
        stateStorage = 'session', // 'session', 'local', or null
        stateKey = null,
        
        // Export configuration
        exportable = false,
        exportFilename = 'export'
    } = options

    // Reactive state
    const loading = ref(false)
    const data = ref(initialData)
    const totalRecords = ref(0)
    const first = ref(0)
    const rows = ref(initialRows)
    const globalFilterValue = ref('')
    const selectedRows = ref([])
    const expandedRows = ref([])
    const columns = ref([])
    const error = ref(null)
    
    // Filters reactive object
    const filters = ref({
        global: { value: null, matchMode: FilterMatchMode.CONTAINS },
        ...initialFilters
    })
    
    // Sorting state
    const sortField = ref(null)
    const sortOrder = ref(null)
    const multiSortMeta = ref([])
    
    // Responsive state
    const isMobile = ref(false)
    const visibleColumns = ref([])
    
    // Table configuration
    const tableConfig = reactive({
        lazy,
        paginator: true,
        rows: rows.value,
        totalRecords: totalRecords.value,
        first: first.value,
        sortMode,
        sortField: sortField.value,
        sortOrder: sortOrder.value,
        multiSortMeta: multiSortMeta.value,
        filters: filters.value,
        globalFilterFields,
        selection: selectedRows.value,
        expandedRows: expandedRows.value,
        loading: loading.value,
        scrollable: true,
        scrollHeight: 'flex',
        resizableColumns: false,
        columnResizeMode: 'fit',
        showGridlines: true,
        stripedRows: true,
        rowHover: true,
        responsiveLayout: 'scroll',
        dataKey,
        rowsPerPageOptions,
        paginatorTemplate: 'FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown',
        currentPageReportTemplate: 'Showing {first} to {last} of {totalRecords} entries'
    })
    
    // Toast for notifications
    const toast = useToast()
    
    // Computed properties
    const currentPage = computed(() => Math.floor(first.value / rows.value) + 1)
    const totalPages = computed(() => Math.ceil(totalRecords.value / rows.value))
    const hasData = computed(() => data.value && data.value.length > 0)
    const hasSelection = computed(() => selectedRows.value && selectedRows.value.length > 0)
    
    // Responsive columns based on screen size
    const responsiveColumns = computed(() => {
        if (!isMobile.value) return columns.value
        
        // On mobile, show only the most important columns
        const priorityColumns = columns.value
            .filter(col => col.responsivePriority && col.responsivePriority <= mobileColumnsToShow)
            .sort((a, b) => (a.responsivePriority || 999) - (b.responsivePriority || 999))
        
        return priorityColumns.length > 0 ? priorityColumns : columns.value.slice(0, mobileColumnsToShow)
    })
    
    // Methods
    const loadData = async (params = {}) => {
        if (!lazy || !routeName) return
        
        loading.value = true
        error.value = null
        
        try {
            const queryParams = buildQueryParams(params)
            
            await router.get(
                typeof route !== 'undefined' ? route(routeName, routeParams) : `/${routeName}`,
                queryParams,
                {
                    preserveState: true,
                    preserveScroll: true,
                    only: resourceKeys.length > 0 ? resourceKeys : undefined,
                    onSuccess: (page) => {
                        if (page.props && resourceKeys.length > 0) {
                            const resourceData = page.props[resourceKeys[0]]
                            if (resourceData) {
                                data.value = resourceData.data || resourceData
                                totalRecords.value = resourceData.total || resourceData.meta?.total || 0
                            }
                        }
                        onSuccess && onSuccess(page)
                    },
                    onError: (errors) => {
                        error.value = errors
                        onError && onError(errors)
                        showError('Failed to load data')
                    },
                    onFinish: () => {
                        loading.value = false
                    }
                }
            )
        } catch (e) {
            loading.value = false
            error.value = e
            showError('An error occurred while loading data')
        }
    }
    
    const buildQueryParams = (additionalParams = {}) => {
        const params = {
            page: currentPage.value,
            per_page: rows.value,
            ...additionalParams
        }
        
        // Add sorting
        if (sortField.value && sortOrder.value) {
            params.sort_by = sortField.value
            params.sort_order = sortOrder.value === 1 ? 'asc' : 'desc'
        }
        
        // Add global search
        if (globalFilterValue.value) {
            params.search = globalFilterValue.value
        }
        
        // Add column filters
        Object.keys(filters.value).forEach(key => {
            if (key !== 'global' && filters.value[key]?.value !== null && filters.value[key]?.value !== '') {
                params[`filter_${key}`] = filters.value[key].value
            }
        })
        
        return params
    }
    
    // Event handlers
    const onPage = (event) => {
        first.value = event.first
        rows.value = event.rows
        if (lazy) {
            loadData()
        }
        saveState()
    }
    
    const onSort = (event) => {
        sortField.value = event.sortField
        sortOrder.value = event.sortOrder
        
        if (sortMode === 'multiple') {
            multiSortMeta.value = event.multiSortMeta || []
        }
        
        if (lazy) {
            loadData()
        }
        saveState()
    }
    
    const onFilter = (event) => {
        filters.value = event.filters
        first.value = 0 // Reset to first page
        
        if (lazy) {
            loadData()
        }
        saveState()
    }
    
    const onGlobalFilter = (value) => {
        globalFilterValue.value = value
        filters.value.global.value = value
        first.value = 0 // Reset to first page
        
        if (lazy) {
            // Debounce global search
            clearTimeout(globalFilterTimeout)
            globalFilterTimeout = setTimeout(() => {
                loadData()
            }, 300)
        }
        saveState()
    }
    
    let globalFilterTimeout = null
    
    const onRowSelectEvent = (event) => {
        selectedRows.value = event.value
        onRowSelect && onRowSelect(event)
        saveState()
    }
    
    const onRowClickEvent = (event) => {
        onRowClick && onRowClick(event)
    }
    
    const onRowExpand = (event) => {
        expandedRows.value.push(event.data)
        saveState()
    }
    
    const onRowCollapse = (event) => {
        expandedRows.value = expandedRows.value.filter(row => row[dataKey] !== event.data[dataKey])
        saveState()
    }
    
    // Utility methods
    const refresh = () => {
        if (lazy) {
            loadData()
        }
    }
    
    const reset = () => {
        first.value = 0
        rows.value = initialRows
        sortField.value = null
        sortOrder.value = null
        multiSortMeta.value = []
        globalFilterValue.value = ''
        filters.value = {
            global: { value: null, matchMode: FilterMatchMode.CONTAINS },
            ...initialFilters
        }
        selectedRows.value = []
        expandedRows.value = []
        
        if (lazy) {
            loadData()
        }
        saveState()
    }
    
    const clearSelection = () => {
        selectedRows.value = []
        saveState()
    }
    
    const selectAll = () => {
        selectedRows.value = [...data.value]
        saveState()
    }
    
    const exportCSV = (options = {}) => {
        if (!exportable) return
        
        // Create CSV content
        const csvContent = generateCSV({
            data: data.value,
            columns: columns.value.filter(col => col.exportable !== false),
            filename: exportFilename,
            ...options
        })
        
        downloadCSV(csvContent, `${exportFilename}_${new Date().toISOString().split('T')[0]}.csv`)
    }
    
    const generateCSV = ({ data, columns, includeHeaders = true }) => {
        const headers = includeHeaders ? columns.map(col => col.header || col.field).join(',') : ''
        const rows = data.map(row => 
            columns.map(col => {
                const value = getNestedProperty(row, col.field)
                return `"${String(value || '').replace(/"/g, '""')}"`
            }).join(',')
        ).join('\n')
        
        return includeHeaders ? `${headers}\n${rows}` : rows
    }
    
    const downloadCSV = (content, filename) => {
        const blob = new Blob([content], { type: 'text/csv;charset=utf-8;' })
        const link = document.createElement('a')
        
        if (link.download !== undefined) {
            const url = URL.createObjectURL(blob)
            link.setAttribute('href', url)
            link.setAttribute('download', filename)
            link.style.visibility = 'hidden'
            document.body.appendChild(link)
            link.click()
            document.body.removeChild(link)
            URL.revokeObjectURL(url)
        }
    }
    
    const getNestedProperty = (obj, path) => {
        return path.split('.').reduce((current, prop) => current?.[prop], obj)
    }
    
    const showError = (message) => {
        toast.add({
            severity: 'error',
            summary: 'Error',
            detail: message,
            life: 5000
        })
    }
    
    const showSuccess = (message) => {
        toast.add({
            severity: 'success',
            summary: 'Success',
            detail: message,
            life: 3000
        })
    }
    
    // State management
    const getStateKey = () => {
        return stateKey || `datatable_${routeName || 'default'}`
    }
    
    const saveState = () => {
        if (!stateStorage) return
        
        const state = {
            first: first.value,
            rows: rows.value,
            sortField: sortField.value,
            sortOrder: sortOrder.value,
            multiSortMeta: multiSortMeta.value,
            filters: filters.value,
            selectedRows: selectedRows.value.map(row => row[dataKey]),
            expandedRows: expandedRows.value.map(row => row[dataKey])
        }
        
        const storage = stateStorage === 'local' ? localStorage : sessionStorage
        storage.setItem(getStateKey(), JSON.stringify(state))
    }
    
    const loadState = () => {
        if (!stateStorage) return
        
        try {
            const storage = stateStorage === 'local' ? localStorage : sessionStorage
            const savedState = storage.getItem(getStateKey())
            
            if (savedState) {
                const state = JSON.parse(savedState)
                
                first.value = state.first || 0
                rows.value = state.rows || initialRows
                sortField.value = state.sortField
                sortOrder.value = state.sortOrder
                multiSortMeta.value = state.multiSortMeta || []
                filters.value = { ...filters.value, ...state.filters }
                
                // Restore selection and expansion after data is loaded
                if (state.selectedRows) {
                    watch(data, (newData) => {
                        if (newData.length > 0) {
                            selectedRows.value = newData.filter(row => 
                                state.selectedRows.includes(row[dataKey])
                            )
                        }
                    }, { immediate: true })
                }
                
                if (state.expandedRows) {
                    watch(data, (newData) => {
                        if (newData.length > 0) {
                            expandedRows.value = newData.filter(row => 
                                state.expandedRows.includes(row[dataKey])
                            )
                        }
                    }, { immediate: true })
                }
            }
        } catch (e) {
            console.warn('Failed to load table state:', e)
        }
    }
    
    const clearState = () => {
        if (!stateStorage) return
        
        const storage = stateStorage === 'local' ? localStorage : sessionStorage
        storage.removeItem(getStateKey())
    }
    
    // Responsive handling
    const checkScreenSize = () => {
        isMobile.value = window.innerWidth < parseInt(responsiveBreakpoint)
    }
    
    const initializeResponsive = () => {
        checkScreenSize()
        window.addEventListener('resize', checkScreenSize)
    }
    
    const cleanupResponsive = () => {
        window.removeEventListener('resize', checkScreenSize)
    }
    
    // Lifecycle
    onMounted(() => {
        loadState()
        initializeResponsive()
        
        if (lazy && hasData.value === false) {
            loadData()
        }
    })
    
    onBeforeUnmount(() => {
        cleanupResponsive()
        clearTimeout(globalFilterTimeout)
    })
    
    // Column management
    const setColumns = (newColumns) => {
        columns.value = newColumns.map((col, index) => ({
            ...col,
            key: col.key || col.field || `col-${index}`,
            responsivePriority: col.responsivePriority || (index < mobileColumnsToShow ? index + 1 : 999)
        }))
    }
    
    const addColumn = (column, position = -1) => {
        if (position === -1) {
            columns.value.push(column)
        } else {
            columns.value.splice(position, 0, column)
        }
    }
    
    const removeColumn = (fieldOrIndex) => {
        if (typeof fieldOrIndex === 'string') {
            columns.value = columns.value.filter(col => col.field !== fieldOrIndex)
        } else {
            columns.value.splice(fieldOrIndex, 1)
        }
    }
    
    const updateColumn = (field, updates) => {
        const index = columns.value.findIndex(col => col.field === field)
        if (index !== -1) {
            columns.value[index] = { ...columns.value[index], ...updates }
        }
    }
    
    // Expose reactive state and methods
    return {
        // State
        data,
        columns,
        loading,
        totalRecords,
        first,
        rows,
        globalFilterValue,
        selectedRows,
        expandedRows,
        filters,
        sortField,
        sortOrder,
        multiSortMeta,
        error,
        isMobile,
        
        // Computed
        currentPage,
        totalPages,
        hasData,
        hasSelection,
        responsiveColumns,
        tableConfig,
        
        // Methods - Data Management
        loadData,
        refresh,
        reset,
        
        // Methods - Event Handlers
        onPage,
        onSort,
        onFilter,
        onGlobalFilter,
        onRowSelect: onRowSelectEvent,
        onRowClick: onRowClickEvent,
        onRowExpand,
        onRowCollapse,
        
        // Methods - Selection
        clearSelection,
        selectAll,
        
        // Methods - Export
        exportCSV,
        
        // Methods - Column Management
        setColumns,
        addColumn,
        removeColumn,
        updateColumn,
        
        // Methods - State Management
        saveState,
        loadState,
        clearState,
        
        // Methods - Utilities
        showError,
        showSuccess
    }
}