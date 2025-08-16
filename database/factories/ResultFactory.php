<?php

namespace Database\Factories;

use App\Models\Result;
use App\Models\User;
use App\Models\ExamSession;
use Illuminate\Database\Eloquent\Factories\Factory;

class ResultFactory extends Factory
{
    protected $model = Result::class;

    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'exam_session_id' => ExamSession::factory(),
            'score' => $this->faker->numberBetween(0, 100),
            'percentage' => $this->faker->numberBetween(0, 100),
            'grade' => $this->faker->randomElement(['A+', 'A', 'B+', 'B', 'C+', 'C', 'F']),
            'status' => $this->faker->randomElement(['pass', 'fail']),
            'total_questions' => $this->faker->numberBetween(10, 50),
            'correct_answers' => $this->faker->numberBetween(0, 50),
            'wrong_answers' => $this->faker->numberBetween(0, 20),
            'unanswered' => $this->faker->numberBetween(0, 10),
            'time_taken' => $this->faker->numberBetween(300, 7200), // seconds
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function passed()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'pass',
                'percentage' => $this->faker->numberBetween(60, 100),
                'grade' => $this->faker->randomElement(['A+', 'A', 'B+', 'B']),
            ];
        });
    }

    public function failed()
    {
        return $this->state(function (array $attributes) {
            return [
                'status' => 'fail',
                'percentage' => $this->faker->numberBetween(0, 59),
                'grade' => $this->faker->randomElement(['C+', 'C', 'F']),
            ];
        });
    }
}
