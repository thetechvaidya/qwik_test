<template>
    <div>
        <div class="ltr:ml-0 rtl:mr-0 transition md:ltr:ml-60 md:rtl:mr-60">
            <arc-banner />
        </div>
        <div class="min-h-screen">
            <!-- Modern Sidebar Navigation -->
            <nav
                class="fixed top-0 ltr:left-0 rtl:right-0 z-20 h-full pb-10 overflow-hidden transition origin-left transform bg-gray-900 w-60 md:ltr:translate-x-0 md:rtl:-translate-x-0"
                :class="{ 'ltr:-translate-x-full rtl:translate-x-full': !sidebar, 'translate-x-0': sidebar }"
                @click="sidebar = false"
            >
                <!-- Logo Section -->
                <Link class="flex items-center px-4 py-5" :href="route('welcome')">
                    <QwikTestLogo 
                        :width="150" 
                        :height="40" 
                        class="h-8 w-auto"
                        variant="dark"
                    />
                </Link>
                
                <!-- Navigation Items -->
                <div ref="scroll" class="h-full overflow-y-auto overflow-x-hidden">
                    <nav class="text-sm font-medium pb-16 text-gray-400" aria-label="Main Navigation">
                        <!-- Welcome Section -->
                        <div class="my-4 mx-4 uppercase font-semibold text-green-500 text-xs">
                            {{ __('Student Portal') }}
                        </div>
                        
                        <!-- Dashboard -->
                        <sidebar-link
                            :title="__('Dashboard')"
                            :url="route('user_dashboard')"
                        >
                            <template #icon>
                                <i class="pi pi-th-large mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Learning Section -->
                        <div class="my-4 mx-4 uppercase font-semibold text-green-500 text-xs">
                            {{ __('Learning') }}
                        </div>
                        
                        <!-- Learn & Practice -->
                        <sidebar-link
                            :title="__('Learn & Practice')"
                            :url="route('learn_practice')"
                        >
                            <template #icon>
                                <i class="pi pi-book mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Exams -->
                        <sidebar-link
                            :title="__('Exams')"
                            :url="route('exam_dashboard')"
                        >
                            <template #icon>
                                <i class="pi pi-file-edit mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Quizzes -->
                        <sidebar-link
                            :title="__('Quizzes')"
                            :url="route('quiz_dashboard')"
                        >
                            <template #icon>
                                <i class="pi pi-question-circle mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Progress Section -->
                        <div class="my-4 mx-4 uppercase font-semibold text-green-500 text-xs">
                            {{ __('Progress') }}
                        </div>
                        
                        <!-- My Progress -->
                        <sidebar-link
                            :title="__('My Progress')"
                            :url="route('my_progress')"
                        >
                            <template #icon>
                                <i class="pi pi-chart-line mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Account Section -->
                        <div class="my-4 mx-4 uppercase font-semibold text-green-500 text-xs">
                            {{ __('Account') }}
                        </div>

                        <!-- My Subscriptions -->
                        <sidebar-link
                            :title="__('My Subscriptions')"
                            :url="route('user_subscriptions')"
                        >
                            <template #icon>
                                <i class="pi pi-credit-card mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- My Payments -->
                        <sidebar-link
                            :title="__('My Payments')"
                            :url="route('user_payments')"
                        >
                            <template #icon>
                                <i class="pi pi-wallet mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>

                        <!-- Profile -->
                        <sidebar-link
                            :title="__('Profile Settings')"
                            :url="route('profile.show')"
                        >
                            <template #icon>
                                <i class="pi pi-user mr-3 text-lg"></i>
                            </template>
                        </sidebar-link>
                    </nav>
                </div>
            </nav>
            <!-- Main Content Area -->
            <div class="ltr:ml-0 rtl:mr-0 transition md:ltr:ml-60 md:rtl:mr-60">
                <!-- Top Header Bar -->
                <header class="bg-white shadow flex items-center justify-between w-full md:mx-auto md:sticky md:z-30 md:top-0 px-4 h-14">
                    <!-- Mobile Menu Button -->
                    <button class="block btn btn-light-secondary md:hidden" @click="sidebar = true">
                        <span class="sr-only">{{ __('Menu') }}</span>
                        <i class="pi pi-bars text-lg"></i>
                    </button>
                    
                    <!-- Dashboard Title -->
                    <div class="hidden -ml-3 form-icon md:block w-96">
                        <Link class="text-sm font-semibold px-4 py-5 capitalize" :href="route('user_dashboard')">
                            {{ __('Student Dashboard') }}
                        </Link>
                    </div>
                    
                    <!-- Header Actions -->
                    <div class="flex items-center space-x-4">
                        <!-- Rewards Badge -->
                        <rewards-badge
                            :text-color="'text-indigo-600'"
                            :points="$page.props.user?.wallet_balance ?? 0"
                        />

                        <!-- Notifications -->
                        <button
                            type="button"
                            class="p-2 text-gray-400 hover:text-gray-500 focus:outline-none focus:ring-2 focus:ring-indigo-500 rounded-lg transition-colors"
                        >
                            <span class="sr-only">{{ __('View notifications') }}</span>
                            <i class="pi pi-bell text-lg"></i>
                        </button>

                        <!-- Profile Dropdown -->
                        <div class="relative">
                            <arc-dropdown align="right" width="48">
                                <template #trigger>
                                    <button
                                        v-if="$page.props.jetstream.managesProfilePhotos"
                                        class="flex border-2 border-transparent rounded-full focus:outline-none focus:border-gray-300 transition duration-150 ease-in-out"
                                    >
                                        <img
                                            class="h-8 w-8 rounded-full object-cover"
                                            :src="$page.props.user?.profile_photo_url"
                                            :alt="$page.props.user?.first_name"
                                        />
                                    </button>

                                    <span v-else class="inline-flex rounded-md">
                                        <button
                                            type="button"
                                            class="inline-flex items-center px-3 py-2 border border-transparent leading-4 font-medium rounded-md text-gray-500 bg-white hover:text-gray-700 focus:outline-none transition ease-in-out duration-150"
                                        >
                                            {{ $page.props.user?.first_name }}
                                            <i class="pi pi-chevron-down ml-2 text-sm"></i>
                                        </button>
                                    </span>
                                </template>
                                <template #content>
                                    <!-- Account Management -->
                                    <div class="block px-4 py-2 text-xs text-gray-400">
                                        {{ __('Manage Account') }}
                                    </div>

                                    <arc-dropdown-link :href="route('profile.show')">
                                        {{ __('Profile') }}
                                    </arc-dropdown-link>

                                    <arc-dropdown-link :href="route('user_subscriptions')">
                                        {{ __('My Subscriptions') }}
                                    </arc-dropdown-link>

                                    <arc-dropdown-link :href="route('user_payments')">
                                        {{ __('My Payments') }}
                                    </arc-dropdown-link>

                                    <arc-dropdown-link
                                        v-if="$page.props.jetstream.hasApiFeatures"
                                        :href="route('api-tokens.index')"
                                    >
                                        {{ __('API Tokens') }}
                                    </arc-dropdown-link>

                                    <div class="border-t border-gray-100"></div>

                                    <!-- Authentication -->
                                    <button
                                        type="button"
                                        class="w-full text-sm px-4 py-2 text-gray-700 ltr:text-left rtl:text-right hover:bg-gray-100 focus:outline-none focus:bg-gray-100 transition duration-150 ease-in-out flex items-center justify-between"
                                        @click="handleLogout"
                                        :disabled="loggingOut"
                                    >
                                        <span>{{ __('Logout') }}</span>
                                        <i v-if="loggingOut" class="pi pi-spinner pi-spin text-xs text-gray-500"></i>
                                    </button>
                                </template>
                            </arc-dropdown>
                        </div>
                    </div>
                </header>

                <!-- Page Header Section -->
                <section>
                    <div class="container mx-auto pt-4 px-4 sm:px-6 lg:px-8">
                        <div class="flex flex-col md:flex-row items-start md:items-center justify-between">
                            <div>
                                <slot name="header"></slot>
                            </div>
                            <div class="mb-6 sm:mb-0 sm:mt-0">
                                <slot name="actions"></slot>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- Main Content -->
                <main>
                    <div class="container mx-auto px-4 sm:px-6 lg:px-8">
                        <Message v-if="$page.props.successMessage" severity="success" :closable="false">
                            {{ $page.props.successMessage }}
                        </Message>
                        <Message v-if="$page.props.errorMessage" severity="error" :closable="false">
                            {{ $page.props.errorMessage }}
                        </Message>
                    </div>

                    <slot></slot>
                </main>

                <!-- Modal Portal using Vue 3 Teleport -->
                <teleport to="#modals" :disabled="!modalTargetExists">
                    <!-- Modals will be rendered here -->
                </teleport>

                <ConfirmDialog />
                <Toast :position="$page.props.rtl ? 'bottom-left' : 'bottom-right'" />
                <Toast :position="$page.props.rtl ? 'top-left' : 'top-right'" group="lm" />
            </div>

            <!-- Sidebar Backdrop -->
            <div
                v-show="sidebar"
                class="fixed inset-0 z-10 w-screen h-screen bg-black bg-opacity-25 md:hidden"
                @click="sidebar = false"
            ></div>
        </div>
    </div>
    </div>
</template>

<script>
import { router } from '@inertiajs/vue3'
import ArcBanner from '@/Components/Banner.vue'
import ArcDropdown from '@/Components/Dropdown.vue'
import ArcDropdownLink from '@/Components/DropdownLink.vue'
import Toast from 'primevue/toast'
import ConfirmDialog from 'primevue/confirmdialog'
import RewardsBadge from '@/Components/RewardsBadge.vue'
import Message from 'primevue/message'
import QwikTestLogo from '@/Components/Icons/QwikTestLogo.vue'
import SidebarLink from '@/Components/SidebarLink.vue'
import translate from '@/Mixins/translate.js'

export default {
    components: {
        ArcBanner,
        ArcDropdown,
        ArcDropdownLink,
        Toast,
        ConfirmDialog,
        Message,
        RewardsBadge,
        SidebarLink,
    },

    mixins: [translate],

    props: {
        canLogin: Boolean,
        canRegister: Boolean,
    },

    data() {
        return {
            sidebar: false,
            modalTargetExists: false,
            loggingOut: false,
        }
    },

    mounted() {
        this.checkModalTarget()
        // Watch for DOM changes
        this.modalObserver = new MutationObserver(() => {
            this.checkModalTarget()
        })
        this.modalObserver.observe(document.body, { childList: true, subtree: true })
    },

    beforeUnmount() {
        if (this.modalObserver) {
            this.modalObserver.disconnect()
        }
    },

    methods: {
        checkModalTarget() {
            this.modalTargetExists = !!document.getElementById('modals')
        },



        handleLogout() {
            if (this.loggingOut) {
                return
            }

            this.loggingOut = true

            router.post(route('logout'), {}, {
                onFinish: () => {
                    this.loggingOut = false
                },
            })
        },
    },
}
</script>

<style scoped>
/* Modern styling to match admin layout */
.btn {
    @apply inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md transition ease-in-out duration-150;
}

.btn-light-secondary {
    @apply text-gray-500 bg-white hover:text-gray-700 focus:outline-none focus:border-gray-300 focus:shadow-outline-gray;
}

.form-icon {
    @apply relative;
}

/* Sidebar backdrop transition */
.sidebar-backdrop-enter-active,
.sidebar-backdrop-leave-active {
    transition: opacity 0.3s ease;
}

.sidebar-backdrop-enter-from,
.sidebar-backdrop-leave-to {
    opacity: 0;
}

/* Sidebar slide transition */
.sidebar-enter-active,
.sidebar-leave-active {
    transition: transform 0.3s ease;
}

.sidebar-enter-from,
.sidebar-leave-to {
    transform: translateX(-100%);
}

/* Dark mode support */
@media (prefers-color-scheme: dark) {
    .dark .bg-white {
        @apply bg-gray-800;
    }
    
    .dark .text-gray-700 {
        @apply text-gray-300;
    }
    
    .dark .border-gray-200 {
        @apply border-gray-700;
    }
}
</style>
