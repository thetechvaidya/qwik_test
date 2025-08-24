<template>
    <div ref="rootEl" class="w-full overflow-hidden dark_question_card rounded cursor-pointer mb-1">
        <div :class="[active ? 'bg-gray-200': 'text-gray-600']" class="hover:bg-gray-200 rounded p-4">
            <div class="flex items-start gap-4">
                <question-chip v-tooltip.right="questionStatus" :sno="sno" :status="chipStatus" :is-active="active"></question-chip>
                <div class="leading-relaxed text-sm" v-html="question.question"></div>
            </div>
        </div>
    </div>
</template>
<script setup>
    import { ref, computed, nextTick, onMounted } from 'vue'
    const rootEl = ref(null)
    import QuestionChip from "@/Components/Buttons/QuestionChip"
    import Tooltip from 'primevue/tooltip'

    // Define component options including directives
    defineOptions({
        name: 'LightQuestionCard',
        directives: {
            tooltip: Tooltip
        }
    })

    // Props
    const props = defineProps({
        question: Object,
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
            return 'Answered & Marked'
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

    // Lifecycle
    onMounted(() => {
        nextTick(() => {
            if (rootEl.value && window.renderMathInElement) {
                window.renderMathInElement(rootEl.value)
            }
        })
    })
</script>
