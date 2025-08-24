<template>
    <div class="q-radio">
        <div v-if="!disable" class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
            Match the following by drag and drop right side items
        </div>
        <div class="flex flex-col sm:flex-row gap-2 q-options">
            <div class="w-full flex flex-col justify-between">
                <div v-for="(item, index) in options" :key="item.id" class="q-option h-full">
                    <label class="h-full" :for="question_id+'_option_'+index">
                        <span class="o-id"><strong>{{ index+1 }}</strong></span>
                        <span class="o-text" v-html="item.value"></span>
                    </label>
                </div>
            </div>
            <div class="w-full">
                <draggable v-model="answer" group="options" :sort="!disable" @end="selectAnswer">
                    <transition-group name="flip-list" tag="div" class="w-full flex flex-col justify-between">
                        <div v-for="(item, index) in answer" :key="item.id" class="q-option h-full">
                            <label class="h-full" :for="question_id+'_pair_'+index" :class="labelClass(index)">
                                <span class="o-id match"><strong>{{ index+1 }}</strong> - <strong>{{ item.code }}</strong></span>
                                <span class="o-text" v-html="item.value"></span>
                                <span v-show="!disable" class="o-bars text-gray-400">
                                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"></path></svg>
                                </span>
                            </label>
                        </div>
                    </transition-group>
                </draggable>
            </div>
        </div>
        <div v-if="disable" class="flex gap-2 border border-green-200 bg-green-50 items-center rounded p-4 mt-6">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <h4 class="text-sm text-gray-600" v-html="answerText"></h4>
        </div>
    </div>
</template>
<script setup>
    import { ref, computed, watch, onMounted, nextTick } from 'vue'
    import draggable from 'vuedraggable'

    // Props
    const props = defineProps({
        parentQid: [Number, String],
        parentOptions: [Array, Object],
        parentAnswer: [Array, Object],
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
    const options = ref(props.parentOptions['matches'])
    const answer = ref(
        (typeof props.parentAnswer !== 'undefined' && props.status === 'answered') 
            ? props.parentAnswer 
            : props.parentOptions['pairs']
    )
    const touched = ref(false)

    // Watch for parent answer changes
    watch(() => props.parentAnswer, (newAnswer) => {
        answer.value = newAnswer
    })

    // Computed properties
    const disable = computed(() => {
        return props.status === 'answered' || props.solutionMode
    })

    const answerText = computed(() => {
        if (disable.value) {
            const answers = []
            props.correctAnswer.forEach((item, index) => {
                const obj = props.parentAnswer.find(o => o.id === item)
                answers.push((index + 1) + " - " + obj.code)
            })
            const str = answers.join(", ")
            return 'Correct answers are ' + str
        }
        return ''
    })

    // Methods
    const selectAnswer = () => {
        touched.value = true
        emit('modifyAnswer', answer.value)
    }

    const labelClass = (index) => {
        if (props.status === 'answered') {
            if (answer.value[index].id === props.correctAnswer[index]) {
                return 'correct'
            } else {
                return 'wrong'
            }
        } else {
            if (touched.value) {
                return 'answered cursor-move'
            }
            return 'cursor-move'
        }
    }

    // Lifecycle
    onMounted(() => {
        nextTick(() => {
            if (window.renderMathInElement) {
                window.renderMathInElement(document.querySelector('.q-radio'))
            }
        })
    })
</script>
