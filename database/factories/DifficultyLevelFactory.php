<?php

namespace Database\Factories;

use App\Models\DifficultyLevel;
use Illuminate\Database\Eloquent\Factories\Factory;

class DifficultyLevelFactory extends Factory
{
    protected $model = DifficultyLevel::class;

    public function definition()
    {
        return [
            'name' => $this->faker->randomElement(['Easy', 'Medium', 'Hard']),
            'slug' => $this->faker->slug(),
            'points' => $this->faker->numberBetween(1, 10),
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function easy()
    {
        return $this->state(function (array $attributes) {
            return [
                'name' => 'Easy',
                'points' => 1,
            ];
        });
    }

    public function medium()
    {
        return $this->state(function (array $attributes) {
            return [
                'name' => 'Medium',
                'points' => 5,
            ];
        });
    }

    public function hard()
    {
        return $this->state(function (array $attributes) {
            return [
                'name' => 'Hard',
                'points' => 10,
            ];
        });
    }
}
