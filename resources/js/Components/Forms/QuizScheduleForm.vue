<template>
    <div class="overflow-y-auto h-screen px-2">
        <div class="bg-gray-100 py-4 lg:py-4 rounded">
            <div class="container px-6 mx-auto flex ltr:flex-row rtl:flex-row-reverse">
                <div>
                    <h4 class="text-base font-semibold leading-tight text-gray-800">
                        {{ title }}
                    </h4>
                </div>
            </div>
        </div>
        <div v-if="loading" class="my-6 w-11/12 mx-auto xl:w-full xl:mx-0">
            <form-input-shimmer></form-input-shimmer>
            <form-input-shimmer></form-input-shimmer>
            <form-input-shimmer></form-input-shimmer>
            <form-switch-shimmer></form-switch-shimmer>
        </div>
        <form v-else class="my-6 w-11/12 mx-auto xl:w-full xl:mx-0" @submit.prevent="submitForm">
            <div class="col-sm-12 col-lg-6 my-auto">
                <label for="schedule_type"> {{ __('Schedule Type') }} <span class="text-red-600">*</span> </label>
                <div class="flex align-items-center justify-content-around w-full h-10 p-1 mt-1">
                    <div v-for="(scheduleType, index) in scheduleTypes" :key="index" class="flex align-items-center">
                        <RadioButton
                            :id="'schedule-type-' + index"
                            v-model="form.schedule_type"
                            :value="scheduleType.code"
                        />
                        <label :for="'schedule-type-' + index" class="ml-2"> {{ scheduleType.name }}</label>
                    </div>
                </div>
                <div v-if="errors.schedule_type" class="text-red-600 text-xs mt-1">{{ errors.schedule_type }}</div>
            </div>
            <div class="flex flex-col sm:flex-row gap-2">
                <div class="w-full flex flex-col mb-6">
                    <label for="start_date" class="pb-2 font-semibold text-gray-800">{{ __('Start Date') }}</label>
                    <Calendar
                        id="start_date"
                        v-model="form.start_date"
                        date-format="yy-mm-dd"
                        :min-date="minDate"
                        :disabled="disableFlag"
                        :class="[errors.start_date ? 'p-invalid' : '']"
                        :placeholder="__('Select Start Date')"
                        show-icon
                    />
                    <small v-if="errors.start_date" id="start_date-help" class="p-invalid">{{
                        errors.start_date
                    }}</small>
                </div>
                <div class="w-full flex flex-col mb-6">
                    <label for="start_time" class="pb-2 font-semibold text-gray-800">{{ __('Start Time') }}</label>
                    <Calendar
                        id="start_time"
                        v-model="form.start_time"
                        time-only
                        :step-minute="5"
                        :disabled="disableFlag"
                        :class="[errors.start_time ? 'p-invalid' : '']"
                        :placeholder="__('Select Start Time')"
                        show-icon
                    />
                    <small v-if="errors.start_time" id="start_time-help" class="p-invalid">{{
                        errors.start_time
                    }}</small>
                </div>
            </div>
            <div v-if="form.schedule_type === 'flexible'" class="flex flex-col sm:flex-row gap-2">
                <div class="w-full flex flex-col mb-6">
                    <label for="end_date" class="pb-2 font-semibold text-gray-800">{{ __('End Date') }}</label>
                    <Calendar
                        id="end_date"
                        v-model="form.end_date"
                        date-format="yy-mm-dd"
                        :min-date="minDate"
                        :disabled="disableFlag"
                        :class="[errors.end_date ? 'p-invalid' : '']"
                        :placeholder="__('Select End Date')"
                        show-icon
                    />
                    <small v-if="errors.end_date" id="ends_at-help" class="p-invalid">{{ errors.end_date }}</small>
                </div>
                <div class="w-full flex flex-col mb-6">
                    <label for="end_time" class="pb-2 font-semibold text-gray-800">{{ __('End Time') }}</label>
                    <Calendar
                        id="end_time"
                        v-model="form.end_time"
                        time-only
                        :step-minute="5"
                        :disabled="disableFlag"
                        :class="[errors.end_time ? 'p-invalid' : '']"
                        :placeholder="__('Select End Time')"
                        show-icon
                    />
                    <small v-if="errors.end_time" id="end_time-help" class="p-invalid">{{ errors.end_time }}</small>
                </div>
            </div>
            <div v-if="form.schedule_type === 'fixed'" class="w-full flex flex-col mb-6">
                <label for="grace_period" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Grace Period to Join') }} ({{ __('Minutes') }})</label
                >
                <InputNumber
                    id="grace_period"
                    v-model="form.grace_period"
                    placeholder="Enter Grace Period"
                    aria-describedby="grace_period-help"
                    :class="[errors.grace_period ? 'p-invalid' : '']"
                    :disabled="disableFlag"
                />
                <small v-if="errors.grace_period" id="grace_period-help" class="p-invalid">{{
                    errors.grace_period
                }}</small>
            </div>
            <div class="w-full flex flex-col mb-6">
                <label for="users" class="pb-2 font-semibold text-gray-800">{{ __('Schedule to User Groups') }}</label>
                <MultiSelect
                    id="users"
                    v-model="form.user_groups"
                    :options="userGroups"
                    option-label="name"
                    option-value="id"
                    :disabled="disableFlag"
                    :placeholder="__('Select User Groups')"
                    class="w-full"
                />
                <small v-if="errors.user_groups" id="users-help" class="p-invalid">{{ errors.user_groups }}</small>
            </div>
            <div v-if="editFlag" class="w-full flex flex-col mb-6">
                <label for="status" class="pb-2 font-semibold text-gray-800">{{ __('Status') }}</label>
                <Select
                    id="status"
                    v-model="form.status"
                    :options="quizStatus"
                    option-label="name"
                    option-value="code"
                    data-key="code"
                    placeholder="Select Status"
                    :disabled="disableFlag"
                />
                <small v-if="errors.status" id="status-help" class="p-invalid">{{ errors.status }}</small>
            </div>
            <small v-if="disableFlag" id="expire-note" class="text-sm text-red-400">{{
                __('schedule_update_message')
            }}</small>
            <div v-if="!disableFlag" class="w-full flex">
                <Button type="submit" :label="editFlag ? __('Update') : __('Create')" />
            </div>
        </form>
    </div>
</template>
<script setup>
import { ref, watch, onMounted } from 'vue'
import { router, useForm } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useConfirmToast } from '@/composables/useConfirmToast'
import InputNumber from 'primevue/inputnumber'
import MultiSelect from 'primevue/multiselect'
import RadioButton from 'primevue/radiobutton'
import Button from 'primevue/button'
import Calendar from 'primevue/calendar'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer.vue'
import FormSwitchShimmer from '@/Components/Shimmers/FormSwitchShimmer.vue'
import axios from 'axios'

// Props
const props = defineProps({
    editFlag: Boolean,
    quizScheduleId: Number,
    quizId: Number,
    userGroups: Array,
    formErrors: Object,
    title: String,
})

// Emits
const emit = defineEmits(['close'])

// Composables
const { __ } = useTranslate()
const { toast } = useConfirmToast()

// Reactive state
const form = useForm({
    quiz_id: props.quizId,
    schedule_type: 'fixed',
    start_date: '',
    end_date: '',
    start_time: '',
    end_time: '',
    grace_period: 5,
    status: 'active',
    user_groups: [],
})

const errors = ref({})
const disableFlag = ref(false)
const scheduleTypes = ref([
    { name: __('Fixed'), code: 'fixed' },
    { name: __('Flexible'), code: 'flexible' },
])

const quizStatus = ref([
    { name: __('Active'), code: 'active' },
    { name: __('Expired'), code: 'expired' },
    { name: __('Cancelled'), code: 'cancelled' },
])

const minDate = ref(new Date())
const formValidated = ref(false)
const loading = ref(false)

// Watchers
watch(
    () => props.formErrors,
    val => {
        errors.value = val || {}
    },
    { immediate: true }
)

// Methods
const submitForm = () => {
    props.editFlag ? update() : create()
}

const formatDateForSubmission = date => {
    if (!date) return ''
    if (typeof date === 'string') return date
    return date.toISOString().split('T')[0] // YYYY-MM-DD format
}

const formatTimeForSubmission = time => {
    if (!time) return ''
    if (typeof time === 'string') return time
    return time.toTimeString().split(' ')[0] // HH:MM:SS format
}

const create = async () => {
    formValidated.value = true

    form.post(route('admin.quiz-schedules.store'), {
        preserveScroll: true,
        transform: data => ({
            ...data,
            start_date: formatDateForSubmission(data.start_date),
            end_date: formatDateForSubmission(data.end_date),
            start_time: formatTimeForSubmission(data.start_time),
            end_time: formatTimeForSubmission(data.end_time),
        }),
        onSuccess: () => {
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Quiz schedule created successfully'),
                life: 3000,
            })
            emit('close', true)
        },
        onError: formErrors => {
            errors.value = formErrors
            toast({
                severity: 'error',
                summary: __('Error'),
                detail: __('Please check the form and try again'),
                life: 5000,
            })
        },
    })
}

const update = async () => {
    formValidated.value = true

    form.patch(route('admin.quiz-schedules.update', props.quizScheduleId), {
        preserveScroll: true,
        transform: data => ({
            ...data,
            start_date: formatDateForSubmission(data.start_date),
            end_date: formatDateForSubmission(data.end_date),
            start_time: formatTimeForSubmission(data.start_time),
            end_time: formatTimeForSubmission(data.end_time),
        }),
        onSuccess: () => {
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Quiz schedule updated successfully'),
                life: 3000,
            })
            emit('close', true)
        },
        onError: formErrors => {
            errors.value = formErrors
            toast({
                severity: 'error',
                summary: __('Error'),
                detail: __('Please check the form and try again'),
                life: 5000,
            })
        },
    })
}

const parseDateString = dateString => {
    if (!dateString) return null
    return new Date(dateString)
}

const parseTimeString = timeString => {
    if (!timeString) return null
    const today = new Date()
    const [hours, minutes, seconds] = timeString.split(':')
    today.setHours(parseInt(hours), parseInt(minutes), parseInt(seconds) || 0, 0)
    return today
}

const fetch = async () => {
    if (!props.editFlag) return

    loading.value = true
    try {
        const response = await axios.get(route('admin.quizzes.schedules.show', [props.quizId, props.quizScheduleId]))

        const data = response.data.schedule
        form.schedule_type = data.schedule_type
        form.start_date = parseDateString(data.start_date)
        form.start_time = parseTimeString(data.start_time)
        form.end_date = parseDateString(data.end_date)
        form.end_time = parseTimeString(data.end_time)
        form.grace_period = data.grace_period
        form.status = data.status
        // Map user groups to IDs if they come as objects, otherwise use as is
        form.user_groups =
            response.data.selectedUserGroupIds ||
            (Array.isArray(response.data.userGroups)
                ? response.data.userGroups.map(g => (typeof g === 'object' ? g.id : g))
                : [])
        disableFlag.value = response.data.disableFlag
    } catch (error) {
        console.error('Failed to fetch quiz schedule:', error)
        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load quiz schedule data'),
            life: 5000,
        })
    } finally {
        loading.value = false
    }
}

// Lifecycle
onMounted(() => {
    if (props.editFlag) {
        fetch()
    }
})
</script>
