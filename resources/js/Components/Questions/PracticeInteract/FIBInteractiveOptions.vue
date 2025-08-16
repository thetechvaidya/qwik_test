<template>
    <div ref="rootEl" class="q-inputs">
        <div v-if="!disable" class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            Fill the blanks in the below text boxes
        </div>
        <div v-for="(blank, index) in options" :key="'blank_'+index">
            <div class="mb-2" :class="labelClass(index)">
                <div class="i-id">
                    <label :for="question_id+'ans_'+(blank-1)">{{ blank }}</label>
                </div>
                <input
:id="question_id+'ans_'+(blank-1)" v-model="answer[blank-1]" :placeholder="'Type your answer for blank '+ blank"
                       :disabled="disable" @change="selectAnswer"/>
            </div>
        </div>
        <div v-if="disable" class="flex gap-2 border border-green-200 bg-green-50 items-center rounded p-4 mt-6">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <h4 class="text-gray-600" v-html="answerText"></h4>
        </div>
    </template>
<script setup>
    import { ref, computed, watch, onMounted, nextTick } from 'vue'
    import { useMathRender } from '@/composables/useMathRender'

    // Props
    const props = defineProps({
        parentQid: [Number, String],
        parentOptions: [String, Array, Number],
        parentAnswer: [String, Array, Number],
        correctAnswer: [String, Array, Number],
        isCorrect: Boolean,
        status: String,
        solutionMode: {
            type: Boolean,
            default: false
        }
    })

    // Emits
    const emit = defineEmits(['modifyAnswer'])

    // Local state
    const question_id = ref(props.parentQid)
    const options = ref(props.parentOptions)
    const answer = ref(props.parentAnswer || [])

    // Watch for parent answer changes
    watch(() => props.parentAnswer, (newAnswer) => {
        answer.value = newAnswer || []
    })

    // Computed properties
    const disable = computed(() => {
        return props.status === 'answered' || props.solutionMode
    })

    const answerText = computed(() => {
        if (disable.value) {
            const answers = props.correctAnswer.map((value, index) => {
                return (index + 1) + '. ' + value
            }).join(', ')
            return 'Correct answers for the blanks are ' + answers
        }
        return ''
    })

    // Methods
    const selectAnswer = () => {
        emit('modifyAnswer', answer.value)
    }

    const labelClass = (index) => {
        if (props.status === 'answered') {
            if (answer.value[index] && answer.value[index].toLowerCase() === props.correctAnswer[index].toLowerCase()) {
                return 'q-input correct'
            } else {
                return 'q-input wrong'
            }
        } else {
            if (answer.value[index] && answer.value[index] !== "") {
                return 'q-input answered'
            }
            return 'q-input'
        }
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
