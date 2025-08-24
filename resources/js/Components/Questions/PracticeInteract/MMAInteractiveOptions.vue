<template>
    <div ref="rootEl" class="q-radio">
        <div v-if="!disable" class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            Choose multiple options
        </div>
        <div class="q-options">
            <div v-for="(sanitizedOption, index) in sanitizedOptions" :key="index" class="q-option">
                <input
                    :id="'q_'+question_id+'_option_'+index"
                    v-model="answer"
                    type="checkbox"
                    :value="index+1"
                    :disabled="(answer.length >= 3 && answer.indexOf(index+1) === -1) || disable"
                    @change="selectAnswer">
                <label :class="labelClass(index)" :for="'q_'+question_id+'_option_'+index">
                    <span class="o-id squared"><strong>{{ index+1 }}</strong></span>
                    <span class="o-text" v-html="sanitizedOption"></span>
                </label>
            </div>
        </div>
        <div v-if="disable" class="flex gap-2 border border-green-200 bg-green-50 items-center rounded p-4 mt-6">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <h4 class="text-gray-600" v-html="sanitizeHtml(answerText)"></h4>
        </div>
    </div>
</template>
<script setup>
    import {sanitizeHtml} from "../../../utils/security";
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
            const answers = [...props.correctAnswer].sort()
            const str = answers.join(", ")
            return 'Correct answers are Option ' + str
        }
        return ''
    })

    const sanitizedOptions = computed(() => {
        if (!Array.isArray(props.parentOptions)) {
            console.error("Invalid options provided. Expected an array.", props.parentOptions);
            return [];
        }
        return props.parentOptions.map(option => {
            if (typeof option !== 'string') {
                console.warn("Option is not a string, returning empty string.", option);
                return sanitizeHtml('');
            }
            return sanitizeHtml(option);
        });
    });

    // Methods
    const selectAnswer = () => {
        if (!Array.isArray(answer.value)) {
            answer.value = [];
        }

        const validatedAnswer = answer.value
            .map(val => Number(val))
            .filter(val => Number.isInteger(val) && val > 0 && val <= options.value.length);

        if (validatedAnswer.length !== answer.value.length) {
            answer.value = validatedAnswer;
        }

        emit('modifyAnswer', answer.value);
    }

    const labelClass = (index) => {
        if (props.status === 'answered') {
            if (answer.value.indexOf(index + 1) !== -1) {
                if (props.correctAnswer.indexOf(index + 1) !== -1) {
                    return 'correct'
                } else {
                    return 'wrong'
                }
            }
            return ''
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
