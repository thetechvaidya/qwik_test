<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class SecurityHeaders
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        $response = $next($request);

        // Only apply security headers to HTML responses
        if ($this->shouldApplyHeaders($response)) {
            $this->applySecurityHeaders($response);
        }

        return $response;
    }

    /**
     * Determine if security headers should be applied to the response.
     */
    private function shouldApplyHeaders(Response $response): bool
    {
        $contentType = $response->headers->get('Content-Type', '');
        
        // Apply headers to HTML responses and responses without explicit content type
        return str_contains($contentType, 'text/html') || 
               str_contains($contentType, 'application/json') ||
               empty($contentType);
    }

    /**
     * Apply comprehensive security headers to the response.
     */
    private function applySecurityHeaders(Response $response): void
    {
        $headers = $this->getSecurityHeaders();

        foreach ($headers as $header => $value) {
            if ($value !== null) {
                $response->headers->set($header, $value);
            }
        }
    }

    /**
     * Get the security headers configuration.
     */
    private function getSecurityHeaders(): array
    {
        $isProduction = app()->environment('production');
        $isHttps = request()->isSecure();

        return [
            // Prevent MIME type sniffing
            'X-Content-Type-Options' => 'nosniff',

            // Prevent clickjacking attacks
            'X-Frame-Options' => config('security.headers.X-Frame-Options', 'SAMEORIGIN'),

            // Enable XSS protection (legacy browsers)
            'X-XSS-Protection' => '1; mode=block',

            // Referrer policy for privacy
            'Referrer-Policy' => config('security.headers.Referrer-Policy', 'strict-origin-when-cross-origin'),

            // Permissions policy (formerly Feature Policy)
            'Permissions-Policy' => $this->getPermissionsPolicy(),

            // Content Security Policy
            'Content-Security-Policy' => $this->getContentSecurityPolicy(),

            // HTTP Strict Transport Security (HTTPS only)
            'Strict-Transport-Security' => $isHttps ? $this->getHstsHeader() : null,

            // Expect-CT header for certificate transparency (HTTPS only)
            'Expect-CT' => $isHttps && $isProduction ? 'max-age=86400, enforce' : null,

            // Cross-Origin policies
            'Cross-Origin-Embedder-Policy' => config('security.headers.Cross-Origin-Embedder-Policy', 'unsafe-none'),
            'Cross-Origin-Opener-Policy' => config('security.headers.Cross-Origin-Opener-Policy', 'same-origin-allow-popups'),
            'Cross-Origin-Resource-Policy' => config('security.headers.Cross-Origin-Resource-Policy', 'cross-origin'),

            // Permitted Cross-Domain Policies
            'X-Permitted-Cross-Domain-Policies' => 'none',

            // Server information hiding
            'Server' => config('security.headers.Server', 'QwikTest'),
            'X-Powered-By' => null, // Remove this header
        ];
    }

    /**
     * Get the Content Security Policy header value.
     */
    private function getContentSecurityPolicy(): string
    {
        $nonce = $this->generateNonce();
        request()->attributes->set('csp_nonce', $nonce);

        $isProduction = app()->environment('production');

        $cspConfig = config('security.csp');
        
        // Add development server URLs for local development
        if (!$isProduction) {
            $viteUrl = 'http://localhost:5173';
            $viteWsUrl = 'ws://localhost:5173';
            
            // Add Vite dev server to allowed sources
            $cspConfig['script-src'][] = $viteUrl;
            $cspConfig['style-src'][] = $viteUrl;
            $cspConfig['font-src'][] = $viteUrl;
            
            // Ensure style-src-elem is set for CSS files
            if (!isset($cspConfig['style-src-elem'])) {
                $cspConfig['style-src-elem'] = $cspConfig['style-src'];
            } else {
                $cspConfig['style-src-elem'][] = $viteUrl;
            }
            
            // Add connect-src for WebSocket and HTTP connections
            if (!isset($cspConfig['connect-src'])) {
                $cspConfig['connect-src'] = ["'self'"];
            }
            $cspConfig['connect-src'][] = $viteUrl;
            $cspConfig['connect-src'][] = $viteWsUrl;
        }
        
        $policy = [];

        foreach ($cspConfig as $directive => $sources) {
            if ($directive === 'report-uri' && empty($sources)) {
                continue;
            }
            
            // Skip directives with null values
            if ($sources === null) {
                continue;
            }
            
            // Ensure sources is an array
            if (!is_array($sources)) {
                $sources = [$sources];
            }
            
            $policy[] = $directive . ' ' . implode(' ', $sources);
        }

        return implode('; ', $policy);
    }

    /**
     * Get the Permissions Policy header value.
     */
    private function getPermissionsPolicy(): string
    {
        $policies = [
            'accelerometer=()',
            'autoplay=(self)',
            'camera=()',
            'display-capture=()',
            'encrypted-media=()',
            'fullscreen=(self)',
            'geolocation=()',
            'gyroscope=()',
            'keyboard-map=()',
            'magnetometer=()',
            'microphone=()',
            'midi=()',
            'payment=()',
            'picture-in-picture=()',
            'publickey-credentials-get=()',
            'screen-wake-lock=()',
            'sync-xhr=()',
            'usb=()',
            'web-share=()',
            'xr-spatial-tracking=()',
        ];

        return implode(', ', $policies);
    }

    /**
     * Get the HSTS header value.
     */
    private function getHstsHeader(): string
    {
        $maxAge = config('security.hsts_max_age', 31536000); // 1 year
        $includeSubdomains = config('security.hsts_include_subdomains', true);
        $preload = config('security.hsts_preload', true);

        $header = "max-age={$maxAge}";

        if ($includeSubdomains) {
            $header .= '; includeSubDomains';
        }

        if ($preload) {
            $header .= '; preload';
        }

        return $header;
    }

    /**
     * Generate a cryptographically secure nonce for CSP.
     */
    private function generateNonce(): string
    {
        return base64_encode(random_bytes(16));
    }
}
