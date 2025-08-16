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

        <div class="mt-6 w-11/12 mx-auto xl:w-full xl:mx-0">
            <form @submit.prevent="submit">
                <div class="grid grid-cols-1 gap-6">
                    <!-- Plan Selection -->
                    <div>
                        <Label for="plan_id" value="Plan" />
                        <Select
                            id="plan_id"
                            v-model="form.plan_id"
                            :options="plans"
                            option-label="text"
                            option-value="value"
                            :placeholder="__('Select Plan')"
                            class="w-full"
                            :class="{ 'p-invalid': errors.plan_id }"
                        />
                        <InputError :message="errors.plan_id" class="mt-2" />
                    </div>

                    <!-- User Selection -->
                    <div>
                        <Label for="user_id" value="User" />
                        <AutoComplete
                            id="user_id"
                            v-model="form.user_id"
                            :suggestions="userSuggestions"
                            field="full_name"
                            :placeholder="__('Search and select user')"
                            class="w-full"
                            :class="{ 'p-invalid': errors.user_id }"
                            @complete="searchUsers"
                        />
                        <InputError :message="errors.user_id" class="mt-2" />
                    </div>

                    <!-- Status -->
                    <div>
                        <Label for="status" value="Status" />
                        <Select
                            id="status"
                            v-model="form.status"
                            :options="statusTypes"
                            option-label="text"
                            option-value="value"
                            :placeholder="__('Select Status')"
                            class="w-full"
                            :class="{ 'p-invalid': errors.status }"
                        />
                        <InputError :message="errors.status" class="mt-2" />
                    </div>
                </div>

                <div class="flex justify-end mt-6 space-x-2">
                    <Button type="button" severity="secondary" :disabled="form.processing" @click="emit('close')">
                        {{ __('Cancel') }}
                    </Button>
                    <Button type="submit" :disabled="form.processing" :class="{ 'opacity-25': form.processing }">
                        {{ __('Create Subscription') }}
                    </Button>
                </div>
            </form>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useForm } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useConfirmToast } from '@/composables/useConfirmToast'
import Label from '@/Components/Label.vue'
import Button from 'primevue/button'
import Select from 'primevue/select'
import AutoComplete from 'primevue/autocomplete'
import InputError from '@/Components/InputError.vue'
import axios from 'axios'

// Props
const props = defineProps({
    title: {
        type: String,
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
const { toast } = useConfirmToast()

// Reactive data
const userSuggestions = ref([])
const plans = ref([])

// Form
const form = useForm({
    plan_id: null,
    user_id: null,
    status: 'active',
})

// Methods
const searchUsers = async event => {
    try {
        const response = await axios.get(route('admin.users.search'), {
            params: { query: event.query },
        })
        userSuggestions.value = response.data
    } catch (error) {
        console.error('Error searching users:', error)
    }
}

const fetchPlans = async () => {
    try {
        const response = await axios.get(route('admin.plans.search'))
        plans.value = response.data
    } catch (error) {
        console.error('Error fetching plans:', error)
    }
}

const submit = () => {
    // Convert user object to ID if needed
    const userId = typeof form.user_id === 'object' ? form.user_id?.id : form.user_id

    form.transform(data => ({
        ...data,
        user_id: userId,
    })).post(route('admin.subscriptions.store'), {
        preserveScroll: true,
        onSuccess: () => {
            emit('close')
            toast({
                severity: 'success',
                summary: __('Success'),
                detail: __('Subscription created successfully'),
                life: 3000,
            })
            form.reset()
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
fetchPlans()
</script>
