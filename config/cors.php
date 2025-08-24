<?php

return [

    /*
    |--------------------------------------------------------------------------
    | Cross-Origin Resource Sharing (CORS) Configuration
    |--------------------------------------------------------------------------
    |
    | Here you may configure your settings for cross-origin resource sharing
    | or "CORS". This determines what cross-origin operations may execute
    | in web browsers. You are free to adjust these settings as needed.
    |
    | To learn more: https://developer.mozilla.org/en-US/docs/Web/HTTP/CORS
    |
    */

    'paths' => ['api/*', 'sanctum/csrf-cookie'],

    'allowed_methods' => ['GET', 'POST', 'PUT', 'PATCH', 'DELETE', 'OPTIONS'],

    'allowed_origins' => array_filter([
        env('FRONTEND_URL'),
        env('APP_URL'),
        env('CORS_ALLOWED_ORIGINS') ? explode(',', env('CORS_ALLOWED_ORIGINS')) : null,
        // Development origins (only in non-production)
        env('APP_ENV') !== 'production' ? 'http://localhost:3000' : null,
        env('APP_ENV') !== 'production' ? 'http://localhost:8000' : null,
        env('APP_ENV') !== 'production' ? 'https://localhost:8000' : null,
        env('APP_ENV') !== 'production' ? 'http://127.0.0.1:8000' : null,
    ]),

    'allowed_origins_patterns' => [],

    'allowed_headers' => [
        'Accept',
        'Authorization',
        'Content-Type',
        'X-Requested-With',
        'X-CSRF-TOKEN',
        'X-Inertia',
        'X-Inertia-Version',
        'X-Inertia-Partial-Component',
        'X-Inertia-Partial-Data',
        'Cache-Control',
    ],

    'exposed_headers' => [
        'X-Inertia-Location',
    ],

    'max_age' => env('CORS_MAX_AGE', 86400), // 24 hours

    'supports_credentials' => true,

];
