/**
 * Core application initialization and configuration
 * Extracted from app.js to improve maintainability
 */

import { createApp, h } from 'vue';
import { createInertiaApp } from '@inertiajs/vue3';
import { resolvePageComponent } from 'laravel-vite-plugin/inertia-helpers';
import { ZiggyVue } from 'ziggy-js';
import { Ziggy } from '../ziggy.js';
import PrimeVue from 'primevue/config';
import Aura from '@primeuix/themes/aura';
import ConfirmationService from 'primevue/confirmationservice';
import ToastService from 'primevue/toastservice';
import { registerComponents } from './component-registry';
import '../bootstrap';

/**
 * Create the main Inertia application
 */
export function createInertiaApplication() {
    return createInertiaApp({
        title: (title) => `${title} - Lara Courses`,
        resolve: (name) => {
            try {
                if (import.meta.env.DEV) {
                    console.log(`[Inertia] Resolving page component: ${name}`);
                    console.log(`[Inertia] Looking for: ../Pages/${name}.vue`);
                }
                return resolvePageComponent(`../Pages/${name}.vue`, import.meta.glob('../Pages/**/*.vue'));
            } catch (error) {
                console.error(`[Inertia] Failed to resolve page component: ${name}`, error);
                console.error(`[Inertia] Make sure the component exists at: resources/js/Pages/${name}.vue`);
                throw error;
            }
        },
        setup({ el, App, props, plugin }) {
            try {
                const app = createApp({ render: () => h(App, props) })
                    .use(plugin)
                    .use(ZiggyVue, Ziggy)
                    .use(PrimeVue, {
                        theme: {
                            preset: Aura,
                            options: {
                                prefix: 'p',
                                darkModeSelector: '.dark',
                                cssLayer: false
                            }
                        }
                    })
                    .use(ConfirmationService)
                    .use(ToastService);

                // Add global error handler for component lifecycle issues
                app.config.errorHandler = (err, instance, info) => {
                    console.error('[Vue Error Handler]', err, info);
                    
                    // Handle DOM manipulation errors during component transitions
                    if (err.message && (
                        err.message.includes('nextSibling') || 
                        err.message.includes('previousSibling') || 
                        err.message.includes('removeChild') ||
                        err.message.includes('Cannot read properties of null')
                    )) {
                        console.warn('[Vue Error Handler] DOM manipulation error detected. This may be due to component lifecycle timing or element removal.');
                        return; // Silently handle these errors as they're often harmless during transitions
                    }
                    
                    // Handle property access errors on null/undefined objects
                    if (err.message && (
                        err.message.includes('Cannot read properties of undefined') ||
                        err.message.includes('Cannot read properties of null')
                    )) {
                        console.warn('[Vue Error Handler] Property access error detected. This may be due to reactive data timing.');
                        return; // Prevent error from bubbling up
                    }
                    
                    // Handle Inertia navigation errors
                    if (info === 'scheduler flush' && err.message && err.message.includes('nextSibling')) {
                        console.warn('[Vue Error Handler] Scheduler flush error during navigation - this is typically harmless.');
                        return;
                    }
                };

                // Register components after PrimeVue setup
                try {
                    registerComponents(app);
                    if (import.meta.env.DEV) {
                        console.log('[App] Components registered successfully');
                    }
                } catch (error) {
                    console.error('[App] Failed to register components:', error);
                    // Continue without component registration to avoid breaking the app
                }

                return app.mount(el);
            } catch (error) {
                console.error('[App] Failed to initialize application:', error);
                throw error;
            }
        },
        progress: {
            color: '#4F46E5',
            showSpinner: true,
            delay: 150,
        },
    });
}

/**
 * Application configuration constants
 */
export const APP_CONFIG = {
    title: 'Lara Courses',
    progressColor: '#4F46E5',
    progressDelay: 150,
    theme: {
        prefix: 'p',
        darkModeSelector: '.dark',
        cssLayer: false
    }
};
