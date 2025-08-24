<template>
    <Head :title="title" />
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Statistics Settings') }}
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

            <div v-for="stat in stats" class="p-4 bg-gray-50 rounded-md col-span-6 sm:sol-span-4">
                <div class="col-span-12 py-3 font-bold border-b border-gray-200">
                    <span>{{ __('Statistic') }} {{ stat }}</span>
                </div>

                <!-- Stat Name -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'stat' + stat + '_name'" :value="__('Name')" />
                    <arc-input
                        :id="'stat' + stat + '_name'"
                        v-model="form['stat' + stat + '_name']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['stat' + stat + '_name']" class="mt-2" />
                </div>

                <!-- Stat Count -->
                <div class="col-span-12 py-3">
                    <arc-label :for="'stat' + stat + '_count'" :value="__('Count')" />
                    <arc-input
                        :id="'stat' + stat + '_count'"
                        v-model="form['stat' + stat + '_count']"
                        type="text"
                        class="mt-1 block w-full"
                    />
                    <arc-input-error :message="form.errors['stat' + stat + '_count']" class="mt-2" />
                </div>
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
import { computed, ref } from 'vue'
import { Head, usePage } from '@inertiajs/vue3'
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
    return __('Settings/ Stat Settings Form') + ' - ' + pageProps.general.app_name
})

// Statistics
const stats = ref([1, 2, 3, 4])

// Form handling
const form = useForm({
    title: props.settings?.title || '',
    subtitle: props.settings?.subtitle || '',
    stat1_name: props.settings?.stat1_name || '',
    stat1_count: props.settings?.stat1_count || '',
    stat2_name: props.settings?.stat2_name || '',
    stat2_count: props.settings?.stat2_count || '',
    stat3_name: props.settings?.stat3_name || '',
    stat3_count: props.settings?.stat3_count || '',
    stat4_name: props.settings?.stat4_name || '',
    stat4_count: props.settings?.stat4_count || '',
})

// Methods
const updateSettings = () => {
    form.post(route('admin.settings.stats.update'), {
        errorBag: 'updateStatSettings',
        preserveScroll: true,
    })
}
</script>
