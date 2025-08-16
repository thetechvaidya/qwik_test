import { ref } from 'vue'
import { useClipboard } from '@vueuse/core'
import { useConfirmToast } from '@/composables/useConfirmToast'

/**
 * Copy-to-clipboard composable for admin UI components.
 *
 * @WARNING This composable is designed for browser-only usage and includes SSR guards.
 * Do not use on server-side or in universal/isomorphic contexts.
 *
 * @param {Object} options - Configuration options
 * @param {Function} options.t - Translation function (optional)
 * @returns {Object} Copy methods and state
 */
export function useCopy({ t } = {}) {
    const _ = msg => (t ? t(msg) : msg)

    // SSR guard: useClipboard from @vueuse/core is browser-only
    const { copy, isSupported } =
        typeof window !== 'undefined' ? useClipboard() : { copy: null, isSupported: ref(false) }
    const copying = ref(false)

    const { toast } = useConfirmToast()

    const handleCopyClick = async (
        text,
        successMessage = _('Copied to clipboard!'),
        errorMessage = _('Failed to copy')
    ) => {
        // SSR guard: early return in server environment
        if (typeof window === 'undefined' || typeof document === 'undefined') {
            console.warn('[useCopy] Attempted to copy in SSR environment')
            return
        }

        if (text === undefined || text === null || copying.value) return

        copying.value = true

        try {
            if (isSupported.value && copy) {
                await copy(text)

                // Show success toast
                toast({ severity: 'success', summary: _('Success'), detail: successMessage })
            } else {
                // Fallback method for unsupported browsers
                await fallbackCopy(text)

                toast({ severity: 'success', summary: _('Success'), detail: successMessage })
            }
        } catch (error) {
            console.error('Copy failed:', error)

            // Show error toast
            toast({ severity: 'error', summary: _('Error'), detail: errorMessage })
        } finally {
            copying.value = false
        }
    }

    const fallbackCopy = async text => {
        return new Promise((resolve, reject) => {
            // SSR guard: document must be available
            if (typeof window === 'undefined' || typeof document === 'undefined') {
                reject(new Error('Document not available (SSR environment)'))
                return
            }

            // Create a temporary textarea element
            const textarea = document.createElement('textarea')
            textarea.value = text
            textarea.style.position = 'fixed'
            textarea.style.opacity = '0'
            textarea.style.left = '-9999px'

            document.body.appendChild(textarea)

            try {
                textarea.select()
                textarea.setSelectionRange(0, 99999) // For mobile devices

                const successful = document.execCommand('copy')
                if (successful) {
                    resolve()
                } else {
                    reject(new Error('execCommand failed'))
                }
            } catch (error) {
                reject(error)
            } finally {
                document.body.removeChild(textarea)
            }
        })
    }

    const copyToClipboard = text => {
        return handleCopyClick(text)
    }

    const copyCode = code => {
        return handleCopyClick(code, _('Code copied to clipboard!'))
    }

    const copyId = id => {
        if (id === undefined || id === null) return
        return handleCopyClick(String(id), _('ID copied to clipboard!'))
    }

    const copyUrl = url => {
        return handleCopyClick(url, _('URL copied to clipboard!'))
    }

    return {
        copying,
        handleCopyClick,
        copyToClipboard,
        copyCode,
        copyId,
        copyUrl,
        isSupported,
    }
}
