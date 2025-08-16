<template>
    <div ref="rootEl" class="q-inputs">
        <div class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            {{ __('saq_hint') }}
        </div>
        <div :class="labelClass()">
            <div class="i-id">
                <label :for="question_id">A</label>
            </div>
            <input :id="question_id" v-model="answer" placeholder="Type your answer" @change="selectAnswer"/>
        </div>
    </template>
<script setup>
    import { ref, computed, watch, onMounted, nextTick } from 'vue'
    import { useMathRender } from '@/composables/useMathRender'
    import { useTranslate } from '@/composables/useTranslate'

    // Props
    const props = defineProps({
        parentQid: [Number, String],
        parentOptions: [String, Array, Number],
        parentAnswer: [String, Array, Number],
        status: String,
    })

    // Emits
    const emit = defineEmits(['modifyAnswer'])

    // Composables
    const { __ } = useTranslate()

    // Local state
    const question_id = ref(props.parentQid)
    const options = ref(props.parentOptions)
    const answer = ref(props.parentAnswer || '')

    // Watch for parent answer changes
    watch(() => props.parentAnswer, (newAnswer) => {
        answer.value = newAnswer || ''
    })

    // Methods
    const selectAnswer = () => {
        emit('modifyAnswer', answer.value)
    }

    const labelClass = () => {
        if (answer.value !== "" && answer.value !== null) {
            return 'q-input answered'
        }
        return 'q-input'
    }

    // Math rendering scoped to component root
    const rootEl = ref(null)
    const { renderMath } = useMathRender()

    onMounted(async () => {
        await nextTick()
        if (rootEl.value) {
            await renderMath(rootEl.value)
        }
    })
</script>
