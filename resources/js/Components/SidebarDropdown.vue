<template>
    <div>
        <div :class="{'text-green-400': open}" class="flex items-center justify-between px-4 py-3 transition cursor-pointer group hover:bg-gray-800 hover:text-gray-200" role="button" @click="open = !open">
            <div class="flex items-center">
                <slot name="icon"></slot>
                <span>{{ __(title) }}</span>
            </div>
            <svg :class="{ 'rotate-90': open }" class="flex-shrink-0 w-4 h-4 ml-2 transition transform" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M7.293 14.707a1 1 0 010-1.414L10.586 10 7.293 6.707a1 1 0 011.414-1.414l4 4a1 1 0 010 1.414l-4 4a1 1 0 01-1.414 0z" clip-rule="evenodd" />
            </svg>
        </div>
        <div v-show="open" class="mb-4">
            <div v-for="item in items" :key="item.url" class="block">
                <Link v-if="item.active" :href="item.url" :class="{'text-green-400': isActive(item.url)}"  class="flex items-center py-2 pl-12 pr-4 transition cursor-pointer hover:bg-gray-800 hover:text-gray-200">
                    {{ __(item.label) }}
                </Link>
            </div>
        </div>
    </div>
</template>
<script setup>
import { ref, computed, onMounted } from 'vue'
import { Link } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'

// Props
const props = defineProps({
    title: String,
    items: Array,
})

// Composables
const { __ } = useTranslate()

// Reactive data
const open = ref(false)

// Computed properties
const urls = computed(() => {
    const arr = []
    props.items.forEach(item => arr.push(item.url))
    return arr
})

// Methods
const isActive = (url) => {
    return window.location.href === url
}

const isOpen = () => {
    return urls.value.includes(window.location.href)
}

// Lifecycle
onMounted(() => {
    open.value = isOpen()
})
</script>
