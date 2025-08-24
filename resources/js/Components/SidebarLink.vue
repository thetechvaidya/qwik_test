<template>
    <Link
        :class="{ 'text-green-400': active }"
        :href="url"
        class="flex items-center px-4 py-3 transition cursor-pointer group hover:bg-gray-800 hover:text-gray-200"
    >
        <slot name="icon"></slot>
        <span>{{ __(title) }}</span>
    </Link>
</template>
<script setup>
import { computed, getCurrentInstance } from 'vue'
import { Link } from '@inertiajs/vue3'
import { usePage } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    title: String,
    url: String,
})

// Composables
const { __ } = useTranslate()
const page = usePage()

// Computed properties
const active = computed(() => {
    // Early return if url is not provided
    if (!props.url) return false

    let targetPath
    try {
        targetPath = new URL(props.url, window.location.origin).pathname.replace(/\/$/, '')
    } catch {
        return false
    }

    // Normalize current path by removing query strings, hash, and trailing slashes
    const currentPath = page.url.split('?')[0].split('#')[0].replace(/\/$/, '')

    // Exact match first
    if (currentPath === targetPath) {
        return true
    }

    // Prefix match for nested routes (only if target path is not root)
    if (targetPath !== '' && targetPath !== '/') {
        return currentPath.startsWith(targetPath + '/')
    }

    return false
})
</script>
