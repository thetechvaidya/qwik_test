<?php

namespace App\Http\Middleware;

use Illuminate\Http\Middleware\TrustHosts as Middleware;

class TrustHosts extends Middleware
{
    /**
     * Get the host patterns that should be trusted.
     *
     * @return array<int, string|null>
     */
    public function hosts(): array
    {
        return [
            $this->allSubdomainsOfApplicationUrl(),
            // Add environment-specific trusted hosts
            env('APP_URL') ? parse_url(env('APP_URL'), PHP_URL_HOST) : null,
            env('FRONTEND_URL') ? parse_url(env('FRONTEND_URL'), PHP_URL_HOST) : null,
            // Development hosts
            app()->environment('local') ? 'localhost' : null,
            app()->environment('local') ? '127.0.0.1' : null,
            app()->environment('local') ? '*.local' : null,
        ];
    }
}
