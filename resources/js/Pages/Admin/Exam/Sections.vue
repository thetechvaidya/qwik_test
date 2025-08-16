<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Exam') }} {{ __('Sections') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? exam.title : __('New') + ' ' + __('Exam')"
                    ></p>
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>

        <div class="py-6">
            <div class="max-w-7xl mx-auto sm:px-6 lg:px-8">
                <div class="flex flex-wrap justify-center">
                    <div class="w-full">
                        <div class="w-full flex justify-end mb-2">
                            <Button
                                severity="success"
                                :label="__('Add') + ' ' + __('Section')"
                                @click="createForm = true"
                            />
                        </div>
                        <table class="shadow-lg bg-white section-form w-full">
                            <tr>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('#')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Display Name')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Section')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Total Questions')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Total Duration')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Total Marks')
                                }}</th>
                                <th class="bg-blue-100 border ltr:text-left rtl:text-right text-sm px-8 py-4">{{
                                    __('Actions')
                                }}</th>
                            </tr>
                            <tr v-for="section in sections">
                                <td class="border px-8 py-2">
                                    <span class="text-sm">{{ section.section_order }}</span>
                                </td>
                                <td class="border px-8 py-2">
                                    <span class="text-sm">{{ section.name }}</span>
                                </td>
                                <td class="border px-8 py-2">
                                    <span class="text-sm">{{ section.section }}</span>
                                </td>
                                <td class="border px-8 py-2">
                                    <span class="text-sm">{{ section.total_questions }} {{ __('Q') }}</span>
                                </td>
                                <td class="border px-8 py-2">
                                    <span class="text-sm">{{ section.total_duration }} {{ __('Minutes') }}</span>
                                </td>
                                <td class="border px-8 py-2">
                                    <span class="text-sm"
                                        >{{ section.total_marks > 0 ? section.total_marks : 0 }} {{ __('Marks') }}</span
                                    >
                                </td>
                                <td class="border px-8 py-2">
                                    <Button
                                        icon="pi pi-pencil"
                                        severity="secondary"
                                        text
                                        rounded
                                        class="p-mr-2"
                                        @click="
                                            editForm = true
                                            currentId = section.id
                                        "
                                    />
                                    <Button
                                        icon="pi pi-trash"
                                        severity="danger"
                                        text
                                        rounded
                                        @click="deleteSection(section.id)"
                                    />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>

                <Drawer v-model:visible="createForm" position="right" class="p-drawer-md">
                    <SectionForm
                        :errors="errors"
                        :exam="exam"
                        :title="__('New') + ' ' + __('Section')"
                        @close="createForm = false"
                    />
                </Drawer>
                <Drawer v-model:visible="editForm" position="right" class="p-drawer-md">
                    <SectionForm
                        v-model:edit-flag="editForm"
                        :section-id="currentId"
                        :errors="errors"
                        :exam="exam"
                        :title="__('Edit') + ' ' + __('Section')"
                        @close="editForm = false"
                    />
                </Drawer>
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
    return __('Exam/ Sections') + ' - ' + pageProps.general.app_name
})
</script>
