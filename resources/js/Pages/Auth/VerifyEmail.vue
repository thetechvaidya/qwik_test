<template>
    <arc-authentication-card>
        <Head title="Email Verification" />
        <template #logo>
            <application-logo />
        </template>

        <div class="mb-4 text-sm text-gray-600">
            {{ __('verify_email_message') }}
        </div>

        <div v-if="verificationLinkSent" class="mb-4 font-medium text-sm text-green-600">
            {{ __('verification_link_sent') }}
        </div>

        <form @submit.prevent="submit">
            <div class="mt-4 flex items-center justify-between">
                <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    {{ __('Resend Verification Email') }}
                </arc-button>

                <Link
                    :href="route('logout')"
                    method="post"
                    as="button"
                    class="underline text-sm text-gray-600 hover:text-gray-900"
                    >{{ __('Logout') }}</Link
                >
            </div>
        </form>
    </arc-authentication-card>
</template>

<script>
import { useForm, Head } from '@inertiajs/vue3'
import { computed } from 'vue'
import ArcAuthenticationCard from '@/Components/AuthenticationCard.vue'
import ArcButton from '@/Components/Button.vue'
import ApplicationLogo from '@/Components/ApplicationLogo'

export default {
    components: {
        ArcAuthenticationCard,
        ArcButton,
        ApplicationLogo,
        Head,
    },

    props: {
        status: String,
    },

    setup(props) {
        // Proper composable usage in setup() for Vue 3
        const form = useForm({})

        const submit = () => {
            form.post(route('verification.send'))
        }

        const verificationLinkSent = computed(() => {
            return props.status === 'verification-link-sent'
        })

        return {
            form,
            submit,
            verificationLinkSent,
        }
    },
}
</script>
