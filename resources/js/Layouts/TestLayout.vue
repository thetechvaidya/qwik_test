<template>
    <div class="min-h-screen bg-gray-50">
        <!-- Modern Navigation -->
        <StoreNavBar :show-search="true" />
        
        <!-- Main Content -->
        <main class="pt-20">
            <slot />
        </main>
        
        <!-- Modern Footer -->
        <StoreFooter :footer-settings="footerSettings" />
    </div>
</template>

<script setup>
import StoreNavBar from '@/Components/Layout/StoreNavBar.vue'
import StoreFooter from '@/Components/Layout/StoreFooter.vue'

// Mock footer settings for testing
const footerSettings = {
    enable_social_links: true,
    enable_links: true,
    social_links: {
        facebook: ['Facebook', true, 'https://facebook.com'],
        twitter: ['Twitter', true, 'https://twitter.com'],
        instagram: ['Instagram', true, 'https://instagram.com'],
        linkedin: ['LinkedIn', true, 'https://linkedin.com'],
    },
    footer_links: [
        ['About Us', '/about', true],
        ['Contact', '/contact', true],
        ['Privacy Policy', '/privacy', true],
    ],
    copyright_text: 'All rights reserved.',
}
</script>