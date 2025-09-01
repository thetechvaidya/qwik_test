<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\RateLimiter;

class MobileApiMiddleware
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): Response
    {
        // Add mobile-specific headers
        $response = $next($request);
        
        // Set mobile-optimized headers
        $response->headers->set('X-Mobile-API', 'v1.0');
        $response->headers->set('Cache-Control', 'public, max-age=300'); // 5 minutes cache
        $response->headers->set('X-Content-Type-Options', 'nosniff');
        
        // Add compression hint for mobile
        if ($request->hasHeader('Accept-Encoding') && 
            str_contains($request->header('Accept-Encoding'), 'gzip')) {
            $response->headers->set('Vary', 'Accept-Encoding');
        }
        
        // Add mobile device detection
        $this->detectMobileDevice($request, $response);
        
        // Apply mobile-specific rate limiting
        $this->applyMobileRateLimit($request);
        
        return $response;
    }
    
    /**
     * Detect mobile device and add headers
     */
    private function detectMobileDevice(Request $request, Response $response): void
    {
        $userAgent = $request->userAgent();
        $isMobile = $this->isMobileDevice($userAgent);
        
        $response->headers->set('X-Device-Type', $isMobile ? 'mobile' : 'desktop');
        
        // Store device info in request for controllers to use
        $request->attributes->set('is_mobile', $isMobile);
        $request->attributes->set('device_type', $isMobile ? 'mobile' : 'desktop');
    }
    
    /**
     * Check if the user agent indicates a mobile device
     */
    private function isMobileDevice(string $userAgent): bool
    {
        $mobileKeywords = [
            'Mobile', 'Android', 'iPhone', 'iPad', 'iPod', 'BlackBerry', 
            'Windows Phone', 'Opera Mini', 'IEMobile', 'Mobile Safari'
        ];
        
        foreach ($mobileKeywords as $keyword) {
            if (stripos($userAgent, $keyword) !== false) {
                return true;
            }
        }
        
        return false;
    }
    
    /**
     * Apply mobile-specific rate limiting
     */
    private function applyMobileRateLimit(Request $request): void
    {
        $key = 'mobile_api:' . $request->ip();
        
        // More generous rate limits for mobile (120 requests per minute)
        $maxAttempts = 120;
        $decayMinutes = 1;
        
        if (RateLimiter::tooManyAttempts($key, $maxAttempts)) {
            $seconds = RateLimiter::availableIn($key);
            
            abort(429, 'Too many requests. Try again in ' . $seconds . ' seconds.');
        }
        
        RateLimiter::hit($key, $decayMinutes * 60);
    }
}