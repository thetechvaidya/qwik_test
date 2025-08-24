<?php

namespace App\Traits;

use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

trait ValidatesMedia
{
    /**
     * Boot the trait.
     *
     * @return void
     */
    public static function bootValidatesMedia()
    {
        static::saving(function ($model) {
            foreach ($model->media as $column) {
                $validator = Validator::make(
                    [$column => $model->{$column}],
                    [$column => 'string|no_media']
                );

                if ($validator->fails()) {
                    throw new ValidationException($validator);
                }
            }
        });
    }
}