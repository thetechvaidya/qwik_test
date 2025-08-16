<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Tax Settings') }}
        </template>

        <template #form>
            <!-- Enable Tax -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_tax" :value="__('Enable Tax')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_tax" v-model="form.enable_tax" />
                </div>
                <arc-input-error :message="form.errors.enable_tax" class="mt-2" />
            </div>

            <!-- Tax Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="tax_name" :value="__('Tax Name')" />
                <arc-input id="tax_name" v-model="form.tax_name" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.tax_name" class="mt-2" />
            </div>

            <!-- Tax Amount Type -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="tax_amount_type" :value="__('Tax Amount Type')" />
                <v-select
                    id="tax_amount_type"
                    v-model="form.tax_amount_type"
                    :options="taxAmountTypes"
                    :reduce="t => t.code"
                    label="name"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.tax_amount_type" class="mt-2" />
            </div>

            <!-- Tax Amount -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="tax_amount" :value="__('Tax Amount')" />
                <arc-input id="tax_amount" v-model="form.tax_amount" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.tax_amount" class="mt-2" />
            </div>

            <!-- Tax Type -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="tax_type" :value="__('Tax Type')" />
                <v-select
                    id="tax_type"
                    v-model="form.tax_type"
                    :options="taxTypes"
                    :reduce="t => t.code"
                    label="name"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.tax_type" class="mt-2" />
            </div>

            <!-- Enable Additional Tax -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_additional_tax" :value="__('Enable Additional Tax')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_additional_tax" v-model="form.enable_additional_tax" />
                </div>
                <arc-input-error :message="form.errors.enable_additional_tax" class="mt-2" />
            </div>

            <!-- Additional Tax Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="additional_tax_name" :value="__('Additional Tax Name')" />
                <arc-input
                    id="additional_tax_name"
                    v-model="form.additional_tax_name"
                    type="text"
                    class="mt-1 block w-full"
                />
                <arc-input-error :message="form.errors.additional_tax_name" class="mt-2" />
            </div>

            <!-- Additional Tax Amount Type -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="additional_tax_amount_type" :value="__('Additional Tax Amount Type')" />
                <v-select
                    id="additional_tax_amount_type"
                    v-model="form.additional_tax_amount_type"
                    :options="taxAmountTypes"
                    :reduce="t => t.code"
                    label="name"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.additional_tax_amount_type" class="mt-2" />
            </div>

            <!-- Additional Tax Amount -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="additional_tax_amount" :value="__('Additional Tax Amount')" />
                <arc-input
                    id="additional_tax_amount"
                    v-model="form.additional_tax_amount"
                    type="text"
                    class="mt-1 block w-full"
                />
                <arc-input-error :message="form.errors.additional_tax_amount" class="mt-2" />
            </div>

            <!-- Additional Tax Type -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="additional_tax_type" :value="__('Additional Tax Type')" />
                <v-select
                    id="additional_tax_type"
                    v-model="form.additional_tax_type"
                    :options="taxTypes"
                    :reduce="t => t.code"
                    label="name"
                    :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                />
                <arc-input-error :message="form.errors.additional_tax_type" class="mt-2" />
            </div>
        </template>

        <template #actions>
            <arc-action-message :on="form.recentlySuccessful" class="mr-3"> {{ __('Saved') }}. </arc-action-message>

            <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                {{ __('Save') }}
            </arc-button>
        </template>
    </arc-form-section>
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
    return __('Settings/ Tax Settings Form') + ' - ' + pageProps.general.app_name
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
