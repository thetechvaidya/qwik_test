<script setup>
import { computed } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
import AppLayout from '@/Layouts/AppLayout.vue'
import SectionHeader from '@/Components/SectionHeader.vue'
import BackButton from '@/Components/BackButton.vue'
import SkillCard from '@/Components/Cards/SkillCard.vue'
import { useTranslate } from '@/composables/useTranslate'

const props = defineProps({
    category: Object,
    section: Object,
})

const { __ } = useTranslate()
const { props: pageProps } = usePage()

const title = computed(() => {
    return props.category.name + ' ' + props.section.name + ' - ' + pageProps.general.app_name
})
</script>

<template>
    <app-layout>
        <Head :title="title" />

        <template #header>
            <div class="flex items-center">
                <back-button />
                <h1 class="app-heading">{{ category.name }} {{ section.name }}</h1>
            </div>
        </template>

        <template #actions>
            <div class="uppercase font-semibold text-secondary">{{ section.skills.length }} {{ __('Skills') }}</div>
        </template>

        <div class="py-8">
            <div class="card flex flex-col justify-center items-center">
                <div class="card-body w-full grid grid-cols-1 divide-y divide-gray-200">
                    <template v-for="(skill, index) in section.skills">
                        <skill-card
                            :skill="skill"
                            :category-slug="category.slug"
                            :section-slug="section.slug"
                            :sno="index + 1"
                        ></skill-card>
                    </template>
                </div>
            </div>
        </div>
    </app-layout>
</template>
