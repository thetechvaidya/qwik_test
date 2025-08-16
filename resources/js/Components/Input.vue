<template>
    <input
        ref="input"
        class="text-sm border-gray-300 focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 rounded-sm shadow-sm"
        :value="value"
        @input="$emit('input', $event.target.value)"
    />
</template>

<script>
export default {
    name: 'FormInput',
    props: {
        value: {
            type: [String, Number],
            default: '',
        },
    },
    emits: ['input'],
    methods: {
        focus() {
            this.$refs.input.focus()
        },
    },
}
</script>
