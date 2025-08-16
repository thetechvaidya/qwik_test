<template>
    <arc-authentication-card>
        <Head title="Reset Password" />
        <template #logo>
            <Link :href="route('welcome')">
                <img
                    :src="$page.props.assetUrl + $page.props.general.logo_path"
                    :alt="$page.props.general.app_name"
                    class="h-12"
                />
            </Link>
        </template>

        <arc-validation-errors class="mb-4" />

        <form @submit.prevent="submit">
            <div>
                <arc-label for="email" :value="__('Email')" />
                <arc-input id="email" v-model="form.email" type="email" class="mt-1 block w-full" required autofocus />
            </div>

            <div class="mt-4">
                <arc-label for="password" :value="__('Password')" />
                <arc-input
                    id="password"
                    v-model="form.password"
                    type="password"
                    class="mt-1 block w-full"
                    required
                    autocomplete="new-password"
                />
            </div>

            <div class="mt-4">
                <arc-label for="password_confirmation" :value="__('Confirm Password')" />
                <arc-input
                    id="password_confirmation"
                    v-model="form.password_confirmation"
                    type="password"
                    class="mt-1 block w-full"
                    required
                    autocomplete="new-password"
                />
            </div>

            <div class="flex items-center justify-end mt-4">
                <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    {{ __('Reset Password') }}
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

export default {
    components: {
        ArcAuthenticationCard,
        ArcButton,
        ArcInput,
        ArcLabel,
        ArcValidationErrors,
        Head,
    },

    props: {
        email: String,
        token: String,
    },

    setup(props) {
        // Proper composable usage in setup() for Vue 3
        const form = useForm({
            token: props.token,
            email: props.email,
            password: '',
            password_confirmation: '',
        })

        const submit = () => {
            form.post(route('password.update'), {
                onFinish: () => form.reset('password', 'password_confirmation'),
            })
        }

        return {
            form,
            submit,
        }
    },
}
</script>
