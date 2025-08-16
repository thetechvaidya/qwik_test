<template>
    <arc-authentication-card>
        <template #logo>
            <arc-authentication-card-logo />
        </template>

        <div class="mb-4 text-gray-600">
            <p v-if="!recovery">
                Please confirm access to your account by entering the authentication code provided by your authenticator
                application.
            </p>

            <p v-else> Please confirm access to your account by entering one of your emergency recovery codes. </p>
        </div>

        <arc-validation-errors class="mb-4" />

        <form @submit.prevent="submit">
            <div v-if="!recovery">
                <arc-label for="code" value="Code" />
                <arc-input
                    id="code"
                    ref="code"
                    v-model="form.code"
                    type="text"
                    inputmode="numeric"
                    class="mt-1 block w-full"
                    autofocus
                    autocomplete="one-time-code"
                />
            </div>

            <div v-else>
                <arc-label for="recovery_code" value="Recovery Code" />
                <arc-input
                    id="recovery_code"
                    ref="recovery_code"
                    v-model="form.recovery_code"
                    type="text"
                    class="mt-1 block w-full"
                    autocomplete="one-time-code"
                />
            </div>

            <div class="flex items-center justify-end mt-4">
                <button
                    type="button"
                    class="text-gray-600 hover:text-gray-900 underline cursor-pointer"
                    @click.prevent="toggleRecovery"
                >
                    <span v-if="!recovery"> Use a recovery code </span>

                    <span v-else> Use an authentication code </span>
                </button>

                <arc-button class="ml-4" :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    {{ __('Login') }}
                </arc-button>
            </div>
        </form>
    </arc-authentication-card>
</template>

<script>
import { useForm } from '@inertiajs/vue3'
import ArcAuthenticationCard from '@/Components/AuthenticationCard.vue'
import ArcAuthenticationCardLogo from '@/Components/AuthenticationCardLogo.vue'
import ArcButton from '@/Components/Button.vue'
import ArcInput from '@/Components/Input.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcValidationErrors from '@/Components/ValidationErrors.vue'

export default {
    components: {
        ArcAuthenticationCard,
        ArcAuthenticationCardLogo,
        ArcButton,
        ArcInput,
        ArcLabel,
        ArcValidationErrors,
    },

    data() {
        return {
            recovery: false,
            form: useForm({
                code: '',
                recovery_code: '',
            }),
        }
    },

    methods: {
        toggleRecovery() {
            this.recovery = !this.recovery

            this.$nextTick(() => {
                if (this.recovery) {
                    this.$refs.recovery_code.focus()
                    this.form.code = ''
                } else {
                    this.$refs.code.focus()
                    this.form.recovery_code = ''
                }
            })
        },

        submit() {
            this.form.post(this.route('two-factor.login'))
        },
    },
}
</script>
