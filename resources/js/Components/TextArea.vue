<template>
    <textarea
        ref="input"
        class="text-sm border-gray-300 focus:border-indigo-300 focus:ring focus:ring-indigo-200 focus:ring-opacity-50 rounded-sm shadow-sm"
        :value="value"
        rows="4"
        @input="$emit('input', $event.target.value)"
    >
    </textarea>
</template>

<script>
export default {
    props: ['value'],

    methods: {
        focus() {
            this.$refs.input.focus()
        },
    },
}
</script>
