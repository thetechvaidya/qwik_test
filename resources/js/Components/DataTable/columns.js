import { FilterMatchMode } from '@primevue/core/api'

/**
 * Enhanced column definitions for PrimeVue 4.x DataTable
 * Following modern design patterns and responsive behavior
 */

// Status badge component for inline use
export const StatusBadge = {
    template: `
        <span 
            :class="[
                'inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-medium',
                getBadgeClasses(value, options)
            ]"
        >
            <span v-if="showIcon" :class="getIconClasses(value, options)" class="mr-1"></span>
            {{ getDisplayText(value, options) }}
        </span>
    `,
    props: {
        value: [String, Number, Boolean],
        options: {
            type: Object,
            default: () => ({
                active: { text: 'Active', class: 'bg-green-100 text-green-800', icon: 'pi pi-check-circle' },
                inactive: { text: 'Inactive', class: 'bg-red-100 text-red-800', icon: 'pi pi-times-circle' },
                draft: { text: 'Draft', class: 'bg-yellow-100 text-yellow-800', icon: 'pi pi-clock' },
                published: { text: 'Published', class: 'bg-blue-100 text-blue-800', icon: 'pi pi-eye' },
                pending: { text: 'Pending', class: 'bg-orange-100 text-orange-800', icon: 'pi pi-hourglass' }
            })
        },
        showIcon: { type: Boolean, default: true }
    },
    methods: {
        getBadgeClasses(value, options) {
            const normalizedValue = this.normalizeValue(value)
            return options[normalizedValue]?.class || 'bg-gray-100 text-gray-800'
        },
        getIconClasses(value, options) {
            const normalizedValue = this.normalizeValue(value)
            return options[normalizedValue]?.icon || 'pi pi-info-circle'
        },
        getDisplayText(value, options) {
            const normalizedValue = this.normalizeValue(value)
            return options[normalizedValue]?.text || String(value)
        },
        normalizeValue(value) {
            if (typeof value === 'boolean') return value ? 'active' : 'inactive'
            if (typeof value === 'number') return value === 1 ? 'active' : 'inactive'
            return String(value).toLowerCase()
        }
    }
}

// Action button component
export const ActionButton = {
    template: `
        <button
            :class="[
                'inline-flex items-center px-3 py-1.5 text-sm font-medium rounded-md transition-colors focus:outline-none focus:ring-2 focus:ring-offset-2',
                getButtonClasses(variant)
            ]"
            @click="$emit('click', $event)"
            :disabled="disabled"
            :title="tooltip"
        >
            <i v-if="icon" :class="[icon, text ? 'mr-2' : '']"></i>
            {{ text }}
        </button>
    `,
    props: {
        text: String,
        icon: String,
        variant: { type: String, default: 'primary' },
        disabled: { type: Boolean, default: false },
        tooltip: String
    },
    emits: ['click'],
    methods: {
        getButtonClasses(variant) {
            const variants = {
                primary: 'bg-blue-600 text-white hover:bg-blue-700 focus:ring-blue-500',
                secondary: 'bg-gray-600 text-white hover:bg-gray-700 focus:ring-gray-500',
                success: 'bg-green-600 text-white hover:bg-green-700 focus:ring-green-500',
                danger: 'bg-red-600 text-white hover:bg-red-700 focus:ring-red-500',
                warning: 'bg-yellow-600 text-white hover:bg-yellow-700 focus:ring-yellow-500',
                info: 'bg-blue-500 text-white hover:bg-blue-600 focus:ring-blue-500',
                light: 'bg-gray-100 text-gray-800 hover:bg-gray-200 focus:ring-gray-500',
                outline: 'border border-gray-300 text-gray-700 hover:bg-gray-50 focus:ring-gray-500'
            }
            return variants[variant] || variants.primary
        }
    }
}

// Actions dropdown component
export const ActionsDropdown = {
    template: `
        <div class="relative inline-block text-left">
            <button
                @click="showDropdown = !showDropdown"
                class="inline-flex items-center px-3 py-2 text-sm font-medium text-gray-700 bg-white border border-gray-300 rounded-md hover:bg-gray-50 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-blue-500"
            >
                <i class="pi pi-ellipsis-v"></i>
            </button>
            
            <div
                v-show="showDropdown"
                @click.away="showDropdown = false"
                class="absolute right-0 z-50 mt-2 w-48 origin-top-right bg-white rounded-md shadow-lg ring-1 ring-black ring-opacity-5 focus:outline-none"
            >
                <div class="py-1">
                    <slot name="actions" :close="() => showDropdown = false" />
                </div>
            </div>
        </div>
    `,
    data() {
        return {
            showDropdown: false
        }
    },
    mounted() {
        document.addEventListener('click', this.handleClickOutside)
    },
    beforeUnmount() {
        document.removeEventListener('click', this.handleClickOutside)
    },
    methods: {
        handleClickOutside(event) {
            if (!this.$el.contains(event.target)) {
                this.showDropdown = false
            }
        }
    }
}

/**
 * Enhanced column factory functions
 */

// Basic text column with modern filtering
export const textColumn = (field, options = {}) => ({
    field,
    header: options.header || field.charAt(0).toUpperCase() + field.slice(1),
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    filterMatchMode: FilterMatchMode.CONTAINS,
    style: options.style,
    headerStyle: options.headerStyle,
    bodyStyle: options.bodyStyle,
    responsivePriority: options.responsivePriority,
    frozen: options.frozen,
    filterOptions: {
        type: 'text',
        placeholder: options.filterPlaceholder || `Filter ${options.header || field}...`
    },
    ...options
})

// Enhanced status column with badge rendering
export const statusColumn = (field = 'status', options = {}) => ({
    field,
    header: options.header || 'Status',
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    style: { width: '120px', ...options.style },
    bodyTemplate: StatusBadge,
    filterOptions: {
        type: 'dropdown',
        placeholder: 'Filter Status...',
        options: options.statusOptions || [
            { label: 'Active', value: 'active' },
            { label: 'Inactive', value: 'inactive' },
            { label: 'Draft', value: 'draft' },
            { label: 'Published', value: 'published' }
        ],
        optionLabel: 'label',
        optionValue: 'value'
    },
    ...options
})

// Code/ID column with copy functionality
export const codeColumn = (field = 'code', options = {}) => ({
    field,
    header: options.header || 'Code',
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    style: { width: '140px', ...options.style },
    bodyTemplate: {
        template: `
            <div class="flex items-center">
                <code 
                    class="px-2 py-1 text-xs bg-gray-100 text-gray-800 rounded cursor-pointer hover:bg-gray-200 transition-colors"
                    @click="copyToClipboard(value)"
                    :title="'Click to copy: ' + value"
                >
                    {{ value }}
                </code>
                <i class="pi pi-copy ml-2 text-gray-400 cursor-pointer hover:text-gray-600" @click="copyToClipboard(value)"></i>
            </div>
        `,
        props: ['value'],
        methods: {
            async copyToClipboard(text) {
                try {
                    await navigator.clipboard.writeText(text)
                    this.$toast?.add({
                        severity: 'success',
                        summary: 'Copied',
                        detail: 'Code copied to clipboard',
                        life: 2000
                    })
                } catch (err) {
                    console.error('Failed to copy:', err)
                }
            }
        }
    },
    filterOptions: {
        type: 'text',
        placeholder: options.filterPlaceholder || 'Filter code...'
    },
    ...options
})

// Actions column with dropdown menu
export const actionsColumn = (actions = [], options = {}) => ({
    field: 'actions',
    header: options.header || 'Actions',
    sortable: false,
    style: { width: '120px', textAlign: 'center', ...options.style },
    bodyTemplate: {
        template: `
            <ActionsDropdown>
                <template #actions="{ close }">
                    <template v-for="action in actions" :key="action.key">
                        <button
                            v-if="!action.condition || action.condition(data)"
                            @click="handleAction(action, close)"
                            :class="[
                                'flex items-center w-full px-4 py-2 text-sm text-left transition-colors',
                                action.variant === 'danger' ? 'text-red-700 hover:bg-red-50' : 'text-gray-700 hover:bg-gray-50'
                            ]"
                        >
                            <i v-if="action.icon" :class="[action.icon, 'mr-3']"></i>
                            {{ action.label }}
                        </button>
                        <hr v-if="action.separator" class="my-1 border-gray-200">
                    </template>
                </template>
            </ActionsDropdown>
        `,
        components: { ActionsDropdown },
        props: ['data', 'index'],
        data() {
            return { actions }
        },
        methods: {
            handleAction(action, close) {
                close()
                if (typeof action.handler === 'function') {
                    action.handler(this.data, this.index)
                }
            }
        }
    },
    ...options
})

// Date column with formatting
export const dateColumn = (field, options = {}) => ({
    field,
    header: options.header || field.charAt(0).toUpperCase() + field.slice(1),
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    dataType: 'date',
    style: { width: '150px', ...options.style },
    bodyTemplate: {
        template: `
            <span :title="formatDate(value, 'full')">
                {{ formatDate(value, format) }}
            </span>
        `,
        props: ['value'],
        data() {
            return {
                format: options.format || 'short'
            }
        },
        methods: {
            formatDate(date, format) {
                if (!date) return '-'
                const d = new Date(date)
                if (isNaN(d.getTime())) return '-'
                
                const formats = {
                    short: d.toLocaleDateString(),
                    medium: d.toLocaleDateString('en-US', { 
                        year: 'numeric', 
                        month: 'short', 
                        day: 'numeric' 
                    }),
                    full: d.toLocaleDateString('en-US', { 
                        year: 'numeric', 
                        month: 'long', 
                        day: 'numeric',
                        hour: '2-digit',
                        minute: '2-digit'
                    })
                }
                return formats[format] || formats.short
            }
        }
    },
    filterOptions: {
        type: 'date',
        placeholder: 'Filter date...'
    },
    ...options
})

// Number column with formatting
export const numberColumn = (field, options = {}) => ({
    field,
    header: options.header || field.charAt(0).toUpperCase() + field.slice(1),
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    dataType: 'numeric',
    style: { width: '120px', textAlign: 'right', ...options.style },
    bodyTemplate: {
        template: `
            <span>{{ formatNumber(value, options) }}</span>
        `,
        props: ['value'],
        data() {
            return { options }
        },
        methods: {
            formatNumber(value, opts = {}) {
                if (value === null || value === undefined) return '-'
                const num = Number(value)
                if (isNaN(num)) return value
                
                return num.toLocaleString('en-US', {
                    minimumFractionDigits: opts.decimals || 0,
                    maximumFractionDigits: opts.decimals || (num % 1 === 0 ? 0 : 2),
                    style: opts.currency ? 'currency' : 'decimal',
                    currency: opts.currency || 'USD'
                })
            }
        }
    },
    filterOptions: {
        type: 'number',
        placeholder: 'Filter number...'
    },
    ...options
})

// Boolean column with toggle switch
export const booleanColumn = (field, options = {}) => ({
    field,
    header: options.header || field.charAt(0).toUpperCase() + field.slice(1),
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    dataType: 'boolean',
    style: { width: '120px', textAlign: 'center', ...options.style },
    bodyTemplate: {
        template: `
            <span 
                :class="[
                    'inline-flex items-center px-2 py-1 rounded-full text-xs font-medium',
                    value ? 'bg-green-100 text-green-800' : 'bg-red-100 text-red-800'
                ]"
            >
                <i :class="[value ? 'pi pi-check' : 'pi pi-times', 'mr-1']"></i>
                {{ value ? (trueLabel || 'Yes') : (falseLabel || 'No') }}
            </span>
        `,
        props: ['value'],
        data() {
            return {
                trueLabel: options.trueLabel,
                falseLabel: options.falseLabel
            }
        }
    },
    filterOptions: {
        type: 'dropdown',
        placeholder: 'Filter...',
        options: [
            { label: options.trueLabel || 'Yes', value: true },
            { label: options.falseLabel || 'No', value: false }
        ],
        optionLabel: 'label',
        optionValue: 'value'
    },
    ...options
})

// Image column with thumbnail
export const imageColumn = (field, options = {}) => ({
    field,
    header: options.header || 'Image',
    sortable: false,
    style: { width: '100px', textAlign: 'center', ...options.style },
    bodyTemplate: {
        template: `
            <div class="flex justify-center">
                <img 
                    v-if="value"
                    :src="value"
                    :alt="alt || 'Image'"
                    class="w-12 h-12 rounded-lg object-cover border border-gray-200"
                    @error="handleImageError"
                />
                <div v-else class="w-12 h-12 rounded-lg bg-gray-100 flex items-center justify-center">
                    <i class="pi pi-image text-gray-400"></i>
                </div>
            </div>
        `,
        props: ['value'],
        data() {
            return {
                alt: options.alt
            }
        },
        methods: {
            handleImageError(event) {
                event.target.style.display = 'none'
                const nextElement = event.target.nextElementSibling
                if (nextElement) {
                    nextElement.style.display = 'flex'
                }
            }
        }
    },
    ...options
})

// Link column with external link handling
export const linkColumn = (field, options = {}) => ({
    field,
    header: options.header || field.charAt(0).toUpperCase() + field.slice(1),
    sortable: options.sortable !== false,
    filterField: options.filterField || field,
    bodyTemplate: {
        template: `
            <a 
                v-if="value"
                :href="getUrl(value)"
                :target="target"
                :rel="target === '_blank' ? 'noopener noreferrer' : undefined"
                class="text-blue-600 hover:text-blue-800 hover:underline"
            >
                {{ getDisplayText(value) }}
                <i v-if="target === '_blank'" class="pi pi-external-link ml-1 text-xs"></i>
            </a>
            <span v-else class="text-gray-400">-</span>
        `,
        props: ['value'],
        data() {
            return {
                target: options.target || '_self',
                urlPrefix: options.urlPrefix || ''
            }
        },
        methods: {
            getUrl(value) {
                if (options.urlBuilder && typeof options.urlBuilder === 'function') {
                    return options.urlBuilder(value)
                }
                return this.urlPrefix + value
            },
            getDisplayText(value) {
                if (options.textBuilder && typeof options.textBuilder === 'function') {
                    return options.textBuilder(value)
                }
                return value
            }
        }
    },
    filterOptions: {
        type: 'text',
        placeholder: `Filter ${options.header || field}...`
    },
    ...options
})

/**
 * Column presets for common use cases
 */

// User/Profile columns
export const userColumns = {
    avatar: (field = 'avatar') => imageColumn(field, { 
        header: 'Avatar', 
        alt: 'User Avatar' 
    }),
    
    name: (field = 'name') => textColumn(field, { 
        header: 'Name',
        style: { fontWeight: 'medium' }
    }),
    
    email: (field = 'email') => linkColumn(field, {
        header: 'Email',
        urlPrefix: 'mailto:',
        target: '_self'
    }),
    
    role: (field = 'role') => statusColumn(field, {
        header: 'Role',
        statusOptions: [
            { label: 'Admin', value: 'admin' },
            { label: 'User', value: 'user' },
            { label: 'Moderator', value: 'moderator' }
        ]
    }),
    
    lastLogin: (field = 'last_login_at') => dateColumn(field, {
        header: 'Last Login',
        format: 'medium'
    })
}

// Content management columns
export const contentColumns = {
    title: (field = 'title') => textColumn(field, {
        header: 'Title',
        style: { fontWeight: 'medium', maxWidth: '300px' }
    }),
    
    slug: (field = 'slug') => codeColumn(field, {
        header: 'Slug'
    }),
    
    status: (field = 'status') => statusColumn(field, {
        statusOptions: [
            { label: 'Published', value: 'published' },
            { label: 'Draft', value: 'draft' },
            { label: 'Archived', value: 'archived' }
        ]
    }),
    
    publishedAt: (field = 'published_at') => dateColumn(field, {
        header: 'Published',
        format: 'medium'
    }),
    
    author: (field = 'author') => textColumn(field, {
        header: 'Author'
    })
}

// E-commerce columns  
export const ecommerceColumns = {
    price: (field = 'price') => numberColumn(field, {
        header: 'Price',
        currency: 'USD',
        decimals: 2
    }),
    
    quantity: (field = 'quantity') => numberColumn(field, {
        header: 'Quantity',
        decimals: 0
    }),
    
    inStock: (field = 'in_stock') => booleanColumn(field, {
        header: 'In Stock',
        trueLabel: 'Available',
        falseLabel: 'Out of Stock'
    })
}

export default {
    // Core column types
    textColumn,
    statusColumn,
    codeColumn,
    actionsColumn,
    dateColumn,
    numberColumn,
    booleanColumn,
    imageColumn,
    linkColumn,
    
    // Components
    StatusBadge,
    ActionButton,
    ActionsDropdown,
    
    // Presets
    userColumns,
    contentColumns,
    ecommerceColumns
}