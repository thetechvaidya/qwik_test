<?php

namespace Database\Factories;

use App\Models\QuestionOption;
use App\Models\Question;
use Illuminate\Database\Eloquent\Factories\Factory;

class QuestionOptionFactory extends Factory
{
    protected $model = QuestionOption::class;

    public function definition()
    {
        return [
            'question_id' => Question::factory(),
            'option_text' => $this->faker->sentence(),
            'is_correct' => false,
            'points' => 0,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function correct()
    {
        return $this->state(function (array $attributes) {
            return [
                'is_correct' => true,
                'points' => 1,
            ];
        });
    }
}
