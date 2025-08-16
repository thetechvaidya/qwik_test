<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Footer Settings') }}
        </template>

        <template #form>
            <!-- Copyright Text -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="copyright_text" :value="__('Copyright Text')" />
                <arc-input id="copyright_text" v-model="form.copyright_text" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.copyright_text" class="mt-2" />
            </div>

            <!-- Enable Links -->
            <div class="col-span-6 sm:col-span-4">
                <div class="flex justify-between items-center">
                    <div class="w-9/12">
                        <label for="enable_links" class="text-sm text-gray-800 pb-1"
                            >{{ __('Enable Footer Links') }} ({{
                                form.enable_links ? __('Enabled') : __('Disabled')
                            }})</label
                        >
                    </div>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch id="enable_links" v-model="form.enable_links" />
                    </div>
                </div>
                <arc-input-error :message="form.errors.enable_links" class="mt-2" />
            </div>

            <!-- Footer Links -->
            <div v-for="(link, index) in form.footer_links" class="p-4 bg-gray-50 rounded-md col-span-6 sm:col-span-4">
                <div class="col-span-12 flex justify-between items-center py-3 font-bold border-b border-gray-200">
                    <span>{{ __('Link') }} {{ index + 1 }}</span>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch :id="'enable_link_' + index" v-model="form.footer_links[index][2]" />
                    </div>
                </div>
                <!-- Link Text -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'text_' + index" :value="__('Link Text')" />
                    <arc-input
                        :id="'text_' + index"
                        v-model="form.footer_links[index][0]"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <!--                        <arc-input-error :message="form.errors.footer_links[index][0]" class="mt-2" />-->
                </div>
                <!-- Link -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'link_' + index" :value="__('Link')" />
                    <arc-input
                        :id="'link_' + index"
                        v-model="form.footer_links[index][1]"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <!--                        <arc-input-error :message="form.errors.footer_links[index][1]" class="mt-2" />-->
                </div>
            </div>

            <!-- Enable Social Links -->
            <div class="col-span-6 sm:col-span-4">
                <div class="flex justify-between items-center">
                    <div class="w-9/12">
                        <label for="enable_social_links" class="text-sm text-gray-800 pb-1"
                            >{{ __('Enable Social Links') }} ({{
                                form.enable_social_links ? __('Enabled') : __('Disabled')
                            }})</label
                        >
                    </div>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch id="enable_social_links" v-model="form.enable_social_links" />
                    </div>
                </div>
                <arc-input-error :message="form.errors.enable_social_links" class="mt-2" />
            </div>

            <!-- Social Links -->
            <div class="p-4 bg-gray-50 rounded-md col-span-6 sm:col-span-4">
                <div v-for="site in social_sites" class="mb-2">
                    <arc-label class="capitalize" :for="site + '_link'" :value="__(site)" />
                    <div class="flex justify-between items-center">
                        <div class="cursor-pointer rounded-full relative shadow-sm">
                            <ToggleSwitch :id="'enable_' + site" v-model="form['enable_' + site]" />
                        </div>
                        <div class="w-9/12">
                            <arc-input
                                :id="site + '_link'"
                                v-model="form[site + '_link']"
                                type="text"
                                class="mt-1 block w-full"
                            />
                        </div>
                    </div>
                    <arc-input-error :message="form.errors[site + '_link']" class="mt-2" />
                </div>
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
    return __('Settings/ Footer Settings Form') + ' - ' + pageProps.general.app_name
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
