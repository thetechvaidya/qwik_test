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
        if(!Cookie::has('category_id')) {
            return redirect()->route('change_syllabus');
        }

        return $next($request);
    }
}
