import { reactive, ref, computed, unref } from 'vue'
import { router } from '@inertiajs/vue3'

/**
 * Server-side table management composable for admin list pages.
 *
 * @WARNING This composable is designed for browser-only admin UI usage.
 * It uses window.location and router navigation which are not available in SSR.
 *
 * @param {Object} initialOptions - Configuration options
 * @param {Array} initialOptions.resourceKeys - Inertia resource keys to reload
 * @param {string} initialOptions.routeName - Laravel route name (requires Ziggy)
 * @param {Object} initialOptions.routeParams - Route parameters
 * @param {Function} initialOptions.buildUrl - Custom URL builder fallback
 * @param {Object} initialOptions.paramMap - Parameter name mapping for backend
 * @param {Function} initialOptions.onSuccess - Success callback
 * @param {Function} initialOptions.onError - Error callback
 * @returns {Object} Table management methods and reactive state
 */
export function useServerTable(initialOptions = {}) {
    const loading = ref(false)
    const error = ref(null)

    // Extract configuration options
    const {
        resourceKeys,
        routeName,
        routeParams = {},
        columns = [], // Add columns configuration
        // i18n labels and search behavior controls
        labels = null, // { pagination: { firstLabel, lastLabel, nextLabel, prevLabel }, search: { placeholder } }
        searchDebounceMs: userSearchDebounceMs,
        searchTrigger = 'enter', // explicit control to avoid relying on tableParams
        buildUrl = null, // Optional custom URL builder fallback when route helper is unavailable
        paramMap = {
            page: 'page',
            perPage: 'per_page',
            search: 'search',
            sortBy: 'sortBy',
            sortOrder: 'sortOrder',
            filterPrefix: '',
            arraySuffixForArrays: true, // When true: sortBy[], when false: sortBy for multi-sort
        },
        filterKeyTransform, // Optional function to transform filter keys
        onSuccess: afterLoad,
        onError: onErrorCallback,
        onFinish,
        ...restOptions
    } = initialOptions

    // Dev-mode guard: Throw error when neither routeName nor buildUrl is provided
    if (import.meta?.env?.MODE !== 'production') {
        if (!routeName && !buildUrl) {
            throw new Error(
                '[useServerTable] Either routeName or buildUrl must be provided for proper URL generation. ' +
                    'Please provide a routeName (requires Ziggy route helper) or a custom buildUrl function.'
            )
        }
        if (routeName && typeof routeName !== 'string') {
            throw new Error('[useServerTable] routeName must be a string')
        }
        if (buildUrl && typeof buildUrl !== 'function') {
            throw new Error('[useServerTable] buildUrl must be a function')
        }
    }

    const serverParams = reactive({
        page: 1,
        perPage: 10,
        sort: [],
        columnFilters: {},
        globalSearchTerm: '',
        ...restOptions,
    })

    const updateParams = newParams => {
        Object.assign(serverParams, newParams)
    }

    const onPageChange = params => {
        serverParams.page = params.currentPage
        loadItems()
    }

    const onPerPageChange = params => {
        serverParams.perPage = params.currentPerPage
        serverParams.page = 1 // Reset to first page
        loadItems()
    }

    const onColumnFilter = params => {
        serverParams.columnFilters = params.columnFilters
        serverParams.page = 1 // Reset to first page
        loadItems()
    }

    const onSortChange = params => {
        let validSortConstructed = false
        // Handle different sort parameter formats
        if (Array.isArray(params)) {
            serverParams.sort = params
            validSortConstructed = true
        } else if (params && typeof params === 'object') {
            // Handle PrimeVue DataTable sort format
            if (params.sortField && params.sortOrder) {
                // PrimeVue DataTable sends { sortField: 'fieldName', sortOrder: 1|-1 }
                const sortType = params.sortOrder === 1 ? 'asc' : 'desc'
                serverParams.sort = [
                    {
                        field: params.sortField,
                        type: sortType,
                    },
                ]
                validSortConstructed = true
            } else if (params.field && params.type) {
                // Direct field/type format
                serverParams.sort = [{ field: params.field, type: params.type }]
                validSortConstructed = true
            } else if (params.sortBy && params.sortType) {
                // Alternative format
                serverParams.sort = [{ field: params.sortBy, type: params.sortType }]
                validSortConstructed = true
            } else {
                serverParams.sort = []
            }
        } else {
            serverParams.sort = []
        }
        // Always reload when sort state changes, including when cleared
        loadItems()
    }

    let searchT
    const onSearch = arg => {
        const term = typeof arg === 'string' ? arg : (arg?.searchTerm ?? arg?.query ?? '')
        // Determine debounce time. If user provided, use it. Otherwise, if trigger is 'enter', don't debounce.
        const trigger = searchTrigger || 'enter'
        const debounceMs =
            typeof userSearchDebounceMs === 'number' ? userSearchDebounceMs : trigger === 'enter' ? 0 : 300

        if (debounceMs <= 0) {
            clearTimeout(searchT)
            serverParams.globalSearchTerm = term
            serverParams.page = 1
            loadItems()
            return
        }

        clearTimeout(searchT)
        searchT = setTimeout(() => {
            serverParams.globalSearchTerm = term
            serverParams.page = 1 // Reset to first page
            loadItems()
        }, debounceMs)
    }

    const getQueryParams = () => {
        const params = {
            [paramMap.page]: serverParams.page,
            [paramMap.perPage]: serverParams.perPage,
        }

        if (serverParams.globalSearchTerm) {
            params[paramMap.search] = serverParams.globalSearchTerm
        }

        // Handle sorting (support multi-column sort)
        if (serverParams.sort && serverParams.sort.length > 0) {
            const sorts = serverParams.sort
            if (sorts.length === 1) {
                params[paramMap.sortBy] = sorts[0].field
                params[paramMap.sortOrder] = sorts[0].type
            } else {
                // Support configurable array key formatting for multi-sort
                if (paramMap.arraySuffixForArrays) {
                    // Default behavior: sortBy[]=field&sortOrder[]=asc
                    params[`${paramMap.sortBy}[]`] = sorts.map(s => s.field)
                    params[`${paramMap.sortOrder}[]`] = sorts.map(s => s.type)
                } else {
                    // Alternative behavior: sortBy=field&sortOrder=asc (plain arrays)
                    params[paramMap.sortBy] = sorts.map(s => s.field)
                    params[paramMap.sortOrder] = sorts.map(s => s.type)
                }
            }
        }

        // Handle column filters
        Object.entries(serverParams.columnFilters).forEach(([key, raw]) => {
            const val = raw && typeof raw === 'object' && 'value' in raw ? raw.value : raw
            const hasVal = Array.isArray(val)
                ? val.length > 0
                : val !== undefined && val !== null && String(val).length > 0
            if (hasVal) {
                // Check for per-column filterKey override
                const columnsArray = unref(columns)
                const column = columnsArray && columnsArray.find(col => col.field === key)

                let filterKey = key

                if (column && column.filterKey) {
                    // Use explicit filterKey from column definition
                    filterKey = column.filterKey
                } else {
                    // Apply custom filter key transformation or default to snake_case
                    const toSnakeCase = str => str.replace(/[A-Z]/g, letter => '_' + letter.toLowerCase())
                    const transform = filterKeyTransform || toSnakeCase
                    const snakeCaseKey = transform(key)
                    filterKey = paramMap.filterPrefix ? `${paramMap.filterPrefix}${snakeCaseKey}` : snakeCaseKey
                }

                params[filterKey] = val
            }
        })

        return params
    }

    const loadItems = (preserveState = true) => {
        if (loading.value) return Promise.resolve()

        loading.value = true
        error.value = null

        const params = getQueryParams()

        const options = {
            preserveState: preserveState,
            preserveScroll: true,
            onSuccess: () => {
                loading.value = false
                error.value = null // Clear any previous errors
                if (afterLoad && typeof afterLoad === 'function') {
                    afterLoad()
                }
            },
            onError: errors => {
                loading.value = false
                // Forward server error messages if present
                if (errors && typeof errors === 'object') {
                    const errorMsg = errors.message || errors.error || 'Failed to load data'
                    error.value = errorMsg
                } else {
                    error.value = 'Failed to load data'
                }
                console.error('Table loading error:', errors)

                // Call consumer-provided onError callback if available
                if (onErrorCallback && typeof onErrorCallback === 'function') {
                    onErrorCallback(errors, error.value)
                }
            },
            onFinish: () => {
                loading.value = false
                if (onFinish && typeof onFinish === 'function') {
                    onFinish()
                }
            },
        }

        // Only add 'only' option if resourceKeys are provided
        if (resourceKeys && Array.isArray(resourceKeys)) {
            options.only = resourceKeys
        }

        let url
        if (routeName) {
            // Prefer Ziggy route helper if available
            const ziggyRoute =
                typeof route === 'function'
                    ? route
                    : typeof window !== 'undefined' && typeof window.route === 'function'
                      ? window.route
                      : null

            if (ziggyRoute) {
                try {
                    url = ziggyRoute(routeName, routeParams)
                } catch (e) {
                    const msg = `[useServerTable] Failed to build URL with routeName="${routeName}". Error: ${e.message}`
                    console.error(msg, e)
                    error.value = msg
                    if (onErrorCallback && typeof onErrorCallback === 'function') {
                        try {
                            onErrorCallback({ message: msg }, msg)
                        } catch (callbackError) {
                            /* no-op */
                        }
                    }
                    loading.value = false
                    return Promise.resolve({ ok: false, error: msg })
                }
            } else if (typeof buildUrl === 'function') {
                // Use consumer-provided URL builder as a safer fallback
                try {
                    url = buildUrl({ routeName, routeParams })
                } catch (e) {
                    const msg = `[useServerTable] buildUrl() function failed. Error: ${e.message}`
                    console.error(msg, e)
                    error.value = msg
                    if (onErrorCallback && typeof onErrorCallback === 'function') {
                        try {
                            onErrorCallback({ message: msg }, msg)
                        } catch (callbackError) {
                            /* no-op */
                        }
                    }
                    loading.value = false
                    return Promise.resolve({ ok: false, error: msg })
                }
            } else {
                // Enhanced error message with guidance
                const msg =
                    `[useServerTable] routeName="${routeName}" provided but no Ziggy route helper or buildUrl() available. ` +
                    `Ensure Ziggy is properly configured or provide a buildUrl function: ` +
                    `buildUrl: ({ routeName, routeParams }) => '/your/path'`
                console.error(msg)
                error.value = msg
                if (onErrorCallback && typeof onErrorCallback === 'function') {
                    try {
                        onErrorCallback({ message: msg }, msg)
                    } catch (e) {
                        /* no-op */
                    }
                }
                loading.value = false
                return Promise.resolve({ ok: false, error: msg })
            }
        } else if (typeof buildUrl === 'function') {
            // No routeName, but buildUrl provided
            try {
                url = buildUrl({ routeParams })
            } catch (e) {
                const msg = `[useServerTable] buildUrl() function failed. Error: ${e.message}`
                console.error(msg, e)
                error.value = msg
                if (onErrorCallback && typeof onErrorCallback === 'function') {
                    try {
                        onErrorCallback({ message: msg }, msg)
                    } catch (callbackError) {
                        /* no-op */
                    }
                }
                loading.value = false
                return Promise.resolve({ ok: false, error: msg })
            }
        } else {
            // Fallback to current path with warning
            url = typeof window !== 'undefined' ? window.location.pathname : '/'
            if (import.meta?.env?.MODE !== 'production') {
                console.warn('[useServerTable] No routeName or buildUrl provided, falling back to current path:', url)
            }
        }

        // Track success state for consumers
        let ok = true
        const userOnSuccess = options.onSuccess
        const userOnError = options.onError

        options.onSuccess = (...args) => {
            ok = true
            userOnSuccess && userOnSuccess(...args)
        }
        options.onError = errs => {
            ok = false
            userOnError && userOnError(errs)
        }

        return new Promise(resolve => {
            options.onFinish = () => {
                loading.value = false
                if (onFinish && typeof onFinish === 'function') {
                    onFinish()
                }
                resolve({ ok, error: ok ? null : error.value || 'Failed to load data' })
            }
            router.get(url, params, options)
        })
    }

    // Computed properties for PrimeVue DataTable compatibility
    const tableParams = computed(() => ({
        lazy: true,
        paginator: true,
        rows: serverParams.perPage,
        rowsPerPageOptions: [10, 25, 50, 100],
        paginatorTemplate: 'FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown',
        currentPageReportTemplate: 'Showing {first} to {last} of {totalRecords} entries',
        sortMode: 'single',
        filterDisplay: 'row',
        globalFilterFields: ['name', 'email', 'code'], // Default fields, should be customized per component
    }))

    const reset = () => {
        Object.assign(serverParams, {
            page: 1,
            perPage: 10,
            sort: [],
            columnFilters: {},
            globalSearchTerm: '',
            ...restOptions,
        })
    }

    // PrimeVue DataTable event handlers
    const onPage = (event) => {
        serverParams.page = event.page + 1 // PrimeVue uses 0-based indexing
        serverParams.perPage = event.rows
        loadItems()
    }

    const onSort = (event) => {
        if (event.sortField && event.sortOrder) {
            onSortChange({
                sortField: event.sortField,
                sortOrder: event.sortOrder
            })
        } else {
            onSortChange({})
        }
    }

    const onFilter = (event) => {
        // Handle global filter
        if (event.filters.global && event.filters.global.value !== undefined) {
            onSearch(event.filters.global.value)
        }
        
        // Handle column filters
        const columnFilters = {}
        Object.keys(event.filters).forEach(key => {
            if (key !== 'global' && event.filters[key] && event.filters[key].value !== undefined) {
                columnFilters[key] = event.filters[key].value
            }
        })
        
        if (Object.keys(columnFilters).length > 0) {
            onColumnFilter(columnFilters)
        }
    }

    return {
        // State
        serverParams,
        loading,
        error,
        tableParams,

        // Legacy Methods (for backward compatibility)
        updateParams,
        onPageChange,
        onPerPageChange,
        onColumnFilter,
        onSortChange,
        onSearch,
        loadItems,
        getQueryParams,
        reset,

        // PrimeVue DataTable Methods
        onPage,
        onSort,
        onFilter,
    }
}
