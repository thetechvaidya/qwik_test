<template>
    <SplitButton class="p-button-success" label="Manage" icon="pi pi-cog" :model="items"></SplitButton>
</template>
<script>
import { router } from '@inertiajs/vue3'
import SplitButton from 'primevue/splitbutton'
export default {
    name: 'QuizNavigation',
    components: {
        SplitButton,
    },
    props: {
        currentRoute: String,
        quizId: String,
    },
    data() {
        return {
            items: [
                {
                    label: 'Edit Details',
                    command: () => {
                        router.get(route('quizzes.edit', { quiz: this.quizId }))
                    },
                },
                {
                    label: 'Questions',
                    command: () => {
                        router.get(route('quizzes.questions', { quiz: this.quizId }))
                    },
                },
                {
                    label: 'Settings',
                    command: () => {
                        router.get(route('quizzes.settings', { quiz: this.quizId }))
                    },
                },
                {
                    label: 'Schedules',
                    command: () => {
                        router.get(route('quizzes.schedules.index', { quiz: this.quizId }))
                    },
                },
            ],
        }
    },
    computed: {
        activeLink() {
            return route(route().current(), { quiz: this.quizId })
        },
    },
}
</script>
