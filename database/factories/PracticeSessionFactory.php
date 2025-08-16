<?php

namespace Database\Factories;

use App\Models\PracticeSession;
use App\Models\User;
use App\Models\Topic;
use Illuminate\Database\Eloquent\Factories\Factory;

class PracticeSessionFactory extends Factory
{
    protected $model = PracticeSession::class;

    public function definition()
    {
        return [
            'user_id' => User::factory(),
            'topic_id' => Topic::factory(),
            'status' => $this->faker->randomElement(['started', 'in_progress', 'completed']),
            'score' => $this->faker->numberBetween(0, 100),
            'total_questions' => $this->faker->numberBetween(5, 20),
            'correct_answers' => $this->faker->numberBetween(0, 20),
            'wrong_answers' => $this->faker->numberBetween(0, 10),
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
