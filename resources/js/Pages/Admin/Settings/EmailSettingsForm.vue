<template>
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Email SMTP Configuration') }}
        </template>

        <template #form>
            <!-- Mail Host -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="host" :value="__('Host Name')" />
                <arc-input id="host" v-model="form.host" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.host" class="mt-2" />
            </div>

            <!-- Port Number -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="port" :value="__('Port Number')" />
                <arc-input id="port" v-model="form.port" type="number" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.port" class="mt-2" />
            </div>

            <!-- User Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="username" :value="__('User Name')" />
                <arc-input id="username" v-model="form.username" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.username" class="mt-2" />
            </div>

            <!-- Password -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="password" :value="__('Password')" />
                <arc-input id="password" v-model="form.password" type="password" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.password" class="mt-2" />
            </div>

            <!-- Encryption -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="encryption" :value="__('Encryption')" />
                <arc-input id="encryption" v-model="form.encryption" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.encryption" class="mt-2" />
            </div>

            <!-- From Address -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="from_address" :value="__('From Address')" />
                <arc-input id="from_address" v-model="form.from_address" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.from_address" class="mt-2" />
            </div>

            <!-- From Name -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="from_name" :value="__('From Name')" />
                <arc-input id="from_name" v-model="form.from_name" type="text" class="mt-1 block w-full" />
                <arc-input-error :message="form.errors.from_name" class="mt-2" />
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
import { useForm } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcButton from '@/Components/Button.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcSecondaryButton from '@/Components/SecondaryButton.vue'

const props = defineProps({
    settings: Object,
})

const { __ } = useTranslate()

const form = useForm({
    host: props.settings.host,
    port: props.settings.port,
    username: props.settings.username,
    password: props.settings.password,
    encryption: props.settings.encryption,
    from_name: props.settings.from_name,
    from_address: props.settings.from_address,
})

const updateSettings = () => {
    form.post(route('update_email_settings'), {
        errorBag: 'updateEmailSettings',
        preserveScroll: true,
    })
}
</script>
