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
            <!-- First Name -->
            <div class="w-full flex flex-col mb-6">
                <label for="first_name" class="pb-2 font-semibold text-gray-800"
                    >{{ __('First Name') }}<span class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="first_name"
                    v-model="form.first_name"
                    type="text"
                    placeholder="Enter First Name"
                    aria-describedby="first_name-help"
                    :class="[errors.first_name ? 'p-invalid' : '']"
                />
                <small v-if="errors.first_name" id="first_name-help" class="p-invalid">{{ errors.first_name }}</small>
            </div>

            <!-- Last Name -->
            <div class="w-full flex flex-col mb-6">
                <label for="last_name" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Last Name') }}<span class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="last_name"
                    v-model="form.last_name"
                    type="text"
                    placeholder="Enter Last Name"
                    aria-describedby="last_name-help"
                    :class="[errors.last_name ? 'p-invalid' : '']"
                />
                <small v-if="errors.last_name" id="last_name-help" class="p-invalid">{{ errors.last_name }}</small>
            </div>

            <!-- Email -->
            <div class="w-full flex flex-col mb-6">
                <label for="email" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Email') }}<span class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="email"
                    v-model="form.email"
                    type="email"
                    placeholder="Enter Email"
                    aria-describedby="email-help"
                    :class="[errors.email ? 'p-invalid' : '']"
                />
                <small v-if="errors.email" id="email-help" class="p-invalid">{{ errors.email }}</small>
            </div>

            <!-- User Name -->
            <div class="w-full flex flex-col mb-6">
                <label for="user_name" class="pb-2 font-semibold text-gray-800"
                    >{{ __('User Name') }}<span class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="user_name"
                    v-model="form.user_name"
                    type="text"
                    placeholder="Enter User Name"
                    aria-describedby="user_name-help"
                    :class="[errors.user_name ? 'p-invalid' : '']"
                />
                <small v-if="errors.user_name" id="user_name-help" class="p-invalid">{{ errors.user_name }}</small>
            </div>

            <!-- User Role Dropdown -->
            <!-- Expected roles prop shape: [{ value: number|string, text: string }] -->
            <!-- Note: role.value should match backend role_id type (integer) -->
            <div class="w-full flex flex-col mb-6">
                <label for="userRole" class="pb-2 font-semibold text-gray-800"
                    >{{ __('User Role') }}<span class="ml-1 text-red-400">*</span></label
                >
                <v-select
                    id="userRole"
                    v-model="form.role"
                    :options="roles"
                    :reduce="role => role.value"
                    label="text"
                    placeholder="Choose Role"
                    :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                >
                    <template #no-options="{ search, searching }">
                        <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                        <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                    </template>
                </v-select>
                <small v-if="errors.role" id="userRole-help" class="p-invalid">{{ errors.role }}</small>
            </div>

            <!-- User Groups Dropdown -->
            <!-- Expected userGroups prop shape: [{ id: number, name: string }] -->
            <!-- Note: group.id should be integer to match backend user_groups relationship -->
            <div v-if="form.role !== 1" class="w-full flex flex-col mb-6">
                <label for="users" class="pb-2 font-semibold text-gray-800">{{ __('User Groups') }}</label>
                <v-select
                    id="users"
                    v-model="form.user_groups"
                    multiple
                    :options="userGroups"
                    :reduce="group => group.id"
                    label="name"
                    placeholder="Select User Groups"
                    :dir="$page.props.rtl ? 'rtl' : 'ltr'"
                >
                    <template #no-options="{ search, searching }">
                        <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                        <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                    </template>
                </v-select>
                <small v-if="errors.user_groups" id="users-help" class="p-invalid">{{ errors.user_groups }}</small>
            </div>

            <!-- Password -->
            <div class="w-full flex flex-col mb-6">
                <label for="password" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Password') }}<span v-if="!editFlag" class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="password"
                    v-model="form.password"
                    type="password"
                    placeholder="Enter Password"
                    aria-describedby="password-help"
                    :class="[errors.password ? 'p-invalid' : '']"
                />
                <small v-if="errors.password" id="password-help" class="p-invalid">{{ errors.password }}</small>
            </div>

            <!-- Email Verified Switch -->
            <div class="w-full">
                <div class="flex justify-between items-center mb-8">
                    <div class="w-9/12">
                        <label
                            for="email_verified_at"
                            class="font-semibold text-gray-800 pb-1"
                            v-html="
                                form.email_verified_at
                                    ? __('Email Verified') + ' - ' + __('Yes')
                                    : __('Email Verified') + ' - ' + __('No')
                            "
                        ></label>
                        <p class="text-gray-500"
                            >{{ __('Yes') }} ({{ __('Email is verified') }}). {{ __('No') }} ({{
                                __('Email not verified')
                            }}).</p
                        >
                    </div>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch id="email_verified_at" v-model="form.email_verified_at" />
                    </div>
                </div>
            </div>

            <!-- Is Active Switch -->
            <div class="w-full">
                <div class="flex justify-between items-center mb-8">
                    <div class="w-9/12">
                        <label
                            for="is_active"
                            class="font-semibold text-gray-800 pb-1"
                            v-html="
                                form.is_active
                                    ? __('Status') + ' - ' + __('Active')
                                    : __('Status') + ' - ' + __('In-active')
                            "
                        ></label>
                        <p class="text-gray-500"
                            >{{ __('Active') }} ({{ __('Allow Login') }}). {{ __('In-active') }} ({{
                                __('Disallow Login')
                            }}).</p
                        >
                    </div>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitch id="is_active" v-model="form.is_active" />
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <div class="w-full flex">
                <Button type="submit" :label="editFlag ? __('Update') : __('Create')" />
            </div>
        </form>
    </div>
</template>
<script setup>
import { ref, reactive, watch, onMounted } from 'vue'
import { router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import InputText from 'primevue/inputtext'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import vSelect from 'vue-select'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer'
import FormSwitchShimmer from '@/Components/Shimmers/FormSwitchShimmer'
import axios from 'axios'

const { __ } = useTranslate()

// Props
// Props with expected data shapes documented for API consistency
const props = defineProps({
    editFlag: Boolean,
    userId: Number,
    formErrors: Object,
    // Expected shape: [{ value: number, text: string }]
    // where value corresponds to backend role_id (integer)
    roles: Array,
    // Expected shape: [{ id: number, name: string }]
    // where id corresponds to backend user_group.id (integer)
    userGroups: Array,
    title: String,
})

// Emits
const emit = defineEmits(['close'])

// Reactive data
const errors = ref({})
const formValidated = ref(false)
const loading = ref(false)

const form = reactive({
    first_name: '',
    last_name: '',
    user_name: '',
    email: '',
    role: '',
    password: '',
    is_active: true,
    user_groups: [],
    email_verified_at: false,
})

// Watch for form errors
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

const create = () => {
    formValidated.value = true

    // Apply data transformation for backend compatibility
    const transformedData = {
        first_name: form.first_name,
        last_name: form.last_name,
        user_name: form.user_name,
        email: form.email,
        role: form.role,
        password: form.password,
        is_active: form.is_active,
        user_groups: form.user_groups,
        email_verified_at: form.email_verified_at,
    }

    router.post(route('users.store'), transformedData, {
        onSuccess: () => {
            if (Object.keys(errors.value).length === 0) {
                emit('close', true)
            }
        },
    })
}

const update = () => {
    formValidated.value = true

    // Apply data transformation for backend compatibility
    const transformedData = {
        first_name: form.first_name,
        last_name: form.last_name,
        user_name: form.user_name,
        email: form.email,
        role: form.role,
        password: form.password,
        is_active: form.is_active,
        user_groups: form.user_groups,
        email_verified_at: form.email_verified_at,
    }

    router.patch(route('users.update', { user: props.userId }), transformedData, {
        onSuccess: () => {
            if (Object.keys(errors.value).length === 0) {
                emit('close', true)
            }
        },
    })
}

const fetch = () => {
    if (props.editFlag) {
        loading.value = true
        // Use API endpoint to ensure JSON response instead of Inertia page response
        axios
            .get(route('api.users.show', { user: props.userId }), {
                headers: {
                    Accept: 'application/json',
                    'X-Requested-With': 'XMLHttpRequest',
                },
            })
            .then(response => {
                const data = response.data.user
                form.first_name = data.first_name
                form.last_name = data.last_name
                form.user_name = data.user_name
                form.email = data.email
                form.role = data.role_id
                form.email_verified_at = data.email_verified_at ? true : false
                form.is_active = data.is_active
                form.user_groups = response.data.userGroups
            })
            .catch(error => {
                loading.value = false
            })
            .finally(() => {
                loading.value = false
            })
    }
}

// Watch userId to fetch when it becomes available (for edit mode)
watch(
    () => props.userId,
    id => {
        if (props.editFlag && id) fetch()
    },
    { immediate: false }
)
</script>
