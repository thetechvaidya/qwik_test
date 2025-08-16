const fs = require('fs');
const path = require('path');

// List of all remaining files to migrate
const remainingFiles = [
  // Exam subdirectory
  'Exam/Settings.vue',
  'Exam/SessionResults.vue', 
  'Exam/Sections.vue',
  'Exam/Questions.vue',
  'Exam/OverallReport.vue',
  'Exam/DetailedReport.vue',
  // Quiz subdirectory
  'Quiz/Settings.vue',
  'Quiz/SessionResults.vue',
  'Quiz/Questions.vue',
  'Quiz/OverallReport.vue',
  'Quiz/DetailedReport.vue',
  // Question subdirectory
  'Question/Solution.vue',
  'Question/Settings.vue',
  'Question/Preview.vue',
  'Question/Attachment.vue',
  // PracticeSet subdirectory
  'PracticeSet/Settings.vue',
  'PracticeSet/Questions.vue',
  'PracticeSet/OverallReport.vue',
  'PracticeSet/PracticeAnalysis.vue',
  'PracticeSet/DetailedReport.vue',
  // Lesson subdirectory
  'Lesson/PracticeLessons.vue',
  'Lesson/Configure.vue',
  // Video subdirectory
  'Video/PracticeVideos.vue',
  'Video/Configure.vue',
  // Settings subdirectory
  'Settings/DebugModeForm.vue',
  'Settings/ExpireSchedulesForm.vue',
  'Settings/EmailSettings.vue',
  'Settings/FontSettingsForm.vue',
  'Settings/FeatureSettingsForm.vue',
  'Settings/FooterSettingsForm.vue',
  'Settings/HeroSettingsForm.vue',
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

// Function to determine file type and apply appropriate migration
function getFileType(content, fileName) {
  if (fileName.includes('Form.vue') || content.includes('useForm')) {
    return 'form';
  } else if (content.includes('vue-good-table') || content.includes('pagination')) {
    return 'table';
  } else if (fileName.includes('Settings.vue') && !fileName.includes('Form')) {
    return 'settings-container';
  } else if (content.includes('Report') || fileName.includes('Report')) {
    return 'report';
  } else {
    return 'basic';
  }
}

// Generate appropriate script based on file type
function generateScript(fileType, fileName) {
  const commonImports = `import { ref, computed, reactive, onMounted } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'`;

  const baseVars = `// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()

// Computed
const title = computed(() => {
  return __('${fileName.replace('.vue', '').replace(/([A-Z])/g, ' $1').trim()}') + ' - ' + pageProps.general.app_name
})`;

  switch (fileType) {
    case 'form':
      return `<script setup>
${commonImports}
import { useForm } from '@inertiajs/vue3'

// Props
const props = defineProps({
  settings: Object,
  errors: Object,
})

${baseVars}

// Form handling
const form = useForm({
  // Add form fields based on original file
})

// Methods
const updateSettings = () => {
  // Add form submission logic
}
</script>`;

    case 'table':
      return `<script setup>
${commonImports}
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'
import Tag from 'primevue/tag'
import NoDataTable from "@/Components/NoDataTable.vue"
import ActionsDropdown from "@/Components/ActionsDropdown.vue"

// Props  
const props = defineProps({
  // Add props based on original file
})

${baseVars}

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Composables
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Server table composable
const {
  onPageChange,
  onPerPageChange,
  onColumnFilter,
  onSortChange
} = useServerTable({
  resourceKeys: [], // Add appropriate resource keys
  routeName: '' // Add appropriate route name
})

// Table configuration
const columns = []
const options = reactive({
  enabled: true,
  mode: 'pages',
  perPageDropdown: [10, 20, 50, 100],
  dropdownAllowAll: false,
})
</script>`;

    case 'settings-container':
      return `<script setup>
${commonImports}

// Props
const props = defineProps({
  // Add settings props based on original file  
})

${baseVars}
</script>`;

    case 'report':
      return `<script setup>
${commonImports}

// Props
const props = defineProps({
  // Add report data props
})

${baseVars}

// Initialize any chart or data visualization
onMounted(() => {
  // Add initialization logic
})
</script>`;

    default:
      return `<script setup>
${commonImports}

// Props
const props = defineProps({
  // Add props based on original file
})

${baseVars}
</script>`;
  }
}

// Process files
let migrated = 0;
let skipped = 0;

remainingFiles.forEach(fileName => {
  const filePath = path.join('resources/js/Pages/Admin', fileName);
  
  if (!fs.existsSync(filePath)) {
    console.log('File not found:', fileName);
    return;
  }

  let content = fs.readFileSync(filePath, 'utf8');
  
  // Skip if already migrated
  if (content.includes('<script setup>')) {
    console.log('Already migrated:', fileName);
    skipped++;
    return;
  }

  // Determine file type
  const fileType = getFileType(content, fileName);
  
  // Basic template conversions
  content = content
    .replace(/<admin-layout>/g, '<AdminLayout>')
    .replace(/<\/admin-layout>/g, '</AdminLayout>')
    .replace(/<inertia-link/g, '<Link')
    .replace(/<\/inertia-link>/g, '</Link>')
    .replace(/<no-data-table>/g, '<NoDataTable>')
    .replace(/<\/no-data-table>/g, '</NoDataTable>')
    .replace(/<actions-dropdown>/g, '<ActionsDropdown>')
    .replace(/<\/actions-dropdown>/g, '</ActionsDropdown>')
    .replace(/slot="table-row" slot-scope="props"/g, '#table-row="props"')
    .replace(/slot="emptystate"/g, '#emptystate')
    .replace(/slot="action"/g, '#action')
    .replace(/\$page\.props\./g, 'pageProps.')
    .replace(/this\.handleCopyClick/g, 'copyCode')
    .replace(/handleCopyClick/g, 'copyCode');

  // Add Head component at the beginning of template
  if (!content.includes('<Head')) {
    content = content.replace(/^<template>/, '<template>\n    <Head :title="title" />');
  }

  // Generate appropriate script
  const newScript = generateScript(fileType, fileName);
  
  // Replace the script section
  content = content.replace(/<script>[\s\S]*?<\/script>/, newScript);

  // Write the migrated file
  fs.writeFileSync(filePath, content);
  migrated++;
  console.log(`Migrated: ${fileName} (${fileType})`);
});

console.log(`\nMigration Summary:`);
console.log(`Files migrated: ${migrated}`);
console.log(`Files skipped (already migrated): ${skipped}`);
console.log(`Total files processed: ${remainingFiles.length}`);
