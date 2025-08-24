<template>
    <div class="audio-options">
        <div class="font-mono px-2 py-1 inline-block text-gray-600 rounded text-sm mb-2">
            Read the passage and answer the question
        </div>
        <div ref="comScroll" class="max-h-96 overflow-y-auto overflow-x-hidden">
            <div v-html="passage"></div>
        </div>
    </div>
</template>
<script>
    export default {
        name: 'ComprehensionAttachment',
        props: {
            passage: String,
        }
    }
</script>
