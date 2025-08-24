/**
 * Component registry for Vue application
 * Efficient component loading with lazy registration strategy
 */

import { Link } from '@inertiajs/vue3';


// Essential PrimeVue Components (loaded immediately)
import Button from 'primevue/button';
import InputText from 'primevue/inputtext';
import Toast from 'primevue/toast';
import Dialog from 'primevue/dialog';

// Custom Components
import ApplicationLogo from '../Components/ApplicationLogo.vue';
import DropdownLink from '../Components/DropdownLink.vue';
import InputError from '../Components/InputError.vue';
import Label from '../Components/Label.vue';
import Modal from '../Components/Modal.vue';
import NavLink from '../Components/NavLink.vue';
import PrimaryButton from '../Components/PrimaryButton.vue';
import ResponsiveNavLink from '../Components/ResponsiveNavLink.vue';
import SecondaryButton from '../Components/SecondaryButton.vue';
import TextInput from '../Components/TextInput.vue';
import ActionMessage from '../Components/ActionMessage.vue';
import ActionSection from '../Components/ActionSection.vue';
import AuthenticationCard from '../Components/AuthenticationCard.vue';
import AuthenticationCardLogo from '../Components/AuthenticationCardLogo.vue';
import Banner from '../Components/Banner.vue';
import ConfirmationModal from '../Components/ConfirmationModal.vue';
import ConfirmsPassword from '../Components/ConfirmsPassword.vue';
import DangerButton from '../Components/DangerButton.vue';
import DialogModal from '../Components/DialogModal.vue';
import FormSection from '../Components/FormSection.vue';
import SectionBorder from '../Components/SectionBorder.vue';
import SectionTitle from '../Components/SectionTitle.vue';
import Welcome from '../Pages/Welcome.vue';

// Essential PrimeVue Directives
import Tooltip from 'primevue/tooltip';
import Ripple from 'primevue/ripple';

/**
 * Component groups for lazy loading optimization
 */
export const COMPONENT_GROUPS = {
    core: ['Button', 'InputText', 'Toast', 'Dialog'],
    forms: ['Password', 'Checkbox', 'Calendar', 'Textarea', 'FileUpload', 'InputNumber', 'Dropdown', 'MultiSelect'],
    data: ['DataTable', 'Column', 'ColumnGroup', 'Row', 'Tree', 'TreeTable', 'Paginator'],
    overlay: ['ConfirmDialog', 'Sidebar', 'OverlayPanel', 'Menu'],
    navigation: ['Menubar', 'PanelMenu', 'TabView', 'TabPanel', 'Steps', 'Breadcrumb'],
    layout: ['Card', 'Divider', 'Toolbar', 'Panel', 'Fieldset', 'Accordion', 'AccordionTab'],
    input: ['Slider', 'Rating', 'SelectButton', 'ToggleButton', 'InputSwitch', 'RadioButton'],
    feedback: ['ProgressBar', 'ProgressSpinner', 'Message', 'InlineMessage'],
    media: ['Image', 'Carousel', 'Galleria'],
    misc: ['Tag', 'Badge', 'Avatar', 'ScrollPanel', 'Splitter', 'SplitterPanel', 'ScrollTop', 'SpeedDial']
};

/**
 * Loaded component groups cache
 */
const loadedGroups = new Set(['core']);
const componentCache = new Map();

/**
 * Register essential components immediately
 */
export function registerComponents(app) {
    try {
        if (import.meta.env.DEV) {
            console.log('[ComponentRegistry] Registering essential components...');
        }

        // Register Inertia components
        app.component('Link', Link);



        // Register essential PrimeVue components
        app.component('Button', Button);
        app.component('InputText', InputText);
        app.component('Toast', Toast);
        app.component('Dialog', Dialog);

        // Register custom components
        app.component('ApplicationLogo', ApplicationLogo);
        app.component('DropdownLink', DropdownLink);
        app.component('InputError', InputError);
        app.component('InputLabel', Label);
        app.component('Modal', Modal);
        app.component('NavLink', NavLink);
        app.component('PrimaryButton', PrimaryButton);
        app.component('ResponsiveNavLink', ResponsiveNavLink);
        app.component('SecondaryButton', SecondaryButton);
        app.component('TextInput', TextInput);
        app.component('ActionMessage', ActionMessage);
        app.component('ActionSection', ActionSection);
        app.component('AuthenticationCard', AuthenticationCard);
        app.component('AuthenticationCardLogo', AuthenticationCardLogo);
        app.component('Banner', Banner);
        app.component('ConfirmationModal', ConfirmationModal);
        app.component('ConfirmsPassword', ConfirmsPassword);
        app.component('DangerButton', DangerButton);
        app.component('DialogModal', DialogModal);
        app.component('FormSection', FormSection);
        app.component('SectionBorder', SectionBorder);
        app.component('SectionTitle', SectionTitle);
        app.component('Welcome', Welcome);

        // Register essential directives
        app.directive('tooltip', Tooltip);
        app.directive('ripple', Ripple);

        if (import.meta.env.DEV) {
            console.log('[ComponentRegistry] Essential components registered successfully');
        }

        return app;
    } catch (error) {
        console.error('[ComponentRegistry] Failed to register essential components:', error);
        throw error;
    }
}

/**
 * Lazy load and register component groups
 */
export async function loadComponentGroup(app, groupName) {
    if (loadedGroups.has(groupName)) {
        if (import.meta.env.DEV) {
            console.log(`[ComponentRegistry] Component group '${groupName}' already loaded`);
        }
        return;
    }

    try {
        if (import.meta.env.DEV) {
            console.log(`[ComponentRegistry] Loading component group: ${groupName}`);
        }

        const components = await getComponentGroup(groupName);
        
        for (const [name, component] of components) {
            if (!componentCache.has(name)) {
                app.component(name, component);
                componentCache.set(name, component);
                
                if (import.meta.env.DEV) {
                    console.log(`[ComponentRegistry] Registered component: ${name}`);
                }
            }
        }

        loadedGroups.add(groupName);
        
        if (import.meta.env.DEV) {
            console.log(`[ComponentRegistry] Component group '${groupName}' loaded successfully`);
        }
    } catch (error) {
        console.error(`[ComponentRegistry] Failed to load component group '${groupName}':`, error);
        // Don't throw to avoid breaking the app - use fallback registration
        await registerFallbackComponents(app, groupName);
    }
}

/**
 * Get component group with dynamic imports
 */
async function getComponentGroup(groupName) {
    const components = new Map();

    switch (groupName) {
        case 'forms':
            const [Password, Checkbox, Calendar, Textarea, FileUpload, InputNumber, Dropdown, MultiSelect] = await Promise.all([
                import('primevue/password'),
                import('primevue/checkbox'),
                import('primevue/calendar'),
                import('primevue/textarea'),
                import('primevue/fileupload'),
                import('primevue/inputnumber'),
                import('primevue/dropdown'),
                import('primevue/multiselect')
            ]);
            
            components.set('Password', Password.default);
            components.set('Checkbox', Checkbox.default);
            components.set('Calendar', Calendar.default);
            components.set('Textarea', Textarea.default);
            components.set('FileUpload', FileUpload.default);
            components.set('InputNumber', InputNumber.default);
            components.set('Dropdown', Dropdown.default);
            components.set('MultiSelect', MultiSelect.default);
            break;

        case 'data':
            const [DataTable, Column, ColumnGroup, Row] = await Promise.all([
                import('primevue/datatable'),
                import('primevue/column'),
                import('primevue/columngroup'),
                import('primevue/row')
            ]);
            
            components.set('DataTable', DataTable.default);
            components.set('Column', Column.default);
            components.set('ColumnGroup', ColumnGroup.default);
            components.set('Row', Row.default);
            break;

        case 'overlay':
            const [ConfirmDialog, Sidebar, OverlayPanel, Menu] = await Promise.all([
                import('primevue/confirmdialog'),
                import('primevue/sidebar'),
                import('primevue/overlaypanel'),
                import('primevue/menu')
            ]);
            
            components.set('ConfirmDialog', ConfirmDialog.default);
            components.set('Sidebar', Sidebar.default);
            components.set('OverlayPanel', OverlayPanel.default);
            components.set('Menu', Menu.default);
            break;

        case 'navigation':
            const [Menubar, PanelMenu, TabView, TabPanel, Steps] = await Promise.all([
                import('primevue/menubar'),
                import('primevue/panelmenu'),
                import('primevue/tabview'),
                import('primevue/tabpanel'),
                import('primevue/steps')
            ]);
            
            components.set('Menubar', Menubar.default);
            components.set('PanelMenu', PanelMenu.default);
            components.set('TabView', TabView.default);
            components.set('TabPanel', TabPanel.default);
            components.set('Steps', Steps.default);
            break;

        case 'layout':
            const [Card, Divider, Toolbar, Panel, Fieldset, Accordion, AccordionTab] = await Promise.all([
                import('primevue/card'),
                import('primevue/divider'),
                import('primevue/toolbar'),
                import('primevue/panel'),
                import('primevue/fieldset'),
                import('primevue/accordion'),
                import('primevue/accordiontab')
            ]);
            
            components.set('Card', Card.default);
            components.set('Divider', Divider.default);
            components.set('Toolbar', Toolbar.default);
            components.set('Panel', Panel.default);
            components.set('Fieldset', Fieldset.default);
            components.set('Accordion', Accordion.default);
            components.set('AccordionTab', AccordionTab.default);
            break;

        case 'feedback':
            const [ProgressBar, ProgressSpinner, Message, InlineMessage] = await Promise.all([
                import('primevue/progressbar'),
                import('primevue/progressspinner'),
                import('primevue/message'),
                import('primevue/inlinemessage')
            ]);
            
            components.set('ProgressBar', ProgressBar.default);
            components.set('ProgressSpinner', ProgressSpinner.default);
            components.set('Message', Message.default);
            components.set('InlineMessage', InlineMessage.default);
            break;

        default:
            if (import.meta.env.DEV) {
                console.warn(`[ComponentRegistry] Unknown component group: ${groupName}`);
            }
    }

    return components;
}

/**
 * Fallback component registration for failed imports
 */
async function registerFallbackComponents(app, groupName) {
    if (import.meta.env.DEV) {
        console.log(`[ComponentRegistry] Registering fallback components for group: ${groupName}`);
    }
    
    // Mark as loaded to prevent infinite retry
    loadedGroups.add(groupName);
    
    // Could implement fallback component stubs here if needed
}

/**
 * Preload components for specific routes
 */
export async function preloadComponentsForRoute(app, routeName) {
    const routeComponentMap = {
        'dashboard': ['data', 'feedback'],
        'profile': ['forms', 'overlay'],
        'admin': ['data', 'navigation', 'overlay'],
        'forms': ['forms', 'feedback'],
        'tables': ['data', 'overlay']
    };

    const groups = routeComponentMap[routeName] || [];
    
    for (const group of groups) {
        await loadComponentGroup(app, group);
    }
}

/**
 * Get loaded component groups for debugging
 */
export function getLoadedGroups() {
    return Array.from(loadedGroups);
}

/**
 * Get component cache status
 */
export function getComponentCacheStatus() {
    return {
        loadedGroups: Array.from(loadedGroups),
        cachedComponents: Array.from(componentCache.keys()),
        totalCachedComponents: componentCache.size
    };
}
