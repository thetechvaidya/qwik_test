<template>
    <SplitButton class="p-button-success" label="Manage" icon="pi pi-cog" :model="items"></SplitButton>
</template>
<script>
import { router } from '@inertiajs/vue3'
import SplitButton from 'primevue/splitbutton'
export default {
    name: 'ExamNavigation',
    components: {
        SplitButton,
    },
    props: {
        currentRoute: String,
        examId: String,
    },
    data() {
        return {
            items: [
                {
                    label: 'Exam Dashboard',
                    command: () => {
                        router.get(route('exams.show', { exam: this.examId }))
                    },
                },
                {
                    label: 'Edit Details',
                    command: () => {
                        router.get(route('exams.edit', { exam: this.examId }))
                    },
                },
                {
                    label: 'Sections',
                    command: () => {
                        router.get(route('exams.sections.index', { exam: this.examId }))
                    },
                },
                {
                    label: 'Questions',
                    command: () => {
                        router.get(route('exams.questions', { exam: this.examId }))
                    },
                },
                {
                    label: 'Settings',
                    command: () => {
                        router.get(route('exams.settings', { exam: this.examId }))
                    },
                },
                {
                    label: 'Schedules',
                    command: () => {
                        router.get(route('exams.sections.index', { exam: this.examId }))
                    },
                },
            ],
        }
    },
    computed: {
        activeLink() {
            return route(route().current(), { exam: this.examId })
        },
    },
}
</script>
