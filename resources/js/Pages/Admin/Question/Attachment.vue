<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Question') }} {{ __('Attachment') }}</h2
                    >
                    <p class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        >{{ questionType.name }} {{ __('Question') }}</p
                    >
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="md:w-8/12 w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <div class="flex gap-2 mb-2">
                                        <label for="has_attachment" class="font-semibold text-sm text-gray-800 pb-1">{{
                                            __('Enable Question Attachment')
                                        }}</label>
                                    </div>
                                    <SelectButton
                                        id="has_attachment"
                                        v-model="form.has_attachment"
                                        :options="choices"
                                        data-key="code"
                                        option-value="code"
                                        option-label="name"
                                    />
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Attachment Type')
                                    }}</label>
                                    <div class="flex gap-4 items-center my-2">
                                        <div
                                            v-for="attachment in attachmentTypes"
                                            :key="attachment.id"
                                            class="p-field-radiobutton"
                                        >
                                            <RadioButton
                                                :id="attachment.id"
                                                v-model="form.attachment_type"
                                                name="attachment_type"
                                                :value="attachment.id"
                                                @input="attachmentTypeChanged($event)"
                                            />
                                            <label class="custom-control-label" :for="attachment.id">{{
                                                attachment.name
                                            }}</label>
                                        </div>
                                    </div>
                                </div>
                                <div v-if="form.has_attachment" class="w-full">
                                    <div
                                        v-if="form.has_attachment && form.attachment_type === 'comprehension'"
                                        class="mb-4"
                                    >
                                        <ComprehensionOptions
                                            :parent-comprehensions="initialComprehensions"
                                            :parent-comprehension-id="form.comprehension_id"
                                            @modify-comprehension="updateComprehension"
                                        />
                                    </div>
                                    <div v-if="form.has_attachment && form.attachment_type === 'audio'" class="mb-4">
                                        <AudioOptions
                                            :parent-options="form.attachment_options"
                                            @modify-options="updateAudioOptions"
                                        />
                                    </div>
                                    <div v-if="form.has_attachment && form.attachment_type === 'video'" class="mb-4">
                                        <VideoOptions
                                            :parent-options="form.attachment_options"
                                            @modify-options="updateVideoOptions"
                                        />
                                    </div>
                                </div>
                                <div
                                    v-if="form.has_attachment && form.attachment_type === 'comprehension'"
                                    class="form-control-errors"
                                >
                                    <p
                                        v-if="v$.form.comprehension_id.$error && !v$.form.comprehension_id.required"
                                        role="alert"
                                        class="text-xs text-red-500 pt-2"
                                        >{{ __('Comprehension') }} {{ __('is required') }}.</p
                                    >
                                </div>
                                <div
                                    v-if="form.has_attachment && form.attachment_type === 'video'"
                                    class="form-control-errors"
                                >
                                    <p
                                        v-if="
                                            v$.form.attachment_options.link.$error &&
                                            !v$.form.attachment_options.link.required
                                        "
                                        role="alert"
                                        class="text-xs text-red-500 pt-2"
                                        >{{ __('Video Link') }} {{ __('is required') }}.</p
                                    >
                                </div>
                                <div
                                    v-if="form.has_attachment && form.attachment_type === 'audio'"
                                    class="form-control-errors"
                                >
                                    <p
                                        v-if="
                                            v$.form.attachment_options.link.$error &&
                                            !v$.form.attachment_options.link.required
                                        "
                                        role="alert"
                                        class="text-xs text-red-500 pt-2"
                                        >{{ __('Audio Link') }} {{ __('is required') }}.</p
                                    >
                                </div>
                                <!-- Submit Button -->
                                <div class="w-full flex justify-end my-8">
                                    <Button type="submit" :label="editFlag ? __('Update') : __('Save')" />
                                </div>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    // Add props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Question/ Attachment') + ' - ' + pageProps.general.app_name
})
</script>
