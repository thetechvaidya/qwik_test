import { ref, watch } from 'vue';
import DOMPurify from 'dompurify';
import dompurifyConfig from '../config/dompurify-config';

/**
 * Standalone sanitize function for direct use
 * @param {string} dirtyHtml - The HTML to sanitize
 * @returns {string} - The sanitized HTML
 */
export function sanitizeHtml(dirtyHtml) {
  try {
    // Validate that the input is a non-empty string
    if (typeof dirtyHtml !== 'string' || dirtyHtml.trim() === '') {
      return '';
    }

    // Sanitize the content using the centralized configuration
    const cleanHtml = DOMPurify.sanitize(dirtyHtml, dompurifyConfig);

    // Additional validation for potentially malicious content
    if (cleanHtml.includes('<script') || cleanHtml.includes('onerror=')) {
      throw new Error('Potentially malicious content detected after sanitization.');
    }

    return cleanHtml;
  } catch (e) {
    console.error('Error sanitizing content:', e);
    return 'Content could not be displayed safely.';
  }
}

/**
 * A Vue composable for sanitizing HTML content using DOMPurify.
 *
 * @param {import('vue').Ref<string>} htmlContent - A ref containing the HTML string to sanitize.
 * @returns {{
 *   sanitizedHtml: import('vue').Ref<string>,
 *   error: import('vue').Ref<string|null>,
 *   isProcessing: import('vue').Ref<boolean>
 * }}
 */
export function useSanitizedHtml(htmlContent) {
  const sanitizedHtml = ref('');
  const error = ref(null);
  const isProcessing = ref(false);

  /**
   * Sanitizes the provided HTML content.
   * @param {string} dirtyHtml - The HTML to sanitize.
   */
  const sanitize = (dirtyHtml) => {
    isProcessing.value = true;
    error.value = null;
    try {
      // Validate that the input is a non-empty string
      if (typeof dirtyHtml !== 'string' || dirtyHtml.trim() === '') {
        sanitizedHtml.value = '';
        return;
      }

      // Sanitize the content using the centralized configuration
      const cleanHtml = DOMPurify.sanitize(dirtyHtml, dompurifyConfig);

      // Additional validation for potentially malicious content
      if (cleanHtml.includes('<script') || cleanHtml.includes('onerror=')) {
        throw new Error('Potentially malicious content detected after sanitization.');
      }

      sanitizedHtml.value = cleanHtml;
    } catch (e) {
      console.error('Error sanitizing content:', e);
      error.value = 'Could not sanitize content. Displaying a safe version.';
      sanitizedHtml.value = 'Content could not be displayed safely.';
    } finally {
      isProcessing.value = false;
    }
  };

  // Watch for changes in the input HTML content and re-sanitize
  watch(htmlContent, (newHtml) => {
    sanitize(newHtml);
  }, { immediate: true });

  return {
    sanitizedHtml,
    error,
    isProcessing,
  };
}