<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold">{{ __('Configure Videos') }}</h2>
                    <p class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1">{{
                        __('Add Videos to Learning')
                    }}</p>
                </div>
                <horizontal-stepper :steps="steps"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card max-w-3xl mx-auto">
                <div class="card-body">
                    <h4 class="py-2 mb-4 text-sm font-semibold flex items-center gap-2 text-gray-800 border-b">
                        {{ __('Choose') }} {{ __('Sub Category') }} & {{ __('Skill') }}
                    </h4>
                    <form class="flex flex-col gap-4" @submit.prevent="submitForm">
                        <div class="w-full flex flex-col">
                            <label class="pb-2 text-sm font-semibold text-gray-800"
                                >{{ __('Sub Category') }}<span class="ltr:ml-1 rtl:mr-1 text-red-400">*</span></label
                            >
                            <v-select
                                id="sub_category"
                                v-model="v$.form.sub_category.$model"
                                :options="subCategories"
                                :reduce="category => category.id"
                                label="name"
                                :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                @search="searchSubCategories"
                            >
                                <template #no-options="{ search, searching }">
                                    <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                                    <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                </template>
                            </v-select>
                            <div class="form-control-errors">
                                <p
                                    v-if="v$.form.sub_category.$error && !v$.form.sub_category.required"
                                    role="alert"
                                    class="text-xs text-red-500 pt-2"
                                    >{{ __('Sub Category') }} {{ __('is required') }}</p
                                >
                            </div>
                        </div>
                        <div class="w-full flex flex-col">
                            <label for="skill" class="pb-2 text-sm font-semibold text-gray-800"
                                >{{ __('Skill') }}<span class="ltr:ml-1 rtl:mr-1 text-red-400">*</span></label
                            >
                            <v-select
                                id="skill"
                                v-model="v$.form.skill.$model"
                                :options="skills"
                                :reduce="skill => skill.id"
                                label="name"
                                :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                @search="searchSkills"
                            >
                                <template #no-options="{ search, searching }">
                                    <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                                    <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                </template>
                            </v-select>
                            <div class="form-control-errors">
                                <p
                                    v-if="v$.form.skill.$error && !v$.form.skill.required"
                                    role="alert"
                                    class="text-xs text-red-500 pt-2"
                                    >{{ __('Skill') }} {{ __('is required') }}</p
                                >
                            </div>
                        </div>
                        <div class="w-full flex justify-end">
                            <button type="submit" class="qt-btn qt-btn-success" v-html="__('Proceed')"></button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    // Add props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Video/ Configure') + ' - ' + pageProps.general.app_name
})
</script>
