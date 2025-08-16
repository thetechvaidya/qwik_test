<template>
    <div v-tooltip.top="questionStatus" class="w-full overflow-hidden rounded-sm cursor-pointer">
        <question-chip :sno="sno" :status="chipStatus" :is-active="active"></question-chip>
    </template>
<script setup>
    import { computed } from 'vue'
    import QuestionChip from "@/Components/Buttons/QuestionChip"
    import Tooltip from 'primevue/tooltip'

    // Define component options including directives
    defineOptions({
        name: 'PracticeQuestionChip',
        directives: {
            tooltip: Tooltip
        }
    })

    // Props
    const props = defineProps({
        sno: Number,
        active: Boolean,
        is_correct: Boolean,
        status: String,
    })

    // Computed properties
    const questionStatus = computed(() => {
        if (props.status === 'answered') {
            return props.is_correct ? 'Correct Answer' : 'Wrong Answer'
        } else {
            return 'Not Answered'
        }
    })

    const chipStatus = computed(() => {
        if (props.status === 'answered') {
            return props.is_correct ? 'success' : 'danger'
        } else {
            return 'default'
        }
    })
</script>
