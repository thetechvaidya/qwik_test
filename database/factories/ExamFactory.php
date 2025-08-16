<?php

namespace Database\Factories;

use App\Models\Exam;
use App\Models\Category;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExamFactory extends Factory
{
    protected $model = Exam::class;

    public function definition()
    {
        return [
            'title' => $this->faker->sentence(3),
            'description' => $this->faker->paragraph(),
            'slug' => $this->faker->slug(),
            'category_id' => Category::factory(),
            'total_marks' => $this->faker->numberBetween(50, 200),
            'duration' => $this->faker->numberBetween(30, 180), // minutes
            'total_questions' => $this->faker->numberBetween(10, 50),
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
