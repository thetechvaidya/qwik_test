<template>
    <AdminLayout>
        <Head title="Homepage Settings" />

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
            <!-- Header -->
            <div class="mb-8">
                <div class="flex items-center justify-between">
                    <div>
                        <h1 class="text-3xl font-bold text-gray-900">Homepage Settings</h1>
                        <p class="mt-2 text-gray-600">Customize your homepage content and appearance</p>
                    </div>
                    <div class="flex items-center gap-4">
                        <Button
                            icon="pi pi-eye"
                            label="Preview"
                            severity="secondary"
                            outlined
                            @click="previewHomepage"
                        />
                        <Button
                            icon="pi pi-refresh"
                            label="Reset to Defaults"
                            severity="danger"
                            outlined
                            :loading="resetting"
                            @click="resetToDefaults"
                        />
                    </div>
                </div>
            </div>

            <form class="space-y-8" @submit.prevent="submitForm">
                <!-- Hero Section -->
                <Card>
                    <template #title>
                        <div class="flex items-center gap-2">
                            <i class="pi pi-star text-xl"></i>
                            Hero Section
                        </div>
                    </template>

                    <template #content>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Main Title </label>
                                <InputText
                                    v-model="form.hero_title"
                                    :class="{ 'p-invalid': errors.hero_title }"
                                    class="w-full"
                                    placeholder="Enter hero title"
                                />
                                <small v-if="errors.hero_title" class="p-error">{{ errors.hero_title }}</small>
                            </div>

                            <div class="md:col-span-2">
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Subtitle </label>
                                <Textarea
                                    v-model="form.hero_subtitle"
                                    :class="{ 'p-invalid': errors.hero_subtitle }"
                                    class="w-full"
                                    rows="3"
                                    placeholder="Enter hero subtitle"
                                />
                                <small v-if="errors.hero_subtitle" class="p-error">{{ errors.hero_subtitle }}</small>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> CTA Button Text </label>
                                <InputText
                                    v-model="form.hero_cta_text"
                                    :class="{ 'p-invalid': errors.hero_cta_text }"
                                    class="w-full"
                                    placeholder="e.g., Get Started"
                                />
                                <small v-if="errors.hero_cta_text" class="p-error">{{ errors.hero_cta_text }}</small>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> CTA Button URL </label>
                                <InputText
                                    v-model="form.hero_cta_url"
                                    :class="{ 'p-invalid': errors.hero_cta_url }"
                                    class="w-full"
                                    placeholder="e.g., /courses"
                                />
                                <small v-if="errors.hero_cta_url" class="p-error">{{ errors.hero_cta_url }}</small>
                            </div>
                        </div>
                    </template>
                </Card>

                <!-- Stats Section -->
                <Card>
                    <template #title>
                        <div class="flex items-center gap-2">
                            <i class="pi pi-chart-bar text-xl"></i>
                            Statistics
                        </div>
                    </template>

                    <template #content>
                        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Students Count </label>
                                <InputNumber
                                    v-model="form.stats_students_count"
                                    :class="{ 'p-invalid': errors.stats_students_count }"
                                    class="w-full"
                                    :min="0"
                                    :max="999999"
                                />
                                <small v-if="errors.stats_students_count" class="p-error">{{
                                    errors.stats_students_count
                                }}</small>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Courses Count </label>
                                <InputNumber
                                    v-model="form.stats_courses_count"
                                    :class="{ 'p-invalid': errors.stats_courses_count }"
                                    class="w-full"
                                    :min="0"
                                    :max="9999"
                                />
                                <small v-if="errors.stats_courses_count" class="p-error">{{
                                    errors.stats_courses_count
                                }}</small>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2">
                                    Completion Rate (%)
                                </label>
                                <InputNumber
                                    v-model="form.stats_completion_rate"
                                    :class="{ 'p-invalid': errors.stats_completion_rate }"
                                    class="w-full"
                                    :min="0"
                                    :max="100"
                                />
                                <small v-if="errors.stats_completion_rate" class="p-error">{{
                                    errors.stats_completion_rate
                                }}</small>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Satisfaction Score </label>
                                <InputNumber
                                    v-model="form.stats_satisfaction_score"
                                    :class="{ 'p-invalid': errors.stats_satisfaction_score }"
                                    class="w-full"
                                    :min="0"
                                    :max="5"
                                    :min-fraction-digits="1"
                                    :max-fraction-digits="1"
                                />
                                <small v-if="errors.stats_satisfaction_score" class="p-error">{{
                                    errors.stats_satisfaction_score
                                }}</small>
                            </div>
                        </div>
                    </template>
                </Card>

                <!-- Features Section -->
                <Card>
                    <template #title>
                        <div class="flex items-center justify-between">
                            <div class="flex items-center gap-2">
                                <i class="pi pi-list text-xl"></i>
                                Features
                            </div>
                            <Button
                                icon="pi pi-plus"
                                label="Add Feature"
                                size="small"
                                :disabled="form.features_list.length >= 6"
                                @click="addFeature"
                            />
                        </div>
                    </template>

                    <template #content>
                        <div class="space-y-6">
                            <div
                                v-for="(feature, index) in form.features_list"
                                :key="index"
                                class="border rounded-lg p-4"
                            >
                                <div class="flex items-center justify-between mb-4">
                                    <h4 class="font-medium">Feature {{ index + 1 }}</h4>
                                    <Button
                                        icon="pi pi-trash"
                                        severity="danger"
                                        outlined
                                        size="small"
                                        :disabled="form.features_list.length <= 1"
                                        @click="removeFeature(index)"
                                    />
                                </div>

                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Title</label>
                                        <InputText
                                            v-model="feature.title"
                                            :class="{ 'p-invalid': errors[`features_list.${index}.title`] }"
                                            class="w-full"
                                            placeholder="Feature title"
                                        />
                                        <small v-if="errors[`features_list.${index}.title`]" class="p-error">
                                            {{ errors[`features_list.${index}.title`] }}
                                        </small>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Icon</label>
                                        <InputText
                                            v-model="feature.icon"
                                            :class="{ 'p-invalid': errors[`features_list.${index}.icon`] }"
                                            class="w-full"
                                            placeholder="e.g., pi-users"
                                        />
                                        <small v-if="errors[`features_list.${index}.icon`]" class="p-error">
                                            {{ errors[`features_list.${index}.icon`] }}
                                        </small>
                                    </div>

                                    <div>
                                        <label class="block text-sm font-medium text-gray-700 mb-2">Description</label>
                                        <Textarea
                                            v-model="feature.description"
                                            :class="{ 'p-invalid': errors[`features_list.${index}.description`] }"
                                            class="w-full"
                                            rows="2"
                                            placeholder="Feature description"
                                        />
                                        <small v-if="errors[`features_list.${index}.description`]" class="p-error">
                                            {{ errors[`features_list.${index}.description`] }}
                                        </small>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </template>
                </Card>

                <!-- Meta Tags -->
                <Card>
                    <template #title>
                        <div class="flex items-center gap-2">
                            <i class="pi pi-search text-xl"></i>
                            SEO Meta Tags
                        </div>
                    </template>

                    <template #content>
                        <div class="space-y-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Meta Title </label>
                                <InputText
                                    v-model="form.meta_title"
                                    :class="{ 'p-invalid': errors.meta_title }"
                                    class="w-full"
                                    placeholder="SEO title (max 60 characters)"
                                    maxlength="60"
                                />
                                <div class="flex justify-between items-center mt-1">
                                    <small v-if="errors.meta_title" class="p-error">{{ errors.meta_title }}</small>
                                    <small class="text-gray-500">{{ form.meta_title?.length || 0 }}/60</small>
                                </div>
                            </div>

                            <div>
                                <label class="block text-sm font-medium text-gray-700 mb-2"> Meta Description </label>
                                <Textarea
                                    v-model="form.meta_description"
                                    :class="{ 'p-invalid': errors.meta_description }"
                                    class="w-full"
                                    rows="3"
                                    placeholder="SEO description (max 160 characters)"
                                    maxlength="160"
                                />
                                <div class="flex justify-between items-center mt-1">
                                    <small v-if="errors.meta_description" class="p-error">{{
                                        errors.meta_description
                                    }}</small>
                                    <small class="text-gray-500">{{ form.meta_description?.length || 0 }}/160</small>
                                </div>
                            </div>
                        </div>
                    </template>
                </Card>

                <!-- Submit Button -->
                <div class="flex justify-end">
                    <Button
                        type="submit"
                        label="Save Settings"
                        icon="pi pi-save"
                        :loading="form.processing"
                        size="large"
                    />
                </div>
            </form>
        </div>
    </AdminLayout>
</template>

<script>
import { Head, useForm } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import Card from 'primevue/card'
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import InputNumber from 'primevue/inputnumber'
import Textarea from 'primevue/textarea'
import { useToast } from '@/composables/useToast'

export default {
    name: 'HomePageSettings',

    components: {
        Head,
        AdminLayout,
        Card,
        Button,
        InputText,
        InputNumber,
        Textarea,
    },

    props: {
        settings: {
            type: Object,
            required: true,
        },
        validation_rules: {
            type: Object,
            required: true,
        },
    },

    setup(props) {
        const { showToast } = useToast()

        const form = useForm({
            hero_title: props.settings.hero_title,
            hero_subtitle: props.settings.hero_subtitle,
            hero_cta_text: props.settings.hero_cta_text,
            hero_cta_url: props.settings.hero_cta_url,
            stats_students_count: props.settings.stats_students_count,
            stats_courses_count: props.settings.stats_courses_count,
            stats_completion_rate: props.settings.stats_completion_rate,
            stats_satisfaction_score: props.settings.stats_satisfaction_score,
            features_list: [...props.settings.features_list],
            pricing_plans: [...props.settings.pricing_plans],
            testimonials: [...props.settings.testimonials],
            meta_title: props.settings.meta_title,
            meta_description: props.settings.meta_description,
        })

        return {
            form,
            showToast,
        }
    },

    data() {
        return {
            resetting: false,
        }
    },

    computed: {
        errors() {
            return this.form.errors || {}
        },
    },

    methods: {
        submitForm() {
            this.form.put('/admin/homepage', {
                onSuccess: () => {
                    this.showToast('success', 'Homepage settings updated successfully!')
                },
                onError: () => {
                    this.showToast('error', 'Please fix the validation errors and try again.')
                },
            })
        },

        addFeature() {
            if (this.form.features_list.length < 6) {
                this.form.features_list.push({
                    title: '',
                    description: '',
                    icon: 'pi-star',
                })
            }
        },

        removeFeature(index) {
            if (this.form.features_list.length > 1) {
                this.form.features_list.splice(index, 1)
            }
        },

        async resetToDefaults() {
            if (!confirm('Are you sure you want to reset all settings to defaults? This action cannot be undone.')) {
                return
            }

            this.resetting = true

            try {
                await this.$inertia.post(
                    '/admin/homepage/reset',
                    {},
                    {
                        onSuccess: () => {
                            this.showToast('success', 'Settings reset to defaults successfully!')
                        },
                        onError: () => {
                            this.showToast('error', 'Failed to reset settings. Please try again.')
                        },
                    }
                )
            } finally {
                this.resetting = false
            }
        },

        previewHomepage() {
            window.open('/admin/homepage/preview', '_blank')
        },
    },
}
</script>

<style scoped>
.p-card .p-card-title {
    font-size: 1.25rem;
    font-weight: 600;
    color: #1f2937;
}

.p-invalid {
    border-color: #ef4444 !important;
}

.p-error {
    color: #ef4444;
    font-size: 0.875rem;
}

/* Responsive grid adjustments */
@media (max-width: 768px) {
    .grid {
        grid-template-columns: 1fr;
    }
}
</style>
