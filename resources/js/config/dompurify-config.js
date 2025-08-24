import DOMPurify from 'dompurify';

/**
 * Custom hook to add MathML tags to the list of allowed tags.
 * This is necessary to render mathematical formulas safely.
 */
DOMPurify.addHook('afterSanitizeAttributes', (node) => {
  // Add MathML tags to the allow list
  if ('tagName' in node && node.tagName === 'math') {
    node.setAttribute('display', 'block');
  }
});

/**
 * DOMPurify configuration object.
 * This configuration is designed to be secure by default, while allowing
 * for the safe rendering of mathematical formulas and other specific content.
 */
const dompurifyConfig = {
  // Allow MathML tags for rendering formulas
  ADD_TAGS: ['math', 'maction', 'merror', 'mfrac', 'mi', 'mmultiscripts', 'mn', 'mo', 'mover', 'mpadded', 'mphantom', 'mroot', 'mrow', 'ms', 'mspace', 'msqrt', 'mstyle', 'msub', 'msubsup', 'msup', 'mtable', 'mtd', 'mtext', 'mtr', 'munder', 'munderover', 'semantics'],
  
  // Forbid dangerous tags and attributes
  FORBID_TAGS: ['style', 'script', 'iframe', 'object', 'embed'],
  FORBID_ATTR: ['style', 'onerror', 'onload', 'onclick', 'onmouseover', 'onfocus', 'onblur'],

  // Allow specific attributes that are considered safe
  ALLOWED_ATTR: ['href', 'src', 'alt', 'title', 'class', 'id', 'display'],

  // Use the browser's built-in parser
  SAFE_FOR_JQUERY: true,
  
  // Return a DocumentFragment instead of a string
  RETURN_DOM_FRAGMENT: false,

  // Return a DOM Element instead of a string
  RETURN_DOM: false,
};

export default dompurifyConfig;