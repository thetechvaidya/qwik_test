<?php

namespace Database\Factories;

use App\Models\ExamSession;
use App\Models\User;
use App\Models\Exam;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExamSessionFactory extends Factory
{
    protected $model = ExamSession::class;

    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'exam_id' => Exam::factory(),
            'status' => $this->faker->randomElement(['started', 'in_progress', 'completed', 'expired']),
            'score' => $this->faker->numberBetween(0, 100),
            'percentage' => $this->faker->numberBetween(0, 100),
            'total_questions' => $this->faker->numberBetween(10, 50),
            'correct_answers' => $this->faker->numberBetween(0, 50),
            'wrong_answers' => $this->faker->numberBetween(0, 20),
            'unanswered' => $this->faker->numberBetween(0, 10),
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

    public function inProgress()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'in_progress',
                'finished_at' => null,
            ];
        });
    }
}
