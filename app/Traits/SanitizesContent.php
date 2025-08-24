<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

trait SanitizesContent
{
    /**
     * Boot the trait.
     *
     * @return void
     */
    public static function bootSanitizesContent()
    {
        static::saving(function ($model) {
            foreach ($model->sanitized as $column) {
                $model->{$column} = app('profanity-filter')->filter($model->{$column});
            }
        });
    }
}