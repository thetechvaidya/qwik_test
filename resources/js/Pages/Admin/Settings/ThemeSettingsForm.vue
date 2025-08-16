<template>
    <arc-form-section @submitted="updateSettings">
        <template #title>
            {{ __('Theme Settings') }}
        </template>

        <template #form>
            <div class="col-span-6 sm:col-span-4">
                <div class="grid grid-cols-1 gap-2 items-center justify-between w-full">
                    <div
                        :style="{ 'background-color': '#' + form.primary_color, color: '#' + form.secondary_color }"
                        class="p-4 h-12 flex items-center justify-center rounded-sm text-sm font-semibold border border-gray-200"
                    >
                        Primary BG + Secondary Text
                    </div>
                    <div
                        :style="{ 'background-color': '#' + form.secondary_color, color: '#' + form.primary_color }"
                        class="p-4 h-12 flex items-center justify-center rounded-sm text-sm font-semibold border border-gray-200"
                    >
                        Secondary BG + Primary Text
                    </div>
                    <div
                        :style="{ 'background-color': '#' + form.primary_color }"
                        class="p-4 h-12 flex items-center justify-center rounded-sm text-sm text-white font-semibold border border-gray-200"
                    >
                        Primary BG + White Text
                    </div>
                    <div
                        :style="{ color: '#' + form.primary_color }"
                        class="p-4 h-12 flex items-center justify-center rounded-sm bg-white text-sm font-semibold border border-gray-200"
                    >
                        White BG + Primary Text
                    </div>
                    <div
                        :style="{ color: '#' + form.secondary_color }"
                        class="p-4 h-12 flex items-center justify-center rounded-sm bg-white text-sm font-semibold border border-gray-200"
                    >
                        White BG + Secondary Text
                    </div>
                </div>
            </div>

            <!-- Primary Color -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="primary_color" :value="__('Primary Color') + ' (' + __('Dark') + ')'" />
                <div class="flex items-center">
                    <ColorPicker v-model="displayPrimaryColor" :format="'hex'" />
                    <arc-input id="primary_color" v-model="displayPrimaryColor" type="text" class="mt-1 block w-full" />
                </div>
                <arc-input-error :message="form.errors.primary_color" class="mt-2" />
            </div>

            <!-- Secondary Color -->
            <div class="col-span-6 sm:col-span-4">
                <arc-label for="secondary_color" :value="__('Secondary Color') + ' (' + __('Light') + ')'" />
                <div class="flex items-center">
                    <ColorPicker v-model="displaySecondaryColor" :format="'hex'" />
                    <arc-input
                        id="secondary_color"
                        v-model="displaySecondaryColor"
                        type="text"
                        class="mt-1 block w-full"
                    />
                </div>
                <arc-input-error :message="form.errors.secondary_color" class="mt-2" />
            </div>
        </template>

        <template #actions>
            <arc-action-message :on="form.recentlySuccessful" class="mr-3"> {{ __('Saved') }}. </arc-action-message>

            <arc-button :class="{ 'opacity-25': form.processing }" :disabled="form.processing">
                {{ __('Save') }}
            </arc-button>
        </template>
    </arc-form-section>
</template>
<script setup>
import { computed } from 'vue'
import { useForm } from '@inertiajs/vue3'
import { useTranslate } from '@/composables/useTranslate'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import ArcActionMessage from '@/Components/ActionMessage'
import ArcButton from '@/Components/Button'
import ArcFormSection from '@/Components/FormSection'
import ArcInput from '@/Components/Input'
import ArcInputError from '@/Components/InputError'
import ArcLabel from '@/Components/Label'
import ArcSecondaryButton from '@/Components/SecondaryButton'
import ColorPicker from 'primevue/colorpicker'

const props = defineProps({
    settings: Object,
})

const { __ } = useTranslate()

/**
 * Normalize color values to hex format without # prefix
 * Handles 3, 6, and 8-digit hex colors with graceful fallback
 *
 * @param {string} color - Color value in various formats
 * @returns {string} - Normalized hex color without # prefix
 */
const normalizeColorValue = color => {
    if (!color || typeof color !== 'string') {
        return '000000' // Default fallback
    }

    // Remove all # prefixes and whitespace
    let normalized = color.replace(/#+/g, '').trim().toLowerCase()

    // Validate hex characters only
    if (!/^[0-9a-f]*$/.test(normalized)) {
        return '000000' // Invalid characters fallback
    }

    // Handle different hex lengths
    if (normalized.length === 3) {
        // Expand 3-digit to 6-digit: abc -> aabbcc
        normalized = normalized
            .split('')
            .map(char => char + char)
            .join('')
    } else if (normalized.length === 8) {
        // Remove alpha channel from 8-digit: aarrggbb -> rrggbb
        normalized = normalized.slice(2)
    } else if (normalized.length !== 6) {
        // Invalid length fallback
        return '000000'
    }

    return normalized
}

/**
 * Ensure color has # prefix for ColorPicker display
 *
 * @param {string} color - Hex color without # prefix
 * @returns {string} - Hex color with # prefix
 */
const ensureHashPrefix = color => {
    if (!color) return '#000000'
    return color.startsWith('#') ? color : `#${color}`
}

const form = useForm({
    primary_color: normalizeColorValue(props.settings.primary_color),
    secondary_color: normalizeColorValue(props.settings.secondary_color),
})

// Ensure consistent color format for ColorPicker display (with #)
const displayPrimaryColor = computed({
    get() {
        return ensureHashPrefix(form.primary_color)
    },
    set(value) {
        form.primary_color = normalizeColorValue(value)
    },
})

const displaySecondaryColor = computed({
    get() {
        return ensureHashPrefix(form.secondary_color)
    },
    set(value) {
        form.secondary_color = normalizeColorValue(value)
    },
})

const updateSettings = () => {
    form.post(route('update_theme_settings'), {
        errorBag: 'updateThemeSettings',
        preserveScroll: true,
        onSuccess: () => {
            // Dispatch custom event to update theme tokens immediately
            // Pass normalized colors (without #) for consistency with app.js
            const themeEvent = new CustomEvent('app:theme-updated', {
                detail: {
                    primary: form.primary_color,
                    secondary: form.secondary_color,
                },
            })
            window.dispatchEvent(themeEvent)
        },
    })
}
</script>
