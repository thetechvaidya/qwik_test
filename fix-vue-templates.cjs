const fs = require('fs');
const path = require('path');
const glob = require('glob');

// Find all Vue files
const vueFiles = glob.sync('resources/js/**/*.vue');

console.log(`Found ${vueFiles.length} Vue files to check...`);

vueFiles.forEach(file => {
    const content = fs.readFileSync(file, 'utf8');
    
    // Pattern to find misplaced template tags
    const fixes = [
        // Fix "</template>\n</template>" to just "</template>"
        {
            pattern: /(\s*)<\/template>\s*<\/template>/g,
            replacement: '$1</template>'
        },
        // Fix lines that end with "</template>" inside template content
        {
            pattern: /^(\s*.*?)(<\/template>)(\s*)$/gm,
            replacement: (match, prefix, tag, suffix) => {
                // Only replace if this isn't the final closing template tag
                if (prefix.trim() && !prefix.includes('<template>')) {
                    return prefix.replace(/&lt;\/template&gt;|<\/template>$/, '</div>') + suffix;
                }
                return match;
            }
        }
    ];
    
    let fixedContent = content;
    let wasFixed = false;
    
    fixes.forEach(fix => {
        const beforeFix = fixedContent;
        fixedContent = fixedContent.replace(fix.pattern, fix.replacement);
        if (beforeFix !== fixedContent) {
            wasFixed = true;
        }
    });
    
    // Additional manual fixes for common patterns
    // Fix cases where </template> appears in wrong places
    const lines = fixedContent.split('\n');
    const fixedLines = [];
    let inTemplate = false;
    let templateDepth = 0;
    
    for (let i = 0; i < lines.length; i++) {
        let line = lines[i];
        
        if (line.includes('<template>')) {
            inTemplate = true;
            templateDepth++;
        }
        
        if (line.includes('</template>')) {
            templateDepth--;
            if (templateDepth === 0) {
                inTemplate = false;
            }
            
            // If we're still inside template content and find </template>, it's likely wrong
            if (inTemplate && templateDepth > 0) {
                line = line.replace('</template>', '</div>');
                wasFixed = true;
            }
        }
        
        fixedLines.push(line);
    }
    
    if (wasFixed) {
        const finalContent = fixedLines.join('\n');
        fs.writeFileSync(file, finalContent);
        console.log(`✓ Fixed: ${file}`);
    }
});

console.log('Vue template fix complete!');
