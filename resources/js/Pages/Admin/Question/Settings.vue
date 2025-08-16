<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start justify-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Question') }} {{ __('Settings') }}</h2
                    >
                    <p class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        >{{ questionType.name }} {{ __('Question') }}</p
                    >
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="md:w-6/12 w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="skill_id" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Skill')
                                    }}</label>
                                    <v-select
                                        id="skill_id"
                                        v-model="v$.form.skill_id.$model"
                                        :options="skills"
                                        :reduce="skill => skill.id"
                                        label="name"
                                        :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                        @search="searchSkills"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.skill_id.$error && !v$.form.skill_id.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Skill') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="topic_id" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Topic')
                                    }}</label>
                                    <v-select
                                        id="topic_id"
                                        v-model="form.topic_id"
                                        :options="topics"
                                        :reduce="topic => topic.id"
                                        label="name"
                                        :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                        @search="searchTopics"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="tag" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Tags')
                                    }}</label>
                                    <v-select
                                        id="tag"
                                        v-model="form.tags"
                                        taggable
                                        multiple
                                        :options="tags"
                                        :reduce="t => t.name"
                                        label="name"
                                        :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                    <small v-if="errors.tags" id="tag-help" class="p-invalid">{{ errors.tags }}</small>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Difficulty Level')
                                    }}</label>
                                    <v-select
                                        id="difficulty_level"
                                        v-model="form.difficulty_level_id"
                                        :options="difficultyLevels"
                                        :reduce="dl => dl.id"
                                        label="name"
                                        :dir="pageProps.rtl ? 'rtl' : 'ltr'"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="
                                                v$.form.difficulty_level_id.$error &&
                                                !v$.form.difficulty_level_id.required
                                            "
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Difficulty Level') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="default_marks" class="pb-2 text-sm font-semibold text-gray-800"
                                        >{{ __('Default Marks') }}/{{ __('Grade Points') }}</label
                                    >
                                    <InputNumber
                                        id="default_marks"
                                        v-model="form.default_marks"
                                        placeholder="Enter Marks"
                                        aria-describedby="default_marks-help"
                                        :class="[errors.default_marks ? 'p-invalid' : '']"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.default_marks.$error && !v$.form.default_marks.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Default Marks') }}/{{ __('Grade Points') }}
                                            {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="default_time" class="pb-2 text-sm font-semibold text-gray-800"
                                        >{{ __('Default Time To Solve') }} (Seconds)</label
                                    >
                                    <InputNumber
                                        id="default_time"
                                        v-model="form.default_time"
                                        placeholder="Enter Time"
                                        aria-describedby="default_time-help"
                                        :class="[errors.default_time ? 'p-invalid' : '']"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.default_time.$error && !v$.form.default_time.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Default Time To Solve') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="w-9/12">
                                            <label
                                                for="is_active"
                                                class="font-semibold text-sm text-gray-800 pb-1"
                                                v-html="form.is_active ? __('Active') : __('In-active')"
                                            ></label>
                                            <p class="text-sm text-gray-500"
                                                >{{ __('Active') }} ({{ __('Shown Everywhere') }}).
                                                {{ __('In-active') }} ({{ __('Hidden Everywhere') }}).</p
                                            >
                                        </div>
                                        <div class="cursor-pointer rounded-full relative shadow-sm">
                                            <ToggleSwitch id="is_active" v-model="form.is_active" />
                                        </div>
                                    </div>
                                </div>
                                <!-- Submit Button -->
                                <div class="w-full flex justify-end my-8">
                                    <Button
                                        type="submit"
                                        :label="editFlag ? __('Update Settings') : __('Save Settings')"
                                    />
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
    return __('Question/ Settings') + ' - ' + pageProps.general.app_name
})
</script>
