<template>
    <Head :title="title" />
    <AdminLayout>
        <template #header>
            <h4 class="page-heading">{{ __('Import Users') }}</h4>
        </template>

        <div class="py-12">
            <div class="w-full mx-auto md:w-10/12 lg:w-8/12 xl:w-6/12 md:pb-0 md:px-6">
                <div
                    v-if="hasErrors"
                    class="bg-red-200 shadow rounded-md md:flex justify-between items-center top-0 mt-12 mb-8 pb-4 px-4"
                >
                    <ArcValidationErrors />
                </div>
                <div class="bg-white rounded shadow">
                    <div class="flex justify-end w-full p-2 border-b border-gray-200">
                        <a
                            :href="sampleFileUrl"
                            class="flex bg-white hover:bg-green-50 py-2 px-4 items-center rounded mb-2 cursor-pointer"
                        >
                            <svg height="27" viewBox="0 0 48 54.2" width="24" xmlns="http://www.w3.org/2000/svg">
                                <g id="xlsx" transform="translate(-24.36 5)">
                                    <path
                                        id="main"
                                        d="M76.323,19.387h-1.3v-6.28a1.041,1.041,0,0,0-.011-.119,1.043,1.043,0,0,0-.253-.688L64.307.363S64.3.359,64.3.356a1.046,1.046,0,0,0-.212-.178c-.023-.015-.046-.028-.069-.041a1.116,1.116,0,0,0-.21-.088c-.02-.005-.037-.013-.057-.018A1.056,1.056,0,0,0,63.507,0H37.825A2.128,2.128,0,0,0,35.7,2.126V19.387H34.4a3.038,3.038,0,0,0-3.038,3.038v15.8A3.039,3.039,0,0,0,34.4,41.26h1.3V52.075A2.127,2.127,0,0,0,37.825,54.2H72.9a2.128,2.128,0,0,0,2.125-2.125V41.26h1.3a3.038,3.038,0,0,0,3.038-3.038v-15.8A3.037,3.037,0,0,0,76.323,19.387ZM37.825,2.126h24.62V13a1.063,1.063,0,0,0,1.063,1.063H72.9v5.324H37.825Zm21.532,28.98c-2.088-.727-3.451-1.883-3.451-3.711,0-2.145,1.79-3.786,4.756-3.786a7.693,7.693,0,0,1,3.207.634l-.634,2.293a5.982,5.982,0,0,0-2.629-.6c-1.231,0-1.828.56-1.828,1.213,0,.8.709,1.156,2.331,1.772,2.219.821,3.263,1.977,3.263,3.749,0,2.108-1.623,3.9-5.073,3.9a8.217,8.217,0,0,1-3.562-.765l.578-2.35a7.261,7.261,0,0,0,3.152.784c1.307,0,2-.541,2-1.362C61.464,32.094,60.867,31.646,59.357,31.105ZM54.547,34v2.388H46.694V23.812h2.855V34ZM37.576,36.384H34.331l3.637-6.361-3.507-6.211h3.264l1.1,2.294c.373.765.653,1.379.952,2.089h.036c.3-.8.541-1.362.858-2.089l1.063-2.294h3.245l-3.544,6.135,3.731,6.436H41.883l-1.138-2.276c-.465-.875-.764-1.529-1.119-2.256h-.037c-.261.727-.578,1.381-.97,2.256ZM72.9,51.5H37.825V41.26H72.9V51.5Zm.019-15.116-1.138-2.276c-.466-.876-.764-1.529-1.119-2.256h-.036c-.262.728-.579,1.38-.971,2.256l-1.043,2.276H65.361L69,30.022l-3.506-6.211h3.264l1.1,2.294c.373.765.652,1.379.951,2.089h.037c.3-.8.54-1.362.857-2.089l1.063-2.294h3.246l-3.544,6.135,3.73,6.436H72.915Z"
                                        data-name="main"
                                        fill="#1d6f42"
                                        transform="translate(-7 -5)"
                                    />
                                </g>
                            </svg>
                            <span class="ltr:pl-2 rtl:pr-2 text-sm font-bold text-gray-600">{{
                                __('Download Sample Excel')
                            }}</span>
                        </a>
                    </div>
                    <div class="p-6">
                        <form enctype="multipart/form-data" @submit.prevent="submit">
                            <div class="flex flex-col w-full mb-6">
                                <input
                                    id="file"
                                    ref="fileRef"
                                    accept="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
                                    class="text-sm"
                                    type="file"
                                    @change="handleFileUpload"
                                />
                                <div class="form-control-errors">
                                    <p v-if="errors?.file" class="pt-2 text-xs text-red-500" role="alert">
                                        {{ errors.file }}
                                    </p>
                                </div>
                            </div>
                            <div class="flex justify-end w-full">
                                <button class="qt-btn qt-btn-success" type="submit">
                                    {{ __('Upload File') }}
                                </button>
                            </div>
                        </form>
                    </div>
                    <hr />
                    <div class="w-full p-6">
                        <h4 class="pb-6 text-sm font-semibold text-gray-800">
                            {{ __('Instructions') }}
                        </h4>
                        <ul class="list-disc text-md list-inside">
                            <li>{{ __('Password must be 8 characters.') }}</li>
                            <li>
                                {{ __('Accepted values for Email Verified are ') }}
                                <Tag class="text-sm cursor-pointer w-28 mr-2" @click="handleCopyClick('yes')">
                                    <i class="pi pi-copy mr-2" />
                                    yes
                                </Tag>
                                <Tag class="text-sm cursor-pointer w-28 mr-2" @click="handleCopyClick('no')">
                                    <i class="pi pi-copy mr-2" />
                                    no
                                </Tag>
                            </li>
                        </ul>
                    </div>
                    <div class="w-full p-6">
                        <h4 class="pb-6 text-sm font-semibold text-gray-800">
                            {{ __('User Roles') }}
                        </h4>
                        <table class="w-full table-auto">
                            <thead>
                                <tr>
                                    <th class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">
                                        {{ __('Name') }}
                                    </th>
                                    <th
                                        class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-center"
                                    >
                                        {{ __('Acceptable Code') }}
                                    </th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr v-for="userRole in userRoles" :key="userRole.code">
                                    <td class="border border-emerald-500 px-4 py-2 text-emerald-600 text-sm">
                                        {{ userRole.name }}
                                    </td>
                                    <td
                                        class="border border-emerald-500 px-4 py-2 text-emerald-600 font-medium text-sm text-center"
                                    >
                                        <Tag
                                            class="text-sm cursor-pointer w-28 mr-2"
                                            @click="handleCopyClick(userRole.code)"
                                        >
                                            <i class="pi pi-copy mr-2" />
                                            {{ userRole.code }}
                                        </Tag>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </AdminLayout>
</template>

<script setup>
import { ref, computed, onBeforeUnmount } from 'vue'
import { Head, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcValidationErrors from '@/Components/ValidationErrors.vue'
import Tag from 'primevue/tag'
import { useTranslate } from '@/composables/useTranslate'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'

// Props
const props = defineProps({
    sampleFileUrl: String,
    errors: Object,
    userRoles: Array,
})

// i18n / page
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Copy & toast
const { handleCopyClick } = useCopy({ t: __ })
const { toast } = useConfirmToast()

// File inputs
const fileRef = ref(null)
const file = ref(null)
const formValidated = ref(false)

// Derived
const title = computed(() => `${__('Import Users')} - ${pageProps.general.app_name}`)
const hasErrors = computed(() => Object.keys(props.errors || {}).length > 0)

// Methods
const handleFileUpload = () => {
    file.value = fileRef.value?.files?.[0] || null
}

const submit = () => {
    formValidated.value = true
    if (!file.value) {
        toast({ severity: 'error', summary: __('Caution'), detail: __('Please choose a file'), life: 3000 })
        return
    }
    const formData = new FormData()
    formData.append('file', file.value)
    router.post(route('import_users'), formData, {
        onSuccess: () => {
            // If server validated and processed without errors, show a small success toast
            if (!props.errors || Object.keys(props.errors).length === 0) {
                toast({ severity: 'success', summary: __('Success'), detail: __('File uploaded'), life: 2500 })
            }
        },
    })
}

// Cleanup on component unmount to prevent DOM manipulation errors
onBeforeUnmount(() => {
    // Reset reactive state
    file.value = null
    formValidated.value = false
    
    // Clear file input if it exists
    if (fileRef.value) {
        fileRef.value.value = ''
    }
    
    // Cancel any pending toasts
    if (window.$toast && window.$toast.removeAllGroups) {
        window.$toast.removeAllGroups()
    }
})
</script>
