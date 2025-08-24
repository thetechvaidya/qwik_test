<?php
/**
 * File name: SiteController.php
 * Last modified: 06/07/21, 11:42 AM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Http\Controllers;

use App\Models\Feature;
use App\Models\SubCategory;
use App\Settings\HomePageSettings;
use App\Settings\PaymentSettings;
use App\Settings\SiteSettings;
use App\Transformers\Platform\PlanTransformer;
use App\Transformers\Platform\PricingTransformer;
use Illuminate\Support\Facades\Cache;
use Inertia\Inertia;

class SiteController extends Controller
{
    /**
     * Welcome page with modern homepage content
     *
     * @param HomePageSettings $homePageSettings
     * @param SiteSettings $siteSettings
     * @return \Inertia\Response
     */
    public function index(HomePageSettings $homePageSettings, SiteSettings $siteSettings)
    {
        // Cache homepage data for better performance
        $homepageData = Cache::remember('homepage_data', 3600, function () use ($homePageSettings, $siteSettings) {
            return [
                'site' => [
                    'name' => $siteSettings->app_name,
                    'description' => $siteSettings->seo_description,
                    'logo' => $siteSettings->logo_path,
                ],
                'sections' => [
                    'hero' => [
                        'enabled' => $homePageSettings->show_hero_section ?? $homePageSettings->enable_hero,
                        'title' => $homePageSettings->hero_title ?? 'Transform Your Learning Journey',
                        'subtitle' => $homePageSettings->hero_subtitle ?? 'Master new skills with our comprehensive quiz platform designed for modern learners',
                        'cta_text' => $homePageSettings->hero_cta_text ?? 'Start Learning Today',
                        'cta_link' => $homePageSettings->hero_cta_link ?? '/register',
                    ],
                    'stats' => [
                        'enabled' => $homePageSettings->show_stats_section ?? $homePageSettings->enable_stats,
                        'students_count' => $homePageSettings->stats_students_count ?? 10000,
                        'success_rate' => $homePageSettings->stats_success_rate ?? 95.5,
                        'tests_count' => $homePageSettings->stats_tests_count ?? 500,
                    ],
                    'features' => [
                        'enabled' => $homePageSettings->show_features_section ?? $homePageSettings->enable_features,
                        'list' => $homePageSettings->features_list ?? $this->getDefaultFeatures(),
                    ],
                    'pricing' => [
                        'enabled' => $homePageSettings->show_pricing_section ?? false,
                        'plans' => $homePageSettings->pricing_plans ?? $this->getDefaultPricingPlans(),
                    ],
                    'testimonials' => [
                        'enabled' => $homePageSettings->show_testimonials_section ?? $homePageSettings->enable_testimonials,
                        'list' => $homePageSettings->testimonials ?? $this->getDefaultTestimonials(),
                    ],
                    'cta' => [
                        'enabled' => $homePageSettings->show_cta_section ?? $homePageSettings->enable_cta,
                    ],
                ],
                'legacy_settings' => [
                    'enable_top_bar' => $homePageSettings->enable_top_bar,
                    'enable_search' => $homePageSettings->enable_search,
                    'enable_categories' => $homePageSettings->enable_categories,
                    'enable_footer' => $homePageSettings->enable_footer,
                ]
            ];
        });

        return Inertia::render('Welcome', $homepageData);
    }

    /**
     * Explore category page
     *
     * @param $slug
     * @param HomePageSettings $homePageSettings
     * @param SiteSettings $siteSettings
     * @param PaymentSettings $paymentSettings
     * @return \Illuminate\Contracts\Foundation\Application|\Illuminate\Contracts\View\Factory|\Illuminate\Contracts\View\View
     */
    public function explore($slug, HomePageSettings $homePageSettings, SiteSettings $siteSettings, PaymentSettings $paymentSettings)
    {
        $category = SubCategory::with(['plans' => function($query) {
            $query->where('is_active', '=', 1)->orderBy('sort_order')->with('features');
        }])->where('slug', $slug)->firstOrFail();

        $features = Feature::orderBy('sort_order')->get();

        return view('store.explore', [
            'category' => $category->only(['id', 'name', 'headline', 'short_description']),
            'least_price' => formatPrice($category->plans->min('price'), $paymentSettings->currency_symbol, $paymentSettings->currency_symbol_position),
            'plans' => fractal($category->plans, new PlanTransformer($features))->toArray()['data'],
            'siteSettings' => $siteSettings,
            'homePageSettings' => $homePageSettings
        ]);
    }

    public function pricing(HomePageSettings $homePageSettings, SiteSettings $siteSettings)
    {
        $features = Feature::orderBy('sort_order')->get();
        $categories = SubCategory::whereHas('plans')->with(['category:id,name', 'plans' => function($query) {
            $query->where('is_active', '=', 1)->orderBy('sort_order')->with('features');
        }])->orderBy('sub_categories.name')->get();
        return view('store.pricing', [
            'categories' => fractal($categories, new PricingTransformer($features))->toArray()['data'],
            'selectedCategory' => $categories->count() > 0 ? $categories->first()->code : '',
            'siteSettings' => $siteSettings,
            'homePageSettings' => $homePageSettings
        ]);
    }

    /**
     * Get default features for fallback
     */
    private function getDefaultFeatures(): array
    {
        return [
            [
                'icon' => 'pi pi-chart-line',
                'title' => 'Advanced Analytics',
                'description' => 'Track your progress with detailed analytics and performance insights'
            ],
            [
                'icon' => 'pi pi-mobile',
                'title' => 'Mobile Friendly',
                'description' => 'Learn anywhere, anytime with our responsive mobile-first design'
            ],
            [
                'icon' => 'pi pi-shield',
                'title' => 'Secure Platform',
                'description' => 'Your data is protected with enterprise-grade security measures'
            ],
            [
                'icon' => 'pi pi-users',
                'title' => 'Community Driven',
                'description' => 'Join thousands of learners in our supportive community'
            ]
        ];
    }

    /**
     * Get default pricing plans for fallback
     */
    private function getDefaultPricingPlans(): array
    {
        return [
            [
                'name' => 'Basic',
                'price' => 'Free',
                'period' => '',
                'features' => [
                    '5 quizzes per month',
                    'Basic analytics',
                    'Community support'
                ],
                'cta_text' => 'Get Started',
                'cta_link' => '/register',
                'popular' => false
            ],
            [
                'name' => 'Pro',
                'price' => '$9.99',
                'period' => '/month',
                'features' => [
                    'Unlimited quizzes',
                    'Advanced analytics',
                    'Priority support',
                    'Custom categories'
                ],
                'cta_text' => 'Go Pro',
                'cta_link' => '/subscribe/pro',
                'popular' => true
            ]
        ];
    }

    /**
     * Get default testimonials for fallback
     */
    private function getDefaultTestimonials(): array
    {
        return [
            [
                'name' => 'Sarah Johnson',
                'role' => 'Software Developer',
                'content' => 'This platform helped me ace my certification exams. The questions are well-structured and the analytics are incredibly helpful.',
                'rating' => 5,
                'avatar' => '/images/avatars/sarah.jpg'
            ],
            [
                'name' => 'Mike Chen',
                'role' => 'Student',
                'content' => 'I love how I can track my progress and see exactly where I need to improve. The mobile app is fantastic!',
                'rating' => 5,
                'avatar' => '/images/avatars/mike.jpg'
            ]
        ];
    }
}
