import { fontFamily } from 'tailwindcss/defaultTheme';
import forms from '@tailwindcss/forms';
import typography from '@tailwindcss/typography';
import aspectRatio from '@tailwindcss/aspect-ratio';
import containerQueries from '@tailwindcss/container-queries';
import tailwindcssDir from 'tailwindcss-dir';

export default {
    content: [
        './vendor/laravel/jetstream/**/*.blade.php',
        './storage/framework/views/*.php',
        './resources/views/**/*.blade.php',
        './resources/js/**/*.vue',
        './resources/js/**/*.js',
        './resources/js/**/*.ts',
        './resources/css/**/*.css',
        './resources/views/vendor/**/*.blade.php',
    ],
    darkMode: ['class', '[data-theme="dark"]'],
    theme: {
        extend: {
            colors: {
                // PrimeVue 4.x compatible color system
                primary: {
                    50: 'rgb(var(--p-primary-50) / <alpha-value>)',
                    100: 'rgb(var(--p-primary-100) / <alpha-value>)',
                    200: 'rgb(var(--p-primary-200) / <alpha-value>)',
                    300: 'rgb(var(--p-primary-300) / <alpha-value>)',
                    400: 'rgb(var(--p-primary-400) / <alpha-value>)',
                    500: 'rgb(var(--p-primary-500) / <alpha-value>)',
                    600: 'rgb(var(--p-primary-600) / <alpha-value>)',
                    700: 'rgb(var(--p-primary-700) / <alpha-value>)',
                    800: 'rgb(var(--p-primary-800) / <alpha-value>)',
                    900: 'rgb(var(--p-primary-900) / <alpha-value>)',
                    950: 'rgb(var(--p-primary-950) / <alpha-value>)',
                    DEFAULT: 'rgb(var(--p-primary-500) / <alpha-value>)',
                },
                surface: {
                    0: 'rgb(var(--p-surface-0) / <alpha-value>)',
                    50: 'rgb(var(--p-surface-50) / <alpha-value>)',
                    100: 'rgb(var(--p-surface-100) / <alpha-value>)',
                    200: 'rgb(var(--p-surface-200) / <alpha-value>)',
                    300: 'rgb(var(--p-surface-300) / <alpha-value>)',
                    400: 'rgb(var(--p-surface-400) / <alpha-value>)',
                    500: 'rgb(var(--p-surface-500) / <alpha-value>)',
                    600: 'rgb(var(--p-surface-600) / <alpha-value>)',
                    700: 'rgb(var(--p-surface-700) / <alpha-value>)',
                    800: 'rgb(var(--p-surface-800) / <alpha-value>)',
                    900: 'rgb(var(--p-surface-900) / <alpha-value>)',
                    950: 'rgb(var(--p-surface-950) / <alpha-value>)',
                    DEFAULT: 'rgb(var(--p-surface-0) / <alpha-value>)',
                },
                // Legacy color support
                secondary: 'var(--secondary-color)',
                'qt-primary': '#38b355',
                'qt-secondary': '#4f4d91',
                'qt-lite': '#7cc9c1',
                'qt-option': '#63d0f2',
                // Semantic colors with CSS variables
                success: 'rgb(var(--p-green-500) / <alpha-value>)',
                warning: 'rgb(var(--p-yellow-500) / <alpha-value>)',
                danger: 'rgb(var(--p-red-500) / <alpha-value>)',
                info: 'rgb(var(--p-blue-500) / <alpha-value>)',
            },
            fontFamily: {
                sans: ['Inter', 'system-ui', 'sans-serif', ...fontFamily.sans],
                mono: ['JetBrains Mono', 'Fira Code', 'Consolas', ...fontFamily.mono],
                display: ['Inter', 'system-ui', 'sans-serif'],
            },
            fontSize: {
                'xs': ['0.75rem', { lineHeight: '1rem' }],
                'sm': ['0.875rem', { lineHeight: '1.25rem' }],
                'base': ['1rem', { lineHeight: '1.5rem' }],
                'lg': ['1.125rem', { lineHeight: '1.75rem' }],
                'xl': ['1.25rem', { lineHeight: '1.75rem' }],
                '2xl': ['1.5rem', { lineHeight: '2rem' }],
                '3xl': ['1.875rem', { lineHeight: '2.25rem' }],
                '4xl': ['2.25rem', { lineHeight: '2.5rem' }],
                '5xl': ['3rem', { lineHeight: '1' }],
                '6xl': ['3.75rem', { lineHeight: '1' }],
                '7xl': ['4.5rem', { lineHeight: '1' }],
                '8xl': ['6rem', { lineHeight: '1' }],
                '9xl': ['8rem', { lineHeight: '1' }],
            },
            spacing: {
                '18': '4.5rem',
                '88': '22rem',
                '92': '23rem',
                '96': '24rem',
                '128': '32rem',
            },
            maxWidth: {
                '8xl': '88rem',
                '9xl': '96rem',
            },
            aspectRatio: {
                '4/3': '4 / 3',
                '3/2': '3 / 2',
                '2/3': '2 / 3',
                '9/16': '9 / 16',
            },
            animation: {
                'fade-in': 'fadeIn 0.5s ease-in-out',
                'fade-out': 'fadeOut 0.5s ease-in-out',
                'slide-up': 'slideUp 0.3s ease-out',
                'slide-down': 'slideDown 0.3s ease-out',
                'slide-in-left': 'slideInLeft 0.3s ease-out',
                'slide-in-right': 'slideInRight 0.3s ease-out',
                'bounce-subtle': 'bounceSubtle 0.6s ease-in-out',
                'pulse-slow': 'pulse 3s ease-in-out infinite',
                'spin-slow': 'spin 3s linear infinite',
            },
            keyframes: {
                fadeIn: {
                    '0%': { opacity: '0' },
                    '100%': { opacity: '1' },
                },
                fadeOut: {
                    '0%': { opacity: '1' },
                    '100%': { opacity: '0' },
                },
                slideUp: {
                    '0%': { transform: 'translateY(10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
                slideDown: {
                    '0%': { transform: 'translateY(-10px)', opacity: '0' },
                    '100%': { transform: 'translateY(0)', opacity: '1' },
                },
                slideInLeft: {
                    '0%': { transform: 'translateX(-10px)', opacity: '0' },
                    '100%': { transform: 'translateX(0)', opacity: '1' },
                },
                slideInRight: {
                    '0%': { transform: 'translateX(10px)', opacity: '0' },
                    '100%': { transform: 'translateX(0)', opacity: '1' },
                },
                bounceSubtle: {
                    '0%, 100%': { transform: 'translateY(0)' },
                    '50%': { transform: 'translateY(-5px)' },
                },
            },
            backdropBlur: {
                xs: '2px',
            },
            screens: {
                'xs': '475px',
                '3xl': '1600px',
            },
            zIndex: {
                '60': '60',
                '70': '70',
                '80': '80',
                '90': '90',
                '100': '100',
            },
            transitionTimingFunction: {
                'out-expo': 'cubic-bezier(0.19, 1, 0.22, 1)',
                'out-circ': 'cubic-bezier(0.08, 0.82, 0.17, 1)',
            },
            boxShadow: {
                'inner-lg': 'inset 0 2px 4px 0 rgb(0 0 0 / 0.1)',
                'card': '0 1px 3px 0 rgb(0 0 0 / 0.1), 0 1px 2px -1px rgb(0 0 0 / 0.1)',
                'card-hover': '0 4px 6px -1px rgb(0 0 0 / 0.1), 0 2px 4px -2px rgb(0 0 0 / 0.1)',
                'dialog': '0 25px 50px -12px rgb(0 0 0 / 0.25)',
            },
        },
    },
    plugins: [
        forms({
            strategy: 'class',
        }),
        typography({
            className: 'prose',
            DEFAULT: {
                css: {
                    '--tw-prose-body': 'rgb(var(--p-surface-700))',
                    '--tw-prose-headings': 'rgb(var(--p-surface-900))',
                    '--tw-prose-links': 'rgb(var(--p-primary-600))',
                    '--tw-prose-bold': 'rgb(var(--p-surface-900))',
                    '--tw-prose-counters': 'rgb(var(--p-surface-500))',
                    '--tw-prose-bullets': 'rgb(var(--p-surface-300))',
                    '--tw-prose-hr': 'rgb(var(--p-surface-200))',
                    '--tw-prose-quotes': 'rgb(var(--p-surface-900))',
                    '--tw-prose-quote-borders': 'rgb(var(--p-surface-200))',
                    '--tw-prose-captions': 'rgb(var(--p-surface-500))',
                    '--tw-prose-code': 'rgb(var(--p-surface-900))',
                    '--tw-prose-pre-code': 'rgb(var(--p-surface-100))',
                    '--tw-prose-pre-bg': 'rgb(var(--p-surface-900))',
                    '--tw-prose-th-borders': 'rgb(var(--p-surface-300))',
                    '--tw-prose-td-borders': 'rgb(var(--p-surface-200))',
                    maxWidth: 'none',
                },
            },
        }),
        aspectRatio,
        containerQueries,
        tailwindcssDir(),
        // Custom utilities plugin
        function({ addUtilities, addComponents, theme }) {
            addUtilities({
                '.scrollbar-hide': {
                    '-ms-overflow-style': 'none',
                    'scrollbar-width': 'none',
                    '&::-webkit-scrollbar': {
                        display: 'none'
                    }
                },
                '.scrollbar-default': {
                    '-ms-overflow-style': 'auto',
                    'scrollbar-width': 'auto',
                    '&::-webkit-scrollbar': {
                        display: 'block'
                    }
                },
            });
            
            addComponents({
                '.btn': {
                    padding: `${theme('spacing.2')} ${theme('spacing.4')}`,
                    borderRadius: theme('borderRadius.md'),
                    fontWeight: theme('fontWeight.medium'),
                    fontSize: theme('fontSize.sm'),
                    lineHeight: theme('lineHeight.5'),
                    textAlign: 'center',
                    textDecoration: 'none',
                    display: 'inline-flex',
                    alignItems: 'center',
                    justifyContent: 'center',
                    transition: 'all 0.15s ease-in-out',
                    cursor: 'pointer',
                    userSelect: 'none',
                    '&:focus': {
                        outline: '2px solid transparent',
                        outlineOffset: '2px',
                    },
                },
                '.btn-primary': {
                    backgroundColor: 'rgb(var(--p-primary-600))',
                    color: 'white',
                    '&:hover': {
                        backgroundColor: 'rgb(var(--p-primary-700))',
                    },
                    '&:focus': {
                        boxShadow: `0 0 0 3px rgb(var(--p-primary-600) / 0.1)`,
                    },
                },
                '.card': {
                    backgroundColor: 'rgb(var(--p-surface-0))',
                    borderRadius: theme('borderRadius.lg'),
                    boxShadow: theme('boxShadow.card'),
                    padding: theme('spacing.6'),
                },
            });
        },
    ],
    // JIT optimizations
    corePlugins: {
        preflight: true,
    },
    // Future features
    future: {
        hoverOnlyWhenSupported: true,
    },
};
