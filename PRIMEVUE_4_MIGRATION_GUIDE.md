# PrimeVue 4 Migration Guide

This guide documents the upgrade from PrimeVue 3 to PrimeVue 4 in this project, including packages, component renames, theming updates, API changes, and testing notes.

## Package upgrades and rationale

- Upgraded PrimeVue to v4 to align with Vue 3 ecosystem and get the new theming system, components, and APIs.
- Added `@primeuix/themes` for design token based themes (Aura preset).
- Ensured `primeicons` is installed for icons.
- Replaced legacy Vue 2-only packages:
  - `vue-clipboard2` → `@vueuse/core` useClipboard
  - `vue-ctk-date-time-picker` → PrimeVue `DatePicker`

## Component renames

- InputSwitch → ToggleSwitch
- Dropdown → Select
- OverlayPanel → Popover
- Sidebar → Drawer

Search-and-replace steps:
- Update imports e.g., `import Drawer from 'primevue/drawer'`.
- Update templates e.g., `<Sidebar ... :visible.sync="x">` → `<Drawer v-model:visible="x" ...>`.

OverlayPanel audit:
- Verified no residual `OverlayPanel` usage remains in the workspace. If adding new overlays, use `Popover` (`import Popover from 'primevue/popover'`) with v4 API.

## Theming migration

- Import design tokens and theme CSS in `resources/css/app.css`:
  - `@import '@primeuix/themes/aura/theme.css';`
  - `@import './primevue-tokens.css';` (place AFTER the theme to ensure overrides)
  - `@import 'primeicons/primeicons.css';`
- Place any custom tokens in `resources/css/primevue-tokens.css`.
- Prefer component variants and CSS vars over deep selectors.

## Common API changes and examples

- v-model: Use `v-model:visible` for overlay components (Drawer, Dialog) instead of `.sync`.
- Date inputs: Use `DatePicker` with `showTime`, `timeOnly`, `hourFormat`, `minDate`, `dateFormat`.
  - Example: `<DatePicker v-model="value" showTime hourFormat="12" />`
- Select: Replace Dropdown with Select, use `optionLabel`/`optionValue` and `v-model`.
- ToggleSwitch: Replace InputSwitch with ToggleSwitch; `v-model` remains.
- Popover: Replace OverlayPanel with Popover and adjust props/events as per docs.

## Input variants in PrimeVue 4.x

PrimeVue 4.x does not support global `inputVariant` configuration. Instead, set `variant` prop per component:
- For filled inputs: `<InputText variant="filled" />`, `<Select variant="filled" />`
- For outlined inputs (default): `<InputText />` or `<InputText variant="outlined" />`
- Available variants: `outlined` (default), `filled`

Example migrations:
```vue
<!-- Before (v3 with global config) -->
<InputText v-model="value" />

<!-- After (v4 with component prop) -->
<InputText v-model="value" variant="filled" />
```

## DatePicker API Compatibility

The DatePicker component maintains backward compatibility with most props from v3.x to v4.x. All props used in ExamScheduleForm.vue have been validated as compatible:

### Validated Compatible Props
- `dateFormat` - Custom date format strings (e.g., "dd M yy")
- `timeOnly` - Show only time picker without date
- `stepMinute` - Minute increment for time picker (e.g., 5, 15, 30)
- `hourFormat` - 12 or 24 hour format for time display
- `manualInput` - Allow manual text input
- `minDate` / `maxDate` - Date boundaries
- `showIcon` - Display calendar icon
- `disabled` - Disable component

### Usage Example (Compatible with v4.x)
```vue
<!-- Current usage in ExamScheduleForm.vue - fully compatible -->
<DatePicker 
    v-model="form.start_time"
    timeOnly
    hourFormat="24"
    :stepMinute="5"
    :manualInput="false"
    class="w-full"
/>
```

### Migration Notes
- No changes required for existing DatePicker implementations
- All time picker configurations remain compatible  
- Date format patterns follow same conventions as v3.x

## Testing and known caveats

- Feature tests now smoke-test page responses; JS import checks are avoided since Vite bundles code.
- For authenticated admin routes, use authenticated users or disable middleware for tests as needed.
- Some boolean values may come from backend as strings ('0'/'1'); coerce to booleans in forms for stable toggles.
- PrimeFlex-specific classes like `p-mr-2` should be replaced with Tailwind equivalents (e.g., `mr-2`).

### UI Assertions (optional)

To validate PrimeVue 4 interactive behavior in-browser, use Laravel Dusk:

#### Laravel Dusk Setup
```bash
# Install Dusk
composer require --dev laravel/dusk

# Scaffold Dusk files
php artisan dusk:install

# Set APP_URL for testing environment
echo "APP_URL=http://127.0.0.1:8000" >> .env.dusk.local

# Run UI interaction tests
php artisan dusk --filter=PrimeVue4InteractionTest
```

#### Example Tests Available
- **Drawer Interaction**: Open/close Drawer with `p-drawer-md` class, verify width sizing
- **Select Value Change**: Click Select component, choose option, verify dropdown closes
- **ToggleSwitch Toggle**: Click ToggleSwitch, verify state change animation
- **DatePicker Selection**: Open DatePicker panel, select date, verify panel closes
- **Toast Notifications**: Trigger actions that show Toast, verify message appears/disappears
- **Tag Copy Functionality**: Click copy Tags, verify clipboard action and success toast

#### Alternative: Cypress
- Add dev dependency and scripts; run against `npm run serve`.
- Example: check Drawer open/close, Select value change, DatePicker time selection.

See `tests/Browser/PrimeVue4InteractionTest.php` for complete test implementations and `tests/Feature/PrimeVue4MigrationTest.php::test_ui_interactions_setup_available` for verification.

---

For more details, see PrimeVue v4 documentation:
- Configuration: https://primevue.org/configuration/
- DatePicker: https://primevue.org/datepicker/
