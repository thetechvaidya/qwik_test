<template>
    <div class="overflow-y-auto h-screen px-2">
        <div class="bg-gray-100 py-4 lg:py-4 rounded">
            <div class="container px-6 mx-auto flex flex-col md:flex-row items-start md:items-center justify-between">
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
                <label for="name" class="pb-2 font-semibold text-gray-800"
                    >{{ __('Quiz Type') }} {{ __('Name') }}</label
                >
                <InputText
                    id="name"
                    type="text"
                    v-model="form.name"
                    aria-describedby="name-help"
                    :class="[errors.name ? 'p-invalid' : '']"
                />
                <small v-if="errors.name" id="name-help" class="p-invalid">{{ errors.name }}</small>
            </div>
            <div class="w-full flex flex-col mb-6">
                <label for="color" class="pb-2 font-semibold text-gray-800">{{ __('Color') }}</label>
                <div class="flex items-center">
                    <ColorPicker v-model="form.color" format="hex" />
                    <InputText id="color" type="text" v-model="form.color" class="mt-1 block w-full" />
                </div>
                <small v-if="errors.color" id="color-help" class="p-invalid">{{ errors.color }}</small>
            </div>
            <div class="w-full flex flex-col mb-6">
                <label for="image_path" class="pb-2 font-semibold text-gray-800">{{ __('Image URL') }}</label>
                <InputText
                    id="image_path"
                    type="text"
                    v-model="form.image_path"
                    aria-describedby="image_path-help"
                    :class="[errors.image_path ? 'p-invalid' : '']"
                />
                <small v-if="errors.image_path" id="image_path-help" class="p-invalid">{{ errors.image_path }}</small>
            </div>
            <div class="w-full flex flex-col mb-6">
                <label for="description" class="pb-2 font-semibold text-gray-800">{{ __('Description') }}</label>
                <TextareaComponent
                    id="description"
                    v-model="form.description"
                    :class="[errors.description ? 'p-invalid' : '']"
                ></TextareaComponent>
                <small v-if="errors.description" id="description-help" class="p-invalid">{{ errors.description }}</small>
            </div>
            <div class="w-full">
                <div class="flex justify-between items-center mb-8">
                    <div class="w-9/12">
                        <label
                            for="is_active"
                            class="font-semibold text-gray-800 pb-1"
                            v-html="form.is_active ? __('Active') : __('In-active')"
                        ></label>
                        <p class="text-sm text-gray-500"
                            >{{ __('Active') }} ({{ __('Shown Everywhere') }}). {{ __('In-active') }} ({{
                                __('Hidden Everywhere')
                            }}).</p
                        >
                    </div>
                    <div class="cursor-pointer rounded-full relative shadow-sm">
                        <ToggleSwitchComponent id="is_active" v-model="form.is_active" />
                    </div>
                </div>
            </div>
            <div class="w-full flex">
                <ButtonComponent type="submit" :label="editFlag ? __('Update') : __('Create')" />
            </div>
        </form>
    </div>
</template>

<script>
import InputText from 'primevue/inputtext'
import ButtonComponent from 'primevue/button'
import ToggleSwitchComponent from 'primevue/toggleswitch'
import TextareaComponent from 'primevue/textarea'
import FormInputShimmer from '@/Components/Shimmers/FormInputShimmer'
import FormSwitchShimmer from '@/Components/Shimmers/FormSwitchShimmer'
import ColorPicker from 'primevue/colorpicker'

export default {
    name: 'QuizTypeForm',
    components: {
        InputText,
        ButtonComponent,
        ToggleSwitchComponent,
        TextareaComponent,
        FormInputShimmer,
        FormSwitchShimmer,
        ColorPicker,
    },
    props: {
        editFlag: {
            type: Boolean,
            default: false
        },
        quizTypeId: {
            type: Number,
            default: null
        },
        formErrors: {
            type: Object,
            default: () => ({})
        },
        title: {
            type: String,
            default: ''
        },
    },
    emits: ['close'],
    data() {
        return {
            errors: {},
            form: {
                name: '',
                description: '',
                color: '',
                image_path: '',
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
        if(this.editFlag === true) {
            this.fetch();
        }
    },
    methods: {
        submitForm() {
            this.editFlag ? this.update() : this.create();
        },
        create() {
            this.formValidated = true;
            // Note: this.$inertia would need to be properly configured
            if (typeof console !== 'undefined') {
                console.log('Would submit form to create quiz type');
            }
            this.$emit('close', true);
        },
        update() {
            this.formValidated = true;
            // Note: this.$inertia would need to be properly configured
            if (typeof console !== 'undefined') {
                console.log('Would submit form to update quiz type');
            }
            this.$emit('close', true);
        },
        fetch() {
            if(this.editFlag) {
                let _this = this;
                _this.loading = true;
                // Note: axios would need to be properly imported
                if (typeof console !== 'undefined') {
                    console.log('Would fetch quiz type data');
                }
                _this.loading = false;
            }
        }
    }
}
</script>