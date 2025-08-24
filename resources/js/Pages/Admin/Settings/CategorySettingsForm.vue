<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Category Settings') }}
        </template>

        <template #form>
            <!-- Feature Title -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="title" :value="__('Title')" />
                <arc-input id="title" v-model="form.title" type="text" class="mt-1 block w-full" autocomplete="title" />
                <arc-input-error :message="form.errors.title" class="mt-2" />
            </div>

            <!-- Feature Subtitle -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="subtitle" :value="__('Subtitle')" />
                <arc-text-area id="subtitle" v-model="form.subtitle" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.subtitle" class="mt-2" />
            </div>

            <!-- Button Text -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="limit" :value="__('Item Limit')" />
                <arc-input id="limit" v-model="form.limit" type="number" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.limit" class="mt-2" />
            </div>
        </template>

        <template #actions>
            <arc-action-message :on="form.recentlySuccessful" class="mr-3"> {{ __('Saved') }}. </arc-action-message>

            <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                {{ __('Save') }}
            </arc-button>
        </template>
    </arc-form-section>
</template>
<script setup>
import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import { useForm } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcTextArea from '@/Components/TextArea.vue'

// Props
const props = defineProps({
    settings: Object,
    errors: Object,
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
    return __('Settings/ Category Settings Form') + ' - ' + pageProps.general.app_name
})

// Form handling
const form = useForm({
    title: props.settings?.title || '',
    subtitle: props.settings?.subtitle || '',
    limit: props.settings?.limit || 6,
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.category.update'), {
        errorBag: 'updateCategorySettings',
        preserveScroll: true,
    })
}
</script>
