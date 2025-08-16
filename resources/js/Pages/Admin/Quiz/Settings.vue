<template>
    <Head :title="title" />
    <AdminLayout>
        <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
            <div
                class="w-full bg-white dark:bg-gray-800 py-5 flex flex-col xl:flex-row items-start xl:items-center justify-between px-5 xl:px-10 shadow rounded-t"
            >
                <div class="mb-4 sm:mb-0 md:mb-0 lg:mb-0 xl:mb-0 lg:w-1/2">
                    <h2 class="text-gray-800 dark:text-gray-100 text-lg font-bold"
                        >{{ __('Quiz') }} {{ __('Settings') }}</h2
                    >
                    <p
                        class="font-normal text-sm text-gray-600 dark:text-gray-100 mt-1"
                        v-html="editFlag ? quiz.title : __('New') + ' ' + __('Quiz')"
                    ></p>
                </div>
                <horizontal-stepper :steps="steps" :edit-flag="editFlag"></horizontal-stepper>
            </div>
        </div>
        <div class="container mx-auto py-8 px-4 sm:px-6 lg:px-8">
            <div class="card">
                <div class="card-body">
                    <div class="flex justify-center flex-wrap">
                        <div class="w-full py-6 md:pb-0 md:px-6">
                            <form @submit.prevent="submitForm">
                                <div class="flex flex-wrap">
                                    <div class="md:w-6/12 w-full py-8 md:pb-0 md:px-8 border-r border-gray-200">
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="auto_duration"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Duration Mode') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Auto</span> -
                                                                Duration will be calculated based on questions' default
                                                                time
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Manual</span>
                                                                - Duration will be considered as specified
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="auto_duration"
                                                v-model="form.auto_duration"
                                                :options="autoModes"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div v-if="!form.auto_duration" class="w-full flex flex-col mb-6">
                                            <label for="total_duration" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Duration') }} ({{ __('Minutes') }})<span
                                                    class="ml-1 text-red-400"
                                                    >*</span
                                                ></label
                                            >
                                            <InputNumber
                                                id="total_duration"
                                                v-model="$v.form.total_duration.$model"
                                                placeholder="Enter Duration (in Minutes)"
                                                aria-describedby="total_duration-help"
                                                :disabled="form.enable_section_timer"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="
                                                        $v.form.total_duration.$error &&
                                                        !$v.form.total_duration.required
                                                    "
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                >
                                                    {{ __('Duration') }} {{ __('is required') }}
                                                </p>
                                            </div>
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="auto_grading"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Marks/Points Mode') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Auto</span> -
                                                                Marks/Points will be calculated based on questions'
                                                                default marks
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Manual</span>
                                                                - Marks/Points will be assigned to each question as
                                                                specified
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="auto_grading"
                                                v-model="form.auto_grading"
                                                :options="autoModes"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div v-if="!form.auto_grading" class="w-full flex flex-col mb-6">
                                            <label for="correct_marks" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Marks for Correct Answer')
                                                }}<span class="ml-1 text-red-400">*</span></label
                                            >
                                            <InputNumber
                                                id="correct_marks"
                                                v-model="$v.form.correct_marks.$model"
                                                placeholder="Enter Marks"
                                                mode="decimal"
                                                :min-fraction-digits="2"
                                                :max-fracion-digits="2"
                                                aria-describedby="correct_marks-help"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="
                                                        $v.form.correct_marks.$error && !$v.form.correct_marks.required
                                                    "
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                    >{{ __('Marks for Correct Answer') }} {{ __('is required') }}</p
                                                >
                                            </div>
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="enable_negative_marking"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Negative Marking') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Negative marking will be considered as specified
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                No Negative marking
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="enable_negative_marking"
                                                v-model="form.enable_negative_marking"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div
                                            v-if="form.enable_negative_marking"
                                            class="w-full flex justify-between items-center mb-6"
                                        >
                                            <div class="flex gap-2">
                                                <label
                                                    for="negative_marking_type"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Negative Marking Type') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Fixed</span>
                                                                - Fixed amount will be deduct from question marks
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold"
                                                                    >Percentage</span
                                                                >
                                                                - Percentage will be deduct from question marks
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="negative_marking_type"
                                                v-model="form.negative_marking_type"
                                                :options="amountTypes"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div v-if="form.enable_negative_marking" class="w-full flex flex-col mb-6">
                                            <label for="negative_marks" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Negative Marks')
                                                }}<span class="ml-1 text-red-400">*</span></label
                                            >
                                            <InputNumber
                                                id="negative_marks"
                                                v-model="$v.form.negative_marks.$model"
                                                aria-describedby="negative_marks-help"
                                                :placeholder="
                                                    form.negative_marking_type === 'percentage'
                                                        ? 'Enter Percentage'
                                                        : 'Enter Number'
                                                "
                                                :suffix="form.negative_marking_type === 'percentage' ? ' %' : ''"
                                                :max="100"
                                                mode="decimal"
                                                :min-fraction-digits="form.negative_marking_type === 'fixed' ? 2 : null"
                                                :max-fracion-digits="form.negative_marking_type === 'fixed' ? 2 : null"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="
                                                        $v.form.negative_marks.$error &&
                                                        !$v.form.negative_marks.required
                                                    "
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                >
                                                    {{ __('Negative Marks') }} {{ __('are required') }}
                                                </p>
                                            </div>
                                        </div>
                                        <div class="w-full flex flex-col mb-6">
                                            <label for="cutoff" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Pass Percentage')
                                                }}<span class="ml-1 text-red-400">*</span></label
                                            >
                                            <InputNumber
                                                id="cutoff"
                                                v-model="$v.form.cutoff.$model"
                                                placeholder="Enter Percentage"
                                                aria-describedby="cutoff-help"
                                                suffix=" %"
                                                :max="100"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="$v.form.cutoff.$error && !$v.form.cutoff.required"
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                >
                                                    {{ __('Pass Percentage') }} {{ __('is required') }}
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="md:w-6/12 w-full py-8 md:pb-0 md:px-8">
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="restrict_attempts"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Shuffle Questions') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Questions will be shuffled for each attempt
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                Questions will not be shuffled
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="shuffle_questions"
                                                v-model="form.shuffle_questions"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="restrict_attempts"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Restrict Attempts') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Attempts will be restricted as specified
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                Unlimited attempts
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="restrict_attempts"
                                                v-model="form.restrict_attempts"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div v-if="form.restrict_attempts" class="w-full flex flex-col mb-6">
                                            <label for="no_of_attempts" class="pb-2 text-sm font-semibold text-gray-800"
                                                >{{ __('Number of Attempts')
                                                }}<span class="ml-1 text-red-400">*</span></label
                                            >
                                            <InputNumber
                                                id="no_of_attempts"
                                                v-model="$v.form.no_of_attempts.$model"
                                                placeholder="Enter Number"
                                                aria-describedby="no_of_attempts-help"
                                            />
                                            <div class="form-control-errors">
                                                <p
                                                    v-if="
                                                        $v.form.no_of_attempts.$error &&
                                                        !$v.form.no_of_attempts.required
                                                    "
                                                    role="alert"
                                                    class="text-xs text-red-500 pt-2"
                                                >
                                                    {{ __('Number of Attempts') }} {{ __('is required') }}
                                                </p>
                                            </div>
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="disable_finish_button"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Disable Finish Button') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Test Finish button will be disabled
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                Test Finish button will be displayed
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="disable_finish_button"
                                                v-model="form.disable_finish_button"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="list_questions"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Enable Question List View') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                User can be able to see all questions as list
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                User cannot be able to see all questions as list
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="list_questions"
                                                v-model="form.list_questions"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="hide_solutions"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Hide Solutions') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Solutions will not be shown in results
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                Solutions will be shown in results
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="hide_solutions"
                                                v-model="form.hide_solutions"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                        <div class="w-full flex justify-between items-center mb-6">
                                            <div class="flex gap-2">
                                                <label
                                                    for="show_leaderboard"
                                                    class="font-semibold text-sm text-gray-800 pb-1"
                                                    >{{ __('Show Leaderboard') }}</label
                                                >
                                                <pop-info>
                                                    <template #message>
                                                        <ul>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">Yes</span> -
                                                                Leaderboard will be shown to test takers
                                                            </li>
                                                            <li class="text-sm text-gray-500">
                                                                <span class="text-green-400 font-semibold">No</span> -
                                                                Leaderboard will not be shown to test takers
                                                            </li>
                                                        </ul>
                                                    </template>
                                                </pop-info>
                                            </div>
                                            <SelectButton
                                                id="show_leaderboard"
                                                v-model="form.show_leaderboard"
                                                :options="choices"
                                                data-key="code"
                                                option-value="code"
                                                option-label="name"
                                            />
                                        </div>
                                    </div>
                                </div>
                                <div class="w-full flex justify-end my-8">
                                    <button
                                        type="submit"
                                        class="qt-btn qt-btn-success"
                                        v-html="editFlag ? __('Update') : __('Save')"
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
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router, useForm } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useVuelidate } from '@vuelidate/core'
import { required } from '@vuelidate/validators'
import HorizontalStepper from '@/Components/Stepper/HorizontalStepper.vue'
import PopInfo from '@/Components/PopInfo.vue'
import SelectButton from 'primevue/selectbutton'
import InputNumber from 'primevue/inputnumber'

// Props
const props = defineProps({
    quiz: Object,
    steps: Array,
    editFlag: { type: Boolean, default: false },
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Form data
const form = useForm({
    auto_duration: props.editFlag ? props.quiz.auto_duration : true,
    total_duration: props.editFlag ? props.quiz.total_duration : null,
    auto_grading: props.editFlag ? props.quiz.auto_grading : true,
    correct_marks: props.editFlag ? props.quiz.correct_marks : null,
    enable_negative_marking: props.editFlag ? props.quiz.enable_negative_marking : false,
    negative_marking_type: props.editFlag ? props.quiz.negative_marking_type : 'fixed',
    negative_marks: props.editFlag ? props.quiz.negative_marks : null,
    cutoff: props.editFlag ? props.quiz.cutoff : null,
    shuffle_questions: props.editFlag ? props.quiz.shuffle_questions : false,
    restrict_attempts: props.editFlag ? props.quiz.restrict_attempts : false,
    no_of_attempts: props.editFlag ? props.quiz.no_of_attempts : null,
    disable_finish_button: props.editFlag ? props.quiz.disable_finish_button : false,
    list_questions: props.editFlag ? props.quiz.list_questions : true,
    hide_solutions: props.editFlag ? props.quiz.hide_solutions : false,
    show_leaderboard: props.editFlag ? props.quiz.show_leaderboard : true,
    enable_section_timer: props.editFlag ? props.quiz.enable_section_timer : false,
})

// Local state
const editFlag = ref(props.editFlag)

// Options
const autoModes = ref([
    { name: __('Auto'), code: true },
    { name: __('Manual'), code: false },
])

const choices = ref([
    { name: __('Yes'), code: true },
    { name: __('No'), code: false },
])

const amountTypes = ref([
    { name: __('Fixed'), code: 'fixed' },
    { name: __('Percentage'), code: 'percentage' },
])

// Validation rules
const validationRules = computed(() => ({
    form: {
        total_duration: form.auto_duration ? {} : { required },
        correct_marks: form.auto_grading ? {} : { required },
        negative_marks: form.enable_negative_marking ? { required } : {},
        cutoff: { required },
        no_of_attempts: form.restrict_attempts ? { required } : {},
    },
}))

const $v = useVuelidate(validationRules, { form })

// Computed
const title = computed(() => {
    return __('Quiz/ Settings') + ' - ' + pageProps.general.app_name
})

// Methods
const submitForm = () => {
    $v.value.$touch()
    if (!$v.value.$invalid) {
        if (editFlag.value) {
            form.patch(route('admin.quizzes.update', props.quiz.id))
        } else {
            form.post(route('admin.quizzes.store'))
        }
    }
}

// Initialize
onMounted(() => {
    // Any initialization logic
})
</script>
