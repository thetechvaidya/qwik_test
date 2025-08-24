<?php

use Spatie\LaravelSettings\Migrations\SettingsMigration;

class AddMissingHomePageSettings extends SettingsMigration
{
    public function up(): void
    {
        // Modern section toggles
        $this->migrator->add('home_page.show_hero_section', true);
        $this->migrator->add('home_page.show_features_section', true);
        $this->migrator->add('home_page.show_stats_section', true);
        $this->migrator->add('home_page.show_pricing_section', false);
        $this->migrator->add('home_page.show_testimonials_section', true);
        $this->migrator->add('home_page.show_cta_section', true);

        // Hero section content
        $this->migrator->add('home_page.hero_title', 'Transform Your Learning Journey');
        $this->migrator->add('home_page.hero_subtitle', 'Master new skills with our comprehensive quiz platform designed for modern learners');
        $this->migrator->add('home_page.hero_cta_text', 'Start Learning Today');
        $this->migrator->add('home_page.hero_cta_link', '/register');

        // Stats section content
        $this->migrator->add('home_page.stats_students_count', 10000);
        $this->migrator->add('home_page.stats_success_rate', 95.5);
        $this->migrator->add('home_page.stats_tests_count', 500);

        // Complex content fields (JSON)
        $this->migrator->add('home_page.features_list', [
            [
                'title' => 'Interactive Quizzes',
                'description' => 'Engage with dynamic, multimedia-rich quizzes that adapt to your learning style.',
                'icon' => 'quiz'
            ],
            [
                'title' => 'Progress Tracking',
                'description' => 'Monitor your learning progress with detailed analytics and performance insights.',
                'icon' => 'chart'
            ],
            [
                'title' => 'Expert Content',
                'description' => 'Learn from industry experts with carefully curated educational content.',
                'icon' => 'expert'
            ],
            [
                'title' => 'Mobile Learning',
                'description' => 'Access your courses and quizzes anywhere, anytime on any device.',
                'icon' => 'mobile'
            ]
        ]);

        $this->migrator->add('home_page.pricing_plans', [
            [
                'name' => 'Free',
                'price' => 0,
                'period' => 'month',
                'features' => [
                    'Access to basic quizzes',
                    'Limited attempts per day',
                    'Basic progress tracking'
                ],
                'highlighted' => false
            ],
            [
                'name' => 'Premium',
                'price' => 19.99,
                'period' => 'month',
                'features' => [
                    'Unlimited quiz access',
                    'Advanced analytics',
                    'Priority support',
                    'Offline access'
                ],
                'highlighted' => true
            ],
            [
                'name' => 'Enterprise',
                'price' => 49.99,
                'period' => 'month',
                'features' => [
                    'All Premium features',
                    'Custom branding',
                    'API access',
                    'Dedicated support'
                ],
                'highlighted' => false
            ]
        ]);

        $this->migrator->add('home_page.testimonials', [
            [
                'name' => 'Sarah Johnson',
                'role' => 'Student',
                'avatar' => '/images/testimonials/sarah.jpg',
                'content' => 'This platform has completely transformed how I study. The interactive quizzes make learning engaging and fun!',
                'rating' => 5
            ],
            [
                'name' => 'Michael Chen',
                'role' => 'Professional',
                'avatar' => '/images/testimonials/michael.jpg',
                'content' => 'The detailed analytics help me identify my weak areas and focus my study time more effectively.',
                'rating' => 5
            ],
            [
                'name' => 'Emily Rodriguez',
                'role' => 'Teacher',
                'avatar' => '/images/testimonials/emily.jpg',
                'content' => 'I use this platform to create quizzes for my students. The interface is intuitive and the results are comprehensive.',
                'rating' => 5
            ]
        ]);
    }

    public function down(): void
    {
        // Modern section toggles
        $this->migrator->delete('home_page.show_hero_section');
        $this->migrator->delete('home_page.show_features_section');
        $this->migrator->delete('home_page.show_stats_section');
        $this->migrator->delete('home_page.show_pricing_section');
        $this->migrator->delete('home_page.show_testimonials_section');
        $this->migrator->delete('home_page.show_cta_section');

        // Hero section content
        $this->migrator->delete('home_page.hero_title');
        $this->migrator->delete('home_page.hero_subtitle');
        $this->migrator->delete('home_page.hero_cta_text');
        $this->migrator->delete('home_page.hero_cta_link');

        // Stats section content
        $this->migrator->delete('home_page.stats_students_count');
        $this->migrator->delete('home_page.stats_success_rate');
        $this->migrator->delete('home_page.stats_tests_count');

        // Complex content fields
        $this->migrator->delete('home_page.features_list');
        $this->migrator->delete('home_page.pricing_plans');
        $this->migrator->delete('home_page.testimonials');
    }
}
