# Breaking Changes Documentation

This document outlines all breaking changes introduced during the comprehensive migration of the Laravel application from legacy technologies to modern alternatives. **Please review this document carefully** before deploying to production.

## Table of Contents

1. [Vue 2 to Vue 3 Breaking Changes](#vue-2-to-vue-3-breaking-changes)
2. [PrimeVue 3 to 4 Breaking Changes](#primevue-3-to-4-breaking-changes)
3. [Inertia 1.x to 2.x Breaking Changes](#inertia-1x-to-2x-breaking-changes)
4. [CKEditor to Tiptap Breaking Changes](#ckeditor-to-tiptap-breaking-changes)
5. [Vuex to Pinia Breaking Changes](#vuex-to-pinia-breaking-changes)
6. [Laravel Mix to Vite Breaking Changes](#laravel-mix-to-vite-breaking-changes)
7. [Vuelidate v1 to v2 Breaking Changes](#vuelidate-v1-to-v2-breaking-changes)
8. [Development Workflow Changes](#development-workflow-changes)
9. [API Changes](#api-changes)
10. [Environment and Configuration Changes](#environment-and-configuration-changes)

## Vue 2 to Vue 3 Breaking Changes

### Component Registration
- **Before**: Global component registration was automatic
- **After**: Components must be explicitly registered or imported
- **Impact**: Custom components may not render if not properly registered

### Template Syntax
- **Before**: Multiple root elements required wrapper div
- **After**: Multiple root elements are supported (fragments)
- **Impact**: Some CSS styles targeting root elements may need adjustment

### Lifecycle Hooks
- **Before**: `beforeDestroy` and `destroyed`
- **After**: `beforeUnmount` and `unmounted`
- **Impact**: Component cleanup logic may not execute properly

### Global API Changes
- **Before**: `Vue.prototype.$property`
- **After**: `app.config.globalProperties.$property`
- **Impact**: Global properties and plugins need re-registration

### Event Handling
- **Before**: `this.$on`, `this.$off`, `this.$once`
- **After**: Use external event library (mitt) or props/emits
- **Impact**: Event bus patterns need refactoring

### Filters
- **Before**: Template filters `{{ value | filter }}`
- **After**: Computed properties or methods
- **Impact**: All template filters must be converted

### Teleport (Previously Portal)
- **Before**: `<portal to="target">`
- **After**: `<teleport to="target">`
- **Impact**: Modal and overlay positioning may need adjustment

## PrimeVue 3 to 4 Breaking Changes

### Component Name Changes
| PrimeVue 3 | PrimeVue 4 | Migration Status |
|------------|------------|------------------|
| `InputSwitch` | `ToggleSwitch` | ✅ Completed |
| `Dropdown` | `Select` | ✅ Completed |
| `Sidebar` | `Drawer` | ✅ Completed |
| `OverlayPanel` | `Popover` | ✅ Completed |
| `Calendar` | `DatePicker` | ✅ Completed |

### Theming System
- **Before**: SASS-based themes with variables
- **After**: CSS custom properties (CSS variables)
- **Impact**: 
  - Custom theme overrides need conversion
  - Theme switching requires CSS variable updates
  - Build process no longer compiles SASS themes

### Configuration Changes
```javascript
// Before (PrimeVue 3)
app.use(PrimeVue, { 
    theme: 'saga-blue',
    locale: { ... }
});

// After (PrimeVue 4)
app.use(PrimeVue, {
    theme: {
        preset: Aura,
        options: {
            darkModeSelector: '.dark-mode'
        }
    }
});
```

### CSS Class Changes
- **Removed Classes**: `.p-link`, `.p-highlight`, `.p-fluid`
- **Changed Classes**: Button states, form control styling
- **Impact**: Custom CSS targeting these classes will break

### Import Path Changes
- **Before**: `import { ... } from 'primevue/api'`
- **After**: Direct component imports only
- **Impact**: API utilities may need alternative solutions

## Inertia 1.x to 2.x Breaking Changes

### Form Handling
```javascript
// Before (Inertia 1.x)
this.$inertia.form({
    name: '',
    email: ''
}).post('/users');

// After (Inertia 2.x)
import { useForm } from '@inertiajs/vue3';
const form = useForm({
    name: '',
    email: ''
});
form.post('/users');
```

### Navigation Methods
```javascript
// Before (Inertia 1.x)
this.$inertia.visit('/dashboard');
this.$inertia.get('/users');

// After (Inertia 2.x)
import { router } from '@inertiajs/vue3';
router.visit('/dashboard');
router.get('/users');
```

### Link Component
```vue
<!-- Before (Inertia 1.x) -->
<inertia-link href="/dashboard">Dashboard</inertia-link>

<!-- After (Inertia 2.x) -->
<Link href="/dashboard">Dashboard</Link>
```

### Component Registration
- **Impact**: All components using Inertia features need import updates
- **Backward Compatibility**: Global aliases provided during transition

## CKEditor to Tiptap Breaking Changes

### Editor Initialization
```javascript
// Before (CKEditor)
CKEDITOR.replace('editor', {
    toolbar: [...],
    plugins: [...]
});

// After (Tiptap)
import { useEditor } from '@tiptap/vue-3';
const editor = useEditor({
    extensions: [StarterKit, Mathematics, Image],
    content: '<p>Hello World!</p>'
});
```

### Content Format
- **Before**: HTML string with CKEditor-specific formatting
- **After**: JSON document structure (ProseMirror)
- **Impact**: Existing content may need conversion

### Mathematical Content
- **Before**: CKEditor MathJax plugin
- **After**: Tiptap Mathematics extension with KaTeX
- **Impact**: Mathematical formulas may render differently

### File Upload Integration
- **Before**: CKEditor upload adapter
- **After**: Custom Tiptap image extension
- **Impact**: Upload flow needs re-implementation

### Toolbar Configuration
- **Before**: CKEditor toolbar config object
- **After**: Tiptap extension configuration
- **Impact**: Toolbar customizations need complete rewrite

## Vuex to Pinia Breaking Changes

### Store Definition
```javascript
// Before (Vuex)
const store = new Vuex.Store({
    state: { count: 0 },
    mutations: { increment(state) { state.count++ } },
    actions: { async fetchData({ commit }) { ... } }
});

// After (Pinia)
import { defineStore } from 'pinia';
export const useCounterStore = defineStore('counter', {
    state: () => ({ count: 0 }),
    actions: {
        increment() { this.count++ },
        async fetchData() { ... }
    }
});
```

### Usage in Components
```javascript
// Before (Vuex)
computed: {
    ...mapState(['count']),
    ...mapGetters(['doubleCount'])
},
methods: {
    ...mapActions(['increment'])
}

// After (Pinia)
import { useCounterStore } from '@/stores/counter';
const counter = useCounterStore();
// Direct access: counter.count, counter.increment()
```

### Module System
- **Before**: Vuex modules with namespacing
- **After**: Individual Pinia stores
- **Impact**: Module-based organization needs restructuring

## Laravel Mix to Vite Breaking Changes

### Asset Compilation
```javascript
// Before (Laravel Mix)
mix.js('resources/js/app.js', 'public/js')
   .vue()
   .sass('resources/sass/app.scss', 'public/css');

// After (Vite)
// Configuration in vite.config.js
export default defineConfig({
    plugins: [
        laravel(['resources/js/app.js', 'resources/css/app.css']),
        vue()
    ]
});
```

### Asset References
```php
<!-- Before (Laravel Mix) -->
<script src="{{ mix('js/app.js') }}"></script>

<!-- After (Vite) -->
@vite(['resources/js/app.js', 'resources/css/app.css'])
```

### Environment Variables
- **Before**: `process.env.NODE_ENV`
- **After**: `import.meta.env.MODE`
- **Impact**: Environment checks need updating

### Hot Module Replacement
- **Before**: Laravel Mix HMR on port 8080
- **After**: Vite HMR on port 5173
- **Impact**: Development URLs and proxy settings

## Vuelidate v1 to v2 Breaking Changes

### Import Changes
```javascript
// Before (Vuelidate v1)
import { required, email } from 'vuelidate/lib/validators';

// After (Vuelidate v2)
import { required, email } from '@vuelidate/validators';
import { useVuelidate } from '@vuelidate/core';
```

### Validation Setup
```javascript
// Before (Vuelidate v1)
validations: {
    email: { required, email },
    password: { required, minLength: minLength(8) }
}

// After (Vuelidate v2)
setup() {
    const rules = {
        email: { required, email },
        password: { required, minLength: minLength(8) }
    };
    const v$ = useVuelidate(rules, formData);
    return { v$ };
}
```

### Error Handling
- **Before**: `$v.field.$error`, `$v.field.$invalid`
- **After**: `v$.field.$error`, `v$.field.$invalid`
- **Impact**: Template validation checks need prefix update

## Development Workflow Changes

### Development Server
```bash
# Before (Laravel Mix)
npm run hot
npm run watch

# After (Vite)
npm run dev
npm run build
```

### Build Commands
```bash
# Before (Laravel Mix)
npm run production

# After (Vite)
npm run build
npm run build:production
```

### Asset Optimization
- **Before**: Laravel Mix handled optimization
- **After**: Vite with manual chunk splitting
- **Impact**: Bundle analysis and optimization strategies

### Testing Commands
```bash
# New performance testing
npm run test:performance
npm run analyze
npm run vitals
```

## API Changes

### Authentication
- **Maintained**: Existing API authentication remains unchanged
- **New**: Enhanced error handling and response formats

### Response Formats
- **Inertia Responses**: Now use Inertia 2.x format
- **JSON API**: Maintains backward compatibility
- **Error Responses**: Enhanced error messages and codes

## Environment and Configuration Changes

### Required Node.js Version
- **Before**: Node.js 14+
- **After**: Node.js 18+ (required for Vite)

### PHP Requirements
- **Before**: PHP 7.4+
- **After**: PHP 8.2+ (Laravel 11 requirement)

### Build Artifacts
- **Before**: `public/js/`, `public/css/`, `public/mix-manifest.json`
- **After**: `public/build/`, `public/build/.vite/`, `public/build/manifest.json`

### Environment Variables
```env
# New variables for Vite
VITE_APP_NAME="${APP_NAME}"
VITE_APP_ENV="${APP_ENV}"

# Existing variables remain the same
APP_NAME="QuizTime"
APP_ENV=local
```

## Migration Timeline and Rollback Procedures

### Phase 1: Preparation ✅ Completed
- Dependency updates
- Configuration changes
- Backward compatibility setup

### Phase 2: Component Migration ✅ Completed
- Vue 3 component updates
- PrimeVue 4 component replacements
- Inertia 2 form handling

### Phase 3: Testing and Validation ✅ Completed
- Comprehensive test suite
- Browser compatibility testing
- Performance validation

### Phase 4: Production Deployment 🔄 In Progress
- Gradual rollout
- Monitoring and alerts
- Rollback procedures

## Rollback Procedures

### Emergency Rollback
1. Revert to previous Git commit: `git checkout production-backup`
2. Restore database backup if needed
3. Update environment variables
4. Clear application caches

### Partial Rollback
1. Use feature flags to disable new functionality
2. Serve legacy assets for specific components
3. Maintain dual compatibility during transition

## Testing Strategy

### Browser Compatibility
- **Supported**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+
- **Testing**: Automated browser testing with Playwright/Cypress

### Performance Testing
- **Tools**: Lighthouse, WebPageTest, custom performance monitors
- **Targets**: LCP < 2.5s, FID < 100ms, CLS < 0.1

### Regression Testing
- **Automated**: PHPUnit, Jest, Cypress test suites
- **Manual**: User workflow validation, admin function testing

## Support and Documentation

### Migration Guides
- [Vue 2 to Vue 3 Migration Guide](./VUE_3_MIGRATION_GUIDE.md)
- [PrimeVue 3 to 4 Migration Guide](./PRIMEVUE_4_MIGRATION_GUIDE.md)
- [Inertia 1 to 2 Migration Guide](./INERTIA_2_MIGRATION_GUIDE.md)

### Getting Help
- **Development Team**: Internal documentation and code reviews
- **Community**: Vue 3, PrimeVue, Inertia community forums
- **Official Documentation**: Framework-specific documentation sites

## Version Compatibility Matrix

| Technology | Previous Version | Current Version | Compatibility Mode |
|------------|------------------|-----------------|-------------------|
| Vue | 2.6.12 | 3.5.0 | ✅ Enabled |
| PrimeVue | 3.50.0 | 4.3.6 | ❌ Breaking |
| Inertia | 1.x | 2.x | ✅ Backwards Compatible |
| Laravel | 8.41.0 | 11.x | ❌ Breaking |
| Node.js | 14+ | 18+ | ❌ Breaking |
| PHP | 7.4+ | 8.2+ | ❌ Breaking |

---

**Important**: This document should be reviewed and updated after each major deployment. Keep team members informed of any breaking changes that may affect their development workflow.
