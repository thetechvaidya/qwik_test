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
<script>
export default {
    name: 'SidebarLink',
    props: {
        title: String,
        url: String,
    },
    computed: {
        active() {
            // Early return if url is not provided
            if (!this.url) return false

            let targetPath
            try {
                targetPath = new URL(this.url, window.location.origin).pathname.replace(/\/$/, '')
            } catch {
                return false
            }

            // Normalize current path by removing query strings, hash, and trailing slashes
            const currentPath = this.$page.url.split('?')[0].split('#')[0].replace(/\/$/, '')

            // Exact match first
            if (currentPath === targetPath) {
                return true
            }

            // Prefix match for nested routes (only if target path is not root)
            if (targetPath !== '' && targetPath !== '/') {
                return currentPath.startsWith(targetPath + '/')
            }

            return false
        },
    },
}
</script>
