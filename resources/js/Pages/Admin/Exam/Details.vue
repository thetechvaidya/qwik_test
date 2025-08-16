<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-8 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Exam') }} {{ __('Details') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? exam.title : __('New') + ' ' + __('Exam')"
                    ></p>
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
                                        <v-select
                                            id="sub_category_id"
                                            v-model="v$.form.sub_category_id.$model"
                                            :options="subCategories"
                                            :reduce="sub => sub.id"
                                            label="name"
                                            :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                                            @search="searchSubCategories"
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
                                            __('Exam Type')
                                        }}</label>
                                        <v-select
                                            id="exam_type_id"
                                            v-model="v$.form.exam_type_id.$model"
                                            :options="examTypes"
                                            :reduce="pattern => pattern.id"
                                            label="name"
                                            :dir="$page.props.rtl ? 'rtl' : 'ltr'"
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
                                                v-if="
                                                    v$.form.exam_type_id.$error &&
                                                    v$.form.exam_type_id.required.$invalid
                                                "
                                                role="alert"
                                                class="text-xs text-red-500 pt-2"
                                                >{{ __('Exam Type') }} {{ __('is required') }}</p
                                            >
                                        </div>
                                    </div>
                                </div>
                                <!--<div class="w-full flex flex-col mb-6">
                                    <label class="pb-2 text-sm font-semibold text-gray-800">{{ __('Exam Mode') }}<span class="ml-1 text-red-400">*</span></label>
                                    <div class="flex flex-col sm:flex-row gap-4">
                                        <div class="p-field-radiobutton" v-for="examMode in examModes">
                                            <RadioButton :id="'exam_mode'+examMode.code" name="exam_mode" :value="examMode.code"
                                                         v-model="form.exam_mode" :disabled="editFlag" />
                                            <label class="text-sm text-gray-800" :for="'exam_type'+examMode.code">{{ examMode.name }}</label>
                                        </div>
                                    </div>
                                    <div class="form-control-errors">
                                        <p v-if="$v.form.exam_mode.$error && !$v.form.exam_mode.required"
                                           role="alert" class="text-xs text-red-500 pt-2">{{ __('Exam Mode') }} {{ __('is required') }}</p>
                                    </div>
                                </div>-->
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="w-9/12">
                                            <label
                                                for="is_paid"
                                                class="font-semibold text-sm text-gray-800 pb-1"
                                                v-html="form.is_paid ? __('Paid') : __('Free')"
                                            ></label>
                                            <p class="text-gray-500 text-sm"
                                                >{{ __('Paid') }} ({{ __('Accessible to only paid users') }}).
                                                {{ __('Free') }} ({{ __('Anyone can access') }}).</p
                                            >
                                        </div>
                                        <div class="cursor-pointer rounded-full relative shadow-sm">
                                            <ToggleSwitch id="is_paid" v-model="form.is_paid" />
                                        </div>
                                    </div>
                                </div>
                                <!--<div v-if="form.is_paid" class="w-full flex flex-col mb-6">
                                    <label for="price" class="pb-2 font-semibold text-gray-800">{{ __('Price') }}<span
                                        class="ml-1 text-red-400">*</span></label>
                                    <InputNumber id="price" v-model="$v.form.price.$model"
                                               placeholder="Enter Price" aria-describedby="price-help"/>
                                    <div class="form-control-errors">
                                        <p v-if="$v.form.price.$error && !$v.form.price.required" role="alert"
                                           class="text-xs text-red-500 pt-2">{{ __('Price') }} {{ __('is required') }}</p>
                                    </div>
                                </div>-->
                                <div v-if="form.is_paid" class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="w-9/12">
                                            <label for="can_redeem" class="font-semibold text-sm text-gray-800 pb-1"
                                                >{{ __('Can access with Points') }} ({{
                                                    form.can_redeem ? 'Yes' : 'No'
                                                }})</label
                                            >
                                            <p class="text-gray-500 text-sm"
                                                >Yes ({{ __('User should redeem with points to access exam') }}). No ({{
                                                    __('Anyone can access')
                                                }}).</p
                                            >
                                        </div>
                                        <div class="cursor-pointer rounded-full relative shadow-sm">
                                            <ToggleSwitch id="can_redeem" v-model="form.can_redeem" />
                                        </div>
                                    </div>
                                </div>
                                <div v-if="form.is_paid && form.can_redeem" class="w-full flex flex-col mb-6">
                                    <label for="points_required" class="pb-2 text-sm font-semibold text-gray-800"
                                        >{{ __('Points Required to Redeem')
                                        }}<span class="ml-1 text-red-400">*</span></label
                                    >
                                    <InputNumber
                                        id="points_required"
                                        v-model="v$.form.points_required.$model"
                                        placeholder="Enter Points Required"
                                        aria-describedby="points_required-help"
                                    />
                                    <div class="form-control-errors">
                                        <p
                                            v-if="
                                                v$.form.points_required.$error &&
                                                v$.form.points_required.required.$invalid
                                            "
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Points') }} {{ __('is required') }}</p
                                        >
                                    </div>
                                </div>
                                <div class="w-full flex flex-col mb-6">
                                    <label for="description" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Description')
                                    }}</label>
                                    <TiptapEditor
                                        v-model="form.description"
                                        :config="{
                                            toolbar: 'advanced',
                                            rtl: $page.props.rtl,
                                            height: '200px',
                                        }"
                                        :placeholder="__('Enter exam description...')"
                                    />
                                </div>
                                <div class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="w-9/12">
                                            <label
                                                for="is_private"
                                                class="font-semibold text-sm text-gray-800 pb-1"
                                                v-html="
                                                    form.is_private
                                                        ? __('Visibility') + ' - ' + __('Private')
                                                        : __('Visibility') + ' - ' + __('Public')
                                                "
                                            ></label>
                                            <p class="text-gray-500 text-sm"
                                                >{{ __('Private') }} ({{
                                                    __('Only scheduled user groups can access')
                                                }}). {{ __('Public') }} ({{ __('Anyone can access') }}).</p
                                            >
                                        </div>
                                        <div class="cursor-pointer rounded-full relative shadow-sm">
                                            <ToggleSwitch id="is_private" v-model="form.is_private" />
                                        </div>
                                    </div>
                                </div>
                                <div v-if="editFlag" class="w-full">
                                    <div class="flex justify-between items-center mb-8">
                                        <div class="w-9/12">
                                            <label
                                                for="is_active"
                                                class="font-semibold text-gray-800 text-sm pb-1"
                                                v-html="
                                                    form.is_active
                                                        ? __('Status') + ' - ' + __('Published')
                                                        : __('Status') + ' - ' + __('Draft')
                                                "
                                            ></label>
                                            <p class="text-sm text-gray-500"
                                                >{{ __('Published') }} ({{ __('Shown Everywhere') }}).
                                                {{ __('Draft') }} ({{ __('Not Shown') }}).</p
                                            >
                                        </div>
                                        <div class="cursor-pointer rounded-full relative shadow-sm">
                                            <ToggleSwitch id="is_active" v-model="form.is_active" />
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full flex justify-end my-8">
                                    <button
                                        type="submit"
                                        class="qt-btn qt-btn-success"
                                        v-html="editFlag ? __('Update Details') : __('Save & Proceed')"
                                    ></button>
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
import { ref, reactive, computed, watch } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import { useTranslate } from '@/composables/useTranslate'
import { useConfirmToast } from '@/composables/useConfirmToast'
import axios from 'axios'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import InputText from 'primevue/inputtext'
import vSelect from 'vue-select'
import TiptapEditor from '@/Components/TiptapEditor'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper'
import ToggleSwitch from 'primevue/toggleswitch'
import InputNumber from 'primevue/inputnumber'

const props = defineProps({
    exam: Object,
    editFlag: { type: Boolean, default: false },
    steps: Array,
    examId: Number,
    examTypes: Array,
    initialSubCategories: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { toast } = useConfirmToast()
const { props: pageProps } = usePage()

// Form initialization
const form = reactive({
    title: props.editFlag ? props.exam.title : '',
    description: props.editFlag ? props.exam.description : '',
    sub_category_id: props.editFlag ? props.exam.sub_category_id : '',
    exam_mode: props.editFlag ? props.exam.exam_mode : 'objective',
    exam_type_id: props.editFlag ? props.exam.exam_type_id : '',
    is_paid: props.editFlag ? !!Number(props.exam.is_paid) : false,
    price: props.editFlag ? props.exam.price : 0,
    can_redeem: props.editFlag ? !!Number(props.exam.can_redeem) : false,
    points_required: props.editFlag ? props.exam.points_required : null,
    exam_template_id: props.editFlag ? props.exam.exam_template_id : null,
    is_active: props.editFlag ? !!Number(props.exam.is_active) : false,
    is_private: props.editFlag ? !!Number(props.exam.is_private) : false,
})

const subCategories = ref(props.initialSubCategories)
const debounce = ref(null)
const searchAbortController = ref(null)
const submitStatus = ref(null)

// Exam modes options
const examModes = [
    { name: __('Objective'), code: 'objective' },
    { name: __('Subjective'), code: 'subjective' },
    { name: __('Mixed (Objective & Subjective)'), code: 'mixed' },
]

// Computed properties
const paid = computed(() => form.is_paid)
const title = computed(() => {
    let str = props.editFlag ? props.exam.title + ' ' + __('Details') : __('Create Exam')
    return str + ' - ' + pageProps.general.app_name
})

// Validation rules
const rules = computed(() => ({
    form: {
        title: { required },
        sub_category_id: { required },
        exam_type_id: { required },
        exam_mode: {},
        price: {},
        is_paid: {},
        can_redeem: {},
        ...(form.can_redeem && {
            points_required: { required },
        }),
    },
}))

const v$ = useVuelidate(rules, { form })

// Watch for paid changes
watch(paid, value => {
    if (value === false) {
        form.can_redeem = false
    }
})

// Methods
const submitForm = () => {
    v$.value.$touch()
    if (v$.value.$invalid) {
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
    router.post(route('exams.store'), form, {
        onSuccess: () => {
            toast({ severity: 'success', summary: __('Success'), detail: __('Exam created successfully') })
            router.get(route('exams.index'))
        },
        onError: () => {
            toast({ severity: 'error', summary: __('Error'), detail: __('Failed to create exam') })
        },
    })
}

const update = () => {
    router.patch(route('exams.update', { exam: props.examId }), form, {
        onSuccess: () => {
            toast({ severity: 'success', summary: __('Success'), detail: __('Exam updated successfully') })
            router.get(route('exams.index'))
        },
        onError: () => {
            toast({ severity: 'error', summary: __('Error'), detail: __('Failed to update exam') })
        },
    })
}

const searchSubCategories = (search, loading) => {
    if (search !== '') {
        loading(true)

        // Clear previous timeout
        clearTimeout(debounce.value)

        // Abort previous request if it exists
        if (searchAbortController.value) {
            searchAbortController.value.abort()
        }

        subCategories.value = []

        debounce.value = setTimeout(() => {
            // Create new AbortController for this request
            searchAbortController.value = new AbortController()

            axios
                .get(route('sub-categories.search'), {
                    params: { search },
                    signal: searchAbortController.value.signal,
                })
                .then(function (response) {
                    subCategories.value = response.data.subCategories
                    loading(false)
                    searchAbortController.value = null
                })
                .catch(function (error) {
                    // Only handle error if request wasn't aborted
                    const aborted =
                        (typeof axios !== 'undefined' && axios.isCancel && axios.isCancel(error)) ||
                        error?.name === 'CanceledError' ||
                        error?.code === 'ERR_CANCELED'
                    if (!aborted) {
                        console.error('Search subcategories error:', error)
                    }
                    loading(false)
                    searchAbortController.value = null
                })
        }, 600)
    }
}
</script>
