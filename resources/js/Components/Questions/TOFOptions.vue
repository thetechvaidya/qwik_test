<template>
    <div class="msa-options">
        <div v-for="(option, index) in options" :key="index" class="mb-4">
            <div class="font-semibold mb-2">{{ translate('Option') }} {{ index+1 }}</div>
            <TiptapEditor 
                v-model="options[index].option" 
                :config="{ 
                    toolbar: 'basic', 
                    rtl: $page.props.rtl
                }" 
                :height="'75px'" 
            />
            <div class="flex bg-gray-50 border-b border-l border-r border-gray-300 justify-between items-center px-4 py-2">
                <div class="flex gap-1 items-center">
                    <input :id="'option-'+index" v-model="correct_answer" type="radio" class="custom-control-input" :value="index+1" @change="selectAnswer">
                    <label class="custom-control-label" :for="'option-'+index">{{ translate('Correct Answer') }}</label>
                </div>
                <div class="flex items-center justify-end gap-2">
                    <!--<div class="flex gap-1 items-center">
                        <label class="custom-control-label" :for="'weight-'+index">{{ __('Partial Weighting') }}: </label>
                        <InputNumber class="tiny-input" :id="'weight-'+index" v-model="options[index].partial_weightage"
                                     suffix=" %" :disabled="(correct_answer-1) === index" />
                    </div>-->
                </div>
            </div>

        </div>
    </div>
</template>
<script>
    import TiptapEditor from "@/Components/TiptapEditor";
    import InputNumber from 'primevue/inputnumber';
    import { useTranslate } from '@/composables/useTranslate';
    export default {
        name: 'TOFOptions',
        components: {
            TiptapEditor,
            InputNumber
        },
        setup() {
            const { __ } = useTranslate();
            return { translate: __ };
        },
        props: {
            parentOptions: Array,
            parentAnswer: null,
        },
        data: function () {
            return {
                options: this.parentOptions,
                correct_answer: this.parentAnswer,
            }
        },
        methods: {
            selectAnswer (event) {
                this.options[this.correct_answer-1].partial_weightage = 0;
                this.$emit('modifyAnswer', this.correct_answer)
            }
        }
    }
</script>
