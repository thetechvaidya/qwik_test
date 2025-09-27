<?php

namespace App\Http\Middleware;

use App\Models\SubCategory;
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
        if (!Cookie::has('category_id')) {
            $defaultCategory = SubCategory::active()
                ->has('sections')
                ->orderBy('name')
                ->first();

            if ($defaultCategory) {
                Cookie::queue('category_id', $defaultCategory->id, 60 * 24 * 30);
                Cookie::queue('category_name', $defaultCategory->name, 60 * 24 * 30);
            }
        }

        return $next($request);
    }
}
