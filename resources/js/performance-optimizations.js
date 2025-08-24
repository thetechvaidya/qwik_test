/**
 * Performance Optimization Examples
 * 
 * This file demonstrates the performance optimizations implemented
 * as part of the comprehensive audit recommendations.
 */

// 1. Component Lazy Loading Example
// Instead of importing heavy components directly:
// import HeavyDashboardComponent from './Components/HeavyDashboardComponent.vue'

// Use defineAsyncComponent for better performance:
import { defineAsyncComponent } from 'vue'

export const HeavyDashboardComponent = defineAsyncComponent(
    () => import('./Components/HeavyDashboardComponent.vue')
)

export const ChartComponent = defineAsyncComponent(
    () => import('./Components/Charts/ChartComponent.vue')
)

export const DataTableComponent = defineAsyncComponent(
    () => import('./Components/DataTable/DataTableComponent.vue')
)

// 2. Route-based Code Splitting Example
// For large admin pages, use lazy loading in route definitions:
export const AdminRoutes = [
    {
        path: '/admin/dashboard',
        component: () => import('./Pages/Admin/Dashboard.vue'),
        name: 'admin.dashboard'
    },
    {
        path: '/admin/users',
        component: () => import('./Pages/Admin/Users.vue'),
        name: 'admin.users'
    },
    {
        path: '/admin/analytics',
        component: () => import('./Pages/Admin/Analytics.vue'),
        name: 'admin.analytics'
    }
]

// 3. Conditional Loading Example
// Load components only when needed:
export const loadComponentWhenNeeded = (condition) => {
    if (condition) {
        return defineAsyncComponent(() => import('./Components/ConditionalComponent.vue'))
    }
    return null
}

// 4. Preload Strategy for Critical Components
// Preload components that are likely to be used soon:
export const preloadCriticalComponents = () => {
    // Preload user dashboard components
    import('./Pages/User/Dashboard.vue')
    
    // Preload frequently used components
    import('./Components/ExamSession/ExamInterface.vue')
    import('./Components/Quiz/QuizInterface.vue')
}

// 5. Bundle Splitting Configuration
// This configuration is applied in vite.config.js:
/*
manualChunks: (id) => {
  // Core Vue ecosystem
  if (id.includes('vue') || id.includes('@vue') || id.includes('@inertiajs')) {
    return 'vue-core';
  }
  
  // PrimeVue components
  if (id.includes('primevue/') || id.includes('@primeuix/')) {
    return 'primevue';
  }
  
  // Large libraries
  if (id.includes('chart.js') || id.includes('@tiptap/')) {
    return 'vendor-large';
  }
  
  // Other vendor dependencies
  if (id.includes('node_modules')) {
    return 'vendor';
  }
}
*/

export default {
    HeavyDashboardComponent,
    ChartComponent,
    DataTableComponent,
    AdminRoutes,
    loadComponentWhenNeeded,
    preloadCriticalComponents
}
