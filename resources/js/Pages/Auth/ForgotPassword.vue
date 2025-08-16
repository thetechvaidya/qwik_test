<template>
    <arc-authentication-card class="px-4 sm:px-6 lg:px-8">
        <Head title="Forgot Password" />
        <template #logo>
            <application-logo></application-logo>
        </template>

        <div class="mb-4 text-sm text-gray-600">
            {{ __('forgot_password_text') }}
        </div>

        <div v-if="status" class="mb-4 font-medium text-sm text-green-600">
            {{ status }}
        </div>

        <arc-validation-errors class="mb-4" />

        <form @submit.prevent="submit">
            <div>
                <arc-label for="email" :value="__('Email')" />
                <arc-input id="email" v-model="form.email" type="email" class="mt-1 block w-full" required autofocus />
            </div>

            <div class="flex items-center ltr:justify-end rtl:justify-start mt-4">
                <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    {{ __('Email Password Reset Link') }}
                </arc-button>
            </div>
        </form>
    </arc-authentication-card>
</template>

<script>
import { useForm, Head } from '@inertiajs/vue3'
import ArcAuthenticationCard from '@/Components/AuthenticationCard.vue'
import ArcButton from '@/Components/Button.vue'
import ArcInput from '@/Components/Input.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcValidationErrors from '@/Components/ValidationErrors.vue'
import ApplicationLogo from '@/Components/ApplicationLogo.vue'

export default {
    components: {
        ArcAuthenticationCard,
        ArcButton,
        ArcInput,
        ArcLabel,
        ArcValidationErrors,
        ApplicationLogo,
        Head,
    },

    props: {
        status: String,
        settings: Object,
    },

    setup() {
        // Proper composable usage in setup() for Vue 3
        const form = useForm({
            email: '',
        })

        const submit = () => {
            form.post(route('password.email'))
        }

        return {
            form,
            submit,
        }
    },
}
</script>
