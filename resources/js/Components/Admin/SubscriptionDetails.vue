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
                            {{ __('Subscription ID') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.code }}
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Plan') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.plan }}
                        </dd>
                    </div>
                    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('User') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.user }}
                        </dd>
                    </div>
                    <div class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Subscription Starts') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.starts }}
                        </dd>
                    </div>
                    <div class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Subscription Ends') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.ends }}
                        </dd>
                    </div>
                    <div v-if="!editFlag" class="bg-gray-50 px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6">
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Status') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2 uppercase">
                            {{ subscription.status }}
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
                            {{ __('Payment Method') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            {{ subscription.payment }}
                        </dd>
                    </div>
                    <div
                        v-if="subscription.payment_id"
                        class="bg-white px-4 py-5 sm:grid sm:grid-cols-3 sm:gap-4 sm:px-6"
                    >
                        <dt class="text-sm font-medium text-gray-500">
                            {{ __('Online Payment Details') }}
                        </dt>
                        <dd class="mt-1 text-sm text-gray-900 sm:mt-0 sm:col-span-2">
                            <ul role="list" class="border border-gray-200 rounded-md divide-y divide-gray-200">
                                <li class="pl-3 pr-4 py-3 flex items-center justify-between text-sm">
                                    <div class="w-0 flex-1 flex items-center">
                                        <i class="pi pi-credit-card flex-shrink-0 text-gray-400 mr-2"></i>
                                        <span class="ml-2 flex-1 w-0 truncate">{{ subscription.payment_id }}</span>
                                    </div>
                                    <div class="ml-4 flex-shrink-0">
                                        <a
                                            :href="route('download_invoice', { id: subscription.payment_id })"
                                            target="_blank"
                                            class="font-medium text-indigo-600 hover:text-indigo-500"
                                        >
                                            {{ __('View Invoice') }}
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
import { ref, computed, onMounted } from 'vue'
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
    subscriptionId: {
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
const subscription = ref({})

// Form
const form = useForm({
    status: '',
})

// Methods
const fetchSubscriptionDetails = async () => {
    try {
        const response = await axios.get(route('admin.subscriptions.show', props.subscriptionId))
        subscription.value = response.data.subscription
        form.status = subscription.value.status
        loading.value = false
    } catch (error) {
        console.error('Error fetching subscription details:', error)
        loading.value = false
        toast({
            severity: 'error',
            summary: __('Error'),
            detail: __('Failed to load subscription details'),
            life: 3000,
        })
    }
}

const update = () => {
    form.patch(route('admin.subscriptions.update', props.subscriptionId), {
        preserveScroll: true,
        onSuccess: () => {
            editFlag.value = false
            fetchSubscriptionDetails() // Reload data
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Subscription updated successfully'),
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
    fetchSubscriptionDetails()
})
</script>
