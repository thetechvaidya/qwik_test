import { onBeforeUnmount, onMounted, ref } from 'vue'

/**
 * Provides responsive scroll height calculations and a root ref for PrimeVue DataTables.
 *
 * @param {Object} options
 * @param {number} options.viewportOffset - Pixels to subtract from window.innerHeight to determine table height.
 * @param {number} options.minHeight - Minimum scroll height in pixels.
 * @param {number} options.maxHeight - Optional max scroll height in pixels.
 * @returns {{ tableRoot: import('vue').Ref<HTMLElement|null>, scrollHeight: import('vue').Ref<string>, recompute: Function }}
 */
export function useResponsiveDatatable(options = {}) {
    const {
        viewportOffset = 360,
        minHeight = 320,
        maxHeight = null,
    } = options

    const tableRoot = ref(null)
    const scrollHeight = ref(`${minHeight}px`)

    const clamp = (value, min, max) => {
        if (max !== null && max !== undefined) {
            return Math.min(Math.max(value, min), max)
        }
        return Math.max(value, min)
    }

    const recompute = () => {
        if (typeof window === 'undefined') return
        const viewportHeight = window.innerHeight || minHeight
        const calculated = viewportHeight - viewportOffset
        const nextHeight = clamp(calculated, minHeight, maxHeight)
        scrollHeight.value = `${Math.round(nextHeight)}px`
    }

    onMounted(() => {
        recompute()
        window.addEventListener('resize', recompute, { passive: true })
    })

    onBeforeUnmount(() => {
        window.removeEventListener('resize', recompute)
    })

    return {
        tableRoot,
        scrollHeight,
        recompute,
    }
}
