<template>
    <div class="emq-options">
        <div class="space-y-4">
            <div v-for="(option, index) in options" :key="index" class="emq-option-item">
                <div class="flex items-center justify-between p-3 border rounded-lg">
                    <div class="flex-1">
                        <span class="font-medium">{{ option.label || `Option ${index + 1}` }}</span>
                        <p v-if="option.description" class="text-sm text-gray-600 mt-1">
                            {{ option.description }}
                        </p>
                    </div>
                    <div class="ml-4">
                        <input
                            v-model="option.value"
                            type="text"
                            :placeholder="`Answer for option ${index + 1}`"
                            class="form-input"
                            @input="updateOption(index, $event.target.value)"
                        />
                    </div>
                </div>
            </div>
        </div>

        <div class="mt-4 flex gap-2">
            <button type="button" class="px-4 py-2 bg-blue-500 text-white rounded hover:bg-blue-600" @click="addOption">
                Add Option
            </button>
            <button
                v-if="options.length > 1"
                type="button"
                class="px-4 py-2 bg-red-500 text-white rounded hover:bg-red-600"
                @click="removeLastOption"
            >
                Remove Last
            </button>
        </div>
    </div>
</template>

<script setup>
import { ref, watch } from 'vue'

// Props
const props = defineProps({
    modelValue: {
        type: Array,
        default: () => [],
    },
    maxOptions: {
        type: Number,
        default: 10,
    },
    minOptions: {
        type: Number,
        default: 2,
    },
})

// Emits
const emit = defineEmits(['update:modelValue'])

// Reactive data
const options = ref(
    props.modelValue.length > 0
        ? [...props.modelValue]
        : [
              { label: '', value: '', description: '' },
              { label: '', value: '', description: '' },
          ]
)

// Watch for external updates
watch(
    () => props.modelValue,
    newVal => {
        if (newVal && newVal.length > 0) {
            options.value = [...newVal]
        }
    },
    { deep: true }
)

// Watch for internal changes
watch(
    options,
    newOptions => {
        emit('update:modelValue', newOptions)
    },
    { deep: true }
)

// Methods
const updateOption = (index, value) => {
    if (options.value[index]) {
        options.value[index].value = value
    }
}

const addOption = () => {
    if (options.value.length < props.maxOptions) {
        options.value.push({
            label: '',
            value: '',
            description: '',
        })
    }
}

const removeLastOption = () => {
    if (options.value.length > props.minOptions) {
        options.value.pop()
    }
}

const removeOption = index => {
    if (options.value.length > props.minOptions) {
        options.value.splice(index, 1)
    }
}

// Expose methods for parent components
defineExpose({
    addOption,
    removeOption,
    removeLastOption,
})
</script>

<style scoped>
.emq-options {
    @apply space-y-4;
}

.emq-option-item {
    @apply transition-all duration-200;
}

.emq-option-item:hover {
    @apply shadow-sm;
}

.form-input {
    @apply w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent;
}
</style>
