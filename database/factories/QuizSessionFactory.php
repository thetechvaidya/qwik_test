<?php

namespace Database\Factories;

use App\Models\QuizSession;
use App\Models\User;
use App\Models\Quiz;
use Illuminate\Database\Eloquent\Factories\Factory;

class QuizSessionFactory extends Factory
{
    protected $model = QuizSession::class;

    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'quiz_id' => Quiz::factory(),
            'status' => $this->faker->randomElement(['started', 'in_progress', 'completed', 'expired']),
            'score' => $this->faker->numberBetween(0, 100),
            'percentage' => $this->faker->numberBetween(0, 100),
            'total_questions' => $this->faker->numberBetween(5, 25),
            'correct_answers' => $this->faker->numberBetween(0, 25),
            'wrong_answers' => $this->faker->numberBetween(0, 10),
            'unanswered' => $this->faker->numberBetween(0, 5),
            'started_at' => now(),
            'finished_at' => null,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function completed()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'completed',
                'finished_at' => now(),
            ];
        });
    }
}
