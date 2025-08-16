<template>
    <div v-model="form.category_id"class="overflo                <v-select id=" cat" :options="categories" :reduce="cat => cat.id" label="name" :dir="$page.props.rtl ? 'rtl' : 'ltr'">
                    <template #no-options="{ search, searching }">
                        <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                        <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                    </template>
                </v-select>to h-screen px-2">
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
            <!-- Sub Category Name -->
            <div class="w-full flex flex-col mb-6">
                <label for="name" class="pb-2 font-semibold text-gray-800">{{ __('Sub Category') }} {{ __('Name') }}</label>
                <InputText
id="name"
                           v-model="form.name"
                           type="text"
                           placeholder="Enter Category Name" aria-describedby="name-help"
                           :class="[errors.name ? 'p-invalid' : '']"

                />
                <small v-if="errors.name" id="name-help" class="p-invalid">{{ errors.name }}</small>
            </div>

            <!-- Category -->
            <div class="w-full flex flex-col mb-6">
                <label for="category" class="pb-2 font-semibold text-gray-800">{{ __('Category') }}<span class="ml-1 text-red-400">*</span></label>
                <v-select id="category" v-model="form.category_id" :options="categories" :reduce="cat => cat.id" label="name" :dir="$page.props.rtl ? 'rtl' : 'ltr'">
                    <template #no-options="{ search, searching }">
                        <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                        <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                    </template>
                </v-select>
                <small v-if="errors.category_id" id="category-help" class="p-invalid">{{ errors.category_id }}</small>
            </div>

            <!-- Type -->
            <div class="w-full flex flex-col mb-6">
                <label for="type" class="pb-2 font-semibold text-gray-800">{{ __('Type') }}<span class="ml-1 text-red-400">*</span></label>
                <v-select id="type" v-model="form.sub_category_type_id" :options="types" :reduce="type => type.id" label="name" :dir="$page.props.rtl ? 'rtl' : 'ltr'">
                    <template #no-options="{ search, searching }">
                        <span v-if="searching">{{ __('No results were found for this search') }}.</span>
                        <em v-else class="opacity-50">{{ __('Start typing to search') }}.</em>
                    </template>
                </v-select>
                </v-select>
                <small v-if="errors.sub_category_type_id" id="type-help" class="p-invalid">{{ errors.sub_category_type_id }}</small>
            </div>

            <!-- Short Description -->
            <div class="w-full flex flex-col mb-6">
                <label for="short_description" class="pb-2 font-semibold text-gray-800">{{ __('Short Description') }}</label>
                <Textarea id="short_description" v-model="form.short_description" :class="[errors.short_description ? 'p-invalid' : '']"></Textarea>
                <small v-if="errors.short_description" id="short_description-help" class="p-invalid">{{ errors.short_description }}</small>
            </div>

            <!-- Description -->
            <div class="w-full flex flex-col mb-6">
                <label for="description" class="pb-2 font-semibold text-gray-800">{{ __('Description') }}</label>
                <TiptapEditor 
                    v-model="form.description" 
                    :config="{ 
                        toolbar: 'advanced', 
                        rtl: $page.props.rtl,
                        height: '250px' 
                    }" 
                    :invalid="errors.description"
                    :placeholder="__('Enter subcategory description...')"
                />
                <small v-if="errors.description" id="description-help" class="p-invalid">{{ errors.description }}</small>
            </div>

            <!-- Status Switch -->
            <div class="w-full">
                <div class="flex justify-between items-center mb-8">
                    <div class="w-9/12">
                        <label for="is_active" class="font-semibold text-gray-800 pb-1" v-html="form.is_active ? __('Active') : __('In-active')"></label>
                        <p class="text-gray-500">{{ __('Active') }} ({{ __('Shown Everywhere') }}). {{ __('In-active') }} ({{ __('Hidden Everywhere') }}).</p>
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
    </template>
<script>
    import InputText from 'primevue/inputtext';
    import Button from 'primevue/button';
    import ToggleSwitch from 'primevue/toggleswitch';
    import Textarea from 'primevue/textarea';
    import TiptapEditor from "@/Components/TiptapEditor";
    import InputNumber from 'primevue/inputnumber';
    import FormInputShimmer from "@/Components/Shimmers/FormInputShimmer";
    import FormSwitchShimmer from "@/Components/Shimmers/FormSwitchShimmer";
    export default {
        name: 'SubCategoryForm',
        components: {
            InputText,
            Button,
            ToggleSwitch,
            Textarea,
            TiptapEditor,
            InputNumber,
            FormInputShimmer,
            FormSwitchShimmer
        },
        props: {
            editFlag: Boolean,
            subCategoryId: Number,
            categories: Array,
            types: Array,
            formErrors: Object,
            title: ''
        },
        data() {
            return {
                errors: {},
                form: {
                    name: '',
                    description: '',
                    category_id: '',
                    sub_category_type_id: '',
                    short_description: '',
                    is_active: true,
                },
                formValidated: false,
                loading: false,
            }
        },
        watch: {
            formErrors(val) {
                this.errors = val;
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
                this.$inertia.post(route('sub-categories.store'), this.form, {
                    onSuccess: () => {
                        if (Object.keys(this.errors).length === 0) {
                            this.$emit('close', true);
                        }
                    },
                });
            },
            update() {
                this.formValidated = true;
                this.$inertia.patch(route('sub-categories.update', { sub_category: this.subCategoryId }), this.form, {
                    onSuccess: () => {
                        if (Object.keys(this.errors).length === 0) {
                            this.$emit('close', true);
                        }
                    },
                });
            },
            fetch() {
                if(this.editFlag) {
                    let _this = this;
                    _this.loading = true;
                    axios.get(route('sub-categories.edit', { sub_category: this.subCategoryId }))
                        .then(function (response) {
                            let data = response.data;
                            _this.form.name = data.name;
                            _this.form.category_id = data.category_id;
                            _this.form.sub_category_type_id = data.sub_category_type_id;
                            _this.form.short_description = data.short_description;
                            _this.form.description = data.description;
                            _this.form.is_private = data.is_private;
                            _this.form.is_active = data.is_active;
                        })
                        .catch(function (error) {
                            _this.loading = false;
                        })
                        .then(function () {
                            _this.loading = false;
                        });
                }
            }
        }
    }
</script>
