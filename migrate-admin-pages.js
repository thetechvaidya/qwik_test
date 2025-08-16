const fs = require('fs');
const path = require('path');

// List of files to migrate from Options API to Composition API
const filesToMigrate = [
    'Plans.vue',
    'PracticeSets.vue', 
    'QuestionTypes.vue',
    'QuizSchedules.vue',
    'QuizTypes.vue',
    'SubscriptionDetails.vue',
    'Subscriptions.vue',
    'PaymentDetails.vue',
    'Payments.vue',
    'ImportQuestions.vue',
    'ExamSchedules.vue',
    'Exam/Settings.vue',
    'Exam/SessionResults.vue',
    'Exam/Sections.vue',
    'Exam/Questions.vue',
    'Exam/OverallReport.vue',
    'Exam/DetailedReport.vue',
    'Quiz/Settings.vue',
    'Quiz/SessionResults.vue',
    'Quiz/Questions.vue',
    'Quiz/OverallReport.vue',
    'Quiz/DetailedReport.vue',
    'Question/Solution.vue',
    'Question/Settings.vue',
    'Question/Preview.vue',
    'Question/Attachment.vue',
    'PracticeSet/Settings.vue',
    'PracticeSet/Questions.vue',
    'PracticeSet/OverallReport.vue',
    'PracticeSet/PracticeAnalysis.vue',
    'PracticeSet/DetailedReport.vue',
    'Lesson/PracticeLessons.vue',
    'Lesson/Configure.vue',
    'Video/PracticeVideos.vue',
    'Video/Configure.vue'
];

const settingsFiles = [
    'Settings/DebugModeForm.vue',
    'Settings/ExpireSchedulesForm.vue',
    'Settings/EmailSettings.vue',
    'Settings/FontSettingsForm.vue',
    'Settings/FeatureSettingsForm.vue',
    'Settings/FooterSettingsForm.vue',
    'Settings/HeroSettingsForm.vue',
    'Settings/HomePageSettings.vue',
    'Settings/HomePageSettingsForm.vue',
    'Settings/CtaSettingsForm.vue',
    'Settings/ClearCacheForm.vue',
    'Settings/LicenseSettings.vue',
    'Settings/LicenseSettingsForm.vue',
    'Settings/CategorySettingsForm.vue',
    'Settings/LocalizationSettings.vue',
    'Settings/LocalizationSettingsForm.vue',
    'Settings/MaintenanceSettings.vue',
    'Settings/PaymentSettings.vue',
    'Settings/BillingSettingsForm.vue',
    'Settings/PaypalSettingsForm.vue',
    'Settings/RazorpaySettingsForm.vue',
    'Settings/BillingSettings.vue',
    'Settings/BankSettingsForm.vue',
    'Settings/UpdateAppForm.vue',
    'Settings/TopBarSettingsForm.vue',
    'Settings/ThemeSettings.vue',
    'Settings/TestimonialSettingsForm.vue',
    'Settings/TaxSettingsForm.vue',
    'Settings/StripeSettingsForm.vue',
    'Settings/StatSettingsForm.vue',
    'Settings/StorageLinksForm.vue'
];

const allFiles = [...filesToMigrate, ...settingsFiles];

// Common imports for composition API
const commonImports = `import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'`;

// Function to convert template syntax
function convertTemplate(template) {
    return template
        // Convert component names to PascalCase
        .replace(/<admin-layout>/g, '<AdminLayout>')
        .replace(/<\/admin-layout>/g, '</AdminLayout>')
        .replace(/<inertia-link/g, '<Link')
        .replace(/<\/inertia-link>/g, '</Link>')
        .replace(/<no-data-table>/g, '<NoDataTable>')
        .replace(/<\/no-data-table>/g, '</NoDataTable>')
        .replace(/<actions-dropdown>/g, '<ActionsDropdown>')
        .replace(/<\/actions-dropdown>/g, '</ActionsDropdown>')
        
        // Convert slot syntax
        .replace(/slot="([^"]+)"/g, '#$1')
        .replace(/slot-scope="([^"]+)"/g, '#table-row="$1"')
        .replace(/<template slot="table-row" slot-scope="props">/g, '<template #table-row="props">')
        .replace(/<div slot="emptystate">/g, '<template #emptystate>')
        .replace(/<template slot="([^"]+)">/g, '<template #$1>')
        
        // Convert page props access
        .replace(/\$page\.props\./g, 'pageProps.')
        
        // Add Head component at the beginning
        .replace(/^<template>\s*/, '<template>\n    <Head :title="title" />\n    ');
}

// Function to extract and convert script content
function convertScript(script) {
    // Extract key information
    const propsMatch = script.match(/props:\s*\{([^}]+)\}/s);
    const dataMatch = script.match(/data\(\)\s*\{[^}]*return\s*\{([^}]+)\}/s);
    const computedMatch = script.match(/computed:\s*\{([^}]+)\}/s);
    const methodsMatch = script.match(/methods:\s*\{([^}]+)\}/s);
    
    // Generate new script setup content
    let newScript = `<script setup>
${commonImports}

// Props
const props = defineProps({
    ${propsMatch ? propsMatch[1].trim() : ''}
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

`;

    // Add data as refs
    if (dataMatch) {
        const dataContent = dataMatch[1];
        newScript += `// Reactive data\n`;
        // Convert data properties to refs
        const dataLines = dataContent.split(',');
        dataLines.forEach(line => {
            const trimmed = line.trim();
            if (trimmed && !trimmed.startsWith('//')) {
                const [key, value] = trimmed.split(':');
                if (key && value) {
                    newScript += `const ${key.trim()} = ref(${value.trim()})\n`;
                }
            }
        });
        newScript += '\n';
    }

    // Add computed properties
    if (computedMatch) {
        newScript += `// Computed properties\n`;
        const computedContent = computedMatch[1];
        // Simple conversion - would need more sophisticated parsing for complex cases
        if (computedContent.includes('title()')) {
            newScript += `const title = computed(() => {
    return __('Page Title') + ' - ' + pageProps.general.app_name
})\n\n`;
        }
    }

    // Add methods
    if (methodsMatch) {
        newScript += `// Methods\n`;
        // Would need more sophisticated parsing for methods
        newScript += `// TODO: Convert methods from Options API\n\n`;
    }

    newScript += `</script>`;
    
    return newScript;
}

// Main migration function
function migrateFile(filePath) {
    const fullPath = path.join('resources/js/Pages/Admin', filePath);
    
    if (!fs.existsSync(fullPath)) {
        console.log(`File not found: ${fullPath}`);
        return;
    }

    const content = fs.readFileSync(fullPath, 'utf8');
    
    // Check if already migrated
    if (content.includes('<script setup>')) {
        console.log(`Already migrated: ${filePath}`);
        return;
    }

    // Extract template and script sections
    const templateMatch = content.match(/<template>(.*?)<\/template>/s);
    const scriptMatch = content.match(/<script>(.*?)<\/script>/s);
    
    if (!templateMatch || !scriptMatch) {
        console.log(`Could not parse: ${filePath}`);
        return;
    }

    const newTemplate = convertTemplate(templateMatch[0]);
    const newScript = convertScript(scriptMatch[1]);

    const newContent = `${newTemplate}\n\n${newScript}\n`;

    // Write the migrated file
    fs.writeFileSync(fullPath, newContent);
    console.log(`Migrated: ${filePath}`);
}

// Migrate all files
console.log('Starting bulk migration of admin pages...');
allFiles.forEach(migrateFile);
console.log('Migration completed!');
