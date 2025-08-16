<?php

namespace Database\Factories;

use App\Models\Question;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Topic;
use App\Models\DifficultyLevel;
use Illuminate\Database\Eloquent\Factories\Factory;

class QuestionFactory extends Factory
{
    protected $model = Question::class;

    public function definition()
    {
        return [
            'question_text' => $this->faker->sentence() . '?',
            'question_type' => $this->faker->randomElement(['mcq', 'true_false', 'short_answer', 'essay']),
            'marks' => $this->faker->numberBetween(1, 10),
            'exam_id' => null,
            'quiz_id' => null,
            'topic_id' => Topic::factory(),
            'difficulty_level_id' => DifficultyLevel::factory(),
            'explanation' => $this->faker->paragraph(),
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function forExam()
    {
        return $this->state(function (array $attributes) {
            return [
                'exam_id' => Exam::factory(),
                'quiz_id' => null,
            ];
        });
    }

    public function forQuiz()
    {
        return $this->state(function (array $attributes) {
            return [
                'exam_id' => null,
                'quiz_id' => Quiz::factory(),
            ];
        });
    }

    public function multipleChoice()
    {
        return $this->state(function (array $attributes) {
            return [
                'question_type' => 'mcq',
            ];
        });
    }

    public function trueFalse()
    {
        return $this->state(function (array $attributes) {
            return [
                'question_type' => 'true_false',
            ];
        });
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
