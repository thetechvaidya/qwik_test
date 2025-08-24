<template>
    <input
        v-model="proxyChecked"
        type="checkbox"
        :value="value"
        class="rounded border-gray-300 text-green-600 shadow-sm focus:border-green-300 focus:ring focus:ring-green-200 focus:ring-opacity-50"
    />
</template>

<script>
export default {
    emits: ['change', 'update:checked'],

    props: {
        checked: {
            type: [Array, Boolean],
            default: false,
        },
        value: {
            default: null,
        },
    },

    computed: {
        proxyChecked: {
            get() {
                return this.checked
            },
            set(val) {
                this.$emit('change', val)
                this.$emit('update:checked', val)
            },
        },
    },
}
</script>
