<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cookie;

class HasSelectedSyllabus
{
    /**
     * Handle an incoming request.
     */
    public function handle(Request $request, Closure $next): mixed
    {
        // Allow dashboard access without syllabus selection for modern UX
        if(!Cookie::has('category_id') && !$request->routeIs('user_dashboard')) {
            return redirect()->route('change_syllabus');
        }

        return $next($request);
    }
}
