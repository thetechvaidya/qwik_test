<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Settings\HomePageSettings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Validation\Rule;
use Inertia\Inertia;

class HomePageController extends Controller
{
    /**
     * Display the homepage settings interface.
     */
    public function index()
    {
        $settings = app(HomePageSettings::class);
        
        return Inertia::render('Admin/HomePage/Settings', [
            'settings' => [
                'hero_title' => $settings->hero_title,
                'hero_subtitle' => $settings->hero_subtitle,
                'hero_cta_text' => $settings->hero_cta_text,
                'hero_cta_url' => $settings->hero_cta_url,
                'stats_students_count' => $settings->stats_students_count,
                'stats_courses_count' => $settings->stats_courses_count,
                'stats_completion_rate' => $settings->stats_completion_rate,
                'stats_satisfaction_score' => $settings->stats_satisfaction_score,
                'features_list' => $settings->features_list,
                'pricing_plans' => $settings->pricing_plans,
                'testimonials' => $settings->testimonials,
                'meta_title' => $settings->meta_title,
                'meta_description' => $settings->meta_description,
            ],
            'validation_rules' => $this->getValidationRules(),
        ]);
    }

    /**
     * Update homepage settings.
     */
    public function update(Request $request)
    {
        $validatedData = $request->validate($this->getValidationRules());
        
        $settings = app(HomePageSettings::class);
        
        // Update basic settings
        $settings->hero_title = $validatedData['hero_title'];
        $settings->hero_subtitle = $validatedData['hero_subtitle'];
        $settings->hero_cta_text = $validatedData['hero_cta_text'];
        $settings->hero_cta_url = $validatedData['hero_cta_url'];
        
        // Update stats
        $settings->stats_students_count = $validatedData['stats_students_count'];
        $settings->stats_courses_count = $validatedData['stats_courses_count'];
        $settings->stats_completion_rate = $validatedData['stats_completion_rate'];
        $settings->stats_satisfaction_score = $validatedData['stats_satisfaction_score'];
        
        // Update JSON fields
        $settings->features_list = $validatedData['features_list'];
        $settings->pricing_plans = $validatedData['pricing_plans'];
        $settings->testimonials = $validatedData['testimonials'];
        
        // Update meta fields
        $settings->meta_title = $validatedData['meta_title'];
        $settings->meta_description = $validatedData['meta_description'];
        
        $settings->save();
        
        // Clear homepage cache
        Cache::tags(['homepage', 'settings'])->flush();
        
        return redirect()->back()->with('message', [
            'type' => 'success',
            'text' => 'Homepage settings updated successfully!'
        ]);
    }

    /**
     * Reset homepage settings to defaults.
     */
    public function reset()
    {
        $settings = app(HomePageSettings::class);
        
        // Reset to default values
        $settings->hero_title = 'Transform Your Learning Journey';
        $settings->hero_subtitle = 'Join thousands of learners who have accelerated their careers with our comprehensive courses and expert instruction.';
        $settings->hero_cta_text = 'Start Learning Today';
        $settings->hero_cta_url = '/courses';
        
        $settings->stats_students_count = 50000;
        $settings->stats_courses_count = 200;
        $settings->stats_completion_rate = 94;
        $settings->stats_satisfaction_score = 4.8;
        
        $settings->features_list = $this->getDefaultFeatures();
        $settings->pricing_plans = $this->getDefaultPricingPlans();
        $settings->testimonials = $this->getDefaultTestimonials();
        
        $settings->meta_title = 'Learning Platform - Transform Your Career';
        $settings->meta_description = 'Join thousands of learners and transform your career with our comprehensive online courses, expert instruction, and hands-on projects.';
        
        $settings->save();
        
        // Clear homepage cache
        Cache::tags(['homepage', 'settings'])->flush();
        
        return redirect()->back()->with('message', [
            'type' => 'success',
            'text' => 'Homepage settings reset to defaults successfully!'
        ]);
    }

    /**
     * Preview homepage with current settings.
     */
    public function preview()
    {
        // Clear cache to ensure fresh data
        Cache::tags(['homepage'])->flush();
        
        return redirect()->route('welcome')->with('preview_mode', true);
    }

    /**
     * Get validation rules for homepage settings.
     */
    private function getValidationRules(): array
    {
        return [
            'hero_title' => ['required', 'string', 'max:255'],
            'hero_subtitle' => ['required', 'string', 'max:500'],
            'hero_cta_text' => ['required', 'string', 'max:50'],
            'hero_cta_url' => ['required', 'string', 'max:255'],
            
            'stats_students_count' => ['required', 'integer', 'min:0', 'max:999999'],
            'stats_courses_count' => ['required', 'integer', 'min:0', 'max:9999'],
            'stats_completion_rate' => ['required', 'integer', 'min:0', 'max:100'],
            'stats_satisfaction_score' => ['required', 'numeric', 'min:0', 'max:5'],
            
            'features_list' => ['required', 'array', 'min:1', 'max:6'],
            'features_list.*.title' => ['required', 'string', 'max:100'],
            'features_list.*.description' => ['required', 'string', 'max:200'],
            'features_list.*.icon' => ['required', 'string', 'max:50'],
            
            'pricing_plans' => ['required', 'array', 'min:1', 'max:4'],
            'pricing_plans.*.name' => ['required', 'string', 'max:50'],
            'pricing_plans.*.price' => ['required', 'numeric', 'min:0'],
            'pricing_plans.*.period' => ['required', 'string', 'max:20'],
            'pricing_plans.*.features' => ['required', 'array', 'min:1'],
            'pricing_plans.*.features.*' => ['required', 'string', 'max:100'],
            'pricing_plans.*.popular' => ['boolean'],
            'pricing_plans.*.cta_text' => ['required', 'string', 'max:30'],
            'pricing_plans.*.cta_url' => ['required', 'string', 'max:255'],
            
            'testimonials' => ['required', 'array', 'min:1', 'max:6'],
            'testimonials.*.name' => ['required', 'string', 'max:100'],
            'testimonials.*.title' => ['required', 'string', 'max:100'],
            'testimonials.*.content' => ['required', 'string', 'max:300'],
            'testimonials.*.avatar' => ['nullable', 'string', 'max:255'],
            'testimonials.*.rating' => ['required', 'integer', 'min:1', 'max:5'],
            
            'meta_title' => ['required', 'string', 'max:60'],
            'meta_description' => ['required', 'string', 'max:160'],
        ];
    }

    /**
     * Get default features for reset functionality.
     */
    private function getDefaultFeatures(): array
    {
        return [
            [
                'title' => 'Expert Instructors',
                'description' => 'Learn from industry professionals with years of real-world experience.',
                'icon' => 'pi-users'
            ],
            [
                'title' => 'Hands-on Projects',
                'description' => 'Build real projects that you can add to your portfolio.',
                'icon' => 'pi-cog'
            ],
            [
                'title' => 'Flexible Learning',
                'description' => 'Study at your own pace with lifetime access to course materials.',
                'icon' => 'pi-clock'
            ],
            [
                'title' => 'Community Support',
                'description' => 'Join a community of learners and get help when you need it.',
                'icon' => 'pi-heart'
            ]
        ];
    }

    /**
     * Get default pricing plans for reset functionality.
     */
    private function getDefaultPricingPlans(): array
    {
        return [
            [
                'name' => 'Starter',
                'price' => 29,
                'period' => 'month',
                'features' => [
                    'Access to 5 courses',
                    'Basic support',
                    'Mobile app access'
                ],
                'popular' => false,
                'cta_text' => 'Get Started',
                'cta_url' => '/register?plan=starter'
            ],
            [
                'name' => 'Professional',
                'price' => 59,
                'period' => 'month',
                'features' => [
                    'Access to all courses',
                    'Priority support',
                    'Mobile app access',
                    'Certificates',
                    'Project reviews'
                ],
                'popular' => true,
                'cta_text' => 'Choose Pro',
                'cta_url' => '/register?plan=professional'
            ],
            [
                'name' => 'Enterprise',
                'price' => 99,
                'period' => 'month',
                'features' => [
                    'Everything in Pro',
                    'Team management',
                    'Custom integrations',
                    'Dedicated support',
                    'Analytics dashboard'
                ],
                'popular' => false,
                'cta_text' => 'Contact Sales',
                'cta_url' => '/contact?plan=enterprise'
            ]
        ];
    }

    /**
     * Get default testimonials for reset functionality.
     */
    private function getDefaultTestimonials(): array
    {
        return [
            [
                'name' => 'Sarah Johnson',
                'title' => 'Software Developer',
                'content' => 'This platform completely transformed my career. The courses are practical and the instructors are amazing!',
                'avatar' => '/images/testimonials/sarah.jpg',
                'rating' => 5
            ],
            [
                'name' => 'Michael Chen',
                'title' => 'Product Manager',
                'content' => 'I learned more in 3 months here than I did in 2 years at university. Highly recommend!',
                'avatar' => '/images/testimonials/michael.jpg',
                'rating' => 5
            ],
            [
                'name' => 'Emily Rodriguez',
                'title' => 'UX Designer',
                'content' => 'The hands-on projects really helped me build a portfolio that landed me my dream job.',
                'avatar' => '/images/testimonials/emily.jpg',
                'rating' => 5
            ]
        ];
    }
}
