import { usePage } from '@inertiajs/vue3'

export function useTranslate() {
    const page = usePage()

    /**
     * Translate the given key.
     */
    const __ = (key, replace = {}) => {
        if (!page || !page.props || !page.props.translations) {
            console.warn('Translation context not available, returning key:', key)
            return key
        }

        let translation = page.props.translations[key] ? page.props.translations[key] : key

        Object.keys(replace).forEach(function (key) {
            translation = translation.replace(':' + key, replace[key])
        })

        return translation
    }

    /**
     * Translate the given key with basic pluralization.
     */
    const __n = (key, number, replace = {}) => {
        let options = key.split('|')

        key = options[1]
        if (number === 1) {
            key = options[0]
        }

        return __(key, replace)
    }

    return {
        __,
        __n,
    }
}
