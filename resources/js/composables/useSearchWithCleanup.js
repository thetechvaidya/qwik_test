import { ref, onUnmounted } from 'vue'

/**
 * Composable for search functionality with automatic cleanup
 * Provides debounced search functionality with memory leak prevention
 */
export function useSearchWithCleanup() {
    const searchTerm = ref('')
    const searchResults = ref([])
    const isSearching = ref(false)
    let searchTimeout = null

    /**
     * Perform debounced search
     * @param {string} term - Search term
     * @param {Function} searchFn - Function to perform the actual search
     * @param {number} delay - Debounce delay in ms (default: 300)
     */
    const search = (term, searchFn, delay = 300) => {
        searchTerm.value = term

        // Clear previous timeout
        clearTimeout(searchTimeout)

        if (!term.trim()) {
            searchResults.value = []
            isSearching.value = false
            return
        }

        isSearching.value = true

        searchTimeout = setTimeout(async () => {
            try {
                const results = await searchFn(term)
                searchResults.value = results || []
            } catch (error) {
                console.error('Search failed:', error)
                searchResults.value = []
            } finally {
                isSearching.value = false
            }
        }, delay)
    }

    /**
     * Clear search results and term
     */
    const clearSearch = () => {
        searchTerm.value = ''
        searchResults.value = []
        isSearching.value = false
        clearTimeout(searchTimeout)
    }

    /**
     * Cleanup on component unmount
     */
    onUnmounted(() => {
        clearTimeout(searchTimeout)
    })

    return {
        searchTerm,
        searchResults,
        isSearching,
        search,
        clearSearch,
    }
}
