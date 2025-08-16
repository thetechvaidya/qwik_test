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
            <div class="w-full flex flex-col mb-6">
                <label class="pb-2 text-sm font-semibold text-gray-800"
                    >{{ __('Schedule Type') }}<span class="ml-1 text-red-400">*</span></label
                >
                <div class="flex flex-col sm:flex-row gap-4">
                    <div v-for="scheduleType in scheduleTypes" class="p-field-radiobutton">
                        <RadioButton
                            :id="'schedule_type' + scheduleType.code"
                            v-model="form.schedule_type"
                            name="schedule_type"
                            :value="scheduleType.code"
                            :disabled="editFlag"
                        />
                        <label class="text-sm text-gray-800" :for="'schedule_type' + scheduleType.code">{{
                            scheduleType.name
                        }}</label>
                    </div>
                </div>
            </div>
            <div class="flex flex-col sm:flex-row gap-2">
                <div class="w-full flex flex-col mb-6">
                    <label for="start_date" class="pb-2 font-semibold text-gray-800">{{ __('Start Date') }}</label>
                    <DatePicker
                        id="start_date"
                        v-model="form.start_date"
                        :manual-input="false"
                        :min-date="minDate"
                        date-format="dd M yy"
                        :class="[errors.start_date ? 'p-invalid' : '']"
                        :disabled="disableFlag"
                        class="w-full"
                    />
                    <small v-if="errors.start_date" id="start_date-help" class="p-invalid">{{
                        errors.start_date
                    }}</small>
                </div>
                <div class="w-full flex flex-col mb-6">
                    <label for="start_time" class="pb-2 font-semibold text-gray-800">{{ __('Start Time') }}</label>
                    <DatePicker
                        id="start_time"
                        v-model="form.start_time"
                        time-only
                        hour-format="24"
                        :step-minute="5"
                        :manual-input="false"
                        :class="[errors.start_time ? 'p-invalid' : '']"
                        :disabled="disableFlag"
                        class="w-full"
                    />
                    <small v-if="errors.start_time" id="start_time-help" class="p-invalid">{{
                        errors.start_time
                    }}</small>
                </div>
            </div>
            <div v-if="form.schedule_type === 'flexible'" class="flex flex-col sm:flex-row gap-2">
                <div class="w-full flex flex-col mb-6">
                    <label for="end_date" class="pb-2 font-semibold text-gray-800">{{ __('End Date') }}</label>
                    <DatePicker
                        id="end_date"
                        v-model="form.end_date"
                        :manual-input="false"
                        :min-date="minDate"
                        date-format="dd M yy"
                        :class="[errors.end_date ? 'p-invalid' : '']"
                        :disabled="disableFlag"
                        class="w-full"
                    />
                    <small v-if="errors.end_date" id="ends_at-help" class="p-invalid">{{ errors.end_date }}</small>
                </div>
                <div class="w-full flex flex-col mb-6">
                    <label for="end_time" class="pb-2 font-semibold text-gray-800">{{ __('End Time') }}</label>
                    <DatePicker
                        id="end_time"
                        v-model="form.end_time"
                        time-only
                        hour-format="24"
                        :step-minute="5"
                        :manual-input="false"
                        :class="[errors.end_time ? 'p-invalid' : '']"
                        :disabled="disableFlag"
                        class="w-full"
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
                    :options="examStatus"
                    option-label="name"
                    option-value="code"
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
import Select from 'primevue/select'
import RadioButton from 'primevue/radiobutton'
import Button from 'primevue/button'
import DatePicker from 'primevue/datepicker'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer.vue'
import FormSwitchShimmer from '@/Components/Shimmers/FormSwitchShimmer.vue'
import axios from 'axios'

// Props
const props = defineProps({
    editFlag: { type: Boolean, default: false },
    examScheduleId: { type: Number, default: null },
    examId: { type: Number, required: true },
    userGroups: { type: Array, default: () => [] },
    formErrors: { type: Object, default: () => ({}) },
    title: { type: String, default: '' },
})

// Emits
const emit = defineEmits(['close'])

// Composables
const { __ } = useTranslate()
const { toast } = useConfirmToast()

// Reactive state
const errors = ref({})
const form = useForm({
    exam_id: props.examId,
    schedule_type: 'fixed',
    start_date: '',
    end_date: '',
    start_time: '',
    end_time: '',
    grace_period: 5,
    status: 'active',
    user_groups: [],
})

const disableFlag = ref(false)
const scheduleTypes = ref([
    { name: __('Fixed'), code: 'fixed' },
    { name: __('Flexible'), code: 'flexible' },
])

const examStatus = ref([
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
// Parsing helpers for converting server strings to Date objects
const parseDate = val => {
    if (!val) return null
    // Expecting 'YYYY-MM-DD'
    const parts = String(val).split('-')
    if (parts.length === 3) {
        const [y, m, d] = parts.map(Number)
        return new Date(y, (m || 1) - 1, d || 1)
    }
    const dt = new Date(val)
    return isNaN(dt.getTime()) ? null : dt
}

const parseTime = val => {
    if (!val) return null
    // Expecting 'HH:mm:ss' or 'HH:mm'
    const parts = String(val).split(':').map(Number)
    const now = new Date()
    now.setHours(parts[0] || 0, parts[1] || 0, parts[2] || 0, 0)
    return now
}

// Formatting helpers to convert Date objects back to server strings
const pad = n => (n < 10 ? '0' + n : String(n))

const formatDate = val => {
    if (!(val instanceof Date)) return val || ''
    const y = val.getFullYear()
    const m = pad(val.getMonth() + 1)
    const d = pad(val.getDate())
    return `${y}-${m}-${d}`
}

const formatTime = val => {
    if (!(val instanceof Date)) return val || ''
    const hh = pad(val.getHours())
    const mm = pad(val.getMinutes())
    const ss = pad(val.getSeconds())
    return `${hh}:${mm}:${ss}`
}

const submitForm = () => {
    props.editFlag ? update() : create()
}

const create = async () => {
    formValidated.value = true

    form.post(route('admin.exam-schedules.store'), {
        preserveScroll: true,
        transform: data => ({
            ...data,
            start_date: formatDate(data.start_date),
            end_date: data.schedule_type === 'flexible' ? formatDate(data.end_date) : '',
            start_time: formatTime(data.start_time),
            end_time: data.schedule_type === 'flexible' ? formatTime(data.end_time) : '',
        }),
        onSuccess: () => {
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Exam schedule created successfully'),
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

    form.patch(route('admin.exam-schedules.update', props.examScheduleId), {
        preserveScroll: true,
        transform: data => ({
            ...data,
            start_date: formatDate(data.start_date),
            end_date: data.schedule_type === 'flexible' ? formatDate(data.end_date) : '',
            start_time: formatTime(data.start_time),
            end_time: data.schedule_type === 'flexible' ? formatTime(data.end_time) : '',
        }),
        onSuccess: () => {
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Exam schedule updated successfully'),
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

const fetch = async () => {
    if (!props.editFlag) return

    loading.value = true
    try {
        const response = await axios.get(route('admin.exams.schedules.show', [props.examId, props.examScheduleId]))

        const data = response.data.schedule
        form.schedule_type = data.schedule_type
        form.start_date = parseDate(data.start_date)
        form.start_time = parseTime(data.start_time)
        form.end_date = parseDate(data.end_date)
        form.end_time = parseTime(data.end_time)
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
        console.error('Failed to fetch exam schedule:', error)
        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load exam schedule data'),
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
