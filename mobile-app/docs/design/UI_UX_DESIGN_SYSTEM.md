# QwikTest Mobile App - UI/UX Design System

## 1. Design Philosophy

### 1.1 Core Principles

**Clarity First**
- Information hierarchy is clear and intuitive
- Content is easily scannable and digestible
- Visual noise is minimized to focus on learning

**Accessibility by Design**
- WCAG 2.1 AA compliance
- High contrast ratios for readability
- Touch targets meet minimum size requirements
- Screen reader friendly

**Performance Focused**
- Lightweight components and assets
- Smooth animations and transitions
- Optimized for various device capabilities

**Consistency**
- Unified visual language across all screens
- Predictable interaction patterns
- Systematic approach to spacing and layout

### 1.2 Design Goals

- **Reduce Cognitive Load**: Minimize mental effort required to use the app
- **Increase Engagement**: Create an enjoyable and motivating learning experience
- **Build Trust**: Professional appearance that instills confidence
- **Ensure Accessibility**: Usable by people with diverse abilities

---

## 2. Color System

### 2.1 Primary Colors

```css
/* Primary Brand Colors */
--primary-50: #EEF2FF;
--primary-100: #E0E7FF;
--primary-200: #C7D2FE;
--primary-300: #A5B4FC;
--primary-400: #818CF8;
--primary-500: #6366F1; /* Main Brand Color */
--primary-600: #4F46E5;
--primary-700: #4338CA;
--primary-800: #3730A3;
--primary-900: #312E81;
--primary-950: #1E1B4B;
```

### 2.2 Secondary Colors

```css
/* Success Colors */
--success-50: #F0FDF4;
--success-100: #DCFCE7;
--success-500: #22C55E;
--success-600: #16A34A;
--success-700: #15803D;

/* Warning Colors */
--warning-50: #FFFBEB;
--warning-100: #FEF3C7;
--warning-500: #F59E0B;
--warning-600: #D97706;
--warning-700: #B45309;

/* Error Colors */
--error-50: #FEF2F2;
--error-100: #FEE2E2;
--error-500: #EF4444;
--error-600: #DC2626;
--error-700: #B91C1C;

/* Info Colors */
--info-50: #EFF6FF;
--info-100: #DBEAFE;
--info-500: #3B82F6;
--info-600: #2563EB;
--info-700: #1D4ED8;
```

### 2.3 Neutral Colors

```css
/* Neutral/Gray Scale */
--neutral-0: #FFFFFF;
--neutral-50: #F9FAFB;
--neutral-100: #F3F4F6;
--neutral-200: #E5E7EB;
--neutral-300: #D1D5DB;
--neutral-400: #9CA3AF;
--neutral-500: #6B7280;
--neutral-600: #4B5563;
--neutral-700: #374151;
--neutral-800: #1F2937;
--neutral-900: #111827;
--neutral-950: #030712;
```

### 2.4 Color Usage Guidelines

| Color | Usage | Examples |
|-------|-------|----------|
| Primary | Main actions, links, active states | Start Exam, Login Button, Active Tab |
| Success | Positive feedback, completed states | Correct Answer, Exam Passed, Success Messages |
| Warning | Caution, important notices | Time Running Low, Incomplete Profile |
| Error | Errors, failed states, destructive actions | Wrong Answer, Failed Login, Delete Account |
| Info | Informational content, tips | Exam Instructions, Help Text, Notifications |
| Neutral | Text, backgrounds, borders | Body Text, Card Backgrounds, Dividers |

---

## 3. Typography

### 3.1 Font Family

**Primary Font**: Inter
- Modern, highly legible sans-serif
- Excellent readability on mobile screens
- Wide range of weights available
- Optimized for UI design

**Fallback**: System fonts (SF Pro on iOS, Roboto on Android)

### 3.2 Type Scale

```css
/* Display Styles */
--text-display-large: {
  font-family: 'Inter', sans-serif;
  font-size: 32px;
  font-weight: 700;
  line-height: 40px;
  letter-spacing: -0.02em;
}

--text-display-medium: {
  font-family: 'Inter', sans-serif;
  font-size: 28px;
  font-weight: 700;
  line-height: 36px;
  letter-spacing: -0.02em;
}

--text-display-small: {
  font-family: 'Inter', sans-serif;
  font-size: 24px;
  font-weight: 600;
  line-height: 32px;
  letter-spacing: -0.01em;
}

/* Headline Styles */
--text-headline-large: {
  font-family: 'Inter', sans-serif;
  font-size: 20px;
  font-weight: 600;
  line-height: 28px;
  letter-spacing: -0.01em;
}

--text-headline-medium: {
  font-family: 'Inter', sans-serif;
  font-size: 18px;
  font-weight: 600;
  line-height: 24px;
  letter-spacing: -0.005em;
}

--text-headline-small: {
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  font-weight: 600;
  line-height: 24px;
  letter-spacing: 0;
}

/* Body Styles */
--text-body-large: {
  font-family: 'Inter', sans-serif;
  font-size: 16px;
  font-weight: 400;
  line-height: 24px;
  letter-spacing: 0;
}

--text-body-medium: {
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 400;
  line-height: 20px;
  letter-spacing: 0;
}

--text-body-small: {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 400;
  line-height: 16px;
  letter-spacing: 0;
}

/* Label Styles */
--text-label-large: {
  font-family: 'Inter', sans-serif;
  font-size: 14px;
  font-weight: 500;
  line-height: 20px;
  letter-spacing: 0;
}

--text-label-medium: {
  font-family: 'Inter', sans-serif;
  font-size: 12px;
  font-weight: 500;
  line-height: 16px;
  letter-spacing: 0;
}

--text-label-small: {
  font-family: 'Inter', sans-serif;
  font-size: 10px;
  font-weight: 500;
  line-height: 12px;
  letter-spacing: 0.5px;
  text-transform: uppercase;
}
```

### 3.3 Typography Usage

| Style | Usage | Examples |
|-------|-------|----------|
| Display Large | App titles, major headings | "Welcome to QwikTest" |
| Display Medium | Section titles | "Featured Exams" |
| Display Small | Card titles | "Flutter Development" |
| Headline Large | Page titles | "Dashboard", "Profile" |
| Headline Medium | Subsection titles | "Recent Activity" |
| Headline Small | Component titles | "Exam Progress" |
| Body Large | Primary content | Question text, descriptions |
| Body Medium | Secondary content | Metadata, captions |
| Body Small | Tertiary content | Timestamps, fine print |
| Label Large | Button text, form labels | "Start Exam", "Email" |
| Label Medium | Tab labels, chips | "All", "Completed" |
| Label Small | Status indicators | "NEW", "PREMIUM" |

---

## 4. Spacing System

### 4.1 Spacing Scale

```css
/* Base unit: 4px */
--space-0: 0px;
--space-1: 4px;
--space-2: 8px;
--space-3: 12px;
--space-4: 16px;
--space-5: 20px;
--space-6: 24px;
--space-8: 32px;
--space-10: 40px;
--space-12: 48px;
--space-16: 64px;
--space-20: 80px;
--space-24: 96px;
--space-32: 128px;
```

### 4.2 Spacing Usage

| Size | Usage | Examples |
|------|-------|----------|
| 4px | Tight spacing | Icon padding, small gaps |
| 8px | Close elements | Button padding, form field spacing |
| 12px | Related elements | List item spacing |
| 16px | Standard spacing | Card padding, section spacing |
| 24px | Loose spacing | Component separation |
| 32px | Section spacing | Major content blocks |
| 48px+ | Layout spacing | Screen margins, major sections |

---

## 5. Component Library

### 5.1 Buttons

#### Primary Button
```css
.button-primary {
  background: var(--primary-500);
  color: var(--neutral-0);
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  font: var(--text-label-large);
  min-height: 44px;
  min-width: 44px;
}

.button-primary:hover {
  background: var(--primary-600);
}

.button-primary:active {
  background: var(--primary-700);
}

.button-primary:disabled {
  background: var(--neutral-300);
  color: var(--neutral-500);
}
```

#### Secondary Button
```css
.button-secondary {
  background: transparent;
  color: var(--primary-500);
  border: 1px solid var(--primary-500);
  border-radius: 8px;
  padding: 12px 24px;
  font: var(--text-label-large);
  min-height: 44px;
  min-width: 44px;
}

.button-secondary:hover {
  background: var(--primary-50);
}

.button-secondary:active {
  background: var(--primary-100);
}
```

#### Ghost Button
```css
.button-ghost {
  background: transparent;
  color: var(--primary-500);
  border: none;
  border-radius: 8px;
  padding: 12px 24px;
  font: var(--text-label-large);
  min-height: 44px;
  min-width: 44px;
}

.button-ghost:hover {
  background: var(--primary-50);
}
```

### 5.2 Input Fields

#### Text Input
```css
.input-field {
  background: var(--neutral-0);
  border: 1px solid var(--neutral-300);
  border-radius: 8px;
  padding: 12px 16px;
  font: var(--text-body-large);
  min-height: 44px;
  width: 100%;
}

.input-field:focus {
  border-color: var(--primary-500);
  outline: 2px solid var(--primary-100);
  outline-offset: -1px;
}

.input-field:error {
  border-color: var(--error-500);
}

.input-field::placeholder {
  color: var(--neutral-400);
}
```

#### Search Input
```css
.search-input {
  background: var(--neutral-50);
  border: 1px solid var(--neutral-200);
  border-radius: 24px;
  padding: 12px 16px 12px 44px;
  font: var(--text-body-medium);
  position: relative;
}

.search-input::before {
  content: "🔍";
  position: absolute;
  left: 16px;
  top: 50%;
  transform: translateY(-50%);
  color: var(--neutral-400);
}
```

### 5.3 Cards

#### Basic Card
```css
.card {
  background: var(--neutral-0);
  border-radius: 12px;
  padding: var(--space-4);
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1);
  border: 1px solid var(--neutral-200);
}

.card:hover {
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15);
  transform: translateY(-2px);
  transition: all 0.2s ease;
}
```

#### Exam Card
```css
.exam-card {
  background: var(--neutral-0);
  border-radius: 16px;
  padding: var(--space-6);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  border: 1px solid var(--neutral-200);
  position: relative;
  overflow: hidden;
}

.exam-card::before {
  content: "";
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: linear-gradient(90deg, var(--primary-500), var(--primary-400));
}
```

### 5.4 Navigation

#### Bottom Navigation
```css
.bottom-nav {
  background: var(--neutral-0);
  border-top: 1px solid var(--neutral-200);
  padding: var(--space-2) var(--space-4);
  display: flex;
  justify-content: space-around;
  align-items: center;
  min-height: 64px;
}

.bottom-nav-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  gap: var(--space-1);
  padding: var(--space-2);
  border-radius: 8px;
  min-width: 44px;
  min-height: 44px;
}

.bottom-nav-item.active {
  color: var(--primary-500);
  background: var(--primary-50);
}

.bottom-nav-item:not(.active) {
  color: var(--neutral-500);
}
```

#### Tab Bar
```css
.tab-bar {
  display: flex;
  background: var(--neutral-50);
  border-radius: 8px;
  padding: var(--space-1);
  gap: var(--space-1);
}

.tab-item {
  flex: 1;
  padding: var(--space-3) var(--space-4);
  text-align: center;
  border-radius: 6px;
  font: var(--text-label-medium);
  color: var(--neutral-600);
  background: transparent;
  border: none;
  min-height: 36px;
}

.tab-item.active {
  background: var(--neutral-0);
  color: var(--primary-500);
  box-shadow: 0 1px 2px rgba(0, 0, 0, 0.1);
}
```

### 5.5 Progress Indicators

#### Progress Bar
```css
.progress-bar {
  width: 100%;
  height: 8px;
  background: var(--neutral-200);
  border-radius: 4px;
  overflow: hidden;
}

.progress-bar-fill {
  height: 100%;
  background: linear-gradient(90deg, var(--primary-500), var(--primary-400));
  border-radius: 4px;
  transition: width 0.3s ease;
}
```

#### Circular Progress
```css
.circular-progress {
  width: 48px;
  height: 48px;
  border: 4px solid var(--neutral-200);
  border-top: 4px solid var(--primary-500);
  border-radius: 50%;
  animation: spin 1s linear infinite;
}

@keyframes spin {
  0% { transform: rotate(0deg); }
  100% { transform: rotate(360deg); }
}
```

### 5.6 Alerts and Notifications

#### Success Alert
```css
.alert-success {
  background: var(--success-50);
  border: 1px solid var(--success-200);
  border-left: 4px solid var(--success-500);
  border-radius: 8px;
  padding: var(--space-4);
  color: var(--success-700);
}
```

#### Error Alert
```css
.alert-error {
  background: var(--error-50);
  border: 1px solid var(--error-200);
  border-left: 4px solid var(--error-500);
  border-radius: 8px;
  padding: var(--space-4);
  color: var(--error-700);
}
```

---

## 6. Icons

### 6.1 Icon System

**Icon Library**: Lucide Icons (or similar outline-style icons)
- Consistent stroke width (1.5px)
- 24x24px default size
- Scalable for different contexts
- Outline style for consistency

### 6.2 Icon Sizes

```css
--icon-xs: 12px;
--icon-sm: 16px;
--icon-md: 20px;
--icon-lg: 24px;
--icon-xl: 32px;
--icon-2xl: 48px;
```

### 6.3 Common Icons

| Icon | Usage | Context |
|------|-------|----------|
| Home | Home/Dashboard | Bottom navigation |
| Book | Exams/Learning | Content sections |
| User | Profile | User-related actions |
| Settings | Settings/Preferences | Configuration |
| Search | Search functionality | Search bars |
| Play | Start exam/video | Action buttons |
| Check | Completed/Correct | Status indicators |
| X | Close/Wrong | Dismissal actions |
| Arrow Right | Navigation | Forward actions |
| Arrow Left | Back navigation | Back actions |
| Clock | Time/Duration | Time-related info |
| Star | Favorites/Rating | Bookmarking |
| Download | Offline content | Download actions |
| Bell | Notifications | Alert system |

---

## 7. Layout System

### 7.1 Grid System

**Base Grid**: 4px grid system
- All elements align to 4px increments
- Consistent spacing and alignment
- Responsive breakpoints

### 7.2 Screen Margins

```css
/* Mobile (default) */
--screen-margin: 16px;

/* Tablet */
@media (min-width: 768px) {
  --screen-margin: 24px;
}

/* Large screens */
@media (min-width: 1024px) {
  --screen-margin: 32px;
}
```

### 7.3 Safe Areas

```css
.safe-area-top {
  padding-top: env(safe-area-inset-top);
}

.safe-area-bottom {
  padding-bottom: env(safe-area-inset-bottom);
}

.safe-area-left {
  padding-left: env(safe-area-inset-left);
}

.safe-area-right {
  padding-right: env(safe-area-inset-right);
}
```

---

## 8. Animation & Motion

### 8.1 Animation Principles

**Purposeful Motion**
- Animations should have clear purpose
- Guide user attention and provide feedback
- Enhance usability, not distract

**Performance First**
- Use transform and opacity for animations
- Avoid animating layout properties
- 60fps target for smooth experience

### 8.2 Timing Functions

```css
/* Easing curves */
--ease-out-cubic: cubic-bezier(0.33, 1, 0.68, 1);
--ease-in-cubic: cubic-bezier(0.32, 0, 0.67, 0);
--ease-in-out-cubic: cubic-bezier(0.65, 0, 0.35, 1);
--ease-out-quart: cubic-bezier(0.25, 1, 0.5, 1);
```

### 8.3 Duration Scale

```css
--duration-fast: 150ms;
--duration-normal: 250ms;
--duration-slow: 350ms;
--duration-slower: 500ms;
```

### 8.4 Common Animations

#### Fade In
```css
@keyframes fadeIn {
  from {
    opacity: 0;
    transform: translateY(8px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

.fade-in {
  animation: fadeIn var(--duration-normal) var(--ease-out-cubic);
}
```

#### Scale In
```css
@keyframes scaleIn {
  from {
    opacity: 0;
    transform: scale(0.95);
  }
  to {
    opacity: 1;
    transform: scale(1);
  }
}

.scale-in {
  animation: scaleIn var(--duration-fast) var(--ease-out-cubic);
}
```

#### Slide In
```css
@keyframes slideInRight {
  from {
    opacity: 0;
    transform: translateX(16px);
  }
  to {
    opacity: 1;
    transform: translateX(0);
  }
}

.slide-in-right {
  animation: slideInRight var(--duration-normal) var(--ease-out-cubic);
}
```

---

## 9. Accessibility Guidelines

### 9.1 Color Accessibility

**Contrast Ratios**
- Normal text: 4.5:1 minimum
- Large text (18px+): 3:1 minimum
- UI components: 3:1 minimum

**Color Independence**
- Never rely solely on color to convey information
- Use icons, text, or patterns as additional indicators
- Provide alternative ways to distinguish elements

### 9.2 Touch Targets

```css
/* Minimum touch target size */
.touch-target {
  min-width: 44px;
  min-height: 44px;
  padding: var(--space-2);
}

/* Recommended touch target size */
.touch-target-recommended {
  min-width: 48px;
  min-height: 48px;
  padding: var(--space-3);
}
```

### 9.3 Focus States

```css
.focusable:focus {
  outline: 2px solid var(--primary-500);
  outline-offset: 2px;
  border-radius: 4px;
}

.focusable:focus:not(:focus-visible) {
  outline: none;
}
```

### 9.4 Screen Reader Support

- Use semantic HTML elements
- Provide meaningful alt text for images
- Use ARIA labels for complex interactions
- Ensure logical tab order
- Provide skip links for navigation

---

## 10. Dark Mode Support

### 10.1 Dark Mode Colors

```css
@media (prefers-color-scheme: dark) {
  :root {
    /* Primary colors remain the same */
    --primary-500: #6366F1;
    
    /* Neutral colors inverted */
    --neutral-0: #111827;
    --neutral-50: #1F2937;
    --neutral-100: #374151;
    --neutral-200: #4B5563;
    --neutral-300: #6B7280;
    --neutral-400: #9CA3AF;
    --neutral-500: #D1D5DB;
    --neutral-600: #E5E7EB;
    --neutral-700: #F3F4F6;
    --neutral-800: #F9FAFB;
    --neutral-900: #FFFFFF;
    
    /* Semantic colors adjusted */
    --success-500: #10B981;
    --warning-500: #F59E0B;
    --error-500: #EF4444;
    --info-500: #3B82F6;
  }
}
```

### 10.2 Dark Mode Components

```css
@media (prefers-color-scheme: dark) {
  .card {
    background: var(--neutral-50);
    border-color: var(--neutral-200);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.3);
  }
  
  .input-field {
    background: var(--neutral-100);
    border-color: var(--neutral-300);
    color: var(--neutral-800);
  }
  
  .bottom-nav {
    background: var(--neutral-50);
    border-color: var(--neutral-200);
  }
}
```

---

## 11. Responsive Design

### 11.1 Breakpoints

```css
/* Mobile First Approach */
--breakpoint-sm: 640px;  /* Small tablets */
--breakpoint-md: 768px;  /* Tablets */
--breakpoint-lg: 1024px; /* Small laptops */
--breakpoint-xl: 1280px; /* Desktops */
```

### 11.2 Responsive Typography

```css
/* Mobile */
.responsive-heading {
  font-size: 24px;
  line-height: 32px;
}

/* Tablet */
@media (min-width: 768px) {
  .responsive-heading {
    font-size: 28px;
    line-height: 36px;
  }
}

/* Desktop */
@media (min-width: 1024px) {
  .responsive-heading {
    font-size: 32px;
    line-height: 40px;
  }
}
```

### 11.3 Responsive Spacing

```css
.responsive-section {
  padding: var(--space-4);
}

@media (min-width: 768px) {
  .responsive-section {
    padding: var(--space-6);
  }
}

@media (min-width: 1024px) {
  .responsive-section {
    padding: var(--space-8);
  }
}
```

---

## 12. Implementation Guidelines

### 12.1 CSS Custom Properties

Use CSS custom properties for all design tokens:

```css
:root {
  /* Colors */
  --primary-500: #6366F1;
  
  /* Typography */
  --font-family-primary: 'Inter', sans-serif;
  
  /* Spacing */
  --space-4: 16px;
  
  /* Shadows */
  --shadow-sm: 0 1px 2px rgba(0, 0, 0, 0.05);
  --shadow-md: 0 4px 6px rgba(0, 0, 0, 0.1);
  --shadow-lg: 0 10px 15px rgba(0, 0, 0, 0.1);
  
  /* Border radius */
  --radius-sm: 4px;
  --radius-md: 8px;
  --radius-lg: 12px;
  --radius-xl: 16px;
  --radius-full: 9999px;
}
```

### 12.2 Component Structure

Follow BEM methodology for CSS classes:

```css
/* Block */
.exam-card { }

/* Element */
.exam-card__title { }
.exam-card__description { }
.exam-card__meta { }

/* Modifier */
.exam-card--featured { }
.exam-card--completed { }
```

### 12.3 Flutter Implementation

```dart
// Theme configuration
class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6366F1),
        brightness: Brightness.light,
      ),
      fontFamily: 'Inter',
      textTheme: _textTheme,
      elevatedButtonTheme: _elevatedButtonTheme,
      inputDecorationTheme: _inputDecorationTheme,
    );
  }
  
  static const TextTheme _textTheme = TextTheme(
    displayLarge: TextStyle(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      height: 1.25,
      letterSpacing: -0.02,
    ),
    headlineLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      height: 1.4,
      letterSpacing: -0.01,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      height: 1.5,
      letterSpacing: 0,
    ),
  );
}
```

---

## 13. Design Tokens

### 13.1 Token Structure

```json
{
  "color": {
    "primary": {
      "50": { "value": "#EEF2FF" },
      "500": { "value": "#6366F1" },
      "900": { "value": "#312E81" }
    },
    "semantic": {
      "success": { "value": "{color.green.500}" },
      "error": { "value": "{color.red.500}" }
    }
  },
  "spacing": {
    "1": { "value": "4px" },
    "4": { "value": "16px" },
    "8": { "value": "32px" }
  },
  "typography": {
    "fontFamily": {
      "primary": { "value": "Inter" }
    },
    "fontSize": {
      "sm": { "value": "14px" },
      "base": { "value": "16px" },
      "lg": { "value": "18px" }
    }
  }
}
```

---

## 14. Quality Assurance

### 14.1 Design Review Checklist

- [ ] Colors meet accessibility contrast requirements
- [ ] Touch targets are minimum 44x44px
- [ ] Text is legible at all sizes
- [ ] Components are consistent with design system
- [ ] Animations are purposeful and performant
- [ ] Dark mode is properly supported
- [ ] Responsive behavior is appropriate
- [ ] Focus states are clearly visible
- [ ] Loading states are handled gracefully
- [ ] Error states provide clear guidance

### 14.2 Testing Guidelines

**Visual Testing**
- Test on various screen sizes
- Verify color accuracy across devices
- Check typography rendering
- Validate spacing and alignment

**Accessibility Testing**
- Use screen reader to navigate
- Test keyboard navigation
- Verify color contrast ratios
- Check touch target sizes

**Performance Testing**
- Monitor animation frame rates
- Test on lower-end devices
- Verify smooth scrolling
- Check memory usage

---

## 15. Maintenance & Evolution

### 15.1 Version Control

- Document all changes to design tokens
- Maintain changelog for design system updates
- Use semantic versioning for major changes
- Communicate changes to development team

### 15.2 Regular Reviews

- Quarterly design system audits
- User feedback integration
- Performance optimization reviews
- Accessibility compliance checks

### 15.3 Future Considerations

- Component library expansion
- Advanced animation patterns
- Micro-interaction enhancements
- Platform-specific optimizations

---

**Document Version**: 1.0  
**Last Updated**: January 2024  
**Next Review**: April 2024  
**Approved By**: Design Team