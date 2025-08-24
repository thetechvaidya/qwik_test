# Performance Optimization Fixes

## 🚨 Critical: Remove Duplicate Code in app.js

**File**: `resources/js/app.js`
**Issue**: Lines 832-1250 contain duplicate `createInertiaApp` setup

**Action**: Remove the entire duplicate block (lines 832-1250) and keep only the first implementation (lines 383-815).

**Impact**: 
- Reduces bundle size by ~50%
- Eliminates potential runtime conflicts
- Improves application startup time

## 🔧 Vite Configuration Optimization

**File**: `vite.config.js`

### Simplify Chunk Strategy
**Current**: 20+ manual chunk definitions
**Recommended**: Simplified approach

```javascript
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
```

### Reduce Chunk Size Limit
```javascript
chunkSizeWarningLimit: 500, // Reduced from 800
```

## 📊 Database Optimization

### Add Query Caching
**Files**: Model files in `app/Models/`

**Example for frequently accessed data**:
```php
// In User model
public function getActiveSubscription()
{
    return Cache::remember(
        "user.{$this->id}.active_subscription",
        3600, // 1 hour
        fn() => $this->subscriptions()->active()->first()
    );
}
```

### Implement Eager Loading
**Example in Controllers**:
```php
// Instead of
$users = User::all();

// Use
$users = User::with(['subscriptions', 'payments', 'examSessions'])->get();
```

## 🚀 Additional Optimizations

### 1. Add Redis Caching
**Update**: `.env`
```env
CACHE_DRIVER=redis
SESSION_DRIVER=redis
QUEUE_CONNECTION=redis
```

### 2. Optimize Images
**Add to**: `package.json` scripts
```json
"optimize:images": "imagemin resources/images/**/*.{jpg,png,svg} --out-dir=public/optimized-images --plugin=imagemin-mozjpeg --plugin=imagemin-pngquant"
```

### 3. Implement Component Lazy Loading
**Example in Vue components**:
```javascript
// Instead of
import HeavyComponent from './HeavyComponent.vue'

// Use
const HeavyComponent = defineAsyncComponent(() => import('./HeavyComponent.vue'))
```
