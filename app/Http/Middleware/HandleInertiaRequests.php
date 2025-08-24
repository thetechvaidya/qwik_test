<?php

namespace App\Http\Middleware;

use App\Settings\LocalizationSettings;
use App\Settings\SiteSettings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cookie;
use Inertia\Middleware;


class HandleInertiaRequests extends Middleware
{
    /**
     * The root template that's loaded on the first page visit.
     *
     * @see https://inertiajs.com/server-side-setup#root-template
     * @var string
     */
    protected $rootView = 'app';

    /**
     * Determines the current asset version.
     *
     * @see https://inertiajs.com/asset-versioning
     */
    public function version(Request $request): ?string
    {
        return parent::version($request);
    }

    /**
     * Defines the props that are shared by default.
     *
     * @see https://inertiajs.com/shared-data
     * @throws \Exception
     */
    public function share(Request $request): array
    {
        $settings = app(SiteSettings::class);
        return array_merge(parent::share($request), [
            'auth' => [
                'user' => $request->user() ? [
                    'id' => $request->user()->id,
                    'name' => $request->user()->name,
                    'email' => $request->user()->email,
                    'role_id' => $request->user()->hasRole('admin') ? 'admin' : 
                               ($request->user()->hasRole('instructor') ? 'instructor' : 
                               ($request->user()->hasRole('student') ? 'student' : 'guest')),
                    'profile_photo_url' => $request->user()->profile_photo_url,
                ] : null,
            ],
            'user' => $request->user() ? [
                'id' => $request->user()->id,
                'name' => $request->user()->name,
                'email' => $request->user()->email,
                'role_id' => $request->user()->hasRole('admin') ? 'admin' : 
                           ($request->user()->hasRole('instructor') ? 'instructor' : 
                           ($request->user()->hasRole('student') ? 'student' : 'guest')),
                'profile_photo_url' => $request->user()->profile_photo_url,
            ] : null,
            'isAdmin' => $request->user() ? $request->user()->hasRole('admin') : false,
            'general' => $settings->toArray(),
            'canLogin' => \Route::has('login'),
            'canResetPassword' => \Route::has('password.request'),
            'isDemo' => config('qwiktest.demo_mode'),
            "appUrl" => config("app.url").'/',
            "assetUrl" => config("app.url").'/storage/',
            'successMessage' => session()->get('successMessage') ? session()->get('successMessage') : null,
            'errorMessage' => session()->get('errorMessage') ? session()->get('errorMessage') : null,
            'csrf_token' => csrf_token(),
            'isMobile' => $this->isMobileDevice($request),
            "currentCategory" => Cookie::has('category_id') ? ['id' => Cookie::get('category_id'), 'name' => Cookie::get('category_name')] : null,
            'rtl' => config('qwiktest.version') == "1.4.1" ? app(LocalizationSettings::class)->default_direction == 'rtl' : false,
            'locale' => function () {
                return app()->getLocale();
            },
            'translations' => translations(app()->getLocale()),
            'appVersion' => config('qwiktest.version'),
        ]);
    }

    /**
     * Simple mobile device detection based on user agent
     *
     * @param Request $request
     * @return bool
     */
    private function isMobileDevice(Request $request): bool
    {
        $userAgent = $request->header('User-Agent', '');
        
        $mobilePatterns = [
            'iPhone', 'iPad', 'iPod', 'Android', 'BlackBerry', 'Windows Phone',
            'Mobile', 'webOS', 'Opera Mini', 'IEMobile', 'tablet'
        ];
        
        foreach ($mobilePatterns as $pattern) {
            if (stripos($userAgent, $pattern) !== false) {
                return true;
            }
        }
        
        return false;
    }
}
