<template>
    <Head :title="title" />
    <arc-action-section>
        <template #title>
            {{ __('Expire Schedules') }}
        </template>

        <template #content>
            <div class="max-w-xl text-sm text-gray-600">
                {{ __('expire_schedules_message') }}
            </div>

            <div class="flex items-center mt-5">
                <arc-confirms-password @confirmed="expireSchedules">
                    <arc-button type="button" :class="{ 'opacity-25': loading }" :disabled="loading">
                        {{ __('Mark Completed Schedules as Expired') }}
                    </arc-button>
                </arc-confirms-password>
            </div>
        </template>
    </arc-action-section>
</template>

<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'

// Props
const props = defineProps({
    settings: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Expire Schedules Form') + ' - ' + pageProps.general.app_name
})

// Form handling
const form = useForm({
    // Add form fields based on original file
})

// Methods
const updateSettings = () => {
    // Add form submission logic
}
</script>
