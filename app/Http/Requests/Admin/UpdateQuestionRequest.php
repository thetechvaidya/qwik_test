<?php
/**
 * File name: UpdateQuestionRequest.php
 * Last modified: 10/07/21, 11:59 AM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

namespace App\Http\Requests\Admin;

use App\Traits\SanitizesContent;
use App\Traits\ValidatesContent;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Support\Facades\Gate;

class UpdateQuestionRequest extends FormRequest
{
    use ValidatesContent, SanitizesContent;

    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return Gate::allows('update', $this->question);
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'question' => ['sometimes', 'required', 'string', 'max:65535', $this->validateContent()],
            'question_type_id' => 'sometimes|required|exists:question_types,id',
            'skill_id' => 'sometimes|required|exists:skills,id',
            'is_active' => 'sometimes|required|boolean',
            'options' => 'sometimes|required|array|min:2',
            'options.*.option' => ['sometimes', 'required', 'string', 'max:65535', $this->validateContent()],
            'options.*.is_correct' => 'sometimes|required|boolean',
            'correct_answer' => 'sometimes|required',
        ];
    }

    /**
     * Get the sanitized data from the request.
     *
     * @return array
     */
    public function sanitizedData()
    {
        $data = $this->validated();
        $data['version'] = $this->question->version + 1;
        return $this->sanitize($data);
    }

    /**
     * Get the original data before the update.
     *
     * @return array
     */
    public function originalData()
    {
        return $this->question->only(array_keys($this->rules()));
    }
}
