import DOMPurify from 'dompurify';

/**
 * Enhanced DOMPurify configuration for KaTeX and image support.
 * This configuration is restrictive to prevent XSS attacks while allowing
 * necessary tags and attributes for rendering mathematical equations and images.
 */
const dompurifyConfig = {
    ALLOWED_TAGS: [
        'span', 'div', 'p', 'br', 'strong', 'em', 'sup', 'sub', 'img', 'mi', 'mo', 'mn', 'mrow',
        'mfrac', 'msup', 'msub', 'msubsup', 'munderover', 'munder', 'mover', 'mtext', 'mspace',
        'ms', 'mpadded', 'mphantom', 'mfenced', 'menclose', 'mlongdiv', 'msqrt', 'mroot',
        'maction', 'mstyle', 'semantics', 'annotation', 'annotation-xml',
    ],
    ALLOWED_ATTR: [
        'class', 'id', 'title', 'src', 'alt', 'width', 'height', 'mathvariant',
        'mathsize', 'mathcolor', 'mathbackground', 'displaystyle', 'scriptlevel',
    ],
    ALLOW_DATA_ATTR: true,
    ALLOWED_URI_REGEXP: /^(?:https?:\/\/|data:image\/(png|jpg|jpeg|gif|svg\+xml);base64,)/,
    FORBID_TAGS: ['script', 'iframe', 'object', 'embed', 'style', 'link'],
    FORBID_ATTR: ['onerror', 'onload', 'onclick', 'onmouseover', 'onfocus', 'onblur'],
};

/**
 * Sanitizes HTML content using the enhanced DOMPurify configuration.
 *
 * @param {string} dirtyHtml - The HTML content to sanitize.
 * @returns {string} The sanitized HTML content.
 */
export function sanitizeHtml(dirtyHtml) {
    return DOMPurify.sanitize(dirtyHtml, dompurifyConfig);
}

/**
 * Validates question content before sanitization.
 *
 * @param {string} content - The content to validate.
 * @returns {boolean} - True if the content is valid, false otherwise.
 */
export function validateContent(content) {
    if (!content || typeof content !== 'string') {
        return false;
    }
    // Add more sophisticated validation rules as needed
    const forbiddenPatterns = [
        /<script/i,
        /onerror=/i,
        /onload=/i,
        /onclick=/i,
        /onmouseover=/i,
    ];
    return !forbiddenPatterns.some(pattern => pattern.test(content));
}