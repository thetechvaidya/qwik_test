<?php

namespace App\Http\Requests\Admin;

use App\Traits\SanitizesContent;
use App\Traits\ValidatesContent;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Gate;

class StoreQuestionRequest extends FormRequest
{
    use ValidatesContent, SanitizesContent;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return Gate::allows('question_create');
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'question' => [
                'required',
                'string',
                'max:65535',
                $this->validateContent(),
            ],
            'question_type_id' => [
                'required',
                'integer',
                'exists:question_types,id',
            ],
            'skill_id' => [
                'required',
                'integer',
                'exists:skills,id',
            ],
            'difficulty_level_id' => [
                'required',
                'integer',
                'exists:difficulty_levels,id',
            ],
            'options' => [
                'required',
                'array',
            ],
            'options.*.option' => [
                'required',
                'string',
                'max:65535',
                $this->validateContent(),
            ],
            'options.*.is_correct' => [
                'boolean',
            ],
            'explanation' => [
                'nullable',
                'string',
                'max:65535',
                $this->validateContent(),
            ],
            'hint' => [
                'nullable',
                'string',
                'max:65535',
                $this->validateContent(),
            ],
            'media_url' => [
                'nullable',
                'string',
                'max:2048',
            ],
            'media_type' => [
                'nullable',
                'string',
                'in:image,video,audio',
            ],
            'attachment' => [
                'nullable',
                'file',
                'mimes:jpeg,png,jpg,gif,svg,pdf,doc,docx,mp4,mp3',
                'max:20480', // 20MB
            ],
        ];
    }

    /**
     * Prepare the data for validation.
     *
     * @return void
     */
    protected function prepareForValidation()
    {
        $this->merge([
            'question' => $this->sanitize($this->question),
            'explanation' => $this->sanitize($this->explanation),
            'hint' => $this->sanitize($this->hint),
        ]);

        if ($this->has('options')) {
            $sanitizedOptions = [];
            foreach ($this->options as $option) {
                $sanitizedOptions[] = [
                    'option' => $this->sanitize($option['option']),
                    'is_correct' => $option['is_correct'] ?? false,
                ];
            }
            $this->merge(['options' => $sanitizedOptions]);
        }
    }

    /**
     * Get the error messages for the defined validation rules.
     *
     * @return array
     */
    public function messages()
    {
        return [
            'question.required' => 'The question field is required.',
            'question_type_id.required' => 'Please select a question type.',
            'skill_id.required' => 'Please select a skill.',
            'difficulty_level_id.required' => 'Please select a difficulty level.',
            'options.required' => 'At least one option is required.',
            'options.*.option.required' => 'The option text is required.',
        ];
    }
}
