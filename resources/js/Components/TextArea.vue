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
    methods: {
        focus() {
            this.$refs.input.focus()
        },
    },
}
</script>
