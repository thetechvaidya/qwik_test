import { ref, reactive, computed } from 'vue'
import { useForm } from '@inertiajs/vue3'
import { router } from '@inertiajs/vue3'
import { useConfirmToast } from '@/composables/useConfirmToast'

/**
 * useAdminForm
 * Standardizes admin form CRUD with Inertia useForm.
 *
 * i18n: pass a `t` function or a `messages` map to localize Success/Error/Confirm strings.
 *
 * Confirm API: destructive actions should use the boolean-returning confirm pattern.
 *   const ok = await confirm({ header, message, icon, acceptClass, acceptLabel, rejectLabel })
 *   if (ok) performAction()
 * Callback style remains supported by useConfirmToast for backward compatibility, but new code should prefer the boolean form.
 */
export function useAdminForm(formConfig = {}) {
    const {
        initialData = {},
        createUrl = null,
        updateUrl = null,
        deleteUrl = null,
        redirectUrl = null,
        confirmDelete = true,
        transformData = null,
        routeName = null, // New option to support Ziggy route building
        routeParams = {}, // Parameters for route building
        idParam = 'id', // Configurable id param for resource routes
        preferArrayParam = false, // Fallback to array shorthand when appropriate
        paramResolver = null, // New: function(operation, item) => params (object or array)
        onCreateSuccess = null,
        onUpdateSuccess = null,
        onDeleteSuccess = null,
        // i18n support
        t = null,
        messages = {},
    } = formConfig

    // Validation warnings for missing URLs
    const validateUrls = () => {
        if (!createUrl && !routeName) {
            console.warn(
                'useAdminForm: createUrl not provided. Form creation may fail. Consider providing createUrl or routeName.'
            )
        }
        if (!updateUrl && !routeName) {
            console.warn(
                'useAdminForm: updateUrl not provided. Form updates may fail. Consider providing updateUrl or routeName.'
            )
        }
        if (!deleteUrl && !routeName) {
            console.warn(
                'useAdminForm: deleteUrl not provided. Item deletion may fail. Consider providing deleteUrl or routeName.'
            )
        }
    }

    // Run validation on initialization
    validateUrls()

    // Helper function to build URLs using Ziggy if routeName is provided
    const buildUrl = (operation, item = null) => {
        if (routeName) {
            const routeMap = {
                create: `${routeName}.store`,
                update: `${routeName}.update`,
                delete: `${routeName}.destroy`,
            }

            const baseRouteName = routeMap[operation]
            const r =
                typeof route === 'function'
                    ? route
                    : typeof window !== 'undefined' && typeof window.route === 'function'
                      ? window.route
                      : null
            if (baseRouteName && r) {
                // Resolve params with precedence: paramResolver > explicit routeParams/id heuristics
                let resolvedParams = null
                if (typeof paramResolver === 'function') {
                    try {
                        resolvedParams = paramResolver(operation, item)
                    } catch (e) {
                        // fall through to defaults
                        resolvedParams = null
                    }
                }
                const params = resolvedParams ?? { ...routeParams }
                if (item && operation !== 'create') {
                    const itemId = item?.[idParam] ?? item?.id
                    if (Array.isArray(params)) {
                        // paramResolver returned array
                        try {
                            return r(baseRouteName, params)
                        } catch (e) {
                            /* continue */
                        }
                    }
                    if (preferArrayParam) {
                        // Use array shorthand: route('resource.update', [id])
                        try {
                            return r(baseRouteName, [itemId])
                        } catch (e) {}
                    }
                    // Try object param: { [idParam]: id }
                    try {
                        return r(
                            baseRouteName,
                            Array.isArray(params) ? { [idParam]: itemId } : { ...params, [idParam]: itemId }
                        )
                    } catch (e) {
                        // Fallback to array shorthand if object param fails
                        try {
                            return r(baseRouteName, [itemId])
                        } catch (e2) {
                            /* no-op */
                        }
                    }
                }
                return r(baseRouteName, params)
            }
        }
        return null
    }

    // Confirm/Toast services
    const { confirm: confirmSvc, toast } = useConfirmToast()

    // Translation helper
    const _ = (key, fallback) => (typeof t === 'function' ? t(key) : (messages?.[key] ?? fallback ?? key))

    // UI State
    const showCreateDrawer = ref(false)
    const showEditDrawer = ref(false)
    const loading = ref(false)
    const deleting = ref(false)
    const editingItem = ref(null)

    // Form state using Inertia's useForm
    const form = useForm(initialData)

    // Computed properties
    const isEditing = computed(() => !!editingItem.value)
    const formTitle = computed(() => (isEditing.value ? 'Edit Item' : 'Create New Item'))

    // Form methods
    const openCreateForm = (data = {}) => {
        editingItem.value = null
        form.reset()
        form.clearErrors()

        // Safely merge provided data with initialData, only setting known form fields
        Object.keys(initialData).forEach(key => {
            form[key] = data[key] ?? initialData[key]
        })
        showCreateDrawer.value = true
    }

    const openEditForm = item => {
        editingItem.value = item
        form.reset()
        form.clearErrors()

        // Populate form with item data
        Object.keys(initialData).forEach(key => {
            if (item.hasOwnProperty(key)) {
                form[key] = item[key]
            }
        })

        showEditDrawer.value = true
    }

    const closeForm = () => {
        showCreateDrawer.value = false
        showEditDrawer.value = false
        editingItem.value = null
        form.reset()
        form.clearErrors()
    }

    const submitForm = async () => {
        if (loading.value) return

        loading.value = true

        try {
            let formData = { ...form.data() }

            // Apply data transformation if provided
            if (transformData && typeof transformData === 'function') {
                formData = transformData(formData, isEditing.value)

                // Update the form with transformed data (only for existing keys)
                Object.keys(form.data()).forEach(key => {
                    if (formData.hasOwnProperty(key)) {
                        form[key] = formData[key]
                    }
                })
            }

            if (isEditing.value) {
                // Update existing item
                const url =
                    typeof updateUrl === 'function'
                        ? updateUrl(editingItem.value)
                        : updateUrl || buildUrl('update', editingItem.value)

                if (!url) {
                    showErrorToast(_('Cannot update item: No valid URL configured. Please contact support.'))
                    loading.value = false
                    return
                }

                form.patch(url, {
                    onSuccess: () => {
                        const wasEditing = true // Capture that this was an update
                        closeForm()
                        showSuccessToast(_(wasEditing ? 'Item updated successfully!' : 'Item created successfully!'))
                        // Optional caller hook
                        if (typeof onUpdateSuccess === 'function') onUpdateSuccess()
                        // Optional redirect
                        if (redirectUrl) router.get(redirectUrl)
                    },
                    onError: () => {
                        showErrorToast(_('Failed to update item. Please try again.'))
                    },
                    onFinish: () => {
                        loading.value = false
                    },
                })
            } else {
                // Create new item
                const url = createUrl || buildUrl('create')

                if (!url) {
                    showErrorToast(_('Cannot create item: No valid URL configured. Please contact support.'))
                    loading.value = false
                    return
                }

                form.post(url, {
                    onSuccess: () => {
                        const wasEditing = false // Capture that this was a creation
                        closeForm()
                        showSuccessToast(_(wasEditing ? 'Item updated successfully!' : 'Item created successfully!'))
                        // Optional caller hook
                        if (typeof onCreateSuccess === 'function') onCreateSuccess()
                        // Optional redirect
                        if (redirectUrl) router.get(redirectUrl)
                    },
                    onError: () => {
                        showErrorToast(_('Failed to create item. Please try again.'))
                    },
                    onFinish: () => {
                        loading.value = false
                    },
                })
            }
        } catch (error) {
            loading.value = false
            showErrorToast(_('An unexpected error occurred. Please try again.'))
            console.error('Form submission error:', error)
        }
    }

    const deleteItem = async (item, customDeleteUrl = null, customConfirmation = null) => {
        if (deleting.value) return Promise.resolve(false)

        const url =
            customDeleteUrl ||
            (typeof deleteUrl === 'function' ? deleteUrl(item) : deleteUrl) ||
            buildUrl('delete', item)

        if (!url) {
            showErrorToast(_('Cannot delete item: No valid URL configured. Please contact support.'))
            return Promise.resolve(false)
        }

        const performDelete = () => {
            deleting.value = true
            let ok = false // Track success/failure status
            return new Promise(resolve => {
                router.delete(url, {
                    onSuccess: () => {
                        ok = true // Mark as successful
                        showSuccessToast(_('Item deleted successfully!'))
                        // Optional caller hook
                        if (typeof onDeleteSuccess === 'function') onDeleteSuccess(item)
                    },
                    onError: () => {
                        ok = false // Mark as failed
                        showErrorToast(_('Failed to delete item. Please try again.'))
                    },
                    onFinish: () => {
                        deleting.value = false
                        if (redirectUrl) router.get(redirectUrl)
                        resolve(ok) // Resolve with actual success/failure status
                    },
                })
            })
        }

        // Handle custom confirmation dialog
        if (customConfirmation && typeof customConfirmation === 'function') {
            try {
                const confirmed = await customConfirmation(item)
                if (confirmed) {
                    return performDelete()
                }
                return Promise.resolve(false)
            } catch (error) {
                console.error('Custom confirmation failed:', error)
                showErrorToast(_('Confirmation process failed. Please try again.'))
                return Promise.resolve(false)
            }
        } else if (confirmDelete) {
            // Use standardized confirm service
            const ok = await confirmSvc({
                header: _('Confirm Deletion'),
                message: _('Are you sure you want to delete this item? This action cannot be undone.'),
                icon: 'pi pi-exclamation-triangle',
                acceptClass: 'p-button-danger',
                acceptLabel: _('Delete'),
                rejectLabel: _('Cancel'),
            })
            if (ok) return performDelete()
            return Promise.resolve(false)
        } else if (confirmDelete === false) {
            // Explicitly skip confirmations when configured
            return performDelete()
        }
    }

    // Toast helper methods
    const showSuccessToast = message => {
        toast({ severity: 'success', summary: _('Success'), detail: message, life: 3000 })
    }

    const showErrorToast = message => {
        toast({ severity: 'error', summary: _('Error'), detail: message, life: 3000 })
    }

    // Validation helpers
    const hasErrors = computed(() => Object.keys(form.errors).length > 0)
    const getFieldError = field => form.errors[field]

    const resetForm = () => {
        form.reset()
        form.clearErrors()
        editingItem.value = null
    }

    return {
        // State
        form,
        showCreateDrawer,
        showEditDrawer,
        loading,
        deleting,
        editingItem,

        // Computed
        isEditing,
        formTitle,
        hasErrors,

        // Methods
        openCreateForm,
        openEditForm,
        closeForm,
        submitForm,
        deleteItem,
        resetForm,
        getFieldError,
        showSuccessToast,
        showErrorToast,
    }
}
