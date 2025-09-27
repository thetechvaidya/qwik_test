<?php

use Spatie\LaravelSettings\Migrations\SettingsMigration;

class UpdateBrandingToSvg extends SettingsMigration
{
    public function up(): void
    {
        $this->migrator->update('site.logo_path', fn () => 'site/logo.svg');
        $this->migrator->update('site.white_logo_path', fn () => 'site/logo-white.svg');
        $this->migrator->update('home_page.hero_image_path', fn () => 'site/hero-illustration.svg');
        $this->migrator->update('hero.image_path', fn () => 'site/hero-illustration.svg');
    }

    public function down(): void
    {
        $this->migrator->update('site.logo_path', fn () => 'site/logo.png');
        $this->migrator->update('site.white_logo_path', fn () => 'site/logo_white.png');
        $this->migrator->update('home_page.hero_image_path', fn () => 'site/hero_image_bg.png');
        $this->migrator->update('hero.image_path', fn () => 'site/hero_image_bg.png');
    }
}
