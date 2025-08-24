<template>
  <!-- Modern minimal wrapper that enhances auth pages -->
  <div class="min-h-screen bg-gradient-to-br from-indigo-50 via-white to-purple-50">
    <!-- Optional Navigation -->
    <div v-if="showNavigation" class="relative z-10">
      <StoreNavBar />
    </div>

    <!-- Main Content Area -->
    <div class="flex items-center justify-center py-12 px-4 sm:px-6 lg:px-8">
      <div class="w-full max-w-md">
        <!-- Content Slot - Auth pages render their own modern cards -->
        <slot />
      </div>
    </div>

    <!-- Optional Footer -->
    <div v-if="showFooter && $page.props.homePageSettings?.enable_footer" class="relative z-10">
      <StoreFooter :footer-settings="$page.props.footerSettings" />
    </div>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { usePage } from '@inertiajs/vue3'
import StoreFooter from '@/Components/Layout/StoreFooter.vue'
import StoreNavBar from '@/Components/Layout/StoreNavBar.vue'

// Props with defaults for optional layout elements
const props = defineProps({
  canLogin: {
    type: Boolean,
    default: false
  },
  canRegister: {
    type: Boolean,
    default: false
  },
  showNavigation: {
    type: Boolean,
    default: false // Default to false since auth pages are self-contained
  },
  showFooter: {
    type: Boolean,
    default: false // Default to false since auth pages are self-contained
  }
})

// Access page props
const page = usePage()

// Computed properties for conditional rendering
const shouldShowNavigation = computed(() => {
  return props.showNavigation || page.props.value.showAuthNavigation
})

const shouldShowFooter = computed(() => {
  return props.showFooter || page.props.value.showAuthFooter
})
</script>

<style scoped>
/* Ensure smooth transitions and modern styling */
.min-h-screen {
  min-height: 100vh;
  min-height: 100dvh; /* Dynamic viewport height for mobile */
}

/* Modern gradient background that matches auth pages */
.bg-gradient-to-br {
  background-image: linear-gradient(to bottom right, var(--tw-gradient-stops));
}

/* Ensure proper stacking context */
.relative {
  position: relative;
}

.z-10 {
  z-index: 10;
}

/* Responsive spacing adjustments */
@media (max-width: 640px) {
  .py-12 {
    padding-top: 2rem;
    padding-bottom: 2rem;
  }
}

/* Enhanced accessibility */
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}

/* Dark mode support (if needed in future) */
@media (prefers-color-scheme: dark) {
  .bg-gradient-to-br {
    /* Keep light theme for auth pages for now */
  }
}
</style>
