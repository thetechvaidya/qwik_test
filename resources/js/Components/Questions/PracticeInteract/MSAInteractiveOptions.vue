<template>
    <div ref="rootEl" class="q-radio">
        <div v-if="!disable" class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            Choose one option
        </div>
        <div class="q-options">
            <div v-for="(option, index) in options" :key="option" class="q-option">
                <input
                    :id="question_id + '_option_' + index"
                    v-model="answer"
                    type="radio"
                    :value="index + 1"
                    :disabled="disable"
                    @change="selectAnswer"
                />
                <label :class="labelClass(index)" :for="question_id + '_option_' + index">
                    <span class="o-id"
                        ><strong>{{ index + 1 }}</strong></span
                    >
                    <span class="o-text" v-html="option"></span>
                </label>
            </div>
        </div>
        <div v-if="disable" class="flex gap-2 border border-green-200 bg-green-50 items-center rounded p-4 mt-6">
            <svg
                class="w-6 h-6 text-green-400"
                fill="none"
                stroke="currentColor"
                viewBox="0 0 24 24"
                xmlns="http://www.w3.org/2000/svg"
            >
                <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                ></path>
            </svg>
            <h4 class="text-gray-600" v-html="answerText"></h4>
        </div>
    </div>
</template>
<script setup>
import { ref, computed, watch, onMounted, nextTick } from 'vue'
import { useMathRender } from '@/composables/useMathRender'

// Props
const props = defineProps({
    parentQid: [Number, String],
    parentOptions: Array,
    parentAnswer: [String, Array, Number],
    correctAnswer: [String, Array, Number],
    isCorrect: Boolean,
    status: String,
    solutionMode: {
        type: Boolean,
        default: false,
    },
})

// Emits
const emit = defineEmits(['modifyAnswer'])

// Local state
const question_id = ref(props.parentQid)
const options = ref(props.parentOptions)
const answer = ref(props.parentAnswer)

// Watch for parent answer changes
watch(
    () => props.parentAnswer,
    newAnswer => {
        answer.value = newAnswer
    }
)

// Computed properties
const disable = computed(() => {
    return props.status === 'answered' || props.solutionMode
})

const answerText = computed(() => {
    if (disable.value) {
        return 'Correct answer is Option ' + props.correctAnswer
    }
    return ''
})

// Methods
const selectAnswer = () => {
    emit('modifyAnswer', answer.value)
}

const labelClass = index => {
    if (props.status === 'answered') {
        if (props.isCorrect && answer.value === index + 1) {
            return 'correct'
        }
        if (!props.isCorrect && answer.value === index + 1) {
            return 'wrong'
        }
    }
    return props.status === 'answered' ? '' : 'cursor-pointer'
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
