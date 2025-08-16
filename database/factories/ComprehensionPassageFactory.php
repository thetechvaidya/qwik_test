<?php

namespace Database\Factories;

use App\Models\ComprehensionPassage;
use Illuminate\Database\Eloquent\Factories\Factory;

class ComprehensionPassageFactory extends Factory
{
    protected $model = ComprehensionPassage::class;

    public function definition()
    {
        return [
            'title' => $this->faker->sentence(),
            'passage' => $this->faker->paragraphs(3, true),
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function inactive()
    {
        return $this->state(function (array $attributes) {
            return [
                'is_active' => false,
            ];
        });
    }
}
