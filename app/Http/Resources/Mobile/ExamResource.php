<?php

namespace App\Http\Resources\Mobile;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ExamResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'description' => $this->description ? substr($this->description, 0, 150) . '...' : null,
            'duration' => $this->duration,
            'total_questions' => $this->questions_count ?? $this->questions->count(),
            'difficulty' => $this->difficulty,
            'category' => [
                'id' => $this->category->id,
                'name' => $this->category->name,
            ],
            'is_free' => $this->is_free,
            'price' => $this->price,
            'passing_score' => $this->passing_score,
            'attempts_allowed' => $this->attempts_allowed,
            'is_active' => $this->is_active,
            'created_at' => $this->created_at->format('Y-m-d H:i:s'),
            'updated_at' => $this->updated_at->format('Y-m-d H:i:s'),
        ];
    }
}