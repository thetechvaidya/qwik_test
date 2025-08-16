<?php

namespace App\Rules;

use Closure;
use Illuminate\Contracts\Validation\ValidationRule;

class ValidQuestionOptions implements ValidationRule
{
    /**
     * Run the validation rule.
     */
    public function validate(string $attribute, mixed $value, Closure $fail): void
    {
        if (!is_array($value)) {
            $fail('The ' . $attribute . ' must be an array.');
            return;
        }

        if (count($value) < 2) {
            $fail('The ' . $attribute . ' must have at least 2 options.');
            return;
        }

        $hasCorrectAnswer = false;
        foreach ($value as $option) {
            if (!is_array($option)) {
                $fail('Each option in ' . $attribute . ' must be an array.');
                return;
            }

            if (!isset($option['option']) || empty($option['option'])) {
                $fail('Each option in ' . $attribute . ' must have a non-empty option text.');
                return;
            }

            if (!isset($option['is_correct'])) {
                $fail('Each option in ' . $attribute . ' must have an is_correct field.');
                return;
            }

            if ($option['is_correct']) {
                $hasCorrectAnswer = true;
            }
        }

        if (!$hasCorrectAnswer) {
            $fail('The ' . $attribute . ' must have at least one correct answer.');
        }
    }
}
