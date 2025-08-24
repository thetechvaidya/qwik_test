import { inject } from 'vue'
import { useConfirm } from 'primevue/useconfirm'
import { useToast } from 'primevue/usetoast'

/**
 * Lightweight confirm/toast helpers with PrimeVue official composables.
 * Usage:
 * const { confirm, toast } = useConfirmToast()
 * Preferred pattern (boolean):
 *   const ok = await confirm({ header, message })
 *   if (ok) { performAction() }
 * Backward-compatible callback form is also supported:
 *   await confirm({ header, message, accept: () => doAction(), reject: () => {} })
 * toast({ severity, summary, detail, life })
 */
export function useConfirmToast() {
    // Use PrimeVue composables directly
    let confirmService, toastService

    try {
        confirmService = useConfirm()
        toastService = useToast()
    } catch (error) {
        // Fall back to service injection if composables are not available
        try {
            confirmService = inject('confirm') || (typeof window !== 'undefined' ? window.$confirm : null)
            toastService = inject('toast') || (typeof window !== 'undefined' ? window.$toast : null)
        } catch (injectError) {
            console.warn('Could not access confirm/toast services:', injectError)
            confirmService = null
            toastService = null
        }
    }

    const confirm = async (options = {}) => {
        // If PrimeVue ConfirmDialog service available (either composable or injected)
        if (confirmService && typeof confirmService.require === 'function') {
            return new Promise(resolve => {
                confirmService.require({
                    header: options.header || 'Confirm',
                    message: options.message || 'Are you sure?',
                    icon: options.icon || 'pi pi-info-circle',
                    acceptClass: options.acceptClass || 'p-button-danger',
                    rejectLabel: options.rejectLabel || 'Cancel',
                    acceptLabel: options.acceptLabel || 'OK',
                    accept: async () => {
                        try {
                            if (typeof options.accept === 'function') await options.accept()
                            resolve(true)
                        } catch (e) {
                            resolve(false)
                        }
                    },
                    reject: () => {
                        if (typeof options.reject === 'function') options.reject()
                        resolve(false)
                    },
                })
            })
        }

        // Fallback to native confirm
        const ok = typeof window !== 'undefined' ? window.confirm(options.message || 'Are you sure?') : false
        if (ok && typeof options.accept === 'function') await options.accept()
        if (!ok && typeof options.reject === 'function') options.reject()
        return ok
    }

    const toast = (payload = {}) => {
        if (toastService && typeof toastService.add === 'function') {
            toastService.add({
                severity: payload.severity || 'info',
                summary: payload.summary || '',
                detail: payload.detail || '',
                life: payload.life ?? 3000,
            })
            return
        }
        // Fallback: console message
        const sev = (payload.severity || 'info').toUpperCase()

        console[sev === 'ERROR' ? 'error' : 'log'](`[${sev}] ${payload.summary ?? ''} ${payload.detail ?? ''}`)
    }

    return { confirm, toast }
}
