<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Content Security Policy (CSP)
    |--------------------------------------------------------------------------
    |
    | The CSP settings help prevent cross-site scripting (XSS) and other
    | code injection attacks. You can define policies for different
    | directives.
    |
    */

    'csp' => [
        'default-src' => ["'self'"],
        'script-src' => ["'self'", 'https://cdn.jsdelivr.net', 'https://unpkg.com', "'unsafe-inline'", 'http://localhost:5173'],
        'style-src' => ["'self'", 'https://fonts.googleapis.com', 'https://cdn.jsdelivr.net', "'unsafe-inline'", 'http://localhost:5173'],
        'style-src-elem' => ["'self'", 'https://fonts.googleapis.com', 'https://cdn.jsdelivr.net', "'unsafe-inline'", 'http://localhost:5173'],
        'connect-src' => ["'self'", 'ws://localhost:5173', 'http://localhost:5173'],
        'font-src' => ["'self'", 'https://fonts.gstatic.com', 'data:'],
        'img-src' => ["'self'", 'data:', 'https:', 'blob:'],
        'media-src' => ["'self'", 'data:', 'https:'],
        'object-src' => ["'none'"],
        'base-uri' => ["'self'"],
        'form-action' => ["'self'"],
        'frame-ancestors' => ["'none'"],
        'upgrade-insecure-requests' => [],
        'report-uri' => [env('CSP_REPORT_URI')],
    ],

    /*
    |--------------------------------------------------------------------------
    | Security Headers
    |--------------------------------------------------------------------------
    |
    | Configure various security headers to be sent with each response.
    | These headers help protect against various attacks.
    |
    */

    'headers' => [
        'X-Content-Type-Options' => 'nosniff',
        'X-Frame-Options' => 'SAMEORIGIN',
        'X-XSS-Protection' => '1; mode=block',
        'Strict-Transport-Security' => 'max-age=31536000; includeSubDomains; preload',
        'Referrer-Policy' => 'strict-origin-when-cross-origin',
        'Permissions-Policy' => "camera=(), microphone=(), geolocation=()",
        'Cross-Origin-Embedder-Policy' => 'unsafe-none',
        'Cross-Origin-Opener-Policy' => 'same-origin-allow-popups',
        'Cross-Origin-Resource-Policy' => 'cross-origin',
        'Server' => 'QwikTest',
    ],

    /*
    |--------------------------------------------------------------------------
    | Rate Limiting
    |--------------------------------------------------------------------------
    |
    | Configure rate limiting for different parts of the application to
    | prevent abuse and denial-of-service attacks.
    |
    */

    'rate_limiting' => [
        'api' => [
            'max_attempts' => 60,
            'decay_minutes' => 1,
        ],
        'web' => [
            'max_attempts' => 100,
            'decay_minutes' => 1,
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Authentication Security
    |--------------------------------------------------------------------------
    |
    | Settings related to authentication security, such as password policies
    | and multi-factor authentication.
    |
    */

    'auth' => [
        'password_policy' => [
            'min_length' => 12,
            'require_uppercase' => true,
            'require_lowercase' => true,
            'require_numbers' => true,
            'require_symbols' => true,
        ],
        'mfa_enabled' => env('MFA_ENABLED', false),
    ],

    /*
    |--------------------------------------------------------------------------
    | Encryption
    |--------------------------------------------------------------------------
    |
    | Configure encryption settings for sensitive data at rest.
    |
    */

    'encryption' => [
        'cipher' => 'AES-256-CBC',
        'key' => env('APP_KEY'),
    ],

    /*
    |--------------------------------------------------------------------------
    | Audit Logging
    |--------------------------------------------------------------------------
    |
    | Configure settings for audit logging to track important events
    | within the application.
    |
    */

    'audit' => [
        'enabled' => env('AUDIT_LOG_ENABLED', true),
        'driver' => 'database', // or 'log', 'file'
        'events' => [
            'user_login',
            'user_logout',
            'failed_login',
            'password_change',
            'sensitive_data_access',
        ],
    ],

    /*
    |--------------------------------------------------------------------------
    | Environment-Specific Settings
    |--------------------------------------------------------------------------
    |
    | Define different security settings for various environments like
    | development, staging, and production.
    |
    */

    'environments' => [
        'development' => [
            'csp' => [
                'script-src' => ["'self'", "'unsafe-eval'"], // Allow eval for dev tools
            ],
            'debug_mode' => true,
        ],
        'staging' => [
            'csp' => [
                'script-src' => ["'self'", 'https://staging.cdn.com'],
            ],
            'debug_mode' => false,
        ],
        'production' => [
            'csp' => [
                'script-src' => ["'self'", 'https://prod.cdn.com'],
            ],
            'debug_mode' => false,
        ],
    ],

];