<?php
/**
 * File name: HomePageSettings.php
 * Last modified: 19/05/21, 7:39 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Settings;

use Spatie\LaravelSettings\Settings;

class HomePageSettings extends Settings
{
    // Legacy section toggles
    public bool $enable_top_bar;
    public bool $enable_search;
    public bool $enable_hero;
    public bool $enable_features;
    public bool $enable_categories;
    public bool $enable_stats;
    public bool $enable_testimonials;
    public bool $enable_cta;
    public bool $enable_footer;

    // Modern section toggles
    public bool $show_hero_section;
    public bool $show_features_section;
    public bool $show_stats_section;
    public bool $show_pricing_section;
    public bool $show_testimonials_section;
    public bool $show_cta_section;

    // Hero section content
    public string $hero_title;
    public string $hero_subtitle;
    public string $hero_cta_text;
    public string $hero_cta_link;

    // Stats section content
    public int $stats_students_count;
    public float $stats_success_rate;
    public int $stats_tests_count;

    // Complex content fields (JSON)
    public array $features_list;
    public array $pricing_plans;
    public array $testimonials;

    public static function group(): string
    {
        return 'home_page';
    }
}
