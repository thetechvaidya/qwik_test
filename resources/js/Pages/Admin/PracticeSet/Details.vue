<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Practice Set') }} {{ __('Details') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? practiceSet.title : __('New') + ' ' + __('Practice Set')"
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
                            <form class="my-6 w-11/12 mx-auto xl:w-full xl:mx-0" @submit.prevent="submitForm">
                                <div class="w-full flex flex-col mb-6">
                                    <label for="title" class="pb-2 text-sm font-semibold text-gray-800">{{
                                        __('Title')
                                    }}</label>
                                    <InputText
                                        id="title"
                                        v-model="v$.form.title.$model"
                                        type="title"
                                        :placeholder="__('Title')"
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
                                <div class="w-full flex flex-col mb-6">
                                    <label class="pb-2 text-sm font-semibold text-gray-800"
                                        >{{ __('Sub Category') }}<span class="ml-1 text-red-400">*</span></label
                                    >
                                    <Select
                                        id="sub_category"
                                        v-model="v$.form.sub_category_id.$model"
                                        :options="subCategories"
                                        optionLabel="name"
                                        optionValue="id"
                                        :placeholder="__('Select Sub Category')"
                                        filter
                                        showClear
                                        class="w-full"
                                        @filter="searchSubCategories"
                                    >
                                        <template #empty>
                                            {{ __('No options available') }}
                                        </template>
                                    </Select>
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
                                    <label for="skill" class="pb-2 text-sm font-semibold text-gray-800">{{ __('Skill') }}</label>
                                    <Select
                                        id="skill"
                                        v-model="v$.form.skill_id.$model"
                                        :options="skills"
                                        optionLabel="name"
                                        optionValue="id"
                                        :placeholder="__('Select Skill')"
                                        filter
                                        showClear
                                        :disabled="editFlag"
                                        class="w-full"
                                        @filter="searchSkills"
                                    >
                                        <template #empty>
                                            {{ __('No options available') }}
                                        </template>
                                    </Select>
                                    <div class="form-control-errors">
                                        <p
                                            v-if="v$.form.skill_id.$error && v$.form.skill_id.required.$invalid"
                                            role="alert"
                                            class="text-xs text-red-500 pt-2"
                                            >{{ __('Skill') }} {{ __('is required') }}</p
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
                                        <ExamNavigation :edit-flag="editFlag" :practice-set-id="practiceSetId" />
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
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import Select from 'primevue/select'
import ExamNavigation from '@/Components/Exams/ExamNavigation.vue' // Renamed for clarity - intentionally shared component
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper'
import axios from 'axios'

const props = defineProps({
    practiceSet: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    practiceSetId: Number,
    initialSubCategories: Array,
    initialSkills: Array,
    errors: Object,
})

const emit = defineEmits(['close'])

const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    title: props.editFlag ? props.practiceSet.title : '',
    sub_category_id: props.editFlag ? props.practiceSet.sub_category_id : '',
    skill_id: props.editFlag ? props.practiceSet.skill_id : '',
    is_paid: props.editFlag ? props.practiceSet.is_paid : false,
    price: props.editFlag ? props.practiceSet.price : 0,
    can_redeem: props.editFlag ? props.practiceSet.can_redeem : false,
    points_required: props.editFlag ? props.practiceSet.points_required : null,
    is_active: props.editFlag ? props.practiceSet.is_active : false,
    is_private: props.editFlag ? props.practiceSet.is_private : false,
})

// Local state
const subCategories = ref(props.initialSubCategories)
const skills = ref(props.initialSkills)
const debounce = ref(null)
const searchAbortController = ref(null)
const submitStatus = ref(null)

// Validation rules
const validationRules = computed(() => ({
    form: {
        title: { required },
        sub_category_id: { required },
        skill_id: { required },
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
    let str = props.editFlag ? props.practiceSet.title + ' ' + __('Details') : __('Create Practice Set')
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
    form.post(route('practice-sets.store'), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                window.$toast?.add({
                    severity: 'success',
                    summary: __('Success'),
                    detail: __('Practice Set created successfully'),
                    life: 3000,
                })
                router.get(route('practice-sets.index'))
            }
        },
    })
}

const update = () => {
    form.patch(route('practice-sets.update', { id: props.practiceSetId }), {
        onSuccess: () => {
            if (Object.keys(props.errors).length === 0) {
                window.$toast?.add({
                    severity: 'success',
                    summary: __('Success'),
                    detail: __('Practice Set updated successfully'),
                    life: 3000,
                })
                router.get(route('practice-sets.index'))
            }
        },
    })
}

const searchSubCategories = (event) => {
    const search = event.value
    if (search && search.length) {
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
                    searchAbortController.value = null
                })
                .catch(error => {
                    if (!axios.isCancel(error)) {
                        console.error('Search subcategories error:', error)
                    }
                    searchAbortController.value = null
                })
        }, 600)
    }
}

const searchSkills = (event) => {
    const search = event.value
    if (search && search !== '') {
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
</script>
