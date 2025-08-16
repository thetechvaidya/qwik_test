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
            <!-- Category Name -->
            <div class="w-full flex flex-col mb-6">
                <label for="name" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Category') }} {{ __('Name') }}<span class="ml-1 text-red-400">*</span></label
                >
                <InputText
                    id="name"
                    v-model="form.name"
                    type="text"
                    placeholder="Enter Category Name"
                    aria-describedby="name-help"
                    :class="[errors.name ? 'p-invalid' : '']"
                />
                <small v-if="errors.name" id="name-help" class="p-invalid">{{ errors.name }}</small>
            </div>

            <!-- Short Description -->
            <div class="w-full flex flex-col mb-6">
                <label for="short_description" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Short Description') }} (Max. 160 Characters)</label
                >
                <Textarea
                    id="short_description"
                    v-model="form.short_description"
                    :class="[errors.short_description ? 'p-invalid' : '']"
                ></Textarea>
                <small v-if="errors.short_description" id="short_description-help" class="p-invalid">{{
                    errors.short_description
                }}</small>
            </div>

            <!-- Description -->
            <div class="w-full flex flex-col mb-6">
                <label for="description" class="pb-2 font-semibold text-gray-800">{{ __('Description') }}</label>
                <TiptapEditor
                    v-model="form.description"
                    :config="{
                        toolbar: 'advanced',
                        rtl: $page.props.rtl,
                        height: '250px',
                    }"
                    :invalid="errors.description"
                    :placeholder="__('Enter category description...')"
                />
                <small v-if="errors.description" id="description-help" class="p-invalid">{{
                    errors.description
                }}</small>
            </div>

            <!-- Is Active Switch -->
            <div class="w-full">
                <div class="flex justify-between items-center mb-8">
                    <div class="w-9/12">
                        <label
                            for="is_active"
                            class="font-semibold text-gray-800 pb-1"
                            v-html="form.is_active ? __('Active') : __('In-active')"
                        ></label>
                        <p class="text-gray-500"
                            >{{ __('Active') }} ({{ __('Shown Everywhere') }}). {{ __('In-active') }} ({{
                                __('Hidden Everywhere')
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
<script>
import InputText from 'primevue/inputtext'
import Button from 'primevue/button'
import ToggleSwitch from 'primevue/toggleswitch'
import Textarea from 'primevue/textarea'
import TiptapEditor from '@/Components/TiptapEditor'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer'
import FormSwitchShimmer from '@/Components/Shimmers/FormSwitchShimmer'
export default {
    name: 'CategoryForm',
    components: {
        InputText,
        Button,
        ToggleSwitch,
        Textarea,
        TiptapEditor,
        FormInputShimmer,
        FormSwitchShimmer,
    },
    props: {
        editFlag: Boolean,
        categoryId: Number,
        formErrors: Object,
        title: '',
    },
    data() {
        return {
            errors: {},
            form: {
                name: '',
                description: '',
                short_description: '',
                is_active: true,
            },
            formValidated: false,
            loading: false,
        }
    },
    watch: {
        formErrors(val) {
            this.errors = val
        },
    },
    mounted() {
        if (this.editFlag === true) {
            this.fetch()
        }
    },
    methods: {
        submitForm() {
            this.editFlag ? this.update() : this.create()
        },
        create() {
            this.formValidated = true
            this.$inertia.post(route('categories.store'), this.form, {
                onSuccess: () => {
                    if (Object.keys(this.errors).length === 0) {
                        this.$emit('close', true)
                    }
                },
            })
        },
        update() {
            this.formValidated = true
            this.$inertia.patch(route('categories.update', { category: this.categoryId }), this.form, {
                onSuccess: () => {
                    if (Object.keys(this.errors).length === 0) {
                        this.$emit('close', true)
                    }
                },
            })
        },
        fetch() {
            if (this.editFlag) {
                let _this = this
                _this.loading = true
                axios
                    .get(route('categories.edit', { category: this.categoryId }))
                    .then(function (response) {
                        let data = response.data
                        _this.form.name = data.name
                        _this.form.short_description = data.short_description
                        _this.form.description = data.description
                        _this.form.is_active = data.is_active
                    })
                    .catch(function (error) {
                        _this.loading = false
                    })
                    .then(function () {
                        _this.loading = false
                    })
            }
        },
    },
}
</script>
