// Reusable clipboard mixin leveraging @vueuse/core useClipboard via globalProperties
export default {
    methods: {
        async handleCopyClick(value) {
            try {
                const text = String(value ?? '')
                if (!text) return

                let copied = false
                // Prefer VueUse useClipboard if available via globalProperties
                if (this.$clipboard) {
                    const { copy } = this.$clipboard()
                    if (copy) {
                        await copy(text)
                        copied = true
                    }
                }

                // Fallback to native clipboard
                if (!copied && navigator?.clipboard?.writeText) {
                    await navigator.clipboard.writeText(text)
                    copied = true
                }

                // Legacy fallback
                if (!copied) {
                    const el = document.createElement('textarea')
                    el.value = text
                    el.setAttribute('readonly', '')
                    el.style.position = 'absolute'
                    el.style.left = '-9999px'
                    document.body.appendChild(el)
                    el.select()
                    document.execCommand('copy')
                    document.body.removeChild(el)
                    copied = true
                }

                if (copied && this.$toast) {
                    this.$toast.add({
                        severity: 'success',
                        summary: this.__ ? this.__('Copied') : 'Copied',
                        detail: this.__ ? this.__('Copied Successfully!') : 'Copied Successfully!',
                        life: 2000,
                    })
                }
            } catch (e) {
                if (this.$toast) {
                    this.$toast.add({
                        severity: 'error',
                        summary: this.__ ? this.__('Error') : 'Error',
                        detail: this.__ ? this.__('Copy failed') : 'Copy failed',
                        life: 2000,
                    })
                }
            }
        },
    },
}
