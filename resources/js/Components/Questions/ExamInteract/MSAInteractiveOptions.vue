<template>
    <div ref="rootEl" class="q-radio">
        <div class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            {{ __('msa_hint') }}
        </div>
        <div class="q-options">
            <div v-for="(option, index) in options" :key="option" class="q-option">
                <input
                    :id="question_id + '_option_' + index"
                    v-model="answer"
                    type="radio"
                    :value="index + 1"
                    @change="selectAnswer"
                />
                <label :class="labelClass(index)" class="cursor-pointer" :for="question_id + '_option_' + index">
                    <span class="o-id"
                        ><strong>{{ index + 1 }}</strong></span
                    >
                    <span class="o-text" v-html="option"></span>
                </label>
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
    parentOptions: Array,
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
const answer = ref(props.parentAnswer)

// Watch for parent answer changes
watch(
    () => props.parentAnswer,
    newAnswer => {
        answer.value = newAnswer
    }
)

// Methods
const selectAnswer = () => {
    emit('modifyAnswer', answer.value)
}

const labelClass = index => {
    const base = 'cursor-pointer'
    if (props.status === 'answered') {
        return answer.value === index + 1 ? 'answered' : base
    }
    return base
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
