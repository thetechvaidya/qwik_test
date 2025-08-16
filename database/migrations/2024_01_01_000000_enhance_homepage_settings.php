<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('settings', function (Blueprint $table) {
            // Modern section toggles
            $table->boolean('home_page.show_hero_section')->default(true);
            $table->boolean('home_page.show_features_section')->default(true);
            $table->boolean('home_page.show_stats_section')->default(true);
            $table->boolean('home_page.show_pricing_section')->default(true);
            $table->boolean('home_page.show_testimonials_section')->default(true);
            $table->boolean('home_page.show_cta_section')->default(true);

            // Hero section content
            $table->string('home_page.hero_title')->default('Transform Your Learning Journey');
            $table->text('home_page.hero_subtitle')->default('Master new skills with our comprehensive quiz platform designed for modern learners');
            $table->string('home_page.hero_cta_text')->default('Start Learning Today');
            $table->string('home_page.hero_cta_link')->default('/register');

            // Stats section content
            $table->integer('home_page.stats_students_count')->default(10000);
            $table->decimal('home_page.stats_success_rate', 5, 2)->default(95.5);
            $table->integer('home_page.stats_tests_count')->default(500);

            // Complex content fields (JSON)
            $table->json('home_page.features_list')->default(json_encode([
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
            ]));

            $table->json('home_page.pricing_plans')->default(json_encode([
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
                ],
                [
                    'name' => 'Enterprise',
                    'price' => '$29.99',
                    'period' => '/month',
                    'features' => [
                        'Everything in Pro',
                        'Team management',
                        'API access',
                        'Custom branding'
                    ],
                    'cta_text' => 'Contact Sales',
                    'cta_link' => '/contact',
                    'popular' => false
                ]
            ]));

            $table->json('home_page.testimonials')->default(json_encode([
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
                ],
                [
                    'name' => 'Emily Rodriguez',
                    'role' => 'Teacher',
                    'content' => 'Perfect for creating engaging quizzes for my students. The interface is intuitive and the results are detailed.',
                    'rating' => 5,
                    'avatar' => '/images/avatars/emily.jpg'
                ]
            ]));
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn([
                'home_page.show_hero_section',
                'home_page.show_features_section',
                'home_page.show_stats_section',
                'home_page.show_pricing_section',
                'home_page.show_testimonials_section',
                'home_page.show_cta_section',
                'home_page.hero_title',
                'home_page.hero_subtitle',
                'home_page.hero_cta_text',
                'home_page.hero_cta_link',
                'home_page.stats_students_count',
                'home_page.stats_success_rate',
                'home_page.stats_tests_count',
                'home_page.features_list',
                'home_page.pricing_plans',
                'home_page.testimonials'
            ]);
        });
    }
};
