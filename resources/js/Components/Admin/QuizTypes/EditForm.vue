<template>
    <div class="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
        <div class="bg-white rounded-lg shadow-xl w-full max-w-2xl mx-4 max-h-[90vh] overflow-hidden">
            <!-- Header -->
            <div class="px-6 py-4 border-b border-gray-200">
                <div class="flex items-center justify-between">
                    <h3 class="text-lg font-semibold text-gray-900">
                        {{ title || __('Edit Quiz Type') }}
                    </h3>
                    <button class="text-gray-400 hover:text-gray-600 transition-colors" @click="$emit('close')">
                        <i class="pi pi-times text-xl"></i>
                    </button>
                </div>
            </div>

            <!-- Content -->
            <div class="overflow-y-auto max-h-[calc(90vh-120px)]">
                <div v-if="loading" class="p-6 space-y-6">
                    <!-- Loading State -->
                    <div v-for="i in 5" :key="i" class="animate-pulse">
                        <div class="h-4 bg-gray-200 rounded w-24 mb-2"></div>
                        <div class="h-10 bg-gray-200 rounded w-full"></div>
                    </div>
                </div>

                <div v-else class="p-6">
                    <form class="space-y-6" @submit.prevent="submitForm">
                        <!-- Name Field -->
                        <div>
                            <label for="name" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Name') }} <span class="text-red-500">*</span>
                            </label>
                            <InputText
                                id="name"
                                v-model="form.name"
                                :placeholder="__('Enter quiz type name')"
                                :class="{ 'p-invalid': errors?.name }"
                                class="w-full"
                            />
                            <small v-if="errors?.name" class="text-red-500 mt-1 block">
                                {{ errors.name[0] }}
                            </small>
                        </div>

                        <!-- Description Field -->
                        <div>
                            <label for="description" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Description') }}
                            </label>
                            <Textarea
                                id="description"
                                v-model="form.description"
                                :placeholder="__('Enter quiz type description')"
                                :class="{ 'p-invalid': errors?.description }"
                                class="w-full"
                                rows="3"
                            />
                            <small v-if="errors?.description" class="text-red-500 mt-1 block">
                                {{ errors.description[0] }}
                            </small>
                        </div>

                        <!-- Color Field -->
                        <div>
                            <label for="color" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Color') }}
                            </label>
                            <div class="flex items-center gap-3">
                                <ColorPicker
                                    v-model="form.color"
                                    format="hex"
                                    :class="{ 'p-invalid': errors?.color }"
                                />
                                <InputText
                                    v-model="form.color"
                                    :placeholder="__('#000000')"
                                    :class="{ 'p-invalid': errors?.color }"
                                    class="flex-1"
                                />
                            </div>
                            <small v-if="errors?.color" class="text-red-500 mt-1 block">
                                {{ errors.color[0] }}
                            </small>
                        </div>

                        <!-- Image Path Field -->
                        <div>
                            <label for="image_path" class="block text-sm font-medium text-gray-700 mb-2">
                                {{ __('Image Path') }}
                            </label>
                            <InputText
                                id="image_path"
                                v-model="form.image_path"
                                :placeholder="__('Enter image path or URL')"
                                :class="{ 'p-invalid': errors?.image_path }"
                                class="w-full"
                            />
                            <small v-if="errors?.image_path" class="text-red-500 mt-1 block">
                                {{ errors.image_path[0] }}
                            </small>
                        </div>

                        <!-- Is Active Toggle -->
                        <div>
                            <div class="flex items-center gap-3">
                                <ToggleSwitch id="is_active" v-model="form.is_active" />
                                <label for="is_active" class="text-sm font-medium text-gray-700">
                                    {{ __('Active') }}
                                </label>
                            </div>
                            <small class="text-gray-500 mt-1 block">
                                {{ __('Set whether this quiz type is active and available for use') }}
                            </small>
                        </div>
                    </form>
                </div>
            </div>

            <!-- Footer -->
            <div class="px-6 py-4 border-t border-gray-200 flex items-center justify-end gap-3">
                <Button
                    :label="__('Cancel')"
                    severity="secondary"
                    :disabled="form.processing || loading"
                    @click="$emit('close')"
                />
                <Button
                    :label="__('Update Quiz Type')"
                    :loading="form.processing"
                    :disabled="!form.name || loading"
                    @click="submitForm"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
import { reactive, ref } from 'vue'
import { router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useConfirmToast } from '@/composables/useConfirmToast'
import InputText from 'primevue/inputtext'
import Textarea from 'primevue/textarea'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import ColorPicker from 'primevue/colorpicker'

// Props
const props = defineProps({
    title: String,
    currentId: {
        type: [Number, String],
        required: true,
    },
    initialData: {
        type: Object,
        default: () => ({}),
    },
})

// Emits
const emit = defineEmits(['close'])

// Composables
const { __ } = useTranslate()
const { toast } = useConfirmToast()

// Local errors state
const errors = ref({})

// Reactive state
const loading = ref(false)
const form = reactive({
    name: props.initialData.name || '',
    description: props.initialData.description || '',
    color: props.initialData.color || '#3B82F6',
    image_path: props.initialData.image_path || '',
    is_active: props.initialData.is_active !== undefined ? props.initialData.is_active : true,
    processing: false,
})

// Methods
const submitForm = async () => {
    if (!form.name.trim()) {
        toast({
            severity: 'warn',
            summary: __('Validation Error'),
            detail: __('Quiz type name is required'),
            life: 3000,
        })
        return
    }

    form.processing = true

    try {
        await router.patch(
            route('admin.quiz-types.update', props.currentId),
            {
                name: form.name,
                description: form.description,
                color: form.color,
                image_path: form.image_path,
                is_active: form.is_active,
            },
            {
                onSuccess: () => {
                    toast({
                        severity: 'success',
                        summary: __('Success'),
                        detail: __('Quiz type updated successfully'),
                        life: 3000,
                    })
                    emit('close')
                },
                onError: e => {
                    errors.value = e
                    console.error('Quiz type update failed:', e)
                    toast({
                        severity: 'error',
                        summary: __('Error'),
                        detail: __('Failed to update quiz type. Please check the form and try again.'),
                        life: 5000,
                    })
                },
                onFinish: () => {
                    form.processing = false
                },
            }
        )
    } catch (error) {
        console.error('Quiz type update error:', error)
        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('An unexpected error occurred. Please try again.'),
            life: 5000,
        })
        form.processing = false
    }
}
</script>
