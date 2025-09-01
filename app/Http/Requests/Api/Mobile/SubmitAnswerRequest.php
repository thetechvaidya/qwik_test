<?php

namespace App\Http\Requests\Api\Mobile;

use Illuminate\Foundation\Http\FormRequest;

class SubmitAnswerRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     */
    public function authorize(): bool
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     */
    public function rules(): array
    {
        return [
            'question_id' => 'required|integer|exists:questions,id',
            'answer' => 'required|string',
            'time_spent' => 'nullable|integer|min:0',
            'is_flagged' => 'nullable|boolean',
            'offline_timestamp' => 'nullable|date',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'question_id.required' => 'Question ID is required.',
            'question_id.integer' => 'Question ID must be a valid number.',
            'question_id.exists' => 'The selected question does not exist.',
            'answer.required' => 'Answer is required.',
            'answer.string' => 'Answer must be a valid string.',
            'time_spent.integer' => 'Time spent must be a valid number.',
            'time_spent.min' => 'Time spent cannot be negative.',
            'is_flagged.boolean' => 'Flagged status must be true or false.',
            'offline_timestamp.date' => 'Offline timestamp must be a valid date.',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     */
    public function attributes(): array
    {
        return [
            'question_id' => 'question',
            'time_spent' => 'time spent',
            'is_flagged' => 'flagged status',
            'offline_timestamp' => 'offline timestamp',
        ];
    }
}