<template>
    <a :href="route('welcome')" class="inline-block">
        <!-- Use QwikTest Logo Component with fallback -->
        <QwikTestLogo 
            v-if="!$page.props.general.logo_path || useDefaultLogo"
            :width="200" 
            :height="60" 
            class="h-12 w-auto"
            :variant="isDark ? 'dark' : 'light'"
        />
        <img
            v-else
            :src="$page.props.assetUrl + $page.props.general.logo_path"
            :alt="$page.props.general.app_name || 'QwikTest'"
            class="h-12 w-auto"
        />
    </a>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import QwikTestLogo from '@/Components/Icons/QwikTestLogo.vue'

// Props
defineProps({
    useDefaultLogo: {
        type: Boolean,
        default: false
    }
})

// Dark mode detection
const isDark = ref(false)

onMounted(() => {
    // Check if dark mode is enabled
    isDark.value = document.documentElement.classList.contains('dark')
    
    // Watch for theme changes
    const observer = new MutationObserver((mutations) => {
        mutations.forEach((mutation) => {
            if (mutation.type === 'attributes' && mutation.attributeName === 'class') {
                isDark.value = document.documentElement.classList.contains('dark')
            }
        })
    })
    
    observer.observe(document.documentElement, {
        attributes: true,
        attributeFilter: ['class']
    })
    
    return () => observer.disconnect()
})
</script>
