import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';
import vue from '@vitejs/plugin-vue';
import path from 'path';

export default defineConfig(({ mode }) => {
    const isProduction = mode === 'production';
    const isDevelopment = mode === 'development';

    // Debug path resolution in development mode
    if (isDevelopment) {
        console.log('[Vite] Development mode detected');
        console.log('[Vite] Project structure:');
        console.log('  - Pages: resources/js/Pages/');
        console.log('  - Components: resources/js/Components/');
        console.log('  - Core: resources/js/core/');
        console.log('[Vite] Path aliases configured for better imports');
    }

    return {
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
                        // Simplified Vue 3 compatibility - remove unnecessary options for better performance
                        compatConfig: {
                            MODE: 3, // Use Vue 3 mode for better performance
                            GLOBAL_MOUNT: false,
                            INSTANCE_EVENT_EMITTER: false,
                            OPTIONS_DATA_FN: false,
                            COMPONENT_V_MODEL: false,
                            FILTERS: false,
                        }
                    }
                },
                // Enable better tree shaking for Vue components
                reactivityTransform: false,
                script: {
                    defineModel: true,
                    propsDestructure: true,
                },
            }),
        ],
        // Optimized development server configuration
        server: {
            host: 'localhost',
            port: 5173,
            strictPort: false,
            https: false, // Explicitly disable HTTPS to match Laravel server
            hmr: {
                overlay: true,
                host: 'localhost',
                port: 5173,
            },
            // Optimized file watching for better performance
            watch: {
                usePolling: process.platform === 'win32', // Only use polling on Windows
                interval: isDevelopment ? 100 : 1000,
                ignored: ['**/node_modules/**', '**/storage/**', '**/vendor/**'],
            },
            // Enable CORS for development
            cors: true,
            // Optimize middleware
            middlewareMode: false,
        },
        
        // Enhanced build configuration with modern optimizations
        build: {
            outDir: 'public/build',
            assetsDir: 'assets',
            manifest: 'manifest.json',
            // Modern build target for better performance
            target: ['es2020', 'edge88', 'firefox78', 'chrome87', 'safari13'],
            // Improved rollup options
            rollupOptions: {
                // Enhanced tree shaking
                treeshake: {
                    moduleSideEffects: false,
                    propertyReadSideEffects: false,
                    unknownGlobalSideEffects: false,
                },
                output: {
                    // Simplified and more efficient chunk splitting strategy
                    manualChunks: (id) => {
                        // Core framework chunks (most stable, best for caching)
                        if (id.includes('vue/') || id.includes('@vue/')) {
                            return 'vue-core';
                        }
                        if (id.includes('@inertiajs/')) {
                            return 'inertia';
                        }
                        
                        // UI library chunks
                        if (id.includes('primevue/') || id.includes('@primeuix/')) {
                            return 'primevue';
                        }
                        
                        // Utility libraries (frequently updated)
                        if (id.includes('axios') || id.includes('lodash') || id.includes('mitt')) {
                            return 'utils';
                        }
                        
                        // Chart and visualization libraries
                        if (id.includes('chart.js') || id.includes('vue-chartjs')) {
                            return 'charts';
                        }
                        
                        // Form and validation libraries
                        if (id.includes('@vuelidate/') || id.includes('sweetalert2')) {
                            return 'forms';
                        }
                        
                        // Other vendor dependencies
                        if (id.includes('node_modules')) {
                            return 'vendor';
                        }
                        
                        // Application code - let Vite handle automatically for better optimization
                        return undefined;
                    },
                    
                    // Optimized file naming for better caching
                    chunkFileNames: (chunkInfo) => {
                        return `js/[name]-[hash:8].js`;
                    },
                    entryFileNames: `js/[name]-[hash:8].js`,
                    assetFileNames: (assetInfo) => {
                        const info = assetInfo.name.split('.');
                        let extType = info[info.length - 1];
                        if (/png|jpe?g|svg|gif|tiff|bmp|ico|webp/i.test(extType)) {
                            extType = 'images';
                        } else if (/woff2?|eot|ttf|otf/i.test(extType)) {
                            extType = 'fonts';
                        } else if (/css/i.test(extType)) {
                            extType = 'css';
                        }
                        return `${extType}/[name]-[hash:8].[ext]`;
                    },
                },
                
                // External dependencies that should not be bundled
                external: isProduction ? [] : ['vue-demi'],
            },
            
            // Performance optimizations
            chunkSizeWarningLimit: 400, // Reduced from 800KB as recommended
            cssCodeSplit: true,
            reportCompressedSize: !isProduction, // Only report in development
            sourcemap: isDevelopment ? true : false,
            
            // Modern minification with better performance
            minify: isProduction ? 'esbuild' : false, // esbuild is faster than terser
            
            // ESBuild options for production (faster than terser)
            esbuild: isProduction ? {
                drop: ['console', 'debugger'],
                legalComments: 'none',
                minifyIdentifiers: true,
                minifySyntax: true,
                minifyWhitespace: true,
            } : false,
            
            // Asset optimization
            assetsInlineLimit: 2048, // Reduced from 4096 for better performance
            
            // CSS optimization
            cssMinify: isProduction ? 'esbuild' : false,
            
            // Enable modern features
            modulePreload: {
                polyfill: true,
            },
            
            // Optimize asset handling
            assetsInclude: ['**/*.woff2', '**/*.woff'],
        },
        // Enhanced dependency optimization for better development performance
        optimizeDeps: {
            include: [
                'vue',
                '@inertiajs/vue3',
                'axios',
                'lodash',
                'ziggy-js',
                'qs',
                '@vuelidate/core',
                '@vuelidate/validators',
                'primevue/usetoast',
                'primevue/button',
                'primevue/inputtext',
                'primevue/toast',
                'primevue/dialog',
                'primevue/config',
                'primevue/toastservice',
                'primevue/confirmationservice',
                '@primeuix/themes/aura',
            ],
            exclude: [
                'primevue/password',
                'primevue/checkbox',
                'primevue/calendar',
                'primevue/textarea',
                'primevue/fileupload',
                'primevue/inputnumber',
                'primevue/dropdown',
                'primevue/multiselect',
                'primevue/datatable',
                'primevue/column',
                'primevue/columngroup',
                'primevue/row',
                'primevue/confirmdialog',
                'primevue/sidebar',
                'primevue/overlaypanel',
                'primevue/menu',
                'primevue/menubar',
                'primevue/panelmenu',
                'primevue/tabview',
                'primevue/tabpanel',
                'primevue/steps',
                'primevue/card',
                'primevue/divider',
                'primevue/toolbar',
                'primevue/panel',
                'primevue/fieldset',
                'primevue/accordion',
                'primevue/accordiontab',
                'primevue/progressbar',
                'primevue/progressspinner',
                'primevue/message',
                'primevue/inlinemessage',
                '@primeuix/core',
                'primeicons',
                'laravel-vite-plugin/inertia-helpers',
                'vue-demi',
            ],
            // Enhanced optimization settings
            force: true,
            entries: ['resources/js/app.js'],
            // Enable esbuild for faster pre-bundling
            esbuildOptions: {
                target: 'es2020',
                supported: {
                    'top-level-await': true,
                },
                // Better handling of PrimeVue components
                plugins: [],
                // Only exclude lazy-loaded components
                external: [
                    'primevue/password',
                    'primevue/checkbox',
                    'primevue/calendar',
                    'primevue/textarea',
                    'primevue/fileupload',
                    'primevue/datatable',
                    'primevue/column',
                    '@primeuix/core',
                    'primeicons',
                ],
            },
        },
        // Enhanced path resolution
        resolve: {
            alias: {
                // Main resources directory - use this for accessing any resource
                '@': path.resolve(__dirname, 'resources/js'),
                '~': path.resolve(__dirname, 'resources'),
                // Specific alias for Pages directory to make imports explicit
                '@pages': path.resolve(__dirname, 'resources/js/Pages'),
                '@components': path.resolve(__dirname, 'resources/js/Components'),
                '@core': path.resolve(__dirname, 'resources/js/core'),
                'vue': 'vue/dist/vue.esm-bundler.js', // Ensure we use the ESM build
            },
            extensions: ['.mjs', '.js', '.ts', '.jsx', '.tsx', '.json', '.vue'],
            // Optimize module resolution
            dedupe: ['vue', '@vue/runtime-core', '@vue/runtime-dom'],
        },
        
        // Enhanced global definitions
        define: {
            __VUE_PROD_DEVTOOLS__: !isProduction,
            __VUE_OPTIONS_API__: true,
            __VUE_PROD_HYDRATION_MISMATCH_DETAILS__: false,
            'process.env.NODE_ENV': JSON.stringify(mode),
        },
        
        // Enhanced CSS configuration
        css: {
            devSourcemap: isDevelopment,
            // CSS modules configuration
            modules: {
                localsConvention: 'camelCase',
            },
        },
        
        // Enhanced worker configuration
        worker: {
            format: 'es',
            plugins: () => [vue()],
        },
        
        // Performance monitoring in development
        ...(isDevelopment && {
            logLevel: 'info',
            clearScreen: false,
        }),
    };
});