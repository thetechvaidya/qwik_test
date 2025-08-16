<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Practice Set') }} {{ __('Settings') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? practiceSet.title : __('New') + ' ' + __('Practice Set')"
                    ></p>
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="flex flex-wrap">
                                    <div class="md:w-6/12 w-full py-8 md:pb-0 md:px-8 border-r border-gray-200">
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="allow_rewards"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Allow Reward Points') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Points will be rewarded for each correct answer
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                No points will be rewarded
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="allow_rewards"
                                                v-model="form.allow_rewards"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="auto_grading"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Points Mode') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Auto</span> -
                                                                Points will be assigned based on question's default
                                                                marks
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Manual</span>
                                                                - Points will be assigned to each correct answered
                                                                question as specified
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="auto_grading"
                                                v-model="form.auto_grading"
                                                :options="autoModes"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div v-if="!form.auto_grading" class="w-full flex flex-col mb-6">
                                            <label for="correct_marks" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Points for Correct Answer')
                                                }}<span class="ml-1 text-red-400">*</span></label
                                            >
                                            <InputNumber
                                                id="correct_marks"
                                                v-model="$v.form.correct_marks.$model"
                                                :placeholder="__('Points')"
                                                aria-describedby="correct_marks-help"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="
                                                        $v.form.correct_marks.$error && !$v.form.correct_marks.required
                                                    "
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                    >{{ __('Points') }} {{ __('is required') }}</p
                                                >
                                            </div>
                                        </div>
                                    </div>
                                    <div class="md:w-6/12 w-full py-8 md:pb-0 md:px-8">
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="show_reward_popup"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Show Reward Popup') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Shows reward popup on correct answer
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                No popup will be shown
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="show_reward_popup"
                                                v-model="form.show_reward_popup"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full flex justify-end my-8">
                                    <button
                                        type="submit"
                                        class="qt-btn qt-btn-success"
                                        v-html="editFlag ? __('Update') : __('Save')"
                                    ></button>
                                </div>
                            </form>
                        </div>
                    </div>
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
    // Add settings props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Practice Set/ Settings') + ' - ' + pageProps.general.app_name
})
</script>
