<template>
    <arc-form-section @submitted="updateProfileInformation">
        <template #title>
            {{ __('Profile Information') }}
        </template>

        <template #form>
            <!-- Profile Photo -->
            <div v-if="page.props.jetstream.managesProfilePhotos" class="col-span-6 sm:col-span-4">
                <!-- Profile Photo File Input -->
                <input ref="photoInput" type="file" class="hidden" @change="updatePhotoPreview" />

                <arc-label for="photo" :value="__('Photo')" />

                <!-- Current Profile Photo -->
                <div v-show="!photoPreview" class="mt-2">
                    <img :src="user.profile_photo_url" :alt="user.name" class="rounded-full h-20 w-20 object-cover" />
                </div>

                <!-- New Profile Photo Preview -->
                <div v-show="photoPreview" class="mt-2">
                    <span
                        class="block rounded-full w-20 h-20"
                        :style="
                            'background-size: cover; background-repeat: no-repeat; background-position: center center; background-image: url(\'' +
                            photoPreview +
                            '\');'
                        "
                    >
                    </span>
                </div>

                <arc-secondary-button class="mt-2 ltr:mr-2 rtl:ml-2" type="button" @click="selectNewPhoto">
                    {{ __('Select A New Photo') }}
                </arc-secondary-button>

                <arc-secondary-button v-if="user.profile_photo_path" type="button" class="mt-2" @click="deletePhoto">
                    {{ __('Remove Photo') }}
                </arc-secondary-button>

                <arc-input-error :message="form.errors.photo" class="mt-2" />
            </div>

            <!-- Last Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="first_name" :value="__('First Name')" />
                <arc-input
                    id="first_name"
                    v-model="form.first_name"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="first_name"
                />
                <arc-input-error :message="form.errors.first_name" class="mt-2" />
            </div>

            <!-- Last Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="last_name" :value="__('Last Name')" />
                <arc-input
                    id="last_name"
                    v-model="form.last_name"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="last_name"
                />
                <arc-input-error :message="form.errors.last_name" class="mt-2" />
            </div>

            <!-- Email -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="email" :value="__('Email')" />
                <arc-input id="email" v-model="form.email" type="email" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.email" class="mt-2" />
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
import { ref } from 'vue'
import { useForm, usePage, router } from '@inertiajs/vue3'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcSecondaryButton from '@/Components/SecondaryButton.vue'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    user: Object,
})

// Composables
const { __ } = useTranslate()
const page = usePage()

// Template refs
const photoInput = ref(null)

// Reactive data
const photoPreview = ref(null)

// Form initialization
const form = useForm({
    _method: 'PUT',
    first_name: props.user.first_name,
    last_name: props.user.last_name,
    email: props.user.email,
    photo: null,
})

// Methods
const updateProfileInformation = () => {
    if (photoInput.value) {
        form.photo = photoInput.value.files[0]
    }

    form.post(route('user-profile-information.update'), {
        errorBag: 'updateProfileInformation',
        preserveScroll: true,
    })
}

const selectNewPhoto = () => {
    photoInput.value?.click()
}

const updatePhotoPreview = () => {
    const reader = new FileReader()

    reader.onload = e => {
        photoPreview.value = e.target.result
    }

    reader.readAsDataURL(photoInput.value.files[0])
}

const deletePhoto = () => {
    router.delete(route('current-user-photo.destroy'), {
        preserveScroll: true,
        onSuccess: () => (photoPreview.value = null),
    })
}
</script>
