<template>
    <arc-action-section>
        <template #title> Delete Account </template>

        <template #description> Permanently delete your account. </template>

        <template #content>
            <div class="max-w-xl text-gray-600">
                Once your account is deleted, all of its resources and data will be permanently deleted. Before deleting
                your account, please download any data or information that you wish to retain.
            </div>

            <div class="mt-5">
                <arc-danger-button @click="confirmUserDeletion"> Delete Account </arc-danger-button>
            </div>

            <!-- Delete Account Confirmation Modal -->
            <arc-dialog-modal :show="confirmingUserDeletion" @close="closeModal">
                <template #title> Delete Account </template>

                <template #content>
                    Are you sure you want to delete your account? Once your account is deleted, all of its resources and
                    data will be permanently deleted. Please enter your password to confirm you would like to
                    permanently delete your account.

                    <div class="mt-4">
                        <arc-input
                            ref="password"
                            v-model="form.password"
                            type="password"
                            class="mt-1 block w-3/4"
                            placeholder="Password"
                            @keyup.enter="deleteUser"
                        />

                        <arc-input-error :message="form.errors.password" class="mt-2" />
                    </div>
                </template>

                <template #footer>
                    <arc-secondary-button @click="closeModal"> Nevermind </arc-secondary-button>

                    <arc-danger-button
                        class="ml-2"
                        :class="{ 'opacity-25': form.processing }"
                        :disabled="form.processing"
                        @click="deleteUser"
                    >
                        Delete Account
                    </arc-danger-button>
                </template>
            </arc-dialog-modal>
        </template>
    </arc-action-section>
</template>

<script>
import { useForm } from '@inertiajs/vue3'
import ArcActionSection from '@/Components/ActionSection.vue'
import ArcDialogModal from '@/Components/DialogModal.vue'
import ArcDangerButton from '@/Components/DangerButton.vue'
import ArcInput from '@/Components/Input.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcSecondaryButton from '@/Components/SecondaryButton.vue'

export default {
    components: {
        ArcActionSection,
        ArcDangerButton,
        ArcDialogModal,
        ArcInput,
        ArcInputError,
        ArcSecondaryButton,
    },

    data() {
        return {
            confirmingUserDeletion: false,

            form: useForm({
                password: '',
            }),
        }
    },

    methods: {
        confirmUserDeletion() {
            this.confirmingUserDeletion = true

            setTimeout(() => {
                if (this.$refs.password && this.$refs.password.focus) {
                    this.$refs.password.focus()
                }
            }, 250)
        },

        deleteUser() {
            this.form.delete(route('current-user.destroy'), {
                preserveScroll: true,
                onSuccess: () => this.closeModal(),
                onError: () => {
                    if (this.$refs.password && this.$refs.password.focus) {
                        this.$refs.password.focus()
                    }
                },
                onFinish: () => this.form.reset(),
            })
        },

        closeModal() {
            this.confirmingUserDeletion = false

            this.form.reset()
        },
    },
}
</script>
