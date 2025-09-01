<template>
    <textarea
        ref="input"
        class="text-sm border-gray-300 focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 rounded-sm shadow-sm"
        :value="modelValue"
        rows="4"
        @input="$emit('update:modelValue', $event.target.value)"
    >
    </textarea>
</template>

<script>
export default {
    props: {
        modelValue: {
            type: [String, Number],
            default: '',
        },
    },
    emits: ['update:modelValue'],
    data() {
        return {
            isUnmounting: false,
        }
    },
    beforeUnmount() {
        this.isUnmounting = true
    },
    methods: {
        focus() {
            if (this.isUnmounting || !this.$refs.input) return
            try {
                this.$refs.input.focus()
            } catch (error) {
                console.warn('TextArea: Focus error during component transition:', error)
            }
        },
    },
}
</script>
