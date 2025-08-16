<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Videos') }}</h4>
        </template>
        <template #actions>
            <Link :href="route('videos.create')" class="qt-btn qt-btn-success">
                {{ __('New') }} {{ __('Video') }}
            </Link>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <vue-good-table
                        mode="remote"
                        :search-options="searchOptions"
                        :pagination-options="tableParams.pagination"
                        :columns="columns"
                        :total-rows="videos.meta.pagination.total"
                        :rows="videos.data"
                        :rtl="$page.props.rtl"
                        @on-page-change="onPageChange"
                        @on-column-filter="onColumnFilter"
                        @on-per-page-change="onPerPageChange"
                        @on-search="onSearch"
                    >
                        <template #table-row="props">
                            <!-- Code Column -->
                            <div v-if="props.column.field === 'code'">
                                <Tag
                                    :value="props.row.code"
                                    icon="pi pi-copy"
                                    class="w-full mr-2 text-sm cursor-pointer"
                                    @click="copyCode(props.row.code)"
                                />
                            </div>

                            <!-- Status Column -->
                            <div v-else-if="props.column.field === 'status'">
                                <span
                                    :class="[props.row.status === 'Active' ? 'badge-success' : 'badge-danger', 'badge']"
                                    >{{ __(props.row.status) }}</span
                                >
                            </div>

                            <!-- Actions Column -->
                            <div v-else-if="props.column.field === 'actions'">
                                <ActionsDropdown>
                                    <template #actions>
                                        <button class="action-item" @click="editVideo(props.row.id)">{{
                                            __('Edit')
                                        }}</button>
                                        <button class="action-item" @click="deleteVideo(props.row.id)">{{
                                            __('Delete')
                                        }}</button>
                                    </template>
                                </ActionsDropdown>
                            </div>

                            <!-- Remaining Columns -->
                            <span v-else>
                                {{ props.formattedRow[props.column.field] }}
                            </span>
                        </template>

                        <template #emptystate>
                            <NoDataTable />
                        </template>
                    </vue-good-table>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed, ref } from 'vue'
import { Head, Link, router, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Tag from 'primevue/tag'
import NoDataTable from '@/Components/NoDataTable'
import ActionsDropdown from '@/Components/ActionsDropdown'

const props = defineProps({
    videos: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()

// Server table configuration
const { onPageChange, onPerPageChange, onColumnFilter, onSearch, tableParams } = useServerTable({
    page: props.videos.meta.pagination.current_page,
    perPage: props.videos.meta.pagination.per_page,
    resourceKeys: ['videos'],
})

// Search options for vue-good-table
const searchOptions = ref({
    enabled: true,
    skipDiacritics: true,
    placeholder: __('Search videos...'),
    externalQuery: '',
})

const columns = ref([
    {
        label: __('Code'),
        field: 'code',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Code'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
        width: '11rem',
    },
    {
        label: __('Title'),
        field: 'title',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Title'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Category'),
        field: 'category',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Category'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Type'),
        field: 'type',
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Type'),
            filterValue: null,
            trigger: 'enter',
        },
        sortable: false,
    },
    {
        label: __('Status'),
        field: 'status',
        sortable: false,
        filterOptions: {
            enabled: true,
            placeholder: __('Search') + ' ' + __('Status'),
            filterValue: null,
            filterDropdownItems: [
                { value: 1, text: __('Published') },
                { value: 0, text: __('Draft') },
            ],
        },
    },
    {
        label: __('Actions'),
        field: 'actions',
        sortable: false,
    },
])

const title = computed(() => {
    return __('Videos') + ' - ' + pageProps.general.app_name
})

const editVideo = id => {
    router.get(route('videos.edit', { video: id }))
}

const deleteVideo = id => {
    if (window.$confirm) {
        window.$confirm.require({
            header: __('Confirm Delete'),
            message: __('Do you want to delete this record?'),
            icon: 'pi pi-info-circle',
            acceptClass: 'p-button-danger',
            rejectLabel: __('Cancel'),
            acceptLabel: __('Delete'),
            accept: () => {
                router.delete(route('videos.destroy', { video: id }), {
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
