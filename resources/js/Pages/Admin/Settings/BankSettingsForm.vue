<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Bank Settings') }}
        </template>

        <template #form>
            <div class="col-span-6 sm:col-span-4">
                <p class="font-mono px-2 py-1 inline-block bg-blue-100 text-gray-600 rounded text-sm">
                    {{ __('hide_field_message') }}
                </p>
            </div>
            <!-- Enable Bank -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="enable_bank" :value="__('Enable Bank Transfers')" />
                <div class="inline-block cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="enable_bank" v-model="form.enable_bank" />
                </div>
                <arc-input-error :message="form.errors.enable_bank" class="mt-2" />
            </div>

            <!-- Bank Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="bank_name" :value="__('Bank Name')" />
                <arc-input id="bank_name" v-model="form.bank_name" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.bank_name" class="mt-2" />
            </div>

            <!-- Account Owner -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="account_owner" :value="__('Account Owner')" />
                <arc-input id="account_owner" v-model="form.account_owner" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.account_owner" class="mt-2" />
            </div>

            <!-- Account Number -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="account_number" :value="__('Account Number')" />
                <arc-input id="account_number" v-model="form.account_number" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.account_number" class="mt-2" />
            </div>

            <!-- IBAN -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="iban" :value="__('IBAN')" />
                <arc-input id="iban" v-model="form.iban" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.iban" class="mt-2" />
            </div>

            <!-- Routing Number -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="routing_number" :value="__('Routing Number')" />
                <arc-input id="routing_number" v-model="form.routing_number" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.routing_number" class="mt-2" />
            </div>

            <!-- BIC/Swift -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="bic_swift" :value="__('BIC/Swift')" />
                <arc-input id="bic_swift" v-model="form.bic_swift" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.bic_swift" class="mt-2" />
            </div>

            <!-- Other Details -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="other_details" :value="__('Other Details')" />
                <arc-text-area id="other_details" v-model="form.other_details" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.other_details" class="mt-2" />
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
    return __('Settings/ Bank Settings Form') + ' - ' + pageProps.general.app_name
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
