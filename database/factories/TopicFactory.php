<?php

namespace Database\Factories;

use App\Models\Topic;
use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;

class TopicFactory extends Factory
{
    protected $model = Topic::class;

    public function definition()
    {
        return [
            'name' => $this->faker->words(2, true),
            'description' => $this->faker->sentence(),
            'slug' => $this->faker->slug(),
            'category_id' => Category::factory(),
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
