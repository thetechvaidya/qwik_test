# Inertia.js 2.x Migration Guide

This guide provides comprehensive information for migrating from Inertia.js 1.x to 2.x within the QwikTest application.

## ⚡ Quick Start Checklist

Before migrating to Inertia 2.x, ensure these critical requirements are met:

- [ ] **CRITICAL**: Verify `@routes` directive is present in `resources/views/app.blade.php`
- [ ] **CRITICAL**: Ensure `<div id="modals"></div>` exists in the main Blade template
- [ ] Run `php artisan ziggy:generate` to generate route definitions
- [ ] Install Inertia 2.x packages: `npm install @inertiajs/vue3`
- [ ] Update imports from `@inertiajs/inertia-vue3` to `@inertiajs/vue3`
- [ ] Test production build to ensure route helper works correctly

**⚠️ PRODUCTION FAILURE WARNING**: Missing `@routes` directive will cause hard-fail in production builds with no fallback (unless `VITE_ENFORCE_ZIGGY=false` is set in your environment).
### Example .env

```env
VITE_ENFORCE_ZIGGY=true
```

## Overview

Inertia.js 2.x introduces modern patterns while maintaining backward compatibility through careful aliasing and helper functions. This migration focuses on updating core patterns while ensuring existing components continue to work.

## Key Migration Patterns

### 1. Component Imports

**Before (Inertia 1.x):**
```javascript
import { InertiaLink, createInertiaApp } from '@inertiajs/inertia-vue3'
```

**After (Inertia 2.x):**
```javascript
import { Link, createInertiaApp } from '@inertiajs/vue3'
```

### 2. Link Components

**Before:**
```vue
<template>
  <inertia-link href="/dashboard">Dashboard</inertia-link>
</template>
```

**After:**
```vue
<template>
  <Link href="/dashboard">Dashboard</Link>
</template>
```

### 3. Form Handling

**Before (Options API):**
```javascript
data() {
  return {
    form: this.$inertia.form({
      name: '',
      email: ''
    })
  }
},
methods: {
  submit() {
    this.form.post('/users')
  }
}
```

**After (Modern Pattern):**
```javascript
import { useForm } from '@inertiajs/vue3'

data() {
  return {
    form: useForm({
      name: '',
      email: ''
    })
  }
},
methods: {
  submit() {
    this.form.post('/users')
  }
}
```

**Composition API Pattern:**
```javascript
import { useForm } from '@inertiajs/vue3'

setup() {
  const form = useForm({
    name: '',
    email: ''
  })
  
  const submit = () => {
    form.post('/users')
  }
  
  return { form, submit }
}
```

### Navigation Methods

**Before:**
```javascript
// Visit a URL
this.$inertia.visit('/dashboard')

// HTTP methods
this.$inertia.get('/users')
this.$inertia.post('/users', data)
this.$inertia.put('/users/1', data)
this.$inertia.delete('/users/1')
```

**After:**
```javascript
import { router } from '@inertiajs/vue3'

// Visit a URL
router.visit('/dashboard')

// HTTP methods
router.get('/users')
router.post('/users', data)
router.put('/users/1', data)
router.delete('/users/1')
```

**⚠️ DEPRECATED: `this.$inertia.*` router methods**
The global `$inertia` object is no longer augmented with router methods in Inertia 2.x. Components should use `router.*` directly by importing from `@inertiajs/vue3`.

**🔧 PRODUCTION COMPATIBILITY: Legacy Router Proxies**
**CURRENT STATUS**: Legacy router proxies are currently enabled in **development only** due to extensive remaining usage. Production builds require explicit migration to `router.*` methods.

**TEMPORARY SOLUTION**: For backward compatibility during migration, production proxies can be temporarily enabled in `app.js` until all `this.$inertia.*` usages are migrated:

- `this.$inertia.get()` → `router.get()`
- `this.$inertia.post()` → `router.post()`  
- `this.$inertia.visit()` → `router.visit()`
- `this.$inertia.remember()` → `router.remember()`
- `this.$inertia.restore()` → `router.restore()`

**Migration Status:**
- **Current Phase**: Proxies enabled in development only, extensive `this.$inertia.*` usage remains
- **Immediate Need**: Either enable production proxies temporarily or migrate all usages
- **Migration Path**: Replace all `this.$inertia.*` with direct `router.*` imports

### Route Helper Usage

**Global Route Function:**
The Laravel Ziggy route helper is available through multiple access patterns:

**Options API (template and methods):**
```vue
<template>
  <Link :href="route('dashboard')">Dashboard</Link>
</template>

<script>
export default {
  methods: {
    navigate() {
      // Both work in Options API
      this.route('dashboard')     // Via mixin
      this.$app.config.globalProperties.route('dashboard') // Via global property
    }
  }
}
</script>
```

**Composition API:**
```vue
<script setup>
import { getCurrentInstance } from 'vue'

// Access via global property
const app = getCurrentInstance()
const routeFn = app.appContext.config.globalProperties.route

// Or import directly if available
// import { route } from 'ziggy-js'

const goToDashboard = () => {
  routeFn('dashboard')
}
</script>
```

**⚠️ Note**: Use `this.route()` in Options API templates and methods. For Composition API, access via the global property as shown above.

## Backward Compatibility Features

### Global Component Aliases

The migration includes backward compatibility through global component registration:

```javascript
// Both work in Inertia 2.x setup
app.component('Link', Link)           // Modern
app.component('inertia-link', Link)   // Legacy alias
```

This means existing `<inertia-link>` components will continue to work without immediate changes.

### Form Helper Aliases

Multiple form helpers are available for different migration approaches:

```javascript
// Available globally in components:
this.$form()        // Direct useForm access
this.$useForm()     // Explicit composable name
this.$inertiaForm() // Legacy naming
```

**⚠️ DEPRECATED: `this.$inertia.form()`**
The pattern `this.$inertia.form()` is deprecated in favor of direct form helper usage above.

### Route Helper

The Laravel route helper (Ziggy) is now a **required** dependency for production builds. It provides robust, named routes that are essential for application stability.

**Production Requirement:**
- The `@routes` Blade directive **must** be present in the main application layout (`app.blade.php`).
- Production builds will throw an error and fail to initialize if `window.route` is not available.
- **Ziggy is mandatory** - no fallback is provided in production to ensure route integrity.

**Development Fallback:**
- In development, a fallback is provided that logs detailed errors to the console to assist with debugging.

```javascript
// This is now a mandatory check in production - no silent fallbacks allowed
if (import.meta.env.PROD && typeof window.route !== 'function') {
    throw new Error('Laravel Ziggy route helper is not available...');
}
```

## Migration Phases

### Phase 1: Core Infrastructure ✅ COMPLETED
- [x] Update app.js with Inertia 2.x imports
- [x] Register global component aliases
- [x] Add form helper functions
- [x] Update layouts (AppLayout, AdminLayout, AuthLayout)
- [x] Update authentication pages
- [x] Update navigation components

### Phase 2: Component Updates 🔄 IN PROGRESS
- [ ] Update profile management components
- [ ] Update API token management
- [ ] Update dashboard components
- [ ] Update pagination components

### Phase 3: Testing & Validation
- [ ] Run comprehensive test suite
- [ ] Verify all navigation flows
- [ ] Test form submissions
- [ ] Validate backward compatibility

## Component Update Examples

### Navigation Links

**Before:**
```vue
<inertia-link class="nav-link" :href="route('dashboard')">
  Dashboard
</inertia-link>
```

**After:**
```vue
<Link class="nav-link" :href="route('dashboard')">
  Dashboard
</Link>
```

### Form Components

**Before:**
```vue
<script>
export default {
  data() {
    return {
      form: this.$inertia.form({
        name: '',
        email: ''
      })
    }
  },
  methods: {
    submit() {
      this.form.post(this.route('users.store'))
    }
  }
}
</script>
```

**After:**
```vue
<script>
import { useForm } from '@inertiajs/vue3'

export default {
  data() {
    return {
      form: useForm({
        name: '',
        email: ''
      })
    }
  },
  methods: {
    submit() {
      this.form.post(this.route('users.store'))
    }
  }
}
</script>
```

## Known Issues and Solutions

### 1. Page Title Handling
**Issue:** `metaInfo()` from vue-meta is deprecated.
**Solution:** Use `useHead` from @vueuse/head:

```vue
<script>
import { useHead } from '@vueuse/head'

export default {
  setup() {
    useHead({
      title: 'Page Title'
    })
  }
}
</script>
```

### 2. Active State Detection
**Issue:** `window.location.href` comparisons may not work with SPA navigation.
**Solution:** Use `$page.url` from Inertia:

```vue
<script>
export default {
  computed: {
    isActive() {
      return this.$page.url === this.targetUrl
    }
  }
}
</script>
```

## Testing Your Migration

### Manual Testing Checklist
- [ ] Login/logout functionality
- [ ] Navigation between pages
- [ ] Form submissions
- [ ] Validation error display
- [ ] Back/forward browser buttons
- [ ] Page refreshes maintain state

### Automated Tests
Run the Inertia navigation test suite:

```bash
php artisan test tests/Feature/InertiaNavigationTest.php
```

## Performance Considerations

### Bundle Size
Inertia 2.x has a smaller footprint than 1.x. Monitor bundle sizes:

```bash
npm run build
```

### Client-Side Navigation
Inertia 2.x improves client-side navigation performance. Test loading times and transitions.

## Rollback Plan

If issues arise, you can rollback by:

1. Reverting `package.json` to Inertia 1.x
2. Removing global component aliases
3. Restoring original import statements
4. Running `npm install` and rebuilding

## Additional Resources

- [Inertia.js 2.x Documentation](https://inertiajs.com/)
- [Vue 3 Composition API Guide](https://vuejs.org/guide/extras/composition-api-faq.html)
- [@vueuse/head Documentation](https://github.com/vueuse/head)

## Support

For migration issues, consult:
1. This migration guide
2. Inertia.js official documentation
3. Project maintainer
4. Laravel community resources
