<template>
    <div class="q-radio">
        <div class="q-options">
            <div v-for="(option, index) in options" :key="option" class="q-option">
                <input
:id="'q_'+question_id+'_option_'+index" v-model="answer" type="checkbox" :value="index+1"
                       disabled="disabled">
                <label :class="labelClass(index)" :for="'q_'+question_id+'_option_'+index">
                    <span class="o-id squared"><strong>{{ index+1 }}</strong></span>
                    <span class="o-text" v-html="sanitizedOption(option.option)"></span>
                </label>
            </div>
        </div>
        <div class="flex gap-2 border border-green-200 bg-green-50 items-center rounded p-4 mt-6">
            <svg class="w-6 h-6 text-green-400" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
            <h4 class="text-gray-600" v-html="sanitizedAnswerText"></h4>
        </div>
    </div>
</template>
<script>
    import { sanitizeHtml } from "../../../utils/security";
    import { ref, computed, onMounted } from 'vue';

    export default {
        name: "MMASolution",
        props: {
            parentQid: {
                type: [Number, String],
                required: true,
            },
            parentOptions: {
                type: Array,
                required: true,
                validator: (options) => options.every(option => typeof option === 'string'),
            },
            parentAnswer: {
                type: [String, Array, Number],
                required: true,
            },
            correctAnswer: {
                type: [String, Array, Number],
                required: true,
            },
            isCorrect: {
                type: Boolean,
                required: true,
            },
            status: {
                type: String,
                required: true,
            },
        },
        setup(props) {
            const question_id = ref(props.parentQid);
            const options = ref(props.parentOptions);
            const answer = ref(props.parentAnswer);

            const answerText = computed(() => {
                if (!Array.isArray(props.correctAnswer)) {
                    return 'Invalid correct answer format';
                }
                let answers = [...props.correctAnswer].sort();
                let str = answers.join(", ");
                return `Correct answers are Options ${str}`;
            });

            const sanitizedAnswerText = computed(() => sanitizeHtml(answerText.value));

            const sanitizedOption = (option) => sanitizeHtml(option);

            const labelClass = (index) => {
                if (props.status === 'answered') {
                    if (Array.isArray(answer.value) && answer.value.includes(index + 1)) {
                        if (Array.isArray(props.correctAnswer) && props.correctAnswer.includes(index + 1)) {
                            return 'correct';
                        } else {
                            return 'wrong';
                        }
                    }
                }
                return '';
            };

            onMounted(() => {
                if (window.MathJax) {
                    window.MathJax.typesetPromise();
                }
            });

            return {
                question_id,
                options,
                answer,
                sanitizedAnswerText,
                sanitizedOption,
                labelClass,
            };
        }
    }
</script>
