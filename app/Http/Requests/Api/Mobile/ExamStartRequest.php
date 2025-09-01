<?php

namespace App\Http\Requests\Api\Mobile;

use Illuminate\Foundation\Http\FormRequest;

class ExamStartRequest extends FormRequest
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
            'device_id' => 'nullable|string|max:255',
            'offline_mode' => 'nullable|boolean',
            'time_zone' => 'nullable|string|max:50',
        ];
    }

    /**
     * Get custom messages for validator errors.
     */
    public function messages(): array
    {
        return [
            'device_id.string' => 'Device ID must be a valid string.',
            'device_id.max' => 'Device ID cannot exceed 255 characters.',
            'offline_mode.boolean' => 'Offline mode must be true or false.',
            'time_zone.string' => 'Time zone must be a valid string.',
            'time_zone.max' => 'Time zone cannot exceed 50 characters.',
        ];
    }

    /**
     * Get custom attributes for validator errors.
     */
    public function attributes(): array
    {
        return [
            'device_id' => 'device ID',
            'offline_mode' => 'offline mode',
            'time_zone' => 'time zone',
        ];
    }
}