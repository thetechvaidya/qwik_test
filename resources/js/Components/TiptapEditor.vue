<template>
    <div class="tiptap-editor" :class="{ 'p-invalid': invalid }">
        <div v-if="showToolbar && editor" class="tiptap-toolbar" :class="{ 'tiptap-toolbar-rtl': isRTL }">
            <!-- Text Formatting -->
            <button
                type="button"
                :disabled="!editor?.can().chain().focus().toggleBold().run()"
                :class="{ 'is-active': editor?.isActive('bold') }"
                class="tiptap-btn"
                @click="editor?.chain().focus().toggleBold().run()"
            >
                <i class="pi pi-bold"></i>
            </button>

            <button
                type="button"
                :disabled="!editor?.can().chain().focus().toggleItalic().run()"
                :class="{ 'is-active': editor?.isActive('italic') }"
                class="tiptap-btn"
                @click="editor?.chain().focus().toggleItalic().run()"
            >
                <i class="pi pi-italic"></i>
            </button>

            <button
                type="button"
                :disabled="!editor?.can().chain().focus().toggleUnderline().run()"
                :class="{ 'is-active': editor?.isActive('underline') }"
                class="tiptap-btn"
                @click="editor?.chain().focus().toggleUnderline().run()"
            >
                <i class="pi pi-underline"></i>
            </button>

            <div class="tiptap-divider"></div>

            <!-- Subscript/Superscript -->
            <button
                type="button"
                :disabled="!editor?.can().chain().focus().toggleSubscript().run()"
                :class="{ 'is-active': editor?.isActive('subscript') }"
                class="tiptap-btn"
                title="Subscript"
                @click="editor?.chain().focus().toggleSubscript().run()"
            >
                X<sub>2</sub>
            </button>

            <button
                type="button"
                :disabled="!editor.can().chain().focus().toggleSuperscript().run()"
                :class="{ 'is-active': editor.isActive('superscript') }"
                class="tiptap-btn"
                title="Superscript"
                @click="editor?.chain().focus().toggleSuperscript().run()"
            >
                X<sup>2</sup>
            </button>

            <!-- Text Color and Highlight (Advanced only) -->
            <template v-if="showColorFeatures">
                <button type="button" class="tiptap-btn" title="Text Color" @click="setTextColor">
                    <i class="pi pi-palette" style="color: #3b82f6"></i>
                </button>

                <button
                    v-if="showHighlightFeature"
                    type="button"
                    :class="{ 'is-active': editor.isActive('highlight') }"
                    class="tiptap-btn"
                    title="Highlight Text"
                    @click="editor.chain().focus().toggleHighlight({ color: '#fef08a' }).run()"
                >
                    <i class="pi pi-bookmark"></i>
                </button>
            </template>

            <div class="tiptap-divider"></div>

            <!-- Text Alignment -->
            <button
                type="button"
                :class="{ 'is-active': editor.isActive({ textAlign: 'left' }) }"
                class="tiptap-btn"
                @click="editor.chain().focus().setTextAlign('left').run()"
            >
                <i class="pi pi-align-left"></i>
            </button>

            <button
                type="button"
                :class="{ 'is-active': editor.isActive({ textAlign: 'center' }) }"
                class="tiptap-btn"
                @click="editor.chain().focus().setTextAlign('center').run()"
            >
                <i class="pi pi-align-center"></i>
            </button>

            <button
                type="button"
                :class="{ 'is-active': editor.isActive({ textAlign: 'right' }) }"
                class="tiptap-btn"
                @click="editor.chain().focus().setTextAlign('right').run()"
            >
                <i class="pi pi-align-right"></i>
            </button>

            <div class="tiptap-divider"></div>

            <!-- Lists -->
            <button
                type="button"
                :class="{ 'is-active': editor.isActive('bulletList') }"
                class="tiptap-btn"
                @click="editor.chain().focus().toggleBulletList().run()"
            >
                <i class="pi pi-list"></i>
            </button>

            <button
                type="button"
                :class="{ 'is-active': editor.isActive('orderedList') }"
                class="tiptap-btn"
                @click="editor.chain().focus().toggleOrderedList().run()"
            >
                <i class="pi pi-sort-numeric-up"></i>
            </button>

            <div v-if="showAdvanced" class="tiptap-divider"></div>

            <!-- Advanced Features -->
            <template v-if="showAdvanced">
                <!-- Mathematics -->
                <button type="button" class="tiptap-btn" title="Insert Math (KaTeX)" @click="insertMath">
                    <i class="pi pi-calculator"></i>
                </button>

                <!-- Image Upload -->
                <button type="button" class="tiptap-btn" title="Insert Image" @click="triggerImageUpload">
                    <i class="pi pi-image"></i>
                </button>

                <!-- Link -->
                <button
                    type="button"
                    :class="{ 'is-active': editor.isActive('link') }"
                    class="tiptap-btn"
                    title="Add Link"
                    @click="setLink"
                >
                    <i class="pi pi-link"></i>
                </button>

                <input
                    ref="imageInput"
                    type="file"
                    accept="image/*"
                    style="display: none"
                    @change="handleImageUpload"
                />
            </template>
        </div>

        <editor-content
            :editor="editor"
            :class="[
                'tiptap-content',
                {
                    'tiptap-content-rtl': isRTL,
                    'tiptap-scroll': hasFixedHeight,
                    'p-invalid': invalid,
                },
            ]"
            :style="editorStyles"
        />

        <!-- LaTeX Equation Dialog -->
        <Dialog
            v-model:visible="showLatexDialog"
            modal
            header="Insert LaTeX Equation"
            :style="{ width: '500px' }"
            @hide="resetLatexForm"
        >
            <div class="flex flex-col gap-4">
                <label for="latex-input" class="font-medium">LaTeX Expression:</label>
                <Textarea
                    id="latex-input"
                    v-model="latexInput"
                    placeholder="e.g., E = mc^2 or \frac{a}{b}"
                    rows="3"
                    class="w-full"
                />
                <div class="text-sm text-gray-600"> Preview: <span class="ml-2" v-html="latexPreview"></span> </div>
            </div>
            <template #footer>
                <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="showLatexDialog = false" />
                <Button label="Insert" icon="pi pi-check" :disabled="!latexInput.trim()" @click="insertLatexEquation" />
            </template>
        </Dialog>

        <!-- URL Link Dialog -->
        <Dialog
            v-model:visible="showLinkDialog"
            modal
            header="Insert/Edit Link"
            :style="{ width: '450px' }"
            @hide="resetLinkForm"
        >
            <div class="flex flex-col gap-4">
                <label for="url-input" class="font-medium">URL:</label>
                <InputText id="url-input" v-model="linkInput" placeholder="https://example.com" class="w-full" />
                <div class="text-sm text-gray-600"> Enter a complete URL starting with http:// or https:// </div>
            </div>
            <template #footer>
                <Button
                    v-if="hasExistingLink"
                    label="Remove Link"
                    icon="pi pi-trash"
                    class="p-button-text p-button-danger"
                    @click="removeLinkFromSelection"
                />
                <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="showLinkDialog = false" />
                <Button label="Apply" icon="pi pi-check" :disabled="!linkInput.trim()" @click="applyLinkToSelection" />
            </template>
        </Dialog>

        <!-- Color Picker Dialog -->
        <Dialog
            v-model:visible="showColorDialog"
            modal
            header="Choose Text Color"
            :style="{ width: '320px' }"
            @hide="resetColorForm"
        >
            <div class="flex flex-col gap-4">
                <div class="flex justify-center">
                    <ColorPicker v-model="selectedColor" format="hex" :inline="true" @change="onColorChange" />
                </div>
                <div class="flex items-center gap-2">
                    <label for="color-input" class="font-medium">Hex Color:</label>
                    <InputText
                        id="color-input"
                        v-model="colorInput"
                        placeholder="#000000"
                        class="flex-1"
                        @input="onColorInputChange"
                    />
                </div>
                <div class="text-sm text-gray-600">
                    Preview: <span :style="{ color: colorInput || '#000000' }">Sample Text</span>
                </div>
            </div>
            <template #footer>
                <Button
                    label="Remove Color"
                    icon="pi pi-trash"
                    class="p-button-text p-button-danger"
                    @click="removeColorFromSelection"
                />
                <Button label="Cancel" icon="pi pi-times" class="p-button-text" @click="showColorDialog = false" />
                <Button label="Apply" icon="pi pi-check" :disabled="!colorInput" @click="applyColorToSelection" />
            </template>
        </Dialog>
    </div>
</template>

<script>
import { Editor, EditorContent } from '@tiptap/vue-3'
import StarterKit from '@tiptap/starter-kit'
import Mathematics from '@tiptap/extension-mathematics'
import Image from '@tiptap/extension-image'
import Link from '@tiptap/extension-link'
import TextDirection from 'tiptap-text-direction-extension'
import Subscript from '@tiptap/extension-subscript'
import Superscript from '@tiptap/extension-superscript'
import TextAlign from '@tiptap/extension-text-align'
import Underline from '@tiptap/extension-underline'
import Placeholder from '@tiptap/extension-placeholder'
import TextStyle from '@tiptap/extension-text-style'
import Color from '@tiptap/extension-color'
import Highlight from '@tiptap/extension-highlight'
import Dialog from 'primevue/dialog'
import Button from 'primevue/button'
import InputText from 'primevue/inputtext'
import Textarea from 'primevue/textarea'
import ColorPicker from 'primevue/colorpicker'

export default {
    name: 'TiptapEditor',

    // SECURITY NOTE: This component includes client-side link validation but
    // server-side HTML sanitization is still required before persisting content.
    // Consider integrating DOMPurify or similar sanitization on the server side
    // to prevent XSS attacks and ensure content security.

    components: {
        EditorContent,
        Dialog,
        Button,
        InputText,
        Textarea,
        ColorPicker,
    },

    props: {
        modelValue: {
            type: String,
            default: '',
        },
        config: {
            type: Object,
            default: () => ({}),
        },
        invalid: {
            type: Boolean,
            default: false,
        },
        height: {
            type: String,
            default: 'auto',
        },
        placeholder: {
            type: String,
            default: '',
        },
    },

    data() {
        return {
            editor: null,
            mathRenderTimer: null,
            // Dialog states
            showLatexDialog: false,
            showLinkDialog: false,
            showColorDialog: false,
            // Form inputs
            latexInput: '',
            linkInput: '',
            colorInput: '#000000',
            selectedColor: '#000000',
            hasExistingLink: false,
        }
    },

    computed: {
        isRTL() {
            return this.config.rtl || this.$page?.props?.rtl || false
        },

        showToolbar() {
            return this.config.toolbar !== false
        },

        showAdvanced() {
            // Show advanced features unless explicitly disabled
            return this.config.toolbar !== 'basic'
        },

        showColorFeatures() {
            // Show color/highlight features if enabled in advanced mode
            const advancedMode = this.showAdvanced
            if (this.config.features) {
                return advancedMode && this.config.features.color !== false
            }
            return advancedMode
        },

        showHighlightFeature() {
            // Show highlight feature if enabled
            const advancedMode = this.showAdvanced
            if (this.config.features) {
                return advancedMode && this.config.features.highlight !== false
            }
            return advancedMode
        },

        hasFixedHeight() {
            const resolvedHeight = this.height || this.config.height
            return resolvedHeight && resolvedHeight !== 'auto'
        },

        editorStyles() {
            const styles = {}
            const resolvedHeight = this.height || this.config.height
            if (resolvedHeight && resolvedHeight !== 'auto') {
                styles.height = resolvedHeight
                // Remove minHeight duplication, rely on CSS class
            }
            return styles
        },

        resolvedPlaceholder() {
            return this.placeholder || this.config.placeholder || ''
        },

        latexPreview() {
            if (!this.latexInput.trim()) return ''
            // Simple preview - could be enhanced with actual KaTeX rendering
            return `<code>\\(${this.latexInput}\\)</code>`
        },
    },

    watch: {
        modelValue: {
            handler(value) {
                if (this.editor && value !== this.editor.getHTML()) {
                    this.editor.commands.setContent(value, false)
                }
            },
            immediate: true,
        },
        'config.rtl'(val) {
            if (!this.editor) return
            this.editor.setOptions({ editorProps: { attributes: { dir: val ? 'rtl' : 'ltr' } } })
            this.editor.commands.setTextDirection(val ? 'rtl' : 'ltr')
        },
        resolvedPlaceholder(newPlaceholder) {
            if (!this.editor) return
            // Persist current HTML content across re-initialization
            const currentHTML = this.editor.getHTML()
            this.editor.destroy()
            this.initEditor()
            // Restore content after re-init
            if (currentHTML) {
                this.editor.commands.setContent(currentHTML, false)
            }
        },
    },

    mounted() {
        this.initEditor()
    },

    beforeUnmount() {
        if (this.mathRenderTimer) {
            clearTimeout(this.mathRenderTimer)
        }
        if (this.editor) {
            this.editor.destroy()
        }
    },

    methods: {
        initEditor() {
            this.editor = new Editor({
                content: this.modelValue,
                extensions: [
                    StarterKit.configure({
                        heading: {
                            levels: [1, 2, 3, 4, 5, 6],
                        },
                    }),
                    Underline,
                    TextStyle,
                    Color.configure({
                        types: ['textStyle'],
                    }),
                    Highlight.configure({
                        multicolor: true,
                    }),
                    TextAlign.configure({
                        types: ['heading', 'paragraph'],
                    }),
                    TextDirection.configure({
                        types: ['heading', 'paragraph', 'listItem', 'blockquote'],
                    }),
                    Subscript,
                    Superscript,
                    Placeholder.configure({
                        placeholder: this.resolvedPlaceholder,
                    }),
                    Mathematics.configure({
                        HTMLAttributes: {
                            class: 'math-node',
                        },
                        katexOptions: {
                            throwOnError: false,
                        },
                    }),
                    Image.configure({
                        inline: false,
                        allowBase64: false,
                        HTMLAttributes: {
                            class: 'tiptap-image',
                        },
                    }),
                    Link.configure({
                        openOnClick: false,
                        validate: href => {
                            const allowRelativeLinks = this.config?.features?.allowRelativeLinks ?? false
                            if (allowRelativeLinks) {
                                // Allow https, http, mailto, tel, and relative paths
                                return /^(?:https?:|mailto:|tel:|\/)/i.test(href)
                            }
                            // Default: only absolute URLs with approved schemes
                            return /^(?:https?:|mailto:|tel:)/.test(href)
                        },
                        HTMLAttributes: {
                            class: 'tiptap-link',
                            rel: 'noopener noreferrer',
                            target: '_blank',
                        },
                    }),
                ],
                editorProps: {
                    attributes: {
                        class: 'tiptap-prose',
                        dir: this.isRTL ? 'rtl' : 'ltr',
                    },
                },
                onUpdate: ({ editor }) => {
                    this.$emit('update:modelValue', editor.getHTML())
                    if (
                        this.config.useAutoRenderForMath &&
                        typeof window !== 'undefined' &&
                        typeof window.renderMathElements === 'function'
                    ) {
                        // Clear existing timer to debounce
                        if (this.mathRenderTimer) {
                            clearTimeout(this.mathRenderTimer)
                        }
                        // Debounced math re-render scoped to this editor element with forceInsideEditor=true
                        this.mathRenderTimer = setTimeout(() => {
                            if (this.$el) {
                                window.renderMathElements(this.$el, true)
                            }
                        }, 100)
                    }
                },
                onCreate: ({ editor }) => {
                    // Set initial direction if RTL
                    if (this.isRTL) {
                        editor.commands.setTextDirection('rtl')
                    }

                    // Handle legacy math markup conversion
                    if (
                        this.modelValue &&
                        typeof window !== 'undefined' &&
                        typeof window.renderMathElements === 'function'
                    ) {
                        setTimeout(() => {
                            if (this.$el) {
                                // Temporarily render legacy delimiters visually while preserving source HTML
                                window.renderMathElements(this.$el, true)
                            }
                        }, 10)
                    }
                },
            })
        },

        focus() {
            if (this.editor) {
                this.editor.commands.focus()
            }
        },

        reRender() {
            try {
                if (typeof window !== 'undefined' && typeof window.renderMathElements === 'function') {
                    // Clear existing timer for debounce
                    if (this.mathRenderTimer) {
                        clearTimeout(this.mathRenderTimer)
                    }
                    // Scoped math re-render to this editor element with forceInsideEditor=true
                    this.mathRenderTimer = setTimeout(() => {
                        if (this.$el) {
                            window.renderMathElements(this.$el, true)
                        }
                    }, 100)
                }
            } catch (e) {
                console.warn('reRender failed:', e)
            }
        },

        insertMath() {
            // Modern Dialog-based LaTeX input instead of native prompt
            this.latexInput = ''
            this.showLatexDialog = true
        },

        insertLatexEquation() {
            if (!this.latexInput.trim()) return

            const chain = this.editor.chain().focus()
            if (this.editor.commands.insertInlineMath) {
                chain.insertInlineMath({ latex: this.latexInput }).run()
            } else if (this.editor.commands.insertBlockMath) {
                chain.insertBlockMath({ latex: this.latexInput }).run()
            } else {
                // Fallback: insert as formatted text
                chain.insertContent(`\\(${this.latexInput}\\)`).run()
            }

            this.showLatexDialog = false
            this.latexInput = ''
        },

        resetLatexForm() {
            this.latexInput = ''
        },

        setLink() {
            const previousUrl = this.editor.getAttributes('link').href
            this.linkInput = previousUrl || ''
            this.hasExistingLink = !!previousUrl
            this.showLinkDialog = true
        },

        applyLinkToSelection() {
            const url = this.linkInput.trim()
            if (!url) return

            // Apply the link
            this.editor.chain().focus().extendMarkRange('link').setLink({ href: url }).run()
            this.showLinkDialog = false
            this.resetLinkForm()
        },

        removeLinkFromSelection() {
            this.editor.chain().focus().extendMarkRange('link').unsetLink().run()
            this.showLinkDialog = false
            this.resetLinkForm()
        },

        resetLinkForm() {
            this.linkInput = ''
            this.hasExistingLink = false
        },

        setTextColor() {
            const currentColor = this.editor.getAttributes('textStyle').color || '#000000'
            this.colorInput = currentColor
            this.selectedColor = currentColor
            this.showColorDialog = true
        },

        onColorChange(event) {
            // Update input when color picker changes
            this.colorInput = event.value
        },

        onColorInputChange() {
            // Update color picker when input changes (if valid hex)
            if (/^#[0-9A-Fa-f]{6}$/.test(this.colorInput)) {
                this.selectedColor = this.colorInput
            }
        },

        applyColorToSelection() {
            const color = this.colorInput.trim()
            if (!color) return

            this.editor.chain().focus().setColor(color).run()
            this.showColorDialog = false
            this.resetColorForm()
        },

        removeColorFromSelection() {
            this.editor.chain().focus().unsetColor().run()
            this.showColorDialog = false
            this.resetColorForm()
        },

        resetColorForm() {
            this.colorInput = '#000000'
            this.selectedColor = '#000000'
        },

        triggerImageUpload() {
            this.$refs.imageInput.click()
        },

        async handleImageUpload(event) {
            const file = event.target.files[0]
            if (!file) return

            const formData = new FormData()
            // Send both field names to ensure backend compatibility
            formData.append('file', file)
            formData.append('upload', file)

            try {
                const csrfEl = document.querySelector('meta[name="csrf-token"]')
                const csrf = csrfEl?.getAttribute('content') || ''
                const headers = { 'X-Requested-With': 'XMLHttpRequest' }

                if (csrf) {
                    headers['X-CSRF-TOKEN'] = csrf
                } else {
                    console.warn('CSRF token not found in meta tag, proceeding with cookie-based CSRF protection')
                }

                const response = await fetch('/admin/file-manager/upload', {
                    method: 'POST',
                    body: formData,
                    headers: headers,
                })

                let data
                try {
                    data = await response.json()
                } catch (jsonError) {
                    // Handle non-JSON responses
                    const text = await response.text()
                    throw new Error(`Server returned non-JSON response: ${text}`)
                }

                // Handle validation errors (422 status)
                if (response.status === 422) {
                    let errorMessage = 'Validation failed'

                    if (data.errors && typeof data.errors === 'object') {
                        const validationMessages = Object.values(data.errors).flat()
                        errorMessage = validationMessages.join(', ')
                    } else if (data.message) {
                        errorMessage = data.message
                    } else if (data.error) {
                        errorMessage = data.error
                    }

                    // Show user-friendly message via toast if available, otherwise alert
                    if (this.$toast) {
                        this.$toast.add({
                            severity: 'error',
                            summary: 'Upload Failed',
                            detail: errorMessage,
                            life: 5000,
                        })
                    } else {
                        alert(`Upload validation error: ${errorMessage}`)
                    }
                    return
                }

                if (!response.ok) {
                    const errorMessage = data.message || data.error || `HTTP error! status: ${response.status}`
                    throw new Error(errorMessage)
                }

                // Support common response formats
                const url = data.url || data.location || data.link || data?.data?.url
                if (url) {
                    this.editor.chain().focus().setImage({ src: url }).run()
                } else {
                    console.error('Upload response:', data)
                    throw new Error('Unexpected upload response: ' + JSON.stringify(data))
                }
            } catch (error) {
                console.error('Image upload failed:', error)

                // Extract meaningful error message
                let errorMessage = 'Failed to upload image. Please try again.'
                if (error.message && !error.message.includes('Failed to fetch')) {
                    errorMessage = error.message
                }

                // Show user-friendly message via toast if available, otherwise alert
                if (this.$toast) {
                    this.$toast.add({
                        severity: 'error',
                        summary: 'Upload Failed',
                        detail: errorMessage,
                        life: 5000,
                    })
                } else {
                    // Fallback for when toast is not available
                    alert(`Upload Failed: ${errorMessage}`)
                }
            } finally {
                // Reset input
                event.target.value = ''
            }
        },
    },
}
</script>

<style scoped>
.tiptap-editor {
    border: 1px solid #d1d5db;
    border-radius: 6px;
    background: white;
}

.tiptap-editor.p-invalid {
    border-color: #ef4444;
}

.tiptap-toolbar {
    display: flex;
    align-items: center;
    gap: 4px;
    padding: 8px 12px;
    border-bottom: 1px solid #e5e7eb;
    background: #f9fafb;
    border-radius: 6px 6px 0 0;
    flex-wrap: wrap;
}

.tiptap-toolbar-rtl {
    direction: rtl;
}

.tiptap-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    width: 32px;
    height: 32px;
    border: 1px solid transparent;
    border-radius: 4px;
    background: transparent;
    cursor: pointer;
    font-size: 14px;
    transition: all 0.2s;
}

.tiptap-btn:hover {
    background: #e5e7eb;
    border-color: #d1d5db;
}

.tiptap-btn.is-active {
    background: #3b82f6;
    color: white;
    border-color: #2563eb;
}

.tiptap-btn:disabled {
    opacity: 0.5;
    cursor: not-allowed;
}

.tiptap-divider {
    width: 1px;
    height: 20px;
    background: #d1d5db;
    margin: 0 4px;
}

.tiptap-content {
    min-height: 120px;
    padding: 12px;
}

.tiptap-content.tiptap-scroll {
    min-height: inherit;
    overflow-y: auto;
}

.tiptap-content.p-invalid {
    border-color: #ef4444;
}

.tiptap-content-rtl {
    direction: rtl;
}

/* Editor Content Styles */
.tiptap-content :deep(.ProseMirror) {
    outline: none;
    min-height: inherit;
}

.tiptap-content :deep(.ProseMirror p) {
    margin: 0 0 8px 0;
}

.tiptap-content :deep(.ProseMirror p:last-child) {
    margin-bottom: 0;
}

.tiptap-content :deep(.ProseMirror ul),
.tiptap-content :deep(.ProseMirror ol) {
    margin: 8px 0;
    padding-left: 20px;
}

.tiptap-content :deep(.ProseMirror li) {
    margin: 4px 0;
}

.tiptap-content :deep(.ProseMirror strong) {
    font-weight: bold;
}

.tiptap-content :deep(.ProseMirror em) {
    font-style: italic;
}

.tiptap-content :deep(.ProseMirror u) {
    text-decoration: underline;
}

.tiptap-content :deep(.ProseMirror sub) {
    vertical-align: sub;
    font-size: smaller;
}

.tiptap-content :deep(.ProseMirror sup) {
    vertical-align: super;
    font-size: smaller;
}

.tiptap-content :deep(.math-node) {
    display: inline-block;
    background: #f3f4f6;
    padding: 2px 4px;
    border-radius: 3px;
    margin: 0 2px;
}

.tiptap-content :deep(.tiptap-image) {
    max-width: 100%;
    height: auto;
    border-radius: 4px;
    margin: 8px 0;
}

.tiptap-content :deep(.tiptap-link) {
    color: #3b82f6;
    text-decoration: underline;
    cursor: pointer;
}

.tiptap-content :deep(.tiptap-link:hover) {
    color: #2563eb;
}

/* RTL Styles */
.tiptap-content-rtl :deep(.ProseMirror ul),
.tiptap-content-rtl :deep(.ProseMirror ol) {
    padding-left: 0;
    padding-right: 20px;
}

/* Dialog Styles */
.tiptap-editor :deep(.p-dialog-header) {
    background: #f8f9fa;
    border-bottom: 1px solid #e9ecef;
}

.tiptap-editor :deep(.p-dialog-content) {
    padding: 1.5rem;
}

.tiptap-editor :deep(.p-dialog-footer) {
    padding: 1rem 1.5rem;
    border-top: 1px solid #e9ecef;
    gap: 0.5rem;
    display: flex;
    justify-content: flex-end;
}

.tiptap-editor :deep(.p-colorpicker) {
    border: none;
}

.tiptap-editor :deep(.p-colorpicker-panel) {
    border: 1px solid #dee2e6;
    border-radius: 6px;
}
</style>
