# Tiptap Migration Guide

## Overview

This guide documents the comprehensive migration from CKEditor4-Vue to Tiptap for Vue 3 compatibility across the educational platform. The migration maintains full feature parity while modernizing the rich text editing experience.

## Migration Summary

### What Changed

- **Editor Library**: CKEditor4-Vue → Tiptap v2.8.0
- **Vue Compatibility**: Vue 2 → Vue 3 support
- **Mathematical Rendering**: MathJax + KaTeX (dual support)
- **RTL Support**: Native text direction handling
- **Image Handling**: Integrated upload system
- **Build System**: ESM module compatibility

### Components Updated

**Core Editor Components:**
- `TiptapEditor.vue` - New comprehensive editor component
- `TextEditor.vue` - Backward compatibility wrapper (intentionally kept)

**Question Components:**
- `Pages/Admin/Question/Details.vue`
- `Pages/Admin/Question/Solution.vue`
- `Components/Questions/MSAOptions.vue`
- `Components/Questions/MMAOptions.vue`
- `Components/Questions/TOFOptions.vue`
- `Components/Questions/MTFOptions.vue`
- `Components/Questions/ORDOptions.vue`

**Form Components:**
- `Pages/Admin/Quiz/Details.vue`
- `Pages/Admin/Exam/Details.vue`
- `Pages/Admin/PracticeSet/Details.vue`
- `Pages/Admin/Lesson/Form.vue`
- `Pages/Admin/Video/Form.vue`
- `Components/Forms/ComprehensionForm.vue`
- Note: SectionForm.vue, TopicForm.vue, PlanForm.vue do not use rich text editors

**Layout Updates:**
- `resources/views/app.blade.php` - KaTeX integration
- `resources/css/app.css` - Tiptap global styles

## TiptapEditor API

### Props

```javascript
{
  modelValue: String,      // Content (v-model)
  config: Object,          // Editor configuration
  invalid: Boolean,        // Validation state
  height: String,          // Editor height ('200px', 'auto')
  placeholder: String      // Placeholder text
}
```

### Configuration Options

```javascript
const config = {
  // Toolbar type: 'basic' | 'advanced' | false (no toolbar)
  toolbar: 'advanced',
  
  // Feature flags for fine-grained control
  features: {
    color: true,          // Text color picker
    highlight: false,     // Text highlighting
    math: true,          // Mathematics insertion
    images: true,        // Image upload
    links: true,         // Link insertion
    allowRelativeLinks: false // Allow relative paths (/path) alongside absolute URLs
  },
  
  // RTL support
  rtl: true|false,
  
  // Height (alternative to height prop)
  height: '250px',
  
  // Placeholder (alternative to placeholder prop)
  placeholder: 'Enter text...',
  
  // Math auto-rendering (for mathematical content)
  useAutoRenderForMath: true
}
```

### Usage Examples

**Basic Editor:**
```vue
<TiptapEditor 
  v-model="content" 
  :config="{ toolbar: 'basic', rtl: $page.props.rtl }" 
  :height="'75px'" 
/>
```

**Advanced Editor with Math:**
```vue
<TiptapEditor 
  v-model="question" 
  :config="{ 
    toolbar: 'advanced', 
    rtl: $page.props.rtl 
  }" 
  :height="'200px'" 
  :placeholder="__('Enter question text...')"
  :invalid="errors.question"
/>
```

## Feature Mapping

### CKEditor4 → Tiptap Feature Mapping

| CKEditor4 Feature | Tiptap Implementation |
|-------------------|----------------------|
| Basic formatting | StarterKit extension |
| Math expressions | Mathematics extension + KaTeX |
| Image uploads | Image extension + custom handler |
| RTL support | TextDirection extension |
| Custom toolbars | Configurable toolbar system |
| Subscript/Superscript | Dedicated extensions |
| Text alignment | TextAlign extension |
| Links | Link extension |

### Toolbar Presets

**Basic Toolbar:**
- Bold, Italic, Underline
- Subscript, Superscript  
- Text alignment
- Lists (bullet, ordered)

**Advanced Toolbar:**
- All basic features
- Mathematics (KaTeX)
- Image upload
- Link insertion
- Extended formatting

## Mathematical Content Handling

### KaTeX Integration

Mathematical expressions are handled through the Tiptap Mathematics extension with KaTeX rendering:

```javascript
// Inline math
$E = mc^2$

// Display math  
$$\int_{-\infty}^{\infty} e^{-x^2} dx = \sqrt{\pi}$$
```

### Legacy Content

Existing mathematical content using MathJax delimiters continues to work through the dual rendering system in `app.blade.php`. An optional MathJax v3 loader can be enabled via the config flag `config('qwiktest.enable_mathjax')` for advanced mathematical content that requires MathJax-specific features.

**Enabling MathJax v3:**
```php
// In config/qwiktest.php or .env
'enable_mathjax' => true,
```

Both KaTeX (primary) and MathJax (optional) renderers exclude Tiptap editor content using `ignoredClasses` to prevent conflicts during editing.

## RTL Language Support

RTL support is handled through the third-party `tiptap-text-direction-extension` package:

### Text Direction Extension Choice

The project uses `tiptap-text-direction-extension: ^1.0.7` instead of an official Tiptap extension because:
- **Proven Stability**: Well-tested community extension with consistent RTL behavior
- **Feature Completeness**: Provides comprehensive RTL/LTR switching capabilities  
- **Vue 3 Compatibility**: Confirmed compatible with Tiptap 2.8.0 and Vue 3.5.0
- **SSR Safe**: No server-side rendering conflicts or hydration issues

**Alternative Considerations:**
- Official `@tiptap/extension-text-direction` does not exist as of Tiptap v2.8.0
- The chosen package provides robust bidirectional text support needed for Arabic/Hebrew content

**Version Locking:**
The version is locked to `^1.0.7` to ensure stability. Future updates should be tested thoroughly for compatibility with the current Tiptap version.

```javascript
// Automatic RTL detection
rtl: $page.props.rtl

// Manual direction setting
editor.commands.setTextDirection('rtl')
```

## Image Upload System

Images are uploaded through the existing MediaLibraryFileController:

```javascript
// Upload endpoint
POST /admin/file-manager/upload

// Supported response formats
{ url: "path/to/image.jpg" }
{ location: "path/to/image.jpg" }  
{ link: "path/to/image.jpg" }
{ data: { url: "path/to/image.jpg" } }
```

## Styling and Theming

### Global Styles

Tiptap-specific styles are defined in `resources/css/app.css`:

- Typography (headings, paragraphs)
- List styling with RTL support
- Mathematical content styling
- Image and link styling
- Placeholder styling

### Custom CSS Classes

- `.tiptap-editor` - Main editor container
- `.tiptap-toolbar` - Toolbar container
- `.tiptap-content` - Content area
- `.ProseMirror` - Core editor styles

## Migration Testing

### Test Coverage

Run the migration test suite:

```bash
php artisan test tests/Feature/TiptapMigrationTest.php
```

Test cases cover:
- Component initialization
- Mathematical content
- RTL functionality  
- Image uploads
- Toolbar configurations
- Large content performance
- Backward compatibility

## Known Limitations

### Content Size Validation

Tiptap's rich HTML output may generate larger payloads than plain text. Backend validation rules should account for HTML structure:

**Recommendations:**
- Increase validation limits from 1,000 to 10,000+ characters for rich text fields
- Implement HTML normalization and compression on save
- Consider content size monitoring for performance optimization
- Review validation rules in form requests and model validation

**Example Backend Validation Update:**
```php
// Before: Simple text validation
'question' => 'required|string|max:1000',

// After: Rich HTML validation
'question' => 'required|string|max:10000',
'solution' => 'required|string|max:15000', // Longer content
```

### TextEditor.vue Compatibility Wrapper

The `TextEditor.vue` component is intentionally maintained as a compatibility wrapper to ensure backward compatibility for existing components and prevent breaking changes. This allows for gradual migration while maintaining system stability.

**Backward Compatibility Maintained:**
- Existing imports continue to work without modification
- All existing component templates function correctly
- No breaking changes for legacy codebases

**Migration Path:**
```javascript
// Current (supported)
import TextEditor from '@/Components/TextEditor'

// Recommended for new development  
import TiptapEditor from '@/Components/TiptapEditor'
```

### Legacy Route Deprecation

Several CKEditor-specific routes are deprecated but maintained for backward compatibility:

**Deprecated Routes:**
- `GET /admin/file-manager/ckeditor` - CKEditor file browser integration
- `GET /admin/file-manager/fm-button` - CKEditor file manager button

**Migration Path:**
- Use the new Media Library endpoints: `/admin/file-manager/*`
- Update any direct route calls to use the modern file management system
- Legacy routes include deprecation warnings in development mode

**Controllers:**
- `FileController` - Legacy file management (deprecated)
- `MediaLibraryFileController` - Modern file management (recommended)

### Height Configuration

Height can be set via prop or config object. The prop takes precedence:

```javascript
// Via prop (recommended)
:height="'200px'"

// Via config (fallback)
:config="{ height: '200px' }"
```

### User Experience Improvements

Current implementation uses browser `prompt()` dialogs for user input. Future enhancements should consider:

**Planned UX Improvements:**
- Replace math expression prompts with inline equation editors
- Use PrimeVue ColorPicker for text color selection
- Implement PrimeVue Dialog components for link insertion
- Add visual feedback for toolbar interactions

**Current Fallbacks:**
- Mathematical expressions require manual LaTeX input through prompts
- Color selection via text input with validation
- Link insertion through simple URL prompts

These improvements can be implemented without breaking the existing API by using feature flags in the configuration object.

## Troubleshooting

### Common Issues

**Build Errors:**
- Ensure all CKEditor imports are removed
- Verify Tiptap extensions are installed
- Check ESM module configuration

**Styling Issues:**
- Confirm global Tiptap styles are loaded
- Check RTL-specific CSS rules
- Verify component-level styling

**Performance:**
- Large documents may require pagination
- Consider lazy loading for multiple editors
- Monitor memory usage with many instances

### Debug Mode

Enable debug logging for Tiptap issues:

```javascript
// In TiptapEditor.vue
console.log('Editor state:', editor.getJSON())
console.log('HTML output:', editor.getHTML())
```

## Server-Side Security and Sanitization

### HTML Content Sanitization Requirements

**Critical Security Note:** Client-side validation in TiptapEditor is not sufficient for security. Server-side HTML sanitization is required to prevent XSS attacks and ensure content security.

**Recommended Approach:**

1. **Install a Laravel-compatible sanitizer:**
```bash
composer require mewebstudio/purifier
```

2. **Configure HTML Purifier in your service provider:**
```php
// config/purifier.php
return [
    'encoding' => 'UTF-8',
    'finalize' => true,
    'cachePath' => storage_path('app/purifier'),
    'settings' => [
        'default' => [
            'HTML.Allowed' => 'p,b,strong,i,em,u,sub,sup,ul,ol,li,br,span[style],div[class],a[href|title],img[src|alt|width|height]',
            'CSS.AllowedProperties' => 'font-weight,font-style,text-decoration,color,text-align',
            'Attr.AllowedFrameTargets' => ['_blank'],
            'HTML.SafeIframe' => true,
            'URI.SafeIframeRegexp' => '%^(https?:)?//(www\.youtube\.com/embed/|player\.vimeo\.com/video/)%',
        ]
    ]
];
```

3. **Implement sanitization in Form Requests:**
```php
use Mews\Purifier\Facades\Purifier;

class UpdateQuestionRequest extends FormRequest
{
    protected function prepareForValidation()
    {
        $this->merge([
            'question' => Purifier::clean($this->question),
            'solution' => Purifier::clean($this->solution),
        ]);
    }
}
```

4. **Alternative: Custom DOMPurify Integration**
For more granular control, consider implementing DOMPurify on the server side using Node.js or a similar approach for consistent sanitization across client and server.

**Mathematical Content Considerations:**
- Preserve KaTeX math delimiters (`$...$`, `$$...$$`) during sanitization
- Allow math-specific HTML classes (`math-inline`, `math-display`, `katex-*`)
- Test mathematical expressions after sanitization to ensure rendering integrity

### Backend Validation Adjustments

**Content Length Validation:**
Rich HTML content generates larger payloads than plain text. Update validation rules accordingly:

```php
// Before: Plain text validation
'question' => 'required|string|max:1000',

// After: Rich HTML validation  
'question' => 'required|string|max:10000',
'solution' => 'required|string|max:15000',
```

**Additional Security Measures:**
- Implement rate limiting on content-heavy endpoints
- Monitor payload sizes and implement compression
- Consider content security policies (CSP) for additional protection

## Support and Maintenance

### Version Compatibility

- **Tiptap**: v2.8.0+ (Vue 3 compatible)
- **Vue**: 3.5.0+
- **KaTeX**: 0.16.0+
- **Laravel**: 11.x

### Future Considerations

- Potential upgrade to Tiptap v3.x
- Enhanced mathematical input methods
- Collaborative editing capabilities
- Mobile responsiveness improvements

---

**Migration Date:** August 2025  
**Migrated Components:** 50+ files  
**Backward Compatibility:** Maintained via TextEditor wrapper  
**Test Coverage:** Comprehensive feature and regression tests
