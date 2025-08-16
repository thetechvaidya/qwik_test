<template>
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Site Favicon') }}
        </template>

        <template #form>
            <!-- Site Logo -->
            <div class="col-span-6 sm:col-span-4">
                <input id="icon" ref="icon" type="file" class="hidden" name="icon" @change="updateLogoPreview" />

                <arc-label for="icon" :value="__('Site Favicon')" />

                <div v-show="!logoPreview" class="my-4">
                    <img
                        :src="$page.props.assetUrl + settings.favicon_path"
                        :alt="settings.app_name"
                        class="h-10 object-cover"
                    />
                </div>

                <!-- New Logo Preview -->
                <div v-show="logoPreview" class="my-4">
                    <span
                        class="block h-10"
                        :style="
                            'background-size: contain; background-repeat: no-repeat; background-position: center center; background-image: url(\'' +
                            logoPreview +
                            '\');'
                        "
                    >
                    </span>
                </div>

                <arc-secondary-button class="mt-2 ltr:mr-2 rtl:ml-2" type="button" @click="selectNewLogo">
                    {{ __('Select A New Image') }}
                </arc-secondary-button>

                <arc-input-error :message="form.errors.favicon_path" class="mt-2" />
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
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcActionMessage from '@/Components/ActionMessage'
import ArcButton from '@/Components/Button'
import ArcFormSection from '@/Components/FormSection'
import ArcInputError from '@/Components/InputError'
import ArcLabel from '@/Components/Label'
import ArcSecondaryButton from '@/Components/SecondaryButton'
import ToggleSwitch from 'primevue/toggleswitch'
import { useForm } from '@inertiajs/vue3'
import { ref } from 'vue'

const props = defineProps({
    settings: Object,
})

const icon = ref()
const logoPreview = ref(null)

const form = useForm({
    favicon_path: props.settings.favicon_path,
})

const updateSettings = () => {
    if (icon.value) {
        form.favicon_path = icon.value.files[0]
    }

    form.post(route('update_favicon'), {
        errorBag: 'updateFavicon',
        preserveScroll: true,
    })
}

const selectNewLogo = () => {
    icon.value.click()
}

const updateLogoPreview = () => {
    const logoReader = new FileReader()

    logoReader.onload = e => {
        logoPreview.value = e.target.result
    }

    logoReader.readAsDataURL(icon.value.files[0])
}
</script>
