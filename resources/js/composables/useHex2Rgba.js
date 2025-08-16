export function useHex2Rgba() {
    /**
     * Converts hex to rgba.
     */
    const hex2rgba = (hex, alpha = 1) => {
        if (!hex) {
            console.warn('hex2rgba: No hex value provided')
            return 'rgba(0, 0, 0, 1)'
        }

        if (alpha > 1 || alpha < 0) {
            console.error('hex2rgba: alpha value must be between 0 and 1')
            return 'rgba(0, 0, 0, 1)'
        }

        // Ensure hex starts with #
        if (!hex.startsWith('#')) {
            hex = '#' + hex
        }

        // Validate hex format
        if (hex.length !== 7) {
            console.error('hex2rgba: Invalid hex format. Expected #RRGGBB')
            return 'rgba(0, 0, 0, 1)'
        }

        try {
            const red = parseInt(hex.slice(1, 3), 16)
            const green = parseInt(hex.slice(3, 5), 16)
            const blue = parseInt(hex.slice(5, 7), 16)

            // Validate parsed values
            if (isNaN(red) || isNaN(green) || isNaN(blue)) {
                console.error('hex2rgba: Invalid hex color values')
                return 'rgba(0, 0, 0, 1)'
            }

            return `rgba(${red}, ${green}, ${blue}, ${alpha})`
        } catch (error) {
            console.error('hex2rgba: Error converting hex to rgba:', error)
            return 'rgba(0, 0, 0, 1)'
        }
    }

    /**
     * Converts hex to rgb (without alpha).
     */
    const hex2rgb = hex => {
        return hex2rgba(hex, 1).replace('rgba', 'rgb').replace(', 1)', ')')
    }

    /**
     * Validates if a string is a valid hex color.
     */
    const isValidHex = hex => {
        if (!hex || typeof hex !== 'string') return false
        const hexPattern = /^#?([0-9A-Fa-f]{6})$/
        return hexPattern.test(hex)
    }

    return {
        hex2rgba,
        hex2rgb,
        isValidHex,
    }
}
