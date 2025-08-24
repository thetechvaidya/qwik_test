<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Quiz') }} {{ __('Details') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? quiz.title : __('New') + ' ' + __('Quiz')"
                    ></p>
                </div>
                <HorizontalStepper :steps="steps" :edit-flag="editFlag"></HorizontalStepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="md:w-8/12 w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="title" class="pb-2 text-sm font-semibold text-gray-800"
                                        >{{ __('Title') }}<span class="ltr:ml-1 rtl:mr-1 text-red-400">*</span></label
                                    >
                                    <InputText
                                        id="title"
                                        v-model="v$.form.title.$model"
                                        type="text"
                                        :placeholder="__('Title')"
                                        aria-describedby="title-help"
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
                                <div class="grid sm:grid-cols-2 sm:gap-4">
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800"
                                            >{{ __('Sub Category')
                                            }}<span class="ltr:ml-1 rtl:mr-1 text-red-400">*</span></label
                                        >
                                        <Select
                            id="sub_category_id"
                            v-model="form.sub_category_id"
                            :options="subCategories"
                            optionValue="id"
                            optionLabel="name"
                            :placeholder="__('Select Sub Category')"
                            filter
                            showClear
                            class="w-full"
                            @filter="searchSubCategories"
                        />
                                        <div class="form-control-errors">
                                            <p
                                                v-if="
                                                    v$.form.sub_category_id.$error &&
                                                    v$.form.sub_category_id.required.$invalid
                                                "
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Sub Category') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                    <div class="w-full flex flex-col mb-6">
                                        <label class="pb-2 text-sm font-semibold text-gray-800">{{
                                            __('Quiz Type')
                                        }}</label>
                                        <Select
                            id="quiz_type_id"
                            v-model="form.quiz_type_id"
                            :options="quizTypes"
                            optionValue="id"
                            optionLabel="name"
                            :placeholder="__('Select Quiz Type')"
                            showClear
                            class="w-full"
                        />
                                        <div class="form-control-errors">
                                            <p
                                                v-if="
                                                    v$.form.quiz_type_id.$error &&
                                                    v$.form.quiz_type_id.required.$invalid
                                                "
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Quiz Type') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <QuizNavigation :edit-flag="editFlag" :quiz-id="quizId" />
                                        <div class="flex items-center gap-2">
                                            <Button
                                                type="submit"
                                                :loading="form.processing"
                                                class="qt-btn qt-btn-primary"
                                            >
                                                {{ editFlag ? __('Update') : __('Create') }}
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
import RadioButton from 'primevue/radiobutton'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import Select from 'primevue/select'
import QuizNavigation from '@/Components/Quizzes/QuizNavigation'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper'
import axios from 'axios'

const props = defineProps({
    quiz: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    quizId: Number,
    initialSubCategories: Array,
    quizTypes: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    title: props.editFlag ? props.quiz.title : '',
    description: props.editFlag ? props.quiz.description : '',
    sub_category_id: props.editFlag ? props.quiz.sub_category_id : '',
    quiz_type_id: props.editFlag ? props.quiz.quiz_type_id : '',
    is_paid: props.editFlag ? props.quiz.is_paid : false,
    price: props.editFlag ? props.quiz.price : 0,
    can_redeem: props.editFlag ? props.quiz.can_redeem : false,
    points_required: props.editFlag ? props.quiz.points_required : null,
    is_active: props.editFlag ? props.quiz.is_active : false,
    is_private: props.editFlag ? props.quiz.is_private : false,
})

// Local state
const subCategories = ref(props.initialSubCategories)
const debounce = ref(null)
const searchAbortController = ref(null)
const submitStatus = ref(null)

// Validation rules
const validationRules = computed(() => ({
    form: {
        title: { required },
        sub_category_id: { required },
        quiz_type_id: { required },
        price: {},
        is_paid: {},
        can_redeem: {},
        ...(form.can_redeem && {
            points_required: { required },
        }),
    },
}))

const v$ = useVuelidate(validationRules, { form })

// Computed properties
const title = computed(() => {
    let str = props.editFlag ? props.quiz.title + ' ' + __('Details') : __('Create Quiz')
    return str + ' - ' + pageProps.general.app_name
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
            props.editFlag ? update() : create()
        }, 100)
    }
}

const create = () => {
    form.post(route('quizzes.store'), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                window.$toast?.add({
                    severity: 'success',
                    summary: __('Success'),
                    detail: __('Quiz created successfully'),
                    life: 3000,
                })
                router.get(route('quizzes.index'))
            }
        },
    })
}

const update = () => {
    form.patch(route('quizzes.update', { quiz: props.quizId }), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                window.$toast?.add({
                    severity: 'success',
                    summary: __('Success'),
                    detail: __('Quiz updated successfully'),
                    life: 3000,
                })
                router.get(route('quizzes.index'))
            }
        },
    })
}

const searchSubCategories = (search, loading) => {
    if (search.length) {
        loading(true)
        // Cancel previous request
        if (searchAbortController.value) {
            searchAbortController.value.abort()
        }

        searchAbortController.value = new AbortController()

        if (debounce.value) {
            clearTimeout(debounce.value)
        }

        debounce.value = setTimeout(() => {
            axios
                .get(route('sub-categories.search'), {
                    params: { search: search },
                    signal: searchAbortController.value.signal,
                })
                .then(response => {
                    subCategories.value = response.data.subCategories
                    loading(false)
                    searchAbortController.value = null
                })
                .catch(error => {
                    if (!axios.isCancel(error)) {
                        console.error('Search subcategories error:', error)
                    }
                    loading(false)
                    searchAbortController.value = null
                })
        }, 600)
    }
}
</script>
