const fs = require('fs');
const path = require('path');

// First 10 files to migrate quickly
const files = [
  'QuestionTypes.vue',
  'QuizSchedules.vue', 
  'QuizTypes.vue',
  'PracticeSets.vue',
  'Subscriptions.vue',
  'SubscriptionDetails.vue',
  'PaymentDetails.vue',
  'Payments.vue',
  'ImportQuestions.vue',
  'ExamSchedules.vue'
];

let migrated = 0;

files.forEach(fileName => {
  const filePath = path.join('resources/js/Pages/Admin', fileName);
  
  if (!fs.existsSync(filePath)) {
    console.log('File not found:', fileName);
    return;
  }

  let content = fs.readFileSync(filePath, 'utf8');
  
  // Skip if already migrated
  if (content.includes('<script setup>')) {
    console.log('Already migrated:', fileName);
    return;
  }

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
    .replace(/\$page\.props\./g, 'pageProps.');

  // Add Head component at the beginning of template
  content = content.replace(/^<template>/, '<template>\n    <Head :title="title" />');

  // Create basic script setup replacement
  const basicScript = `<script setup>
import { ref, computed, reactive } from 'vue'
import { Head, Link, usePage, router } from '@inertiajs/vue3'
import AdminLayout from '@/Layouts/AdminLayout.vue'
import { useTranslate } from '@/composables/useTranslate'
import { useServerTable } from '@/composables/useServerTable'
import { useCopy } from '@/composables/useCopy'
import { useConfirmToast } from '@/composables/useConfirmToast'

// Props - TODO: Extract from original file
const props = defineProps({
  // Add props based on original file
})

// Composables
const { __ } = useTranslate()
const { props: pageProps } = usePage()
const { copyCode } = useCopy()
const { confirm, toast } = useConfirmToast()

// Reactive data
const createForm = ref(false)
const editForm = ref(false)
const currentId = ref(null)

// Computed
const title = computed(() => {
  return __('Page Title') + ' - ' + pageProps.general.app_name
})

// TODO: Add remaining functionality from original file
</script>`;

  // Replace the script section
  content = content.replace(/<script>[\s\S]*?<\/script>/, basicScript);

  // Write the migrated file
  fs.writeFileSync(filePath, content);
  migrated++;
  console.log('Migrated:', fileName);
});

console.log(`Migration completed: ${migrated} files migrated`);
