// Shared table column helper definitions to keep consistency across admin pages
// Each helper receives a translation function t (or __) and optional extra props

export const codeColumn = (t, { width = '11rem', trigger = 'enter' } = {}) => ({
    label: t('Code'),
    field: 'code',
    filterOptions: {
        enabled: true,
        placeholder: `${t('Search')} ${t('Code')}`,
        filterValue: null,
        trigger,
    },
    sortable: false,
    width,
})

export const statusColumn = (t, { options = null, width = '11rem' } = {}) => ({
    label: t('Status'),
    field: 'status',
    sortable: false,
    filterOptions: {
        enabled: true,
        placeholder: `${t('Search')} ${t('Status')}`,
        filterValue: null,
        filterDropdownItems: options ?? [
            { value: 1, text: t('Active') },
            { value: 0, text: t('In-active') },
        ],
    },
    width,
})

export const textFilterColumn = (
    t,
    { label, field, placeholderLabel = null, trigger = 'enter', sortable = false, width = null, filterKey = null }
) => ({
    label: t(label),
    field,
    ...(filterKey ? { filterKey } : {}),
    filterOptions: {
        enabled: true,
        placeholder: `${t('Search')} ${t(placeholderLabel || label)}`,
        filterValue: null,
        trigger,
    },
    sortable,
    ...(width ? { width } : {}),
})

export const dropdownFilterColumn = (t, { label, field, items, filterKey = null, sortable = false, width = null }) => ({
    label: t(label),
    field,
    ...(filterKey ? { filterKey } : {}),
    sortable,
    filterOptions: {
        enabled: true,
        placeholder: `${t('Search')} ${t(label)}`,
        filterValue: null,
        filterDropdownItems: items,
    },
    ...(width ? { width } : {}),
})
