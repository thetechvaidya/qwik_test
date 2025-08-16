<?php

namespace Tests\Unit;

use Tests\TestCase;

class TiptapEditorDialogTest extends TestCase
{
    /**
     * Test that TiptapEditor component is properly structured for dialog-based UX.
     */
    public function test_tiptap_editor_component_has_dialog_imports()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $this->assertFileExists($componentPath, 'TiptapEditor.vue component should exist');
        
        $content = file_get_contents($componentPath);
        
        // Verify PrimeVue component imports
        $this->assertStringContainsString('import Dialog from \'primevue/dialog\'', $content, 'Should import Dialog component');
        $this->assertStringContainsString('import Button from \'primevue/button\'', $content, 'Should import Button component');
        $this->assertStringContainsString('import InputText from \'primevue/inputtext\'', $content, 'Should import InputText component');
        $this->assertStringContainsString('import Textarea from \'primevue/textarea\'', $content, 'Should import Textarea component');
        $this->assertStringContainsString('import ColorPicker from \'primevue/colorpicker\'', $content, 'Should import ColorPicker component');
    }

    public function test_tiptap_editor_has_dialog_components_registered()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify components are registered
        $this->assertStringContainsString('Dialog,', $content, 'Dialog should be registered in components');
        $this->assertStringContainsString('Button,', $content, 'Button should be registered in components');
        $this->assertStringContainsString('InputText,', $content, 'InputText should be registered in components');
        $this->assertStringContainsString('Textarea,', $content, 'Textarea should be registered in components');
        $this->assertStringContainsString('ColorPicker,', $content, 'ColorPicker should be registered in components');
    }

    public function test_tiptap_editor_has_dialog_state_data()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify dialog state properties
        $this->assertStringContainsString('showLatexDialog: false', $content, 'Should have LaTeX dialog state');
        $this->assertStringContainsString('showLinkDialog: false', $content, 'Should have Link dialog state');
        $this->assertStringContainsString('showColorDialog: false', $content, 'Should have Color dialog state');
        
        // Verify form input properties
        $this->assertStringContainsString('latexInput:', $content, 'Should have LaTeX input property');
        $this->assertStringContainsString('linkInput:', $content, 'Should have link input property');
        $this->assertStringContainsString('colorInput:', $content, 'Should have color input property');
        $this->assertStringContainsString('selectedColor:', $content, 'Should have selected color property');
        $this->assertStringContainsString('hasExistingLink:', $content, 'Should have existing link flag');
    }

    public function test_tiptap_editor_has_modern_dialog_methods()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify no more TODO comments with native prompts
        $this->assertStringNotContainsString('TODO: Replace with inline equation editor', $content, 'LaTeX TODO should be resolved');
        $this->assertStringNotContainsString('TODO: Replace with PrimeVue Dialog', $content, 'Link TODO should be resolved');
        $this->assertStringNotContainsString('TODO: Replace with PrimeVue ColorPicker', $content, 'Color TODO should be resolved');
        
        // Verify no native prompt usage
        $this->assertStringNotContainsString('prompt(\'Enter LaTeX expression:', $content, 'Should not use native prompt for LaTeX');
        $this->assertStringNotContainsString('window.prompt(\'URL\'', $content, 'Should not use native prompt for URL');
        $this->assertStringNotContainsString('window.prompt(\'Enter color', $content, 'Should not use native prompt for color');
        
        // Verify modern dialog methods exist
        $this->assertStringContainsString('insertLatexEquation()', $content, 'Should have modern LaTeX insertion method');
        $this->assertStringContainsString('applyLinkToSelection()', $content, 'Should have modern link application method');
        $this->assertStringContainsString('applyColorToSelection()', $content, 'Should have modern color application method');
        $this->assertStringContainsString('removeLinkFromSelection()', $content, 'Should have link removal method');
        $this->assertStringContainsString('removeColorFromSelection()', $content, 'Should have color removal method');
    }

    public function test_tiptap_editor_has_dialog_templates()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify dialog templates exist
        $this->assertStringContainsString('<!-- LaTeX Equation Dialog -->', $content, 'Should have LaTeX dialog template');
        $this->assertStringContainsString('<!-- URL Link Dialog -->', $content, 'Should have Link dialog template');
        $this->assertStringContainsString('<!-- Color Picker Dialog -->', $content, 'Should have Color dialog template');
        
        // Verify dialog components in template
        $this->assertStringContainsString('v-model:visible="showLatexDialog"', $content, 'Should have LaTeX dialog visibility binding');
        $this->assertStringContainsString('v-model:visible="showLinkDialog"', $content, 'Should have Link dialog visibility binding');
        $this->assertStringContainsString('v-model:visible="showColorDialog"', $content, 'Should have Color dialog visibility binding');
        
        // Verify dialog headers
        $this->assertStringContainsString('header="Insert LaTeX Equation"', $content, 'Should have LaTeX dialog header');
        $this->assertStringContainsString('header="Insert/Edit Link"', $content, 'Should have Link dialog header');
        $this->assertStringContainsString('header="Choose Text Color"', $content, 'Should have Color dialog header');
    }

    public function test_tiptap_editor_has_proper_form_bindings()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify form input bindings
        $this->assertStringContainsString('v-model="latexInput"', $content, 'LaTeX input should have proper v-model binding');
        $this->assertStringContainsString('v-model="linkInput"', $content, 'Link input should have proper v-model binding');
        $this->assertStringContainsString('v-model="colorInput"', $content, 'Color input should have proper v-model binding');
        $this->assertStringContainsString('v-model="selectedColor"', $content, 'Color picker should have proper v-model binding');
        
        // Verify form validation
        $this->assertStringContainsString(':disabled="!latexInput.trim()"', $content, 'LaTeX insert should be disabled when empty');
        $this->assertStringContainsString(':disabled="!linkInput.trim()"', $content, 'Link apply should be disabled when empty');
        $this->assertStringContainsString(':disabled="!colorInput"', $content, 'Color apply should be disabled when empty');
    }

    public function test_tiptap_editor_has_improved_user_experience_features()
    {
        $componentPath = resource_path('js/Components/TiptapEditor.vue');
        $content = file_get_contents($componentPath);
        
        // Verify UX improvements
        $this->assertStringContainsString('Preview:', $content, 'Should show LaTeX preview');
        $this->assertStringContainsString('Sample Text', $content, 'Should show color preview');
        $this->assertStringContainsString('Remove Link', $content, 'Should have remove link option');
        $this->assertStringContainsString('Remove Color', $content, 'Should have remove color option');
        
        // Verify placeholders and help text
        $this->assertStringContainsString('e.g., E = mc^2', $content, 'Should have LaTeX example');
        $this->assertStringContainsString('https://example.com', $content, 'Should have URL example');
        $this->assertStringContainsString('Enter a complete URL', $content, 'Should have URL help text');
        
        // Verify proper modal dialogs
        $this->assertStringContainsString('modal', $content, 'Dialogs should be modal');
        $this->assertStringContainsString('@hide="resetLatexForm"', $content, 'Should reset forms on dialog hide');
        $this->assertStringContainsString('@hide="resetLinkForm"', $content, 'Should reset forms on dialog hide');
        $this->assertStringContainsString('@hide="resetColorForm"', $content, 'Should reset forms on dialog hide');
    }
}
