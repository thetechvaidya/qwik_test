<template>
    <component
        :is="renderAsLink ? 'Link' : 'button'"
        v-bind="renderAsLink ? linkAttrs : buttonAttrs"
        :class="normalizedClass"
    >
        <slot></slot>
    </component>
</template>

<script>
export default {
    inheritAttrs: false,
    props: {
        href: String,
        method: { type: String, default: 'get' },
        data: { type: [Object, Array, FormData], default: () => ({}) },
        as: { type: String, default: 'a' },
        preserveScroll: { type: [Boolean, String], default: undefined },
        preserveState: { type: [Boolean, String], default: undefined },
        replace: { type: [Boolean, String], default: undefined },
        headers: { type: Object, default: () => ({}) },
        only: { type: Array, default: undefined },
    },
    computed: {
        renderAsLink() {
            // Render as Link only if href is provided
            return !!this.href
        },
        normalizedClass() {
            // Merge parent classes with default dropdown classes
            const defaultClasses =
                'text-sm block w-full px-4 py-2 leading-5 text-gray-700 ltr:text-left rtl:text-right hover:bg-gray-100 focus:outline-none focus:bg-gray-100 transition duration-150 ease-in-out'
            const cls = this.$attrs.class

            if (!cls) {
                return defaultClasses
            }

            // Handle array classes
            if (Array.isArray(cls)) {
                return [defaultClasses, ...cls]
            }

            // Handle object classes (e.g., { 'class-name': true })
            if (typeof cls === 'object' && cls !== null) {
                const activeClasses = Object.keys(cls).filter(k => cls[k])
                return [defaultClasses, ...activeClasses]
            }

            // Handle string classes
            return [defaultClasses, cls].filter(Boolean).join(' ')
        },
        attrsWithoutClass() {
            // Remove class and href from attrs to avoid duplication
            const attrs = { ...this.$attrs }
            delete attrs.class
            delete attrs.href
            return attrs
        },

        buttonAttrs() {
            // Remove Link-only props when rendering as button
            const LINK_ONLY_PROPS = [
                'method',
                'data',
                'as',
                'preserve-scroll',
                'preserveScroll',
                'preserve-state',
                'preserveState',
                'only',
                'headers',
                'replace',
            ]
            const attrs = { ...this.attrsWithoutClass }
            LINK_ONLY_PROPS.forEach(k => delete attrs[k])
            return { type: 'button', ...attrs }
        },

        linkAttrs() {
            // Forward all Link props: method, data, as, preserveScroll, preserveState, replace, headers, only
            // Ensure type: 'button' is applied when as === 'button'
            const linkProps = {
                href: this.href,
                method: this.method,
                data: this.data,
                as: this.as,
                preserveScroll: this.preserveScroll,
                preserveState: this.preserveState,
                replace: this.replace,
                headers: this.headers,
                ...(this.only ? { only: this.only } : {}),
                ...(this.as === 'button' ? { type: 'button' } : {}),
                ...this.attrsWithoutClass,
            }
            return linkProps
        },
    },
}
</script>
