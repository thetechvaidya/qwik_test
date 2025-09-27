<template>
    <div class="modern-datatable-wrapper">
        <!-- Header Section with Global Search and Actions -->
        <div class="datatable-header" v-if="showHeader">
            <div class="datatable-title-section">
                <h3 v-if="title" class="datatable-title">{{ title }}</h3>
                <p v-if="subtitle" class="datatable-subtitle">{{ subtitle }}</p>
            </div>
            
            <!-- Global Search and Actions -->
            <div class="datatable-controls">
                <div class="search-section" v-if="showGlobalSearch">
                    <IconField iconPosition="left">
                        <InputIcon class="pi pi-search" />
                        <InputText
                            v-model="globalFilterValue"
                            :placeholder="searchPlaceholder"
                            class="global-search-input"
                            @input="onGlobalFilter"
                        />
                    </IconField>
                </div>
                
                <!-- Custom Actions Slot -->
                <div class="actions-section" v-if="$slots.actions">
                    <slot name="actions" />
                </div>
            </div>
        </div>

        <!-- Modern DataTable with PrimeVue 4.x Features -->
        <div class="datatable-container" :class="containerClasses">
            <DataTable
                ref="dataTableRef"
                :value="data"
                :lazy="lazy"
                :loading="loading"
                :paginator="paginator"
                :rows="rows"
                :totalRecords="totalRecords"
                :rowsPerPageOptions="rowsPerPageOptions"
                :first="first"
                :sortMode="sortMode"
                :sortField="sortField"
                :sortOrder="sortOrder"
                :multiSortMeta="multiSortMeta"
                :filterDisplay="filterDisplay"
                :filters="filters"
                :globalFilterFields="globalFilterFields"
                :scrollable="scrollable"
                :scrollHeight="scrollHeight"
                :virtualScrollerOptions="virtualScrollerOptions"
                :resizableColumns="resizableColumns"
                :columnResizeMode="columnResizeMode"
                :reorderableColumns="reorderableColumns"
                :showGridlines="showGridlines"
                :stripedRows="stripedRows"
                :rowHover="rowHover"
                :size="size"
                :tableStyle="tableStyle"
                :tableClass="tableClasses"
                :paginatorTemplate="paginatorTemplate"
                :currentPageReportTemplate="currentPageReportTemplate"
                :paginatorPosition="paginatorPosition"
                :selection="selection"
                :selectionMode="selectionMode"
                :metaKeySelection="metaKeySelection"
                :contextMenu="contextMenu"
                :rowGroupMode="rowGroupMode"
                :groupRowsBy="groupRowsBy"
                :expandableRowGroups="expandableRowGroups"
                :expandedRowGroups="expandedRowGroups"
                :dataKey="dataKey"
                :expandedRows="expandedRows"
                :responsiveLayout="responsiveLayout"
                :breakpoint="breakpoint"
                @page="onPage"
                @sort="onSort"
                @filter="onFilter"
                @row-select="onRowSelect"
                @row-unselect="onRowUnselect"
                @select-all-change="onSelectAllChange"
                @row-click="onRowClick"
                @row-dblclick="onRowDblClick"
                @row-contextmenu="onRowContextMenu"
                @row-expand="onRowExpand"
                @row-collapse="onRowCollapse"
                @cell-edit-init="onCellEditInit"
                @cell-edit-complete="onCellEditComplete"
                @cell-edit-cancel="onCellEditCancel"
                @row-edit-init="onRowEditInit"
                @row-edit-save="onRowEditSave"
                @row-edit-cancel="onRowEditCancel"
                @column-resize-end="onColumnResizeEnd"
                @column-reorder="onColumnReorder"
                @row-reorder="onRowReorder"
                @state-restore="onStateRestore"
                @state-save="onStateSave"
            >
                <!-- Selection Column -->
                <Column
                    v-if="selectionMode === 'multiple'"
                    selectionMode="multiple"
                    :headerStyle="{ width: '3rem' }"
                    :frozen="frozenSelection"
                />

                <!-- Expand Column for Row Expansion -->
                <Column
                    v-if="expandableRows"
                    expander
                    :headerStyle="{ width: '3rem' }"
                    :frozen="frozenExpander"
                />

                <!-- Dynamic Columns -->
                <Column
                    v-for="(column, index) in normalizedColumns"
                    :key="column.key || column.field || index"
                    :field="column.field"
                    :header="column.header"
                    :sortable="column.sortable"
                    :filterField="column.filterField || column.field"
                    :dataType="column.dataType"
                    :bodyStyle="column.bodyStyle"
                    :headerStyle="column.headerStyle"
                    :style="column.style"
                    :class="column.class"
                    :headerClass="column.headerClass"
                    :bodyClass="column.bodyClass"
                    :sortField="column.sortField"
                    :filterMatchMode="column.filterMatchMode"
                    :filterFunction="column.filterFunction"
                    :excludeGlobalFilter="column.excludeGlobalFilter"
                    :filterHeaderClass="column.filterHeaderClass"
                    :filterHeaderStyle="column.filterHeaderStyle"
                    :filterMenuClass="column.filterMenuClass"
                    :filterMenuStyle="column.filterMenuStyle"
                    :selectionMode="column.selectionMode"
                    :expander="column.expander"
                    :rowReorder="column.rowReorder"
                    :rowEditor="column.rowEditor"
                    :frozen="column.frozen"
                    :alignFrozen="column.alignFrozen"
                    :exportable="column.exportable"
                    :exportHeader="column.exportHeader"
                    :filterMatchModeOptions="column.filterMatchModeOptions"
                    :maxConstraints="column.maxConstraints"
                    :showFilterMatchModes="column.showFilterMatchModes"
                    :showFilterOperator="column.showFilterOperator"
                    :showClearButton="column.showClearButton"
                    :showApplyButton="column.showApplyButton"
                    :showFilterMenu="column.showFilterMenu"
                    :showAddButton="column.showAddButton"
                    :filterDisplay="column.filterDisplay"
                    :responsivePriority="column.responsivePriority"
                    :hidden="column.hidden"
                >
                    <!-- Column Header Template -->
                    <template #header v-if="column.headerTemplate || $slots[`header-${column.field}`]">
                        <slot
                            v-if="$slots[`header-${column.field}`]"
                            :name="`header-${column.field}`"
                            :column="column"
                        />
                        <component
                            v-else-if="column.headerTemplate"
                            :is="column.headerTemplate"
                            :column="column"
                        />
                    </template>

                    <!-- Column Body Template -->
                    <template #body="slotProps" v-if="column.bodyTemplate || $slots[`body-${column.field}`]">
                        <slot
                            v-if="$slots[`body-${column.field}`]"
                            :name="`body-${column.field}`"
                            :data="slotProps.data"
                            :column="column"
                            :field="column.field"
                            :index="slotProps.index"
                            :frozenRow="slotProps.frozenRow"
                            :editorInitCallback="slotProps.editorInitCallback"
                            :rowToggler="slotProps.rowToggler"
                        />
                        <component
                            v-else-if="column.bodyTemplate"
                            :is="column.bodyTemplate"
                            v-bind="slotProps"
                            :column="column"
                        />
                        <span v-else>{{ getNestedValue(slotProps.data, column.field) }}</span>
                    </template>

                    <!-- Column Filter Template -->
                    <template #filter="{ filterModel, filterCallback }" v-if="column.filterTemplate || $slots[`filter-${column.field}`]">
                        <slot
                            v-if="$slots[`filter-${column.field}`]"
                            :name="`filter-${column.field}`"
                            :filterModel="filterModel"
                            :filterCallback="filterCallback"
                            :column="column"
                        />
                        <component
                            v-else-if="column.filterTemplate"
                            :is="column.filterTemplate"
                            :filterModel="filterModel"
                            :filterCallback="filterCallback"
                            :column="column"
                        />
                        <InputText
                            v-else-if="!column.filterOptions || column.filterOptions.type === 'text'"
                            :modelValue="filterModel ? filterModel.value : ''"
                            @update:modelValue="val => { if (filterModel) filterModel.value = val }"
                            @input="filterCallback()"
                            :placeholder="getFilterPlaceholder(column)"
                            class="p-column-filter"
                        />
                        <Select
                            v-else-if="column.filterOptions?.type === 'dropdown'"
                            :modelValue="filterModel ? filterModel.value : null"
                            @update:modelValue="val => { if (filterModel) filterModel.value = val; filterCallback() }"
                            :options="column.filterOptions.options"
                            :optionLabel="column.filterOptions.optionLabel || 'label'"
                            :optionValue="column.filterOptions.optionValue || 'value'"
                            :placeholder="getFilterPlaceholder(column)"
                            :showClear="true"
                            class="p-column-filter"
                        />
                        <Calendar
                            v-else-if="column.filterOptions?.type === 'date'"
                            :modelValue="filterModel ? filterModel.value : null"
                            @update:modelValue="val => { if (filterModel) filterModel.value = val; filterCallback() }"
                            :placeholder="getFilterPlaceholder(column)"
                            :showIcon="true"
                            :showButtonBar="true"
                            class="p-column-filter"
                        />
                        <InputNumber
                            v-else-if="column.filterOptions?.type === 'number'"
                            :modelValue="filterModel ? filterModel.value : null"
                            @update:modelValue="val => { if (filterModel) filterModel.value = val; filterCallback() }"
                            :placeholder="getFilterPlaceholder(column)"
                            class="p-column-filter"
                        />
                    </template>

                    <!-- Column Editor Template -->
                    <template #editor="{ data, field }" v-if="column.editorTemplate || $slots[`editor-${column.field}`]">
                        <slot
                            v-if="$slots[`editor-${column.field}`]"
                            :name="`editor-${column.field}`"
                            :data="data"
                            :field="field"
                            :column="column"
                        />
                        <component
                            v-else-if="column.editorTemplate"
                            :is="column.editorTemplate"
                            :data="data"
                            :field="field"
                            :column="column"
                        />
                    </template>
                </Column>

                <!-- Actions Column (if provided) -->
                <Column
                    v-if="$slots.actions"
                    :header="actionsHeader"
                    :sortable="false"
                    :style="actionsStyle"
                    :headerStyle="actionsHeaderStyle"
                    :bodyClass="actionsBodyClass"
                    :frozen="actionsColumnFrozen"
                    :alignFrozen="actionsColumnAlign"
                >
                    <template #body="slotProps">
                        <slot
                            name="actions"
                            :data="slotProps.data"
                            :index="slotProps.index"
                            :frozenRow="slotProps.frozenRow"
                        />
                    </template>
                </Column>

                <!-- Row Expansion Template -->
                <template #expansion="slotProps" v-if="$slots.expansion">
                    <slot
                        name="expansion"
                        :data="slotProps.data"
                        :index="slotProps.index"
                    />
                </template>

                <!-- Group Header Template -->
                <template #groupheader="slotProps" v-if="$slots.groupheader">
                    <slot
                        name="groupheader"
                        :data="slotProps.data"
                        :index="slotProps.index"
                    />
                </template>

                <!-- Group Footer Template -->
                <template #groupfooter="slotProps" v-if="$slots.groupfooter">
                    <slot
                        name="groupfooter"
                        :data="slotProps.data"
                        :index="slotProps.index"
                    />
                </template>

                <!-- Empty State Template -->
                <template #empty>
                    <slot name="empty">
                        <div class="empty-table-state">
                            <div class="empty-icon">
                                <i class="pi pi-inbox" style="font-size: 3rem; color: var(--text-color-secondary);"></i>
                            </div>
                            <div class="empty-message">
                                <h4>{{ emptyMessage }}</h4>
                                <p v-if="emptyDescription">{{ emptyDescription }}</p>
                            </div>
                            <div class="empty-actions" v-if="$slots.emptyActions">
                                <slot name="emptyActions" />
                            </div>
                        </div>
                    </slot>
                </template>

                <!-- Loading Template -->
                <template #loading v-if="$slots.loading">
                    <slot name="loading" />
                </template>
            </DataTable>
        </div>

        <!-- Footer Section -->
        <div class="datatable-footer" v-if="$slots.footer">
            <slot name="footer" />
        </div>
    </div>
</template>

<script setup>
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import { FilterMatchMode } from '@primevue/core/api'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Select from 'primevue/select'
import Calendar from 'primevue/calendar'
import IconField from 'primevue/iconfield'
import InputIcon from 'primevue/inputicon'

// Props with comprehensive PrimeVue 4.x support
const props = defineProps({
    // Data and Basic Configuration
    data: { type: Array, default: () => [] },
    columns: { type: Array, required: true },
    dataKey: { type: String, default: 'id' },
    loading: { type: Boolean, default: false },
    
    // Header Configuration
    showHeader: { type: Boolean, default: true },
    title: { type: String, default: '' },
    subtitle: { type: String, default: '' },
    
    // Search Configuration
    showGlobalSearch: { type: Boolean, default: true },
    searchPlaceholder: { type: String, default: 'Search...' },
    globalFilterFields: { type: Array, default: () => [] },
    
    // Pagination
    lazy: { type: Boolean, default: false },
    paginator: { type: Boolean, default: true },
    rows: { type: Number, default: 10 },
    totalRecords: { type: Number, default: 0 },
    rowsPerPageOptions: { type: Array, default: () => [10, 25, 50, 100] },
    first: { type: Number, default: 0 },
    paginatorTemplate: { 
        type: String, 
        default: 'FirstPageLink PrevPageLink PageLinks NextPageLink LastPageLink CurrentPageReport RowsPerPageDropdown' 
    },
    currentPageReportTemplate: { 
        type: String, 
        default: 'Showing {first} to {last} of {totalRecords} entries' 
    },
    paginatorPosition: { type: String, default: 'bottom' },
    
    // Sorting
    sortMode: { type: String, default: 'single' },
    sortField: { type: String, default: null },
    sortOrder: { type: Number, default: null },
    multiSortMeta: { type: Array, default: null },
    
    // Filtering
    filters: { type: Object, default: () => ({}) },
    filterDisplay: { type: String, default: 'row' },
    
    // Table Appearance
    scrollable: { type: Boolean, default: true },
    scrollHeight: { type: String, default: 'flex' },
    virtualScrollerOptions: { type: Object, default: null },
    resizableColumns: { type: Boolean, default: false },
    columnResizeMode: { type: String, default: 'fit' },
    reorderableColumns: { type: Boolean, default: false },
    showGridlines: { type: Boolean, default: true },
    stripedRows: { type: Boolean, default: true },
    rowHover: { type: Boolean, default: true },
    size: { type: String, default: 'normal' }, // 'small', 'normal', 'large'
    responsiveLayout: { type: String, default: 'scroll' },
    breakpoint: { type: String, default: '960px' },
    
    // Selection
    selection: { type: [Object, Array], default: null },
    selectionMode: { type: String, default: null },
    metaKeySelection: { type: Boolean, default: false },
    contextMenu: { type: Boolean, default: false },
    frozenSelection: { type: Boolean, default: false },
    
    // Row Expansion
    expandableRows: { type: Boolean, default: false },
    expandedRows: { type: [Object, Array], default: null },
    frozenExpander: { type: Boolean, default: false },
    
    // Row Grouping
    rowGroupMode: { type: String, default: null },
    groupRowsBy: { type: String, default: null },
    expandableRowGroups: { type: Boolean, default: false },
    expandedRowGroups: { type: Array, default: null },
    
    // Actions Column
    actionsHeader: { type: String, default: 'Actions' },
    actionsStyle: { type: Object, default: () => ({ width: '120px' }) },
    actionsHeaderStyle: { type: Object, default: null },
    actionsBodyClass: { type: String, default: 'text-center' },
    actionsColumnFrozen: { type: Boolean, default: false },
    actionsColumnAlign: { type: String, default: 'right' },
    
    // Empty State
    emptyMessage: { type: String, default: 'No data found' },
    emptyDescription: { type: String, default: null },
    
    // Styling
    tableStyle: { type: Object, default: () => ({ minWidth: '50rem' }) },
    tableClass: { type: String, default: '' },
    containerClass: { type: String, default: '' }
})

// Emits for all PrimeVue DataTable events
const emit = defineEmits([
    'page', 'sort', 'filter', 'row-select', 'row-unselect', 'select-all-change',
    'row-click', 'row-dblclick', 'row-contextmenu', 'row-expand', 'row-collapse',
    'cell-edit-init', 'cell-edit-complete', 'cell-edit-cancel',
    'row-edit-init', 'row-edit-save', 'row-edit-cancel',
    'column-resize-end', 'column-reorder', 'row-reorder',
    'state-restore', 'state-save', 'global-filter'
])

// Reactive state
const dataTableRef = ref(null)
const globalFilterValue = ref('')

// Computed properties
const normalizedColumns = computed(() => {
    return props.columns.map((col, index) => ({
        key: col.key || col.field || `col-${index}`,
        field: col.field,
        header: col.header || col.label,
        sortable: col.sortable !== false,
        filterField: col.filterField || col.field,
        dataType: col.dataType || 'text',
        filterMatchMode: col.filterMatchMode || FilterMatchMode.CONTAINS,
        style: col.style,
        class: col.class,
        headerStyle: col.headerStyle,
        headerClass: col.headerClass,
        bodyStyle: col.bodyStyle,
        bodyClass: col.bodyClass,
        bodyTemplate: col.bodyTemplate,
        headerTemplate: col.headerTemplate,
        filterTemplate: col.filterTemplate,
        editorTemplate: col.editorTemplate,
        filterOptions: col.filterOptions,
        frozen: col.frozen,
        alignFrozen: col.alignFrozen,
        responsivePriority: col.responsivePriority,
        hidden: col.hidden,
        exportable: col.exportable !== false,
        ...col // Spread any additional column properties
    }))
})

const containerClasses = computed(() => {
    const classes = ['modern-datatable']
    if (props.containerClass) classes.push(props.containerClass)
    if (props.size) classes.push(`datatable-${props.size}`)
    return classes.join(' ')
})

const tableClasses = computed(() => {
    const classes = []
    if (props.tableClass) classes.push(props.tableClass)
    return classes.join(' ')
})

// Helper functions
const getNestedValue = (obj, path) => {
    return path.split('.').reduce((current, prop) => current?.[prop], obj)
}

const getFilterPlaceholder = (column) => {
    return column.filterOptions?.placeholder || `Filter ${column.header || column.field}`
}

// Event handlers
const onGlobalFilter = () => {
    emit('global-filter', globalFilterValue.value)
}

const onPage = (event) => {
    emit('page', event)
}

const onSort = (event) => {
    emit('sort', event)
}

const onFilter = (event) => {
    emit('filter', event)
}

const onRowSelect = (event) => {
    emit('row-select', event)
}

const onRowUnselect = (event) => {
    emit('row-unselect', event)
}

const onSelectAllChange = (event) => {
    emit('select-all-change', event)
}

const onRowClick = (event) => {
    emit('row-click', event)
}

const onRowDblClick = (event) => {
    emit('row-dblclick', event)
}

const onRowContextMenu = (event) => {
    emit('row-contextmenu', event)
}

const onRowExpand = (event) => {
    emit('row-expand', event)
}

const onRowCollapse = (event) => {
    emit('row-collapse', event)
}

const onCellEditInit = (event) => {
    emit('cell-edit-init', event)
}

const onCellEditComplete = (event) => {
    emit('cell-edit-complete', event)
}

const onCellEditCancel = (event) => {
    emit('cell-edit-cancel', event)
}

const onRowEditInit = (event) => {
    emit('row-edit-init', event)
}

const onRowEditSave = (event) => {
    emit('row-edit-save', event)
}

const onRowEditCancel = (event) => {
    emit('row-edit-cancel', event)
}

const onColumnResizeEnd = (event) => {
    emit('column-resize-end', event)
}

const onColumnReorder = (event) => {
    emit('column-reorder', event)
}

const onRowReorder = (event) => {
    emit('row-reorder', event)
}

const onStateRestore = (event) => {
    emit('state-restore', event)
}

const onStateSave = (event) => {
    emit('state-save', event)
}

// Public methods
const exportCSV = (options) => {
    dataTableRef.value.exportCSV(options)
}

const clearState = () => {
    dataTableRef.value.clearState()
}

const saveState = () => {
    dataTableRef.value.saveState()
}

const restoreState = () => {
    dataTableRef.value.restoreState()
}

const reset = () => {
    globalFilterValue.value = ''
    if (dataTableRef.value) {
        dataTableRef.value.reset()
    }
}

// Expose public methods
defineExpose({
    exportCSV,
    clearState,
    saveState,
    restoreState,
    reset,
    getTable: () => dataTableRef.value
})

// Watch for global filter changes from parent
watch(() => globalFilterValue.value, (newValue) => {
    if (dataTableRef.value) {
        dataTableRef.value.filters.global = { value: newValue, matchMode: FilterMatchMode.CONTAINS }
    }
})
</script>

<style scoped>
.modern-datatable-wrapper {
    @apply bg-white rounded-lg shadow-sm border border-gray-200;
}

.datatable-header {
    @apply flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 p-6 border-b border-gray-200;
}

.datatable-title-section {
    @apply flex flex-col gap-1;
}

.datatable-title {
    @apply text-xl font-semibold text-gray-900 m-0;
}

.datatable-subtitle {
    @apply text-sm text-gray-600 m-0;
}

.datatable-controls {
    @apply flex flex-col sm:flex-row items-stretch sm:items-center gap-4;
}

.search-section {
    @apply flex-1 min-w-0;
}

.global-search-input {
    @apply w-full sm:w-80;
}

.actions-section {
    @apply flex items-center gap-2;
}

.datatable-container {
    @apply relative;
}

.modern-datatable {
    @apply rounded-none border-0;
}

.datatable-small {
    @apply text-sm;
}

.datatable-large {
    @apply text-base;
}

.empty-table-state {
    @apply flex flex-col items-center justify-center py-12 px-6 text-center;
}

.empty-icon {
    @apply mb-4;
}

.empty-message h4 {
    @apply text-lg font-medium text-gray-900 mb-2;
}

.empty-message p {
    @apply text-gray-600 mb-4;
}

.empty-actions {
    @apply flex gap-2;
}

.datatable-footer {
    @apply p-6 border-t border-gray-200 bg-gray-50;
}

/* PrimeVue DataTable Style Overrides */
:deep(.p-datatable) {
    @apply border-0 rounded-none;
}

:deep(.p-datatable .p-datatable-header) {
    @apply border-0 bg-transparent p-0;
}

:deep(.p-datatable .p-datatable-thead > tr > th) {
    @apply bg-gray-50 border-b border-gray-200 text-gray-900 font-semibold text-sm px-4 py-3;
}

:deep(.p-datatable .p-datatable-tbody > tr) {
    @apply border-b border-gray-100 hover:bg-gray-50 transition-colors;
}

:deep(.p-datatable .p-datatable-tbody > tr > td) {
    @apply px-4 py-3 text-sm text-gray-700;
}

:deep(.p-datatable .p-datatable-tbody > tr:last-child) {
    @apply border-b-0;
}

:deep(.p-paginator) {
    @apply bg-white border-0 px-6 py-4;
}

:deep(.p-column-filter) {
    @apply w-full;
}

:deep(.p-datatable-scrollable .p-datatable-wrapper) {
    @apply border-0;
}

/* Responsive Design */
@media (max-width: 768px) {
    .datatable-header {
        @apply flex-col items-stretch gap-4;
    }
    
    .datatable-controls {
        @apply flex-col gap-3;
    }
    
    .global-search-input {
        @apply w-full;
    }
}
</style>