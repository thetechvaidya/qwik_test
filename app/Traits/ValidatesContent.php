<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

trait ValidatesContent
{
    /**
     * Boot the trait.
     *
     * @return void
     */
    public static function bootValidatesContent()
    {
        static::saving(function ($model) {
            $validator = Validator::make($model->getAttributes(), [
                'question' => 'required|string',
                'options' => 'required|array',
                'correct_answer' => 'required',
            ]);

            if ($validator->fails()) {
                throw new ValidationException($validator);
            }
        });
    }
}