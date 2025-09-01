<template>
    <div class="bg-white rounded p-6 shadow">
        <h4 class="pb-4 text-sm font-semibold uppercase text-gray-800">{{ __('Quick Links') }}</h4>
        <div class="grid grid-cols-1 sm:grid-cols-2 flex justify-between items-center">
            <ul>
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('quizzes.index')">{{
                        __('New Quiz Schedule')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('quizzes.create')">{{
                        __('Create New Quiz')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('admin.practice-sets.create')">{{
                        __('Create Practice Set')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('quizzes.index')">{{ __('View Quizzes') }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('admin.practice-sets.index')">{{
                        __('View Practice Sets')
                    }}</Link></li
                >
            </ul>
            <ul>
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('questions.index')">{{
                        __('Create New Question')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('initiate_import_questions')">{{
                        __('Import Questions')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('comprehensions.index')">{{
                        __('Create New Comprehension')
                    }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('skills.index')">{{ __('Create New Skill') }}</Link></li
                >
                <li class="mb-2"
                    ><Link class="qt-link-success" :href="route('topics.index')">{{ __('Create New Topic') }}</Link></li
                >
            </ul>
        </div>
    </div>
</template>

<script setup>
import { Link } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'

const { __ } = useTranslate()
</script>
