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
            <FormInputShimmer />
            <FormInputShimmer />
            <FormInputShimmer />
        </div>
        <div v-else class="mt-6 w-11/12 mx-auto xl:w-full xl:mx-0">
            <div>
                <dl>
                    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Payment ID') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.payment_id }}
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Plan') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.plan }}
                        </dd>
                    </div>
                    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Date') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.date }}
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Amount') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.amount }}
                        </dd>
                    </div>
                    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('User') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.user }}
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Payment Method') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ payment.method }}
                        </dd>
                    </div>
                    <div v-if="!editFlag" class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Status') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2 uppercase">
                            {{ payment.status }}
                            <span class="ml-2 text-xs text-blue-500 cursor-pointer underline" @click="editFlag = true">
                                {{ __('Edit') }}
                            </span>
                        </dd>
                    </div>
                    <div v-if="editFlag" class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Update Status') }}
                        </dt>
                        <dd class="mt-1 sm:mt-0 sm:col-span-2">
                            <form @submit.prevent="update">
                                <!-- Status -->
                                <div class="col-span-6 sm:col-span-4">
                                    <Label for="status">
                                        {{ __('Status') }}
                                        <span
                                            class="ml-2 text-xs text-blue-500 cursor-pointer underline"
                                            @click="editFlag = false"
                                        >
                                            {{ __('Close') }}
                                        </span>
                                    </Label>
                                    <Select
                                        id="status"
                                        v-model="form.status"
                                        :options="statusTypes"
                                        option-label="text"
                                        option-value="value"
                                        :placeholder="__('Select Status')"
                                        class="w-full"
                                    />
                                    <InputError v-if="form.errors.status" :message="form.errors.status" class="mt-2" />
                                </div>
                                <Button
                                    :class="{ 'opacity-25': form.processing }"
                                    class="mt-3"
                                    :disabled="form.processing"
                                    type="submit"
                                >
                                    {{ __('Update') }}
                                </Button>
                            </form>
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Invoice') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            <ul role="list" class="border border-gray-200 rounded-md divide-y divide-gray-200">
                                <li class="pl-3 pr-4 py-3 flex items-center justify-between text-sm">
                                    <div class="w-0 flex-1 flex items-center">
                                        <i class="pi pi-file-pdf flex-shrink-0 text-gray-400 mr-2"></i>
                                        <span class="ml-2 flex-1 w-0 truncate">{{ payment.invoice_no }}</span>
                                    </div>
                                    <div class="ml-4 flex-shrink-0">
                                        <a
                                            :href="route('download_invoice', { id: payment.payment_id })"
                                            target="_blank"
                                            class="font-medium text-indigo-600 hover:text-indigo-500"
                                        >
                                            {{ __('Download') }}
                                        </a>
                                    </div>
                                </li>
                            </ul>
                        </dd>
                    </div>
                </dl>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useForm, usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useConfirmToast } from '@/composables/useConfirmToast'
import Label from '@/Components/Label.vue'
import Button from 'primevue/button'
import Select from 'primevue/select'
import InputError from '@/Components/InputError.vue'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer.vue'
import axios from 'axios'

// Props
const props = defineProps({
    title: {
        type: String,
        required: true,
    },
    paymentId: {
        type: [String, Number],
        required: true,
    },
    statusTypes: {
        type: Array,
        default: () => [],
    },
    errors: {
        type: Object,
        default: () => ({}),
    },
})

// Emits
const emit = defineEmits(['close'])

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { toast } = useConfirmToast()

// Reactive data
const loading = ref(true)
const editFlag = ref(false)
const payment = ref({})

// Form
const form = useForm({
    status: '',
})

// Methods
const fetchPaymentDetails = async () => {
    try {
        const response = await axios.get(route('admin.payments.show', props.paymentId))
        payment.value = response.data.payment
        form.status = payment.value.status
        loading.value = false
    } catch (error) {
        console.error('Error fetching payment details:', error)
        loading.value = false
        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load payment details'),
            life: 3000,
        })
    }
}

const update = () => {
    form.patch(route('admin.payments.update', props.paymentId), {
        preserveScroll: true,
        onSuccess: () => {
            editFlag.value = false
            fetchPaymentDetails() // Reload data
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Payment updated successfully'),
                life: 3000,
            })
        },
        onError: () => {
            toast({
                severity: 'error',
                summary: __('Error'),
                detail: __('Something went wrong'),
                life: 3000,
            })
        },
    })
}

// Lifecycle
onMounted(() => {
    fetchPaymentDetails()
})
</script>
