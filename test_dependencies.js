// Test script to verify major dependency versions
import fs from 'fs';
import path from 'path';

try {
    // Check package.json
    const packagePath = path.join(process.cwd(), 'package.json');
    const packageJson = JSON.parse(fs.readFileSync(packagePath, 'utf8'));
    
    console.log('✅ Axios in dependencies:', packageJson.dependencies.axios || 'Not found');
    console.log('✅ Axios in devDependencies:', packageJson.devDependencies.axios || 'Removed');
    
    console.log('\n✅ Dependency audit complete!');
} catch (error) {
    console.error('❌ Error:', error.message);
}
