<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
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
            if (!Schema::hasColumn('settings', 'home_page_show_hero_section')) {
                $table->boolean('home_page_show_hero_section')->default(true);
            }
            if (!Schema::hasColumn('settings', 'home_page_show_features_section')) {
                $table->boolean('home_page_show_features_section')->default(true);
            }
            if (!Schema::hasColumn('settings', 'home_page_show_stats_section')) {
                $table->boolean('home_page_show_stats_section')->default(true);
            }
            if (!Schema::hasColumn('settings', 'home_page_show_pricing_section')) {
                $table->boolean('home_page_show_pricing_section')->default(true);
            }
            if (!Schema::hasColumn('settings', 'home_page_show_testimonials_section')) {
                $table->boolean('home_page_show_testimonials_section')->default(true);
            }
            if (!Schema::hasColumn('settings', 'home_page_show_cta_section')) {
                $table->boolean('home_page_show_cta_section')->default(true);
            }

            // Hero section content
            if (!Schema::hasColumn('settings', 'home_page_hero_title')) {
                $table->string('home_page_hero_title')->default('Transform Your Learning Journey');
            }
            if (!Schema::hasColumn('settings', 'home_page_hero_subtitle')) {
                $table->string('home_page_hero_subtitle', 512)->default('Master new skills with our comprehensive quiz platform designed for modern learners');
            }
            if (!Schema::hasColumn('settings', 'home_page_hero_cta_text')) {
                $table->string('home_page_hero_cta_text')->default('Start Learning Today');
            }
            if (!Schema::hasColumn('settings', 'home_page_hero_cta_link')) {
                $table->string('home_page_hero_cta_link')->default('/register');
            }

            // Stats section content
            if (!Schema::hasColumn('settings', 'home_page_stats_students_count')) {
                $table->integer('home_page_stats_students_count')->default(10000);
            }
            if (!Schema::hasColumn('settings', 'home_page_stats_success_rate')) {
                $table->decimal('home_page_stats_success_rate', 5, 2)->default(95.5);
            }
            if (!Schema::hasColumn('settings', 'home_page_stats_tests_count')) {
                $table->integer('home_page_stats_tests_count')->default(500);
            }

            // Complex content fields (JSON)
            if (!Schema::hasColumn('settings', 'home_page_features_list')) {
                $table->json('home_page_features_list')->nullable();
            }

            if (!Schema::hasColumn('settings', 'home_page_pricing_plans')) {
                $table->json('home_page_pricing_plans')->nullable();
            }

            if (!Schema::hasColumn('settings', 'home_page_testimonials')) {
                $table->json('home_page_testimonials')->nullable();
            }
        });

        if (Schema::hasColumn('settings', 'home_page_features_list')) {
            DB::table('settings')
                ->whereNull('home_page_features_list')
                ->update([
                    'home_page_features_list' => json_encode([
                        [
                            'icon' => 'pi pi-chart-line',
                            'title' => 'Advanced Analytics',
                            'description' => 'Track your progress with detailed analytics and performance insights',
                        ],
                        [
                            'icon' => 'pi pi-mobile',
                            'title' => 'Mobile Friendly',
                            'description' => 'Learn anywhere, anytime with our responsive mobile-first design',
                        ],
                        [
                            'icon' => 'pi pi-shield',
                            'title' => 'Secure Platform',
                            'description' => 'Your data is protected with enterprise-grade security measures',
                        ],
                        [
                            'icon' => 'pi pi-users',
                            'title' => 'Community Driven',
                            'description' => 'Join thousands of learners in our supportive community',
                        ],
                    ]),
                ]);
        }

        if (Schema::hasColumn('settings', 'home_page_pricing_plans')) {
            DB::table('settings')
                ->whereNull('home_page_pricing_plans')
                ->update([
                    'home_page_pricing_plans' => json_encode([
                        [
                            'name' => 'Basic',
                            'price' => 'Free',
                            'period' => '',
                            'features' => [
                                '5 quizzes per month',
                                'Basic analytics',
                                'Community support',
                            ],
                            'cta_text' => 'Get Started',
                            'cta_link' => '/register',
                            'popular' => false,
                        ],
                        [
                            'name' => 'Pro',
                            'price' => '$9.99',
                            'period' => '/month',
                            'features' => [
                                'Unlimited quizzes',
                                'Advanced analytics',
                                'Priority support',
                                'Custom categories',
                            ],
                            'cta_text' => 'Go Pro',
                            'cta_link' => '/subscribe/pro',
                            'popular' => true,
                        ],
                        [
                            'name' => 'Enterprise',
                            'price' => '$29.99',
                            'period' => '/month',
                            'features' => [
                                'Everything in Pro',
                                'Team management',
                                'API access',
                                'Custom branding',
                            ],
                            'cta_text' => 'Contact Sales',
                            'cta_link' => '/contact',
                            'popular' => false,
                        ],
                    ]),
                ]);
        }

        if (Schema::hasColumn('settings', 'home_page_testimonials')) {
            DB::table('settings')
                ->whereNull('home_page_testimonials')
                ->update([
                    'home_page_testimonials' => json_encode([
                        [
                            'name' => 'Sarah Johnson',
                            'role' => 'Software Developer',
                            'content' => 'This platform helped me ace my certification exams. The questions are well-structured and the analytics are incredibly helpful.',
                            'rating' => 5,
                            'avatar' => '/images/avatars/sarah.jpg',
                        ],
                        [
                            'name' => 'Mike Chen',
                            'role' => 'Student',
                            'content' => 'I love how I can track my progress and see exactly where I need to improve. The mobile app is fantastic!',
                            'rating' => 5,
                            'avatar' => '/images/avatars/mike.jpg',
                        ],
                        [
                            'name' => 'Emily Rodriguez',
                            'role' => 'Teacher',
                            'content' => 'Perfect for creating engaging quizzes for my students. The interface is intuitive and the results are detailed.',
                            'rating' => 5,
                            'avatar' => '/images/avatars/emily.jpg',
                        ],
                    ]),
                ]);
        }
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('settings', function (Blueprint $table) {
            $table->dropColumn([
                'home_page_show_hero_section',
                'home_page_show_features_section',
                'home_page_show_stats_section',
                'home_page_show_pricing_section',
                'home_page_show_testimonials_section',
                'home_page_show_cta_section',
                'home_page_hero_title',
                'home_page_hero_subtitle',
                'home_page_hero_cta_text',
                'home_page_hero_cta_link',
                'home_page_stats_students_count',
                'home_page_stats_success_rate',
                'home_page_stats_tests_count',
                'home_page_features_list',
                'home_page_pricing_plans',
                'home_page_testimonials'
            ]);
        });
    }
};
