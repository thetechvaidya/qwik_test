<template>
    <arc-authentication-card>
        <template #logo>
            <Link :href="route('welcome')">
                <img
                    :src="$page.props.assetUrl + $page.props.general.logo_path"
                    :alt="$page.props.general.app_name"
                    class="h-12"
                />
            </Link>
        </template>

        <div class="mb-4 text-sm text-gray-600">
            This is a secure area of the application. Please confirm your password before continuing.
        </div>

        <arc-validation-errors class="mb-4" />

        <form @submit.prevent="submit">
            <div>
                <arc-label for="password" value="Password" />
                <arc-input
                    id="password"
                    v-model="form.password"
                    type="password"
                    class="mt-1 block w-full"
                    required
                    autocomplete="current-password"
                    autofocus
                />
            </div>

            <div class="flex justify-end mt-4">
                <arc-button class="ml-4" :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                    Confirm
                </arc-button>
            </div>
        </form>
    </arc-authentication-card>
</template>

<script>
import { useForm } from '@inertiajs/vue3'
import { useHead } from '@vueuse/head'
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
    },

    setup() {
        // Set page title using useHead
        useHead({
            title: 'Confirm Password',
        })
    },

    data() {
        return {
            form: useForm({
                password: '',
            }),
        }
    },

    computed: {
        title() {
            return this.__('Confirm Password') + ' - ' + this.$page.props.general.app_name
        },
    },

    methods: {
        submit() {
            this.form.post(this.route('password.confirm'), {
                onFinish: () => this.form.reset(),
            })
        },
    },
}
</script>
