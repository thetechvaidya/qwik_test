<template>
    <div class="fib-options">
        <div class="w-full">
            <div class="flex justify-between items-center mb-4">
                <div class="w-9/12">
                    <label for="is_active" class="font-semibold text-gray-800 pb-1">Word Limit</label>
                    <p class="text-gray-500">Restrict answer with certain word limit.</p>
                </div>
                <div class="cursor-pointer rounded-full relative shadow-sm">
                    <ToggleSwitch id="is_active" v-model="preferences.word_limit" />
                </div>
            </div>
        </div>
        <div class="w-full">
            <div class="flex justify-between items-center mb-8">
                <div class="w-6/12">
                    <label for="min_words" class="font-semibold text-gray-800 pb-1">Minimum Words</label>
                    <InputNumber id="min_words" v-model="preferences.min_words" placeholder="Enter Minimum Words" :disabled="!preferences.word_limit" />
                </div>
                <div class="w-6/12">
                    <label for="max_words" class="font-semibold text-gray-800 pb-1">Maximum Words</label>
                    <InputNumber id="max_words" v-model="preferences.max_words" placeholder="Enter Minimum Words" :disabled="!preferences.word_limit" />
                </div>
            </div>
        </div>
    </div>
</template>
<script>
    import ToggleSwitch from 'primevue/toggleswitch';
    import InputNumber from 'primevue/inputnumber';
    import { required } from '@vuelidate/validators';
    import { useVuelidate } from '@vuelidate/core';
    export default {
        name: 'LAQOptions',
        components: {
            ToggleSwitch,
        },
        props: {
            parentPreferences: Object,
        },
        setup() {
            return {
                v$: useVuelidate()
            }
        },
        data: function () {
            return {
                preferences: this.parentPreferences,
            }
        },
        validations() {
            return {
                preferences: {
                    ...this.preferences.word_limit && {
                        min_words: {
                            required
                        },
                        max_words: {
                            required
                        },
                    },
                }
            }
        },
        watch: {
            preferences: {
                deep: true,
                handler(value) {
                    this.$emit('modifyPreferences', value)
                }
            }
        },
        methods: {
            selectAnswer (event) {
                this.$emit('modifyPreferences', this.preferences)
            }
        }
    }
</script>
