<?php

namespace Database\Factories;

use App\Models\Quiz;
use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;

class QuizFactory extends Factory
{
    protected $model = Quiz::class;

    public function definition()
    {
        return [
            'title' => $this->faker->sentence(3),
            'description' => $this->faker->paragraph(),
            'slug' => $this->faker->slug(),
            'category_id' => Category::factory(),
            'total_marks' => $this->faker->numberBetween(20, 100),
            'duration' => $this->faker->numberBetween(15, 60), // minutes
            'total_questions' => $this->faker->numberBetween(5, 25),
            'is_active' => true,
            'is_featured' => false,
            'auto_grading' => true,
            'negative_marking' => false,
            'negative_marks' => 0,
            'pass_percentage' => $this->faker->numberBetween(40, 70),
            'instructions' => $this->faker->paragraph(),
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

    public function featured()
    {
        return $this->state(function (array $attributes) {
            return [
                'is_featured' => true,
            ];
        });
    }
}
