<template>
    <div v-tooltip.top="questionStatus" class="w-full overflow-hidden rounded-sm cursor-pointer">
        <question-chip :sno="sno" :status="chipStatus" :is-active="active"></question-chip>
    </div>
</template>
<script setup>
    import { computed } from 'vue'
    import QuestionChip from "@/Components/Buttons/QuestionChip"
    import Tooltip from 'primevue/tooltip'

    // Define component options including directives
    defineOptions({
        name: 'ExamQuestionChip',
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
            return 'Answered'
        } else if (props.status === 'not_answered') {
            return 'Not Answered'
        } else if (props.status === 'mark_for_review') {
            return 'Marked for Review'
        } else if (props.status === 'answered_mark_for_review') {
            return 'Answered & Marked for Review'
        } else if (props.status === 'touched') {
            return 'Answered & Not Saved'
        } else {
            return 'Not Visited'
        }
    })

    const chipStatus = computed(() => {
        if (props.status === 'answered') {
            return 'success'
        } else if (props.status === 'not_answered') {
            return 'danger'
        } else if (props.status === 'mark_for_review') {
            return 'warning'
        } else if (props.status === 'answered_mark_for_review') {
            return 'caution'
        } else {
            return 'default'
        }
    })
</script>
