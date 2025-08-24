<template>
    <div ref="rootEl" class="q-inputs">
        <div class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            {{ __('fib_hint') }}
        </div>
        <div v-for="(blank, index) in options" :key="'blank_'+index">
            <div :class="labelClass(index)">
                <div class="i-id">
                    <label :for="question_id+'ans_'+(blank-1)">{{ blank }}</label>
                </div>
                <input
                    :id="question_id+'ans_'+(blank-1)" 
                    v-model="answer[blank-1]" 
                    :placeholder="'Type your answer for blank '+ blank"
                    @change="selectAnswer"/>
            </div>
        </div>
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
    const answer = ref(props.parentAnswer || [])

    // Watch for parent answer changes
    watch(() => props.parentAnswer, (newAnswer) => {
        answer.value = newAnswer || []
    })

    // Methods
    const selectAnswer = () => {
        emit('modifyAnswer', answer.value)
    }

    const labelClass = (index) => {
        if (answer.value[index] && (answer.value[index] !== "" && answer.value[index] !== null)) {
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
