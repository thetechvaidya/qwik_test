<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Edit') }} {{ __('Lesson') }}</h4>
        </template>

        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="max-w-4xl w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="title" class="pb-2 font-semibold text-gray-800 text-sm"
                                        >{{ __('Lesson') }} {{ __('Title') }}</label
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
                                            v-if="v$.form.title.$error && !v$.form.title.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Title') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="body" class="pb-2 font-semibold text-gray-800 text-sm">{{
                                        __('Body')
                                    }}</label>
                                    <TiptapEditor
                                        v-model="form.body"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: $page.props.rtl,
                                            height: '300px',
                                        }"
                                        :invalid="errors.body"
                                        :placeholder="__('Enter lesson content...')"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.body.$error && !v$.form.body.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Body') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="skill_id" class="pb-2 text-sm font-semibold text-gray-800">{{ __('Skill') }}</label>
                                    <Select
                            id="skill_id"
                            v-model="v$.form.skill_id.$model"
                            :options="skills"
                            optionLabel="name"
                            optionValue="id"
                            :placeholder="__('Select a skill')"
                            filter
                            showClear
                            class="w-full"
                            @filter="searchSkills"
                        >
                            <template #empty>
                                <span>{{ __('Start typing to search') }}</span>
                            </template>
                        </Select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.skill_id.$error && !v$.form.skill_id.required"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Skill') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="topic_id" class="pb-2 text-sm font-semibold text-gray-800">{{ __('Topic') }}</label>
                                    <Select
                            id="topic_id"
                            v-model="v$.form.topic_id.$model"
                            :options="topics"
                            optionLabel="name"
                            optionValue="id"
                            :placeholder="__('Select a topic')"
                            filter
                            showClear
                            class="w-full"
                            @filter="searchTopics"
                        >
                            <template #empty>
                                <span>{{ __('Start typing to search') }}</span>
                            </template>
                        </Select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.topic_id.$error && !v$.form.topic_id.required"
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
                                                v-if="v$.form.price.$error && !v$.form.price.required"
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
                                                    v$.form.points_required.$error && !v$.form.points_required.required
                                                "
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Points Required') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                </div>
                                <div class="grid sm:grid-cols-2 sm:gap-4">
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
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="flex items-center gap-2">
                                            <Button
                                                type="submit"
                                                :loading="form.processing"
                                                class="qt-btn qt-btn-primary"
                                            >
                                                {{ __('Update') }}
                                            </Button>
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
import AdminLayout from '@/Layouts/AdminLayout.vue'
import TiptapEditor from '@/Components/TiptapEditor'
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import Select from 'primevue/select'
import axios from 'axios'

const props = defineProps({
    lesson: Object,
    initialSkills: Array,
    initialTopics: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    title: props.lesson ? props.lesson.title : '',
    body: props.lesson ? props.lesson.body : '',
    skill_id: props.lesson ? props.lesson.skill_id : '',
    topic_id: props.lesson ? props.lesson.topic_id : '',
    is_paid: props.lesson ? props.lesson.is_paid : false,
    price: props.lesson ? props.lesson.price : 0,
    can_redeem: props.lesson ? props.lesson.can_redeem : false,
    points_required: props.lesson ? props.lesson.points_required : null,
    is_active: props.lesson ? props.lesson.is_active : true,
    is_private: props.lesson ? props.lesson.is_private : false,
})

// Local state
const skills = ref(props.initialSkills)
const topics = ref(props.initialTopics)
const debounce = ref(null)
const searchAbortController = ref(null)
const submitStatus = ref(null)

// Validation rules
const validationRules = computed(() => ({
    form: {
        title: { required },
        body: { required },
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
    return __('Edit Lesson') + ' - ' + pageProps.general.app_name
})

const paid = computed(() => form.is_paid)

// Watchers
watch(paid, value => {
    if (value === false) {
        form.can_redeem = false
    }
})

// Methods
const submitForm = () => {
    v$.$touch()
    if (v$.$invalid) {
        submitStatus.value = 'ERROR'
    } else {
        submitStatus.value = 'PENDING'
        setTimeout(() => {
            submitStatus.value = 'OK'
            update()
        }, 100)
    }
}

const update = () => {
    form.patch(route('admin.lessons.update', { lesson: props.lesson.id }), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                emit('close', true)
            }
        },
    })
}

const searchSkills = (event) => {
    const search = event.value
    if (search !== '') {
        // Cancel previous request
        if (searchAbortController.value) {
            searchAbortController.value.abort()
        }

        searchAbortController.value = new AbortController()

        if (debounce.value) {
            clearTimeout(debounce.value)
        }

        skills.value = []

        debounce.value = setTimeout(() => {
            axios
                .get(route('search_skills', { query: search }), {
                    signal: searchAbortController.value.signal,
                })
                .then(response => {
                    skills.value = response.data.skills
                    searchAbortController.value = null
                })
                .catch(error => {
                    if (!axios.isCancel(error)) {
                        console.error('Search skills error:', error)
                    }
                    searchAbortController.value = null
                })
        }, 600)
    }
}

const searchTopics = (event) => {
    const search = event.value
    if (search !== '') {
        // Cancel previous request
        if (searchAbortController.value) {
            searchAbortController.value.abort()
        }

        searchAbortController.value = new AbortController()

        if (debounce.value) {
            clearTimeout(debounce.value)
        }

        topics.value = []

        debounce.value = setTimeout(() => {
            axios
                .get(route('search_topics', { query: search }), {
                    signal: searchAbortController.value.signal,
                })
                .then(response => {
                    topics.value = response.data.topics
                    searchAbortController.value = null
                })
                .catch(error => {
                    if (!axios.isCancel(error)) {
                        console.error('Search topics error:', error)
                    }
                    searchAbortController.value = null
                })
        }, 600)
    }
}
</script>
