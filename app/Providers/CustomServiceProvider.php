<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Services\QuestionParserService;
use App\Services\PaymentGatewayService;
use App\Services\ExamSchedulerService;

class CustomServiceProvider extends ServiceProvider
{
    /**
     * Register services.
     */
    public function register(): void
    {
        $this->app->singleton('question.parser', function ($app) {
            return new QuestionParserService();
        });

        $this->app->singleton('payment.gateway', function ($app) {
            return new PaymentGatewayService();
        });

        $this->app->singleton('exam.scheduler', function ($app) {
            return new ExamSchedulerService();
        });
    }

    /**
     * Bootstrap services.
     */
    public function boot(): void
    {
        //
    }
}
