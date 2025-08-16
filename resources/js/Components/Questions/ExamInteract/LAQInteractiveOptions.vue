<template>
	<div ref="rootEl" class="q-inputs">
		<div class="font-mono px-2 py-1 inline-block bg-gray-100 text-gray-600 rounded text-sm mb-2">
			{{ __('laq_hint') }}
		</template>
		<div :class="labelClass()">
			<div class="i-id">
				<label :for="question_id">A</label>
			</template>
			<textarea :id="question_id" v-model="answer" @change="selectAnswer" rows="5" class="w-full p-2 border rounded" placeholder="Type your detailed answer"></textarea>
		</template>
    
</template>
<script setup>
	import { ref, watch, onMounted, nextTick } from 'vue'
	import { useMathRender } from '@/composables/useMathRender'
	import { useTranslate } from '@/composables/useTranslate'

	const props = defineProps({
		parentQid: [Number, String],
		parentOptions: [String, Array, Number],
		parentAnswer: [String, Array, Number],
		status: String,
	})

	const emit = defineEmits(['modifyAnswer'])
	const { __ } = useTranslate()

	const question_id = ref(props.parentQid)
	const answer = ref(props.parentAnswer || '')

	watch(() => props.parentAnswer, (val) => {
		answer.value = val || ''
	})

	const selectAnswer = () => {
		emit('modifyAnswer', answer.value)
	}

	const labelClass = () => {
		return (answer.value !== '' && answer.value !== null) ? 'q-input answered' : 'q-input'
	}

	const rootEl = ref(null)
	const { renderMath } = useMathRender()
	onMounted(async () => {
		await nextTick()
		if (rootEl.value) await renderMath(rootEl.value)
	})
</script>
