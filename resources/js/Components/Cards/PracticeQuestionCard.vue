<template>
    <div ref="rootEl" class="border rounded border-gray-200 bg-gray-50 p-6 shadow-sm">
        <div class="flex gap-2 mb-4">
            <span class="text-sm font-semibold">Q{{ sno }} of {{ totalQuestions }}</span>
            <span class="text-sm">|</span>
            <span class="text-sm text-gray-600 uppercase">{{ question.skill }}</span>
        </div>
        <div v-if="attachmentType != null" class="mb-4">
            <div v-if="attachmentType === 'audio'">
                <audio-attachment :reference="'player_'+question.code" :options="attachment"></audio-attachment>
            </div>
            <div v-if="attachmentType === 'video'">
                <video-attachment :reference="'player_'+question.code" :options="attachment"></video-attachment>
            </div>
            <div v-if="attachmentType === 'comprehension'">
                <comprehension-attachment :passage="attachment"></comprehension-attachment>
            </div>
        </div>
        <div class="q-data question" v-html="question.question">
</template>
<script setup>
    import { ref, nextTick, onMounted } from 'vue'
    import AudioAttachment from "@/Components/Questions/Attachments/AudioAttachment"
    import VideoAttachment from "@/Components/Questions/Attachments/VideoAttachment"
    import ComprehensionAttachment from "@/Components/Questions/Attachments/ComprehensionAttachment"

    // Define component options
    defineOptions({
        name: 'PracticeQuestionCard'
    })

    // Props
    const props = defineProps({
        question: Object,
        sno: Number,
        totalQuestions: Number,
        attachmentType: String,
        attachment: [String, Object]
    })

    // Lifecycle
    onMounted(() => {
        nextTick(() => {
            if (rootEl.value) {
                window.renderMathInElement?.(rootEl.value)
            }
        })
    })

    // Local refs
    const rootEl = ref(null)
</script>
