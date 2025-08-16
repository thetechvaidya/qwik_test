#!/usr/bin/env node
/**
 * Vue Import Fix Script
 * 
 * This script fixes inconsistent import patterns in Vue files:
 * 1. Adds .vue extensions to Layout imports
 * 2. Adds .vue extensions to Component imports 
 * 3. Preserves composable imports (they should not have .vue extensions)
 */

const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Define patterns to fix
const LAYOUT_PATTERNS = [
    { from: "from '@/Layouts/AppLayout'", to: "from '@/Layouts/AppLayout.vue'" },
    { from: "from '@/Layouts/AdminLayout'", to: "from '@/Layouts/AdminLayout.vue'" },
    { from: "from '@/Layouts/AuthLayout'", to: "from '@/Layouts/AuthLayout.vue'" },
    { from: "from '@/Layouts/PracticeLayout'", to: "from '@/Layouts/PracticeLayout.vue'" },
    { from: "from '@/Layouts/QuizLayout'", to: "from '@/Layouts/QuizLayout.vue'" }
];

const COMPONENT_PATTERNS = [
    // Common components that may be missing .vue extensions
    { from: /from '@\/Components\/([^']+)'$/gm, to: "from '@/Components/$1.vue'" },
    { from: /from '@\/Layouts\/([^']+)'$/gm, to: "from '@/Layouts/$1.vue'" }
];

function fixVueImports(filePath) {
    try {
        let content = fs.readFileSync(filePath, 'utf8');
        let modified = false;
        const originalContent = content;

        // Fix Layout imports
        LAYOUT_PATTERNS.forEach(pattern => {
            if (content.includes(pattern.from)) {
                content = content.replace(new RegExp(pattern.from.replace(/'/g, "\\'"), 'g'), pattern.to);
                modified = true;
                console.log(`  ✓ Fixed: ${pattern.from} → ${pattern.to}`);
            }
        });

        // Fix Component imports that are missing .vue but shouldn't be composables
        const lines = content.split('\n');
        const fixedLines = lines.map(line => {
            // Skip lines that import composables (use*, services, utilities, etc.)
            if (line.includes('import {') || 
                line.includes('use') ||
                line.includes('composables') ||
                line.includes('services') ||
                line.includes('.vue\'')) {
                return line;
            }

            // Fix component imports missing .vue extension
            if (line.match(/import\s+\w+\s+from\s+'@\/Components\/[^']+'\s*$/) ||
                line.match(/import\s+\w+\s+from\s+'@\/Layouts\/[^']+'\s*$/)) {
                
                // Check if already ends with .vue
                if (!line.endsWith(".vue'") && !line.endsWith('.vue"')) {
                    const fixedLine = line.replace(/'$/, ".vue'").replace(/"$/, '.vue"');
                    if (fixedLine !== line) {
                        console.log(`  ✓ Fixed component import: ${line.trim()}`);
                        modified = true;
                        return fixedLine;
                    }
                }
            }

            return line;
        });

        content = fixedLines.join('\n');

        // Only write if modified
        if (modified && content !== originalContent) {
            fs.writeFileSync(filePath, content, 'utf8');
            return true;
        }

        return false;
    } catch (error) {
        console.error(`Error processing ${filePath}:`, error.message);
        return false;
    }
}

function main() {
    console.log('🔧 Starting Vue Import Fix...\n');

    // Find all Vue files
    const vueFiles = glob.sync('resources/js/**/*.vue', { cwd: process.cwd() });
    
    console.log(`Found ${vueFiles.length} Vue files to process\n`);

    let totalFixed = 0;
    const processedFiles = [];

    vueFiles.forEach(file => {
        const fullPath = path.join(process.cwd(), file);
        console.log(`Processing: ${file}`);
        
        const wasModified = fixVueImports(fullPath);
        if (wasModified) {
            totalFixed++;
            processedFiles.push(file);
        } else {
            console.log('  ℹ  No changes needed');
        }
        console.log('');
    });

    console.log('📋 Summary:');
    console.log(`  Total files processed: ${vueFiles.length}`);
    console.log(`  Files modified: ${totalFixed}`);
    
    if (processedFiles.length > 0) {
        console.log('\n✅ Modified files:');
        processedFiles.forEach(file => console.log(`  - ${file}`));
    }

    console.log('\n🎉 Vue import fix completed!');
}

// Run if this file is executed directly
if (require.main === module) {
    main();
}

module.exports = { fixVueImports };
