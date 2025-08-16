<?php

namespace Database\Factories;

use App\Models\Lesson;
use App\Models\Topic;
use Illuminate\Database\Eloquent\Factories\Factory;

class LessonFactory extends Factory
{
    protected $model = Lesson::class;

    public function definition()
    {
        return [
            'title' => $this->faker->sentence(),
            'content' => $this->faker->paragraphs(3, true),
            'slug' => $this->faker->slug(),
            'topic_id' => Topic::factory(),
            'is_active' => true,
            'order' => $this->faker->numberBetween(1, 100),
            'created_at' => now(),
            'updated_at' => now(),
        ];
    }
}
