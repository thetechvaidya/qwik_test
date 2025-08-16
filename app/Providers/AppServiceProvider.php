<?php

namespace App\Providers;

use Illuminate\Support\Facades\URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     *
     * @return void
     */
    public function register()
    {
        // Disable package migrations for bavix/laravel-wallet; we maintain local migrations.
        if (class_exists(\Bavix\Wallet\WalletConfigure::class)) {
            \Bavix\Wallet\WalletConfigure::ignoreMigrations();
        }
    }

    /**
     * Bootstrap any application services.
     *
     * @return void
     */
    public function boot()
    {
        if(config('app.env') === 'production') {
            URL::forceScheme('https');
        }
    }
}
