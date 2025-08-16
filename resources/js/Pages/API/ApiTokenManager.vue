<template>
    <div>
        <!-- Generate API Token -->
        <arc-form-section @submitted="createApiToken">
            <template #title> Create API Token </template>

            <template #description>
                API tokens allow third-party services to authenticate with our application on your behalf.
            </template>

            <template #form>
                <!-- Token Name -->
                <div class="col-span-6 sm:col-span-4">
                    <arc-label for="name" value="Name" />
                    <arc-input
                        id="name"
                        v-model="createApiTokenForm.name"
                        type="text"
                        class="mt-1 block w-full"
                        autofocus
                    />
                    <arc-input-error :message="createApiTokenForm.errors.name" class="mt-2" />
                </div>

                <!-- Token Permissions -->
                <div v-if="availablePermissions.length > 0" class="col-span-6">
                    <arc-label for="permissions" value="Permissions" />

                    <div class="mt-2 grid grid-cols-1 md:grid-cols-2 gap-4">
                        <div v-for="permission in availablePermissions" :key="permission">
                            <label class="flex items-center">
                                <arc-checkbox v-model="createApiTokenForm.permissions" :value="permission" />
                                <span class="ml-2 text-gray-600">{{ permission }}</span>
                            </label>
                        </div>
                    </div>
                </div>
            </template>

            <template #actions>
                <arc-action-message :on="createApiTokenForm.recentlySuccessful" class="mr-3">
                    Created.
                </arc-action-message>

                <arc-button
                    :class="{ 'opacity-25': createApiTokenForm.processing }"
                    :disabled="createApiTokenForm.processing"
                >
                    Create
                </arc-button>
            </template>
        </arc-form-section>

        <div v-if="tokens.length > 0">
            <arc-section-border />

            <!-- Manage API Tokens -->
            <div class="mt-10 sm:mt-0">
                <arc-action-section>
                    <template #title> Manage API Tokens </template>

                    <template #description>
                        You may delete any of your existing tokens if they are no longer needed.
                    </template>

                    <!-- API Token List -->
                    <template #content>
                        <div class="space-y-6">
                            <div v-for="token in tokens" :key="token.id" class="flex items-center justify-between">
                                <div>
                                    {{ token.name }}
                                </div>

                                <div class="flex items-center">
                                    <div v-if="token.last_used_ago" class="text-gray-400">
                                        Last used {{ token.last_used_ago }}
                                    </div>

                                    <button
                                        v-if="availablePermissions.length > 0"
                                        class="cursor-pointer ml-6 text-gray-400 underline"
                                        @click="manageApiTokenPermissions(token)"
                                    >
                                        Permissions
                                    </button>

                                    <button
                                        class="cursor-pointer ml-6 text-red-500"
                                        @click="confirmApiTokenDeletion(token)"
                                    >
                                        Delete
                                    </button>
                                </div>
                            </div>
                        </div>
                    </template>
                </arc-action-section>
            </div>
        </div>

        <!-- Token Value Modal -->
        <arc-dialog-modal :show="displayingToken" @close="displayingToken = false">
            <template #title> API Token </template>

            <template #content>
                <div> Please copy your new API token. For your security, it won't be shown again. </div>

                <div
                    v-if="page.props.jetstream.flash.token"
                    class="mt-4 bg-gray-100 px-4 py-2 rounded font-mono text-gray-500"
                >
                    {{ page.props.jetstream.flash.token }}
                </div>
            </template>

            <template #footer>
                <arc-secondary-button @click="displayingToken = false"> Close </arc-secondary-button>
            </template>
        </arc-dialog-modal>

        <!-- API Token Permissions Modal -->
        <arc-dialog-modal :show="managingPermissionsFor" @close="managingPermissionsFor = null">
            <template #title> API Token Permissions </template>

            <template #content>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div v-for="permission in availablePermissions" :key="permission">
                        <label class="flex items-center">
                            <arc-checkbox v-model="updateApiTokenForm.permissions" :value="permission" />
                            <span class="ml-2 text-gray-600">{{ permission }}</span>
                        </label>
                    </div>
                </div>
            </template>

            <template #footer>
                <arc-secondary-button @click="managingPermissionsFor = null"> Nevermind </arc-secondary-button>

                <arc-button
                    class="ml-2"
                    :class="{ 'opacity-25': updateApiTokenForm.processing }"
                    :disabled="updateApiTokenForm.processing"
                    @click="updateApiToken"
                >
                    Save
                </arc-button>
            </template>
        </arc-dialog-modal>

        <!-- Delete Token Confirmation Modal -->
        <arc-confirmation-modal :show="apiTokenBeingDeleted" @close="apiTokenBeingDeleted = null">
            <template #title> Delete API Token </template>

            <template #content> Are you sure you would like to delete this API token? </template>

            <template #footer>
                <arc-secondary-button @click="apiTokenBeingDeleted = null"> Nevermind </arc-secondary-button>

                <arc-danger-button
                    class="ml-2"
                    :class="{ 'opacity-25': deleteApiTokenForm.processing }"
                    :disabled="deleteApiTokenForm.processing"
                    @click="deleteApiToken"
                >
                    Delete
                </arc-danger-button>
            </template>
        </arc-confirmation-modal>
    </div>
</template>

<script setup>
import { ref } from 'vue'
import { useForm, usePage } from '@inertiajs/vue3'
import ArcActionMessage from '@/Components/ActionMessage.vue'
import ArcActionSection from '@/Components/ActionSection.vue'
import ArcButton from '@/Components/Button.vue'
import ArcConfirmationModal from '@/Components/ConfirmationModal.vue'
import ArcDangerButton from '@/Components/DangerButton.vue'
import ArcDialogModal from '@/Components/DialogModal.vue'
import ArcFormSection from '@/Components/FormSection.vue'
import ArcInput from '@/Components/Input.vue'
import ArcCheckbox from '@/Components/Checkbox.vue'
import ArcInputError from '@/Components/InputError.vue'
import ArcLabel from '@/Components/Label.vue'
import ArcSecondaryButton from '@/Components/SecondaryButton.vue'
import ArcSectionBorder from '@/Components/SectionBorder.vue'

// Props
const props = defineProps({
    tokens: Array,
    availablePermissions: Array,
    defaultPermissions: Array,
})

// Composables
const page = usePage()

// Reactive data
const displayingToken = ref(false)
const managingPermissionsFor = ref(null)
const apiTokenBeingDeleted = ref(null)

// Forms
const createApiTokenForm = useForm({
    name: '',
    permissions: props.defaultPermissions,
})

const updateApiTokenForm = useForm({
    permissions: [],
})

const deleteApiTokenForm = useForm({})

// Methods
const createApiToken = () => {
    createApiTokenForm.post(route('api-tokens.store'), {
        preserveScroll: true,
        onSuccess: () => {
            displayingToken.value = true
            createApiTokenForm.reset()
        },
    })
}

const manageApiTokenPermissions = token => {
    updateApiTokenForm.permissions = token.abilities
    managingPermissionsFor.value = token
}

const updateApiToken = () => {
    updateApiTokenForm.put(route('api-tokens.update', managingPermissionsFor.value), {
        preserveScroll: true,
        preserveState: true,
        onSuccess: () => (managingPermissionsFor.value = null),
    })
}

const confirmApiTokenDeletion = token => {
    apiTokenBeingDeleted.value = token
}

const deleteApiToken = () => {
    deleteApiTokenForm.delete(route('api-tokens.destroy', apiTokenBeingDeleted.value), {
        preserveScroll: true,
        preserveState: true,
        onSuccess: () => (apiTokenBeingDeleted.value = null),
    })
}
</script>
