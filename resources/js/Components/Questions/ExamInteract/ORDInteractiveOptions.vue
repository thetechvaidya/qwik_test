<template>
    <div ref="rootEl" class="q-radio">
        <div class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            {{ __('ord_hint') }}
        </div>
        <div class="q-options">
            <draggable v-model="answer" group="options" @end="selectAnswer">
                <transition-group name="flip-list" tag="div">
                    <div v-for="(option, index) in answer" :key="option.id" class="q-option">
                        <label :for="question_id+'_option_'+index" :class="labelClass(index)">
                            <span class="o-id match"><strong>{{ index+1 }}</strong> - <strong>{{ option.code }}</strong></span>
                            <span class="o-text" v-html="option.value"></span>
                            <span class="o-bars text-gray-400">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                            </span>
                        </label>
                    </div>
                </transition-group>
            </draggable>
        </div>
    </div>
</template>
<script setup>
    import { ref, computed, watch, onMounted, nextTick } from 'vue'
    import { useMathRender } from '@/composables/useMathRender'
    import { useTranslate } from '@/composables/useTranslate'
    import draggable from 'vuedraggable'

    // Props
    const props = defineProps({
        parentQid: [Number, String],
        parentOptions: Array,
        parentAnswer: [String, Array, Number],
        status: String
    })

    // Emits
    const emit = defineEmits(['modifyAnswer'])

    // Composables
    const { __ } = useTranslate()

    // Local state
    const question_id = ref(props.parentQid)
    const options = ref(props.parentOptions)
    const answer = ref(
        (typeof props.parentAnswer !== 'undefined' && props.status === 'answered') 
            ? props.parentAnswer 
            : props.parentOptions
    )
    const touched = ref(false)

    // Watch for parent answer changes
    watch(() => props.parentAnswer, (newAnswer) => {
        answer.value = newAnswer
    })

    // Methods
    const selectAnswer = () => {
        touched.value = true
        emit('modifyAnswer', answer.value)
    }

    const labelClass = (index) => {
        if (touched.value || props.status === 'answered') {
            return 'answered cursor-move'
        }
        return 'cursor-move'
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
