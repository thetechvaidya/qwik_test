<?php

namespace Database\Factories;

use App\Models\Subscription;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

class SubscriptionFactory extends Factory
{
    protected $model = Subscription::class;

    public function definition()
    {
        $startDate = now();
        $endDate = $startDate->copy()->addDays(30);

        return [
            'user_id' => User::factory(),
            'plan_name' => $this->faker->randomElement(['Basic', 'Premium', 'Pro']),
            'amount' => $this->faker->randomFloat(2, 10, 100),
            'currency' => 'USD',
            'status' => $this->faker->randomElement(['active', 'expired', 'cancelled']),
            'starts_at' => $startDate,
            'expires_at' => $endDate,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function active()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'active',
                'starts_at' => now()->subDays(5),
                'expires_at' => now()->addDays(25),
            ];
        });
    }

    public function expired()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'expired',
                'starts_at' => now()->subDays(35),
                'expires_at' => now()->subDays(5),
            ];
        });
    }
}
