<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\RateLimiter;

class RateLimitingMiddleware
{
    public function handle(Request $request, Closure $next, $key = 'default', $maxAttempts = 60, $decayMinutes = 1)
    {
        $limiterKey = $key . ':' . $request->ip();

        if (RateLimiter::tooManyAttempts($limiterKey, $maxAttempts)) {
            return response('Too Many Attempts.', 429);
        }

        RateLimiter::hit($limiterKey, $decayMinutes * 60);

        return $next($request);
    }
}