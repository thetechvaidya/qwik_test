<template>
    <div ref="rootEl" class="q-data rounded bg-yellow-50 border border-yellow-200 p-6">
        <h4 class="font-semibold text-gray-600 mb-4 uppercase">{{ __('Solution') }}</h4>
        <div v-if="question.solution_video">
            <video-attachment :reference="'player_'+question.code" :options="question.solution_video" :show-message="false"></video-attachment>
        </div>
        <div v-html="question.solution"></div>
    </div>
</template>
<script setup>
    import { ref, onMounted, nextTick } from 'vue'
    import { useMathRender } from '@/composables/useMathRender'
    import VideoAttachment from "@/Components/Questions/Attachments/VideoAttachment";

    defineOptions({ name: 'PracticeSolutionCard' })
    const props = defineProps({
        question: Object
    })

    const rootEl = ref(null)
    const { renderMath } = useMathRender()

    onMounted(async () => {
        await nextTick()
        if (rootEl.value) {
            await renderMath(rootEl.value)
        }
    })
</script>
