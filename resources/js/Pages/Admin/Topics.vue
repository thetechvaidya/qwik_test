<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Topics') }}</h4>
        </template>
        <template #actions>
            <button class="qt-btn qt-btn-success" @click="createForm = true">
                {{ __('New') }} {{ __('Topic') }}
            </button>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <DataTable
                        :value="data"
                        :totalRecords="totalRecords"
                        :loading="tableLoading"
                        lazy
                        paginator
                        :rows="10"
                        :rowsPerPageOptions="[10, 25, 50, 100]"
                        paginatorTemplate="RowsPerPageDropdown FirstPageLink PrevPageLink CurrentPageReport NextPageLink LastPageLink"
                        currentPageReportTemplate="{first} to {last} of {totalRecords}"
                        @page="onPage"
                        @sort="onSort"
                        @filter="onFilter"
                        filterDisplay="row"
                        :globalFilterFields="['code', 'name', 'skill', 'status']"
                        class="p-datatable-sm"
                    >
                        <Column
                            v-for="col in columns"
                            :key="col.field"
                            :field="col.field"
                            :header="col.header"
                            :sortable="col.sortable"
                            :showFilterMenu="false"
                        >
                            <template #filter="{ filterModel, filterCallback }" v-if="col.filter">
                                <InputText
                                    v-if="col.filter.type === 'text'"
                                    v-model="filterModel.value"
                                    type="text"
                                    @input="filterCallback()"
                                    :placeholder="col.filter.placeholder"
                                    class="p-column-filter"
                                />
                                <Select
                                    v-else-if="col.filter.type === 'dropdown'"
                                    v-model="filterModel.value"
                                    :options="col.filter.options"
                                    optionLabel="text"
                                    optionValue="value"
                                    :placeholder="col.filter.placeholder"
                                    class="p-column-filter"
                                    showClear
                                    @change="filterCallback()"
                                >
                                    <template #value="slotProps">
                                        <span v-if="slotProps.value !== null && slotProps.value !== undefined">
                                            {{ col.filter.options.find(option => option.value === slotProps.value)?.text }}
                                        </span>
                                    </template>
                                    <template #option="slotProps">
                                        {{ slotProps.option.text }}
                                    </template>
                                </Select>
                            </template>
                            <template #body="slotProps" v-if="col.field === 'code'">
                                <div class="flex items-center gap-2">
                                    <span>{{ slotProps.data.code }}</span>
                                    <button
                                        class="qt-btn-xs qt-btn-light"
                                        type="button"
                                        @click="copyCode(slotProps.data.code)"
                                    >
                                        <i class="fa fa-copy"></i>
                                    </button>
                                </div>
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'status'">
                                <Tag
                                    :value="slotProps.data.status ? __('Active') : __('In-active')"
                                    :severity="slotProps.data.status ? 'success' : 'danger'"
                                />
                            </template>
                            <template #body="slotProps" v-else-if="col.field === 'actions'">
                                <div class="flex justify-center">
                                    <ActionsDropdown>
                                        <template #actions>
                                            <button
                                                class="action-item"
                                                @click="
                                    editForm = true;
                                    currentId = slotProps.data.id;
                                "
                                            >{{ __('Edit') }}</button>
                                            <button class="action-item" @click="deleteTopic(slotProps.data.id)">{{ __('Delete') }}</button>
                                        </template>
                                    </ActionsDropdown>
                                </div>
                            </template>
                        </Column>
                        <template #empty>
                            <NoDataTable>
                                <template #action>
                                    <button class="qt-btn-sm qt-btn-primary" type="button" @click="createForm = true">
                                        {{ __('New') }} {{ __('Topic') }}
                                    </button>
                                </template>
                            </NoDataTable>
                        </template>
                    </DataTable>

                    <!--Sidebar Forms -->
                    <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                        <TopicForm
                            :skills="skills"
                            :form-errors="errors"
                            :title="__('New') + ' ' + __('Topic')"
                            @close="createForm = false"
                        />
                    </Drawer>
                    <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                        <TopicForm
                            :skills="skills"
                            :topic-id="currentId"
                            :form-errors="errors"
                            :title="__('Edit') + ' ' + __('Topic')"
                            @close="editForm = false"
                        />
                    </Drawer>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import { Head, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import TopicForm from '@/Components/Forms/TopicForm.vue'
import DataTable from 'primevue/datatable'
import Column from 'primevue/column'
import InputText from 'primevue/inputtext'
import Select from 'primevue/select'
import Tag from 'primevue/tag'
import Drawer from 'primevue/drawer'
import NoDataTable from '@/Components/NoDataTable.vue'
import ActionsDropdown from '@/Components/ActionsDropdown.vue'

const props = defineProps({
    topics: Object,
    skills: Array,
    errors: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// State
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Server table configuration
const { data, columns, totalRecords, tableLoading, onPage, onSort, onFilter } = useServerTable({
    columns: [
        {
            field: 'code',
            header: __('Code'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search') + ' ' + __('Code')
            }
        },
        {
            field: 'name',
            header: __('Name'),
            sortable: false,
            filter: {
                type: 'text',
                placeholder: __('Search') + ' ' + __('Name')
            }
        },
        {
            field: 'skill',
            header: __('Skill'),
            sortable: false
        },
        {
            field: 'status',
            header: __('Status'),
            sortable: false,
            filter: {
                type: 'dropdown',
                options: [
                    { value: 1, text: __('Active') },
                    { value: 0, text: __('In-active') }
                ],
                placeholder: __('Search') + ' ' + __('Status')
            }
        },
        {
            field: 'actions',
            header: __('Actions'),
            sortable: false
        }
    ],
    data: props.topics
})

const title = computed(() => {
    return __('Topics') + ' - ' + pageProps.general.app_name
})

const deleteTopic = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('topics.destroy', { topic: id }), {
                    onSuccess: () => {
                        if (window.$toast) {
                            window.$toast.add({
                                severity: 'info',
                                summary: __('Confirmed'),
                                detail: __('Record deleted'),
                                life: 3000,
                            })
                        }
                    },
                })
            },
            reject: () => {
                // Do nothing on reject
            },
        })
    }
}
</script>
