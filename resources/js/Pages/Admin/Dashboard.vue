<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto py-4 px-4 sm:px-6 lg:px-8">
            <div class="flex flex-wrap mb-6">
                <div class="w-full">
                    <div class="w-full grid sm:grid-cols-1 md:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-8">
                        <DashboardStat
                            v-for="stat in stats"
                            :key="stat.key"
                            :title="stat.title"
                            :count="stat.count"
                        ></DashboardStat>
                    </div>
                </div>
            </div>
            <div class="flex flex-wrap mb-6">
                <div class="w-full">
                    <div class="w-full grid sm:grid-cols-1 md:grid-cols-2 gap-8">
                        <AdminHelp></AdminHelp>
                        <AdminQuickLinks></AdminQuickLinks>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import DashboardStat from '@/Components/Cards/DashboardStat.vue'
import AdminQuickLinks from '@/Components/Widgets/AdminQuickLinks.vue'
import AdminHelp from '@/Components/Widgets/AdminHelp.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
defineProps({
    stats: Array,
})

// Composables
const { __ } = useTranslate()
const { props } = usePage()

// Computed properties
const title = computed(() => {
    return __('Admin Dashboard') + ' - ' + props.general.app_name
})
</script>
