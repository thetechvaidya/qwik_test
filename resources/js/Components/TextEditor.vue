<template>
    <TiptapEditor
        v-bind="$attrs"
        ref="tiptapEditor"
        :model-value="mergedValue"
        :config="editorConfig"
        @update:model-value="updateValue"
    />
</template>

<script>
/**
 * TextEditor.vue - Backward Compatibility Wrapper
 *
 * @deprecated This component is deprecated as of the Tiptap migration (August 2025).
 * New development should import TiptapEditor directly for better performance and features.
 * This wrapper is maintained for backward compatibility only.
 *
 * Migration guide:
 * - Replace `import TextEditor from '@/Components/TextEditor'`
 *   with `import TiptapEditor from '@/Components/TiptapEditor'`
 * - Update component registration accordingly
 * - Review and update any custom configurations
 *
 * @see TIPTAP_MIGRATION_GUIDE.md for complete migration instructions
 */
import TiptapEditor from './TiptapEditor.vue'

export default {
    name: 'TextEditor',
    components: {
        TiptapEditor,
    },
    inheritAttrs: false,
    props: {
        // Vue 3 v-model
        modelValue: {
            type: String,
            default: '',
        },
        // Vue 2 v-model (legacy)
        value: {
            type: String,
            default: '',
        },
        config: {
            type: Object,
            default: () => ({}),
        },
    },
    data() {
        return {
            isUnmounting: false,
        }
    },
    beforeUnmount() {
        this.isUnmounting = true
    },
    computed: {
        mergedValue() {
            // Vue 3 takes precedence over Vue 2
            return this.modelValue !== undefined ? this.modelValue : this.value
        },
        editorConfig() {
            // Map legacy CKEditor config to Tiptap config with standardized toolbar values
            let toolbarValue = this.config.toolbar ?? 'advanced'

            // Normalize legacy boolean values to string presets
            if (toolbarValue === true) {
                toolbarValue = 'advanced'
            } else if (toolbarValue === false) {
                toolbarValue = false // Keep false for no toolbar
            }

            return {
                toolbar: toolbarValue,
                rtl: this.config.language === 'ar' || this.$page?.props?.rtl,
                ...this.config,
            }
        },
    },
    methods: {
        updateValue(newValue) {
            // Emit both Vue 3 and Vue 2 events for compatibility
            this.$emit('update:modelValue', newValue) // Vue 3
            this.$emit('input', newValue) // Vue 2
        },
        focus() {
            if (this.isUnmounting || !this.$refs.tiptapEditor) return
            try {
                this.$refs.tiptapEditor.focus()
            } catch (error) {
                console.warn('TextEditor: Focus error during component transition:', error)
            }
        },
        reRender() {
            if (this.isUnmounting || !this.$refs.tiptapEditor) return
            try {
                this.$refs.tiptapEditor.reRender()
            } catch (error) {
                console.warn('TextEditor: ReRender error during component transition:', error)
            }
        },
    },
}
</script>
