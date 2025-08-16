<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Edit') }} {{ __('Video') }}</h4>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-description">
                    <div class="flex justify-center flex-wrap">
                        <div class="max-w-4xl w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="title" class="pb-2 font-semibold text-gray-800 text-sm"
                                        >{{ __('Video') }} {{ __('Title') }}</label
                                    >
                                    <InputText
                                        id="title"
                                        v-model="form.title"
                                        type="text"
                                        aria-describedby="title-help"
                                        :class="[errors.title ? 'p-invalid' : '']"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.title.$error && v$.form.title.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Title') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="mb-6">
                                    <VideoOptions :parent-options="videoOptions" @modify-options="updateVideoOptions" />
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="thumbnail" class="pb-2 font-semibold text-gray-800 text-sm"
                                        >{{ __('Video') }} {{ __('Thumbnail') }}</label
                                    >
                                    <div class="p-inputgroup">
                                        <InputText
                                            id="thumbnail"
                                            ref="thumbnail"
                                            v-model="form.thumbnail"
                                            type="text"
                                            aria-describedby="thumbnail-help"
                                        />
                                        <Button icon="pi pi-upload" class="p-button" @click="chooseThumbnail()" />
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="description" class="pb-2 font-semibold text-gray-800 text-sm">{{
                                        __('Description')
                                    }}</label>
                                    <TiptapEditor
                                        v-model="form.description"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: $page.props.rtl,
                                            height: '250px',
                                        }"
                                        :invalid="errors.description"
                                        :placeholder="__('Enter video description...')"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.description.$error && v$.form.description.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Body') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="skill_id" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Skill')
                                    }}</label>
                                    <v-select
                                        id="skill_id"
                                        v-model="v$.form.skill_id.$model"
                                        :options="skills"
                                        :reduce="skill => skill.id"
                                        label="name"
                                        :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                                        @search="handleSkillSearch"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.skill_id.$error && v$.form.skill_id.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Skill') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="topic_id" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Topic')
                                    }}</label>
                                    <v-select
                                        id="topic_id"
                                        v-model="v$.form.topic_id.$model"
                                        :options="topics"
                                        :reduce="topic => topic.id"
                                        label="name"
                                        :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                                        @search="handleTopicSearch"
                                    >
                                        <template #no-options="{ search, searching }">
                                            <span v-if="searching"
                                                >{{ __('No results were found for this search') }}.</span
                                            >
                                            <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                                        </template>
                                    </v-select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.topic_id.$error && v$.form.topic_id.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Topic') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="grid sm:grid-cols-2 sm:gap-4">
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Is Paid')
                                        }}</label>
                                        <div class="flex align-items-center">
                                            <ToggleSwitch v-model="form.is_paid" input-id="is_paid" />
                                            <label for="is_paid" class="ml-2">{{
                                                form.is_paid ? __('Yes') : __('No')
                                            }}</label>
                                        </div>
                                    </div>
                                    <div v-if="form.is_paid" class="w-full flex flex-col mb-6">
                                        <label for="price" class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Price')
                                        }}</label>
                                        <InputNumber
                                            id="price"
                                            v-model="v$.form.price.$model"
                                            mode="currency"
                                            :currency="$page.props.general.default_currency"
                                            :locale="$page.props.locale"
                                            :placeholder="__('Price')"
                                        />
                                        <div class="form-control-errors">
                                            <p
                                                v-if="v$.form.price.$error && v$.form.price.required.$invalid"
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Price') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                </div>
                                <div v-if="form.is_paid" class="grid sm:grid-cols-2 sm:gap-4">
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Can Redeem')
                                        }}</label>
                                        <div class="flex align-items-center">
                                            <ToggleSwitch v-model="form.can_redeem" input-id="can_redeem" />
                                            <label for="can_redeem" class="ml-2">{{
                                                form.can_redeem ? __('Yes') : __('No')
                                            }}</label>
                                        </div>
                                    </div>
                                    <div v-if="form.can_redeem" class="w-full flex flex-col mb-6">
                                        <label for="points_required" class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Points Required')
                                        }}</label>
                                        <InputNumber
                                            id="points_required"
                                            v-model="v$.form.points_required.$model"
                                            :placeholder="__('Points Required')"
                                        />
                                        <div class="form-control-errors">
                                            <p
                                                v-if="
                                                    v$.form.points_required.$error &&
                                                    v$.form.points_required.required.$invalid
                                                "
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Points Required') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                </div>
                                <div class="grid sm:grid-cols-3 sm:gap-4">
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Is Active')
                                        }}</label>
                                        <div class="flex align-items-center">
                                            <ToggleSwitch v-model="form.is_active" input-id="is_active" />
                                            <label for="is_active" class="ml-2">{{
                                                form.is_active ? __('Active') : __('Inactive')
                                            }}</label>
                                        </div>
                                    </div>
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Is Private')
                                        }}</label>
                                        <div class="flex align-items-center">
                                            <ToggleSwitch v-model="form.is_private" input-id="is_private" />
                                            <label for="is_private" class="ml-2">{{
                                                form.is_private ? __('Private') : __('Public')
                                            }}</label>
                                        </div>
                                    </div>
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Is Featured')
                                        }}</label>
                                        <div class="flex align-items-center">
                                            <ToggleSwitch v-model="form.is_featured" input-id="is_featured" />
                                            <label for="is_featured" class="ml-2">{{
                                                form.is_featured ? __('Featured') : __('Not Featured')
                                            }}</label>
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="flex items-center gap-2">
                                            <EnhancedSubmitButton
                                                :label="__('Update')"
                                                :submit-status="submitStatus"
                                                :processing="form.processing"
                                                :validation-error="v$.$invalid"
                                                type="submit"
                                            />
                                            <Button
                                                v-if="showErrorFeedback"
                                                severity="help"
                                                text
                                                icon="pi pi-info-circle"
                                                @click="showValidationHelp"
                                            />
                                        </div>
                                        <div v-if="submitStatus === 'ERROR'" class="text-sm text-red-600">
                                            {{ __('Please check the form for errors') }}
                                        </div>
                                    </div>
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
import { computed, ref, watch } from 'vue'
import { Head, router, useForm, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import { useFormValidation } from '@/composables/useFormValidation'
import { useCleanup, useSearchWithCleanup } from '@/composables/useCleanup'
import { useConfirmToast } from '@/composables/useConfirmToast'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import TiptapEditor from '@/Components/TiptapEditor'
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import VideoOptions from '@/Components/Videos/VideoOptions'
import EnhancedSubmitButton from '@/Components/Buttons/EnhancedSubmitButton.vue'
import axios from 'axios'

const props = defineProps({
    video: Object,
    initialSkills: Array,
    initialTopics: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { toast } = useConfirmToast()

// Enhanced composables
const { createAxiosRequest, createDebouncer } = useCleanup()
const { showErrorFeedback, showSuccessFeedback, handleSubmit, resetStatus } = useFormValidation()

// Submit status for enhanced button
const submitStatus = ref('IDLE')

// Form data
const form = useForm({
    title: props.video ? props.video.title : '',
    description: props.video ? props.video.description : '',
    thumbnail: props.video ? props.video.thumbnail : '',
    skill_id: props.video ? props.video.skill_id : '',
    topic_id: props.video ? props.video.topic_id : '',
    is_paid: props.video ? props.video.is_paid : false,
    price: props.video ? props.video.price : 0,
    can_redeem: props.video ? props.video.can_redeem : false,
    points_required: props.video ? props.video.points_required : null,
    is_active: props.video ? props.video.is_active : true,
    is_private: props.video ? props.video.is_private : false,
    is_featured: props.video ? props.video.is_featured : false,
    vimeo_id: props.video ? props.video.vimeo_id : '',
    youtube_id: props.video ? props.video.youtube_id : '',
    video_path: props.video ? props.video.video_path : '',
    video_type: props.video ? props.video.video_type : 'upload',
})

// Local state
const skills = ref(props.initialSkills)
const topics = ref(props.initialTopics)

// Video options data
const videoOptions = ref({
    video_type: form.video_type,
    vimeo_id: form.vimeo_id,
    youtube_id: form.youtube_id,
    video_path: form.video_path,
})

// Validation rules
const validationRules = computed(() => ({
    form: {
        title: { required },
        description: { required },
        skill_id: { required },
        topic_id: { required },
        ...(form.is_paid && {
            price: { required },
        }),
        ...(form.can_redeem && {
            points_required: { required },
        }),
    },
}))

const v$ = useVuelidate(validationRules, { form })

// Computed properties
const title = computed(() => {
    return __('Edit Video') + ' - ' + pageProps.general.app_name
})

const paid = computed(() => form.is_paid)

// Watchers
watch(paid, value => {
    if (value === false) {
        form.can_redeem = false
    }
})

// Enhanced search with cleanup
const { search: searchSkills } = useSearchWithCleanup(
    async (query, { signal }) => {
        const response = await axios.get(route('search_skills', { query }), { signal })
        return response.data.skills
    },
    {
        onError: error => {
            if (!axios.isCancel(error)) {
                console.error('Search skills error:', error)
                toast({
                    severity: 'error',
                    summary: __('Error'),
                    detail: __('Failed to search skills'),
                    life: 3000,
                })
            }
        },
        onLoading: loading => {
            // Update UI loading state if needed
        },
    }
)

const { search: searchTopics } = useSearchWithCleanup(
    async (query, { signal }) => {
        const response = await axios.get(route('search_topics', { query }), { signal })
        return response.data.topics
    },
    {
        onError: error => {
            if (!axios.isCancel(error)) {
                console.error('Search topics error:', error)
                toast({
                    severity: 'error',
                    summary: __('Error'),
                    detail: __('Failed to search topics'),
                    life: 3000,
                })
            }
        },
    }
)

// Enhanced form submission
const submitForm = async () => {
    // Trigger validation
    v$.$touch()

    if (v$.$invalid) {
        submitStatus.value = 'ERROR'
        toast({
            severity: 'error',
            summary: __('Validation Error'),
            detail: __('Please correct the form errors'),
            life: 3000,
        })
        setTimeout(() => (submitStatus.value = 'IDLE'), 3000)
        return
    }

    submitStatus.value = 'PENDING'

    try {
        await update()
        submitStatus.value = 'OK'
        toast({
            severity: 'success',
            summary: __('Success'),
            detail: __('Video updated successfully'),
            life: 3000,
        })
        setTimeout(() => (submitStatus.value = 'IDLE'), 2000)
    } catch (error) {
        submitStatus.value = 'ERROR'
        setTimeout(() => (submitStatus.value = 'IDLE'), 3000)

        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to update video. Please try again.'),
            life: 3000,
        })
    }
}

const update = () => {
    return form.patch(route('admin.videos.update', { video: props.video.id }), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                emit('close', true)
            }
        },
    })
}

const updateVideoOptions = options => {
    videoOptions.value = options
    form.video_type = options.video_type
    form.vimeo_id = options.vimeo_id
    form.youtube_id = options.youtube_id
    form.video_path = options.video_path
}

const chooseThumbnail = () => {
    if (typeof window !== 'undefined') {
        window.parent.tinymce.activeEditor.windowManager.openUrl({
            title: 'File Manager',
            url: route('unisharp.lfm.show') + '?type=Images&CKEditor=thumbnail',
            width: 900,
            height: 450,
        })
    }
}

// Enhanced search handlers with automatic cleanup
const handleSkillSearch = (search, loading) => {
    if (search && search.length >= 2) {
        loading(true)
        searchSkills(search)
            .then(results => {
                skills.value = results || []
                loading(false)
            })
            .catch(error => {
                loading(false)
            })
    } else {
        skills.value = []
    }
}

const handleTopicSearch = (search, loading) => {
    if (search && search.length >= 2) {
        loading(true)
        searchTopics(search)
            .then(results => {
                topics.value = results || []
                loading(false)
            })
            .catch(error => {
                loading(false)
            })
    } else {
        topics.value = []
    }
}

// Validation help function
const showValidationHelp = () => {
    const errors = []

    if (v$.value.form.title.$invalid) {
        errors.push(__('Title is required'))
    }
    if (v$.value.form.description.$invalid) {
        errors.push(__('Description is required'))
    }
    if (v$.value.form.skill_id.$invalid) {
        errors.push(__('Skill selection is required'))
    }
    if (v$.value.form.topic_id.$invalid) {
        errors.push(__('Topic selection is required'))
    }
    if (form.is_paid && v$.value.form.price.$invalid) {
        errors.push(__('Price is required for paid videos'))
    }
    if (form.can_redeem && v$.value.form.points_required.$invalid) {
        errors.push(__('Points required is needed for redeemable videos'))
    }

    if (errors.length > 0) {
        toast({
            severity: 'warn',
            summary: __('Validation Help'),
            detail: errors.join(', '),
            life: 8000,
        })
    }
}

// File manager callback for thumbnail
if (typeof window !== 'undefined') {
    window.SetUrl = function (url, file_path) {
        form.thumbnail = url
    }
}
</script>
