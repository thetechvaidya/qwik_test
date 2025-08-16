<template>
    <Button
        :type="type"
        :class="buttonClasses"
        :disabled="isDisabled"
        :loading="isLoading"
        :severity="buttonSeverity"
        :icon="buttonIcon"
    >
        <span v-if="!isLoading">{{ label }}</span>
    </Button>
</template>

<script setup>
import { computed } from 'vue'
import Button from 'primevue/button'

// Props
const props = defineProps({
    label: {
        type: String,
        default: 'Submit',
    },
    type: {
        type: String,
        default: 'submit',
    },
    submitStatus: {
        type: String,
        default: null,
        validator: value => !value || ['ERROR', 'PENDING', 'OK', 'IDLE'].includes(value),
    },
    processing: {
        type: Boolean,
        default: false,
    },
    disabled: {
        type: Boolean,
        default: false,
    },
    validationError: {
        type: Boolean,
        default: false,
    },
    severity: {
        type: String,
        default: null,
    },
})

// Computed properties for enhanced UX feedback
const isLoading = computed(() => {
    return props.processing || props.submitStatus === 'PENDING'
})

const isDisabled = computed(() => {
    return props.disabled || props.processing || props.submitStatus === 'PENDING'
})

const buttonSeverity = computed(() => {
    if (props.severity) return props.severity

    switch (props.submitStatus) {
        case 'ERROR':
            return 'danger'
        case 'OK':
            return 'success'
        case 'PENDING':
            return 'secondary'
        default:
            return 'primary'
    }
})

const buttonIcon = computed(() => {
    switch (props.submitStatus) {
        case 'ERROR':
            return 'pi pi-exclamation-triangle'
        case 'OK':
            return 'pi pi-check'
        case 'PENDING':
            return 'pi pi-spinner pi-spin'
        default:
            return null
    }
})

const buttonClasses = computed(() => {
    const classes = []

    // Base classes
    classes.push('qt-btn')

    // Status-specific classes
    switch (props.submitStatus) {
        case 'ERROR':
            classes.push('qt-btn-error', 'animate-pulse')
            break
        case 'OK':
            classes.push('qt-btn-success')
            break
        case 'PENDING':
            classes.push('qt-btn-pending')
            break
        default:
            classes.push('qt-btn-primary')
    }

    // Validation error styling
    if (props.validationError) {
        classes.push('border-red-300', 'text-red-700')
    }

    // Disabled state styling
    if (isDisabled.value) {
        classes.push('opacity-25', 'cursor-not-allowed')
    }

    return classes.join(' ')
})
</script>

<style scoped>
/* Enhanced button styles for better UX feedback */
.qt-btn {
    @apply px-4 py-2 rounded-md font-medium transition-all duration-200 ease-in-out;
}

.qt-btn-primary {
    @apply bg-blue-600 hover:bg-blue-700 text-white border border-blue-600;
}

.qt-btn-success {
    @apply bg-green-600 hover:bg-green-700 text-white border border-green-600;
}

.qt-btn-error {
    @apply bg-red-600 hover:bg-red-700 text-white border border-red-600;
}

.qt-btn-pending {
    @apply bg-gray-400 text-gray-700 border border-gray-400;
}

.qt-btn:disabled {
    @apply cursor-not-allowed;
}

/* Animation for error state */
@keyframes pulse-error {
    0%,
    100% {
        @apply bg-red-600;
    }
    50% {
        @apply bg-red-700;
    }
}

.animate-pulse {
    animation: pulse-error 2s infinite;
}
</style>
