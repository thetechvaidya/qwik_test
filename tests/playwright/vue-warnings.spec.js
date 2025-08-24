import { test, expect } from '@playwright/test';

test.describe('Vue Warnings Check', () => {
  test('should not have Vue warnings about reserved prefixes', async ({ page }) => {
    // Listen for console warnings
    const consoleWarnings = [];
    page.on('console', msg => {
      if (msg.type() === 'warning' && msg.text().includes('Vue warn')) {
        consoleWarnings.push(msg.text());
      }
    });

    // Navigate to the ChangeSyllabus page
    await page.goto('/user/change-syllabus');

    // Wait for the page to load completely
    await page.waitForLoadState('networkidle');

    // Check for specific Vue warnings about reserved prefixes
    const reservedPrefixWarnings = consoleWarnings.filter(warning => 
      warning.includes('should not start with "$" or "_"') ||
      warning.includes('reserved prefixes')
    );

    // Verify no reserved prefix warnings occurred
    expect(reservedPrefixWarnings).toHaveLength(0);

    // Log any other Vue warnings for debugging (but don't fail the test)
    if (consoleWarnings.length > 0) {
      console.log('Vue warnings found:', consoleWarnings);
    }
  });

  test('should load SideBarNav component without errors', async ({ page }) => {
    // Listen for console errors
    const consoleErrors = [];
    page.on('console', msg => {
      if (msg.type() === 'error') {
        consoleErrors.push(msg.text());
      }
    });

    // Navigate to the ChangeSyllabus page
    await page.goto('/user/change-syllabus');
    
    // Wait for the page to load
    await page.waitForLoadState('networkidle');
    
    // Check that the page loaded successfully (basic check)
    await expect(page.locator('body')).toBeVisible();
    
    // Verify no JavaScript errors occurred
    expect(consoleErrors).toHaveLength(0);
  });
});