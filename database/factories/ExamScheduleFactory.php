<?php

namespace Database\Factories;

use App\Models\ExamSchedule;
use App\Models\Exam;
use Illuminate\Database\Eloquent\Factories\Factory;

class ExamScheduleFactory extends Factory
{
    protected $model = ExamSchedule::class;

    public function definition()
    {
        $startDate = $this->faker->dateTimeBetween('now', '+30 days');
        $endDate = $this->faker->dateTimeBetween($startDate, '+60 days');

        return [
            'exam_id' => Exam::factory(),
            'start_date' => $startDate,
            'end_date' => $endDate,
            'max_attempts' => $this->faker->numberBetween(1, 3),
            'is_active' => true,
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }

    public function active()
    {
        return $this->state(function (array $attributes) {
            return [
                'start_date' => now()->subDay(),
                'end_date' => now()->addDay(),
                'is_active' => true,
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
