import { ref, onMounted, nextTick, onBeforeUnmount } from 'vue'

export function useMathRender() {
    const rendering = ref(false)

    const renderMath = async element => {
        const target = element ?? (typeof document !== 'undefined' ? document : undefined)
        if (rendering.value) return

        // SSR safety guard
        if (typeof window === 'undefined' || typeof document === 'undefined') {
            return
        }

        rendering.value = true

        try {
            await nextTick()

            // Check for KaTeX rendering function
            if (window.renderMathInElement) {
                const targetElement = target === document ? document.body : target

                // Configure rendering options
                const options = {
                    delimiters: [
                        { left: '$$', right: '$$', display: true },
                        { left: '$', right: '$', display: false },
                        { left: '\\[', right: '\\]', display: true },
                        { left: '\\(', right: '\\)', display: false },
                    ],
                    throwOnError: false,
                    errorColor: '#cc0000',
                    strict: 'warn',
                    trust: false,
                    // Ignore elements with tiptap-editor class to avoid conflicts
                    ignoredTags: ['script', 'noscript', 'style', 'textarea', 'pre', 'code'],
                    ignoredClasses: ['tiptap-editor', 'ProseMirror'],
                }

                window.renderMathInElement(targetElement, options)
            }
            // Check for MathJax rendering
            else if (window.MathJax && window.MathJax.typesetPromise) {
                const targetElement = target === document ? [document.body] : [target]
                await window.MathJax.typesetPromise(targetElement)
            }
        } catch (error) {
            console.warn('Math rendering failed:', error)
        } finally {
            rendering.value = false
        }
    }

    const reRenderMath = async (element, delay = 100) => {
        const target = element ?? (typeof document !== 'undefined' ? document : undefined)
        // Add a small delay to allow DOM updates
        return new Promise(resolve => {
            setTimeout(async () => {
                await renderMath(target)
                resolve()
            }, delay)
        })
    }

    const renderMathInTable = async (rootEl = null, delay = 200) => {
        // Specific function for table pagination/filtering
        return new Promise(resolve => {
            setTimeout(async () => {
                try {
                    await nextTick()

                    // SSR safety guard
                    if (typeof document === 'undefined') {
                        resolve()
                        return
                    }

                    if (rootEl) {
                        // Render only within the provided root element
                        await renderMath(rootEl)
                    } else {
                        // Find all table containers
                        const tableContainers = document.querySelectorAll(
                            '.vgt-wrap, .vgt-table, .vgt-inner-wrap, .table-container, [data-table]'
                        )

                        if (tableContainers.length > 0) {
                            for (const container of tableContainers) {
                                await renderMath(container)
                            }
                        } else {
                            await renderMath()
                        }
                    }
                } catch (error) {
                    console.warn('Table math rendering failed:', error)
                } finally {
                    resolve()
                }
            }, delay)
        })
    }

    const observeMathContent = element => {
        // SSR safety guard
        if (!element || typeof window === 'undefined' || typeof MutationObserver === 'undefined') {
            return () => {} // Return no-op cleanup function
        }

        const observer = new MutationObserver(async mutations => {
            let shouldRender = false

            for (const mutation of mutations) {
                if (mutation.type === 'childList') {
                    // Check if added nodes contain math content
                    for (const node of mutation.addedNodes) {
                        if (node.nodeType === Node.ELEMENT_NODE) {
                            const mathContent = node.textContent || ''
                            if (
                                mathContent.includes('$') ||
                                mathContent.includes('\\[') ||
                                mathContent.includes('\\(')
                            ) {
                                shouldRender = true
                                break
                            }
                        }
                    }
                }
            }

            if (shouldRender) {
                await reRenderMath(element)
            }
        })

        observer.observe(element, {
            childList: true,
            subtree: true,
        })

        // Return cleanup function
        return () => {
            observer.disconnect()
        }
    }

    // Helper that wires both observe and auto-cleanup
    const observeMathContentWithCleanup = element => {
        const cleanup = observeMathContent(element)

        onBeforeUnmount(() => {
            cleanup()
        })

        return cleanup
    }

    const initializeMathRendering = element => {
        const target = element ?? (typeof document !== 'undefined' ? document : undefined)
        onMounted(async () => {
            await renderMath(target)
        })
    }

    // Debounced version for frequent updates
    let renderTimeout = null
    const debouncedRenderMath = (element, delay = 300) => {
        const target = element ?? (typeof document !== 'undefined' ? document : undefined)
        if (renderTimeout) {
            clearTimeout(renderTimeout)
        }

        renderTimeout = setTimeout(async () => {
            await renderMath(target)
            renderTimeout = null
        }, delay)
    }

    return {
        rendering,
        renderMath,
        reRenderMath,
        renderMathInTable,
        observeMathContent,
        observeMathContentWithCleanup,
        initializeMathRendering,
        debouncedRenderMath,
    }
}
