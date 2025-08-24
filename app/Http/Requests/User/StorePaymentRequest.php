<?php

namespace App\Http\Requests\User;

use Illuminate\Foundation\Http\FormRequest;

class StorePaymentRequest extends FormRequest
{
    /**
     * Determine if the user is authorized to make this request.
     *
     * @return bool
     */
    public function authorize()
    {
        return true;
    }

    /**
     * Get the validation rules that apply to the request.
     *
     * @return array
     */
    public function rules()
    {
        return [
            'plan_id' => 'required|exists:plans,id',
            'payment_gateway' => 'required|string|in:stripe,razorpay,paypal',
            'amount' => 'required|numeric|min:0',
            'currency' => 'required|string|size:3',
        ];
    }
}