/**
 * DOM Safety Utilities
 * Provides safe methods for DOM manipulation to prevent common errors
 */

/**
 * Safely removes a DOM element from its parent
 * @param {HTMLElement} element - The element to remove
 * @returns {boolean} - True if successfully removed, false otherwise
 */
export function safeRemoveElement(element) {
    try {
        if (element && element.parentNode) {
            element.parentNode.removeChild(element);
            return true;
        }
        return false;
    } catch (error) {
        console.warn('[DOM Safety] Failed to remove element:', error);
        return false;
    }
}

/**
 * Safely appends a child element to a parent
 * @param {HTMLElement} parent - The parent element
 * @param {HTMLElement} child - The child element to append
 * @returns {boolean} - True if successfully appended, false otherwise
 */
export function safeAppendChild(parent, child) {
    try {
        if (parent && child && typeof parent.appendChild === 'function') {
            parent.appendChild(child);
            return true;
        }
        return false;
    } catch (error) {
        console.warn('[DOM Safety] Failed to append child:', error);
        return false;
    }
}

/**
 * Safely inserts an element before another element
 * @param {HTMLElement} parent - The parent element
 * @param {HTMLElement} newElement - The element to insert
 * @param {HTMLElement} referenceElement - The reference element
 * @returns {boolean} - True if successfully inserted, false otherwise
 */
export function safeInsertBefore(parent, newElement, referenceElement) {
    try {
        if (parent && newElement && referenceElement && 
            typeof parent.insertBefore === 'function' &&
            referenceElement.parentNode === parent) {
            parent.insertBefore(newElement, referenceElement);
            return true;
        }
        return false;
    } catch (error) {
        console.warn('[DOM Safety] Failed to insert element:', error);
        return false;
    }
}

/**
 * Safely gets the next sibling of an element
 * @param {HTMLElement} element - The element
 * @returns {HTMLElement|null} - The next sibling or null
 */
export function safeGetNextSibling(element) {
    try {
        return element && element.parentNode ? element.nextSibling : null;
    } catch (error) {
        console.warn('[DOM Safety] Failed to get next sibling:', error);
        return null;
    }
}

/**
 * Safely gets the previous sibling of an element
 * @param {HTMLElement} element - The element
 * @returns {HTMLElement|null} - The previous sibling or null
 */
export function safeGetPreviousSibling(element) {
    try {
        return element && element.parentNode ? element.previousSibling : null;
    } catch (error) {
        console.warn('[DOM Safety] Failed to get previous sibling:', error);
        return null;
    }
}

/**
 * Creates a temporary element for operations like copying text
 * @param {string} tagName - The tag name for the element
 * @param {Object} options - Configuration options
 * @returns {Object} - Object with element and cleanup function
 */
export function createTemporaryElement(tagName = 'div', options = {}) {
    const element = document.createElement(tagName);
    
    // Apply default styles for temporary elements
    Object.assign(element.style, {
        position: 'fixed',
        opacity: '0',
        left: '-9999px',
        top: '-9999px',
        pointerEvents: 'none',
        ...options.styles
    });
    
    // Apply attributes
    if (options.attributes) {
        Object.entries(options.attributes).forEach(([key, value]) => {
            element.setAttribute(key, value);
        });
    }
    
    // Apply properties
    if (options.properties) {
        Object.assign(element, options.properties);
    }
    
    let isAppended = false;
    
    return {
        element,
        append: () => {
            if (!isAppended && safeAppendChild(document.body, element)) {
                isAppended = true;
                return true;
            }
            return false;
        },
        remove: () => {
            if (isAppended && safeRemoveElement(element)) {
                isAppended = false;
                return true;
            }
            return false;
        },
        isAppended: () => isAppended
    };
}

/**
 * Waits for an element to be ready for DOM operations
 * @param {HTMLElement} element - The element to check
 * @param {number} timeout - Maximum time to wait in milliseconds
 * @returns {Promise<boolean>} - Resolves to true if element is ready
 */
export function waitForElementReady(element, timeout = 1000) {
    return new Promise((resolve) => {
        if (!element) {
            resolve(false);
            return;
        }
        
        const startTime = Date.now();
        
        const checkReady = () => {
            if (element.parentNode && document.contains(element)) {
                resolve(true);
                return;
            }
            
            if (Date.now() - startTime > timeout) {
                resolve(false);
                return;
            }
            
            requestAnimationFrame(checkReady);
        };
        
        checkReady();
    });
}

export default {
    safeRemoveElement,
    safeAppendChild,
    safeInsertBefore,
    safeGetNextSibling,
    safeGetPreviousSibling,
    createTemporaryElement,
    waitForElementReady
};