import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig(({ mode }) => ({
    plugins: [
        laravel({
            input: [
                'resources/css/app.css',
                'resources/css/store.css',
                'resources/js/app.js',
            ],
            refresh: true,
        }),
        vue({
            template: {
                transformAssetUrls: {
                    base: null,
                    includeAbsolute: false,
                },
                compilerOptions: {
                    compatConfig: {
                        MODE: 2,
                        GLOBAL_MOUNT: true,
                        GLOBAL_EXTEND: false,
                        GLOBAL_PROTOTYPE: false,
                        GLOBAL_SET: false,
                        GLOBAL_DELETE: false,
                        GLOBAL_OBSERVABLE: false,
                        CONFIG_WHITESPACE: false,
                        INSTANCE_SET: false,
                        INSTANCE_DELETE: false,
                        INSTANCE_DESTROY: false,
                        INSTANCE_EVENT_EMITTER: true,
                        INSTANCE_EVENT_HOOKS: false,
                        INSTANCE_CHILDREN: false,
                        OPTIONS_DATA_FN: true,
                        OPTIONS_DATA_MERGE: false,
                        OPTIONS_BEFORE_DESTROY: false,
                        OPTIONS_DESTROYED: false,
                        WATCH_ARRAY: false,
                        PROPS_DEFAULT_THIS: false,
                        INSTANCE_ATTRS_CLASS_STYLE: false,
                        TRANSITION_CLASSES: false,
                        COMPONENT_ASYNC: false,
                        COMPONENT_FUNCTIONAL: false,
                        COMPONENT_V_MODEL: true,
                        RENDER_FUNCTION: false,
                        FILTERS: true,
                        PRIVATE_APIS: false
                    }
                }
            },
        }),
    ],
    server: {
        host: 'localhost',
        port: 5173,
        strictPort: false,
        hmr: {
            overlay: true,
            host: 'localhost',
        },
        watch: {
            usePolling: true,
            interval: 100,
        },
    },
    build: {
        outDir: 'public/build',
        assetsDir: 'assets',
        manifest: true,
        rollupOptions: {
            output: {
                manualChunks: (id) => {
                    // Vue core ecosystem
                    if (id.includes('vue') || id.includes('@vue') || id.includes('@inertiajs/vue3')) {
                        return 'vue-core';
                    }
                    
                    // PrimeVue core and theme system
                    if (id.includes('primevue/config') || id.includes('primevue/toastservice') || 
                        id.includes('primevue/confirmationservice') || id.includes('@primeuix/styled')) {
                        return 'primevue-core';
                    }
                    
                    // PrimeVue themes and design tokens
                    if (id.includes('@primeuix/themes') || id.includes('primevue/themes')) {
                        return 'primevue-themes';
                    }
                    
                    // PrimeVue components - Form controls
                    if (id.includes('primevue/') && (id.includes('input') || id.includes('dropdown') || 
                        id.includes('checkbox') || id.includes('radiobutton') || id.includes('textarea') ||
                        id.includes('calendar') || id.includes('multiselect') || id.includes('toggleswitch'))) {
                        return 'primevue-forms';
                    }
                    
                    // PrimeVue components - Data display
                    if (id.includes('primevue/') && (id.includes('datatable') || id.includes('column') || 
                        id.includes('tree') || id.includes('treetable') || id.includes('card') ||
                        id.includes('panel') || id.includes('accordion') || id.includes('tabview'))) {
                        return 'primevue-data';
                    }
                    
                    // PrimeVue components - Navigation and layout
                    if (id.includes('primevue/') && (id.includes('menubar') || id.includes('menu') || 
                        id.includes('breadcrumb') || id.includes('steps') || id.includes('toolbar') ||
                        id.includes('sidebar') || id.includes('splitpanel') || id.includes('scrollpanel'))) {
                        return 'primevue-navigation';
                    }
                    
                    // PrimeVue components - Overlays and dialogs
                    if (id.includes('primevue/') && (id.includes('dialog') || id.includes('overlaypanel') || 
                        id.includes('tooltip') || id.includes('popover') || id.includes('confirmbox') ||
                        id.includes('toast') || id.includes('inplace'))) {
                        return 'primevue-overlays';
                    }
                    
                    // Chart and visualization libraries
                    if (id.includes('chart.js') || id.includes('vue-chartjs') || id.includes('d3') || 
                        id.includes('echarts') || id.includes('apexcharts')) {
                        return 'charts';
                    }
                    
                    // Tiptap editor ecosystem
                    if (id.includes('@tiptap/')) {
                        return 'tiptap-editor';
                    }
                    
                    // Mathematical content rendering
                    if (id.includes('katex') || id.includes('mathjax') || id.includes('mathquill')) {
                        return 'math-renderer';
                    }
                    
                    // Data table and grid components
                    if (id.includes('vue-good-table') || id.includes('ag-grid') || id.includes('vue-tables-2')) {
                        return 'data-tables';
                    }
                    
                    // Media and file handling
                    if (id.includes('swiper') || id.includes('vue-plyr') || id.includes('plyr') || 
                        id.includes('dropzone') || id.includes('vue-upload')) {
                        return 'media-components';
                    }
                    
                    // Core utilities - HTTP and state
                    if (id.includes('axios') || id.includes('ky') || id.includes('fetch')) {
                        return 'http-client';
                    }
                    
                    // Utility libraries
                    if (id.includes('lodash') || id.includes('ramda') || id.includes('moment') || 
                        id.includes('dayjs') || id.includes('date-fns')) {
                        return 'utils';
                    }
                    
                    // Form validation and handling
                    if (id.includes('@vuelidate/') || id.includes('vue-select') || id.includes('vue-multiselect') ||
                        id.includes('vee-validate') || id.includes('yup') || id.includes('joi')) {
                        return 'forms-validation';
                    }
                    
                    // State management ecosystem
                    if (id.includes('pinia') || id.includes('vuex') || id.includes('@pinia/')) {
                        return 'state-management';
                    }
                    
                    // Vue composables and utilities
                    if (id.includes('@vueuse/') || id.includes('vue-demi') || id.includes('@vue/shared')) {
                        return 'vue-composables';
                    }
                    
                    // UI enhancements and interactions
                    if (id.includes('sweetalert2') || id.includes('vue-sweetalert2') || id.includes('v-calendar') ||
                        id.includes('vuedraggable') || id.includes('@dnd-kit/') || id.includes('sortablejs')) {
                        return 'ui-enhancements';
                    }
                    
                    // Animation libraries
                    if (id.includes('gsap') || id.includes('lottie') || id.includes('animate.css') ||
                        id.includes('@vueuse/motion') || id.includes('framer-motion')) {
                        return 'animations';
                    }
                    
                    // Admin-specific components (if they exist in separate directories)
                    if (id.includes('/Admin/') || id.includes('/admin/') || id.includes('admin-')) {
                        return 'admin-components';
                    }
                    
                    // User-facing components
                    if (id.includes('/User/') || id.includes('/user/') || id.includes('user-')) {
                        return 'user-components';
                    }
                    
                    // Common vendor dependencies
                    if (id.includes('node_modules') && !id.includes('vue') && !id.includes('primevue')) {
                        return 'vendor';
                    }
                    
                    // Application code
                    return 'app';
                },
                // Optimize chunk naming for better caching
                chunkFileNames: (chunkInfo) => {
                    const facadeModuleId = chunkInfo.facadeModuleId ? chunkInfo.facadeModuleId.split('/').pop() : 'chunk';
                    return `js/[name]-[hash].js`;
                },
                entryFileNames: `js/[name]-[hash].js`,
                assetFileNames: (assetInfo) => {
                    const info = assetInfo.name.split('.');
                    let extType = info[info.length - 1];
                    if (/png|jpe?g|svg|gif|tiff|bmp|ico/i.test(extType)) {
                        extType = 'images';
                    } else if (/woff2?|eot|ttf|otf/i.test(extType)) {
                        extType = 'fonts';
                    } else if (/css/i.test(extType)) {
                        extType = 'css';
                    }
                    return `${extType}/[name]-[hash].[ext]`;
                },
            },
        },
        // Performance optimizations
        chunkSizeWarningLimit: 800,
        cssCodeSplit: true,
        sourcemap: mode === 'development' ? 'inline-source-map' : false,
        minify: mode === 'production' ? 'terser' : false,
        terserOptions: mode === 'production' ? {
            compress: {
                drop_console: true,
                drop_debugger: true,
                pure_funcs: ['console.log'],
            },
            mangle: {
                safari10: true,
            },
            format: {
                safari10: true,
            },
        } : {},
        // Asset size limits and warnings
        assetsInlineLimit: 4096,
        reportCompressedSize: false,
        // CSS optimization
        cssMinify: mode === 'production',
    },
    optimizeDeps: {
        include: [
            'vue',
            '@vue/compat',
            '@inertiajs/vue3',
            'axios',
            'lodash',
            'nprogress',
            'primevue/config',
            'primevue/toastservice',
            'primevue/confirmationservice',
            '@primeuix/themes/aura',
            'vue-good-table-next',
            'sweetalert2',
            'pinia',
            '@vueuse/head',
            '@vueuse/core',
            '@vuelidate/core',
            '@vuelidate/validators',
            'mitt',
            'chart.js',
            'vue-chartjs',
        ],
        exclude: ['vue-demi'],
        // Force re-optimization on dependency changes
        force: false,
        // Pre-bundle dependencies for faster development
        entries: ['resources/js/app.js'],
    },
    resolve: {
        alias: {
            vue: '@vue/compat',
            '@': path.resolve(__dirname, 'resources/js'),
            '~': path.resolve(__dirname, 'resources'),
        },
        extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
    },
    define: {
        __VUE_OPTIONS_API__: true,
        __VUE_PROD_DEVTOOLS__: mode === 'development',
        __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: mode === 'development',
    },
    css: {
        devSourcemap: true,
    },
}));