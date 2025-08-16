<?php
/**
 * File name: PaymentHelper.php
 * Last modified: 14/06/21, 7:36 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

if (!function_exists('formatPrice')) {
    /**
     * Format the display price
     *
     * @param $price
     * @param $symbol
     * @param $position
     * @return string
     */
    function formatPrice($price, $symbol, $position)
    {
        return $position == 'right' ? "{$price}{$symbol}" : "{$symbol}{$price}";
    }
}

if (!function_exists('formatCurrency')) {
    /**
     * Format currency with symbol
     * @param float $amount
     * @param string $currency
     * @return string
     */
    function formatCurrency($amount, $currency = 'USD')
    {
        if ($amount === null) $amount = 0;
        
        $symbols = [
            'USD' => '$',
            'EUR' => '€', 
            'GBP' => '£',
            'INR' => '₹',
            'JPY' => '¥',
        ];
        
        $symbol = $symbols[$currency] ?? '$';
        return $symbol . number_format($amount, 2);
    }
}

if (!function_exists('isValidPaymentGateway')) {
    /**
     * Check if payment gateway is valid
     * @param string $gateway
     * @return bool
     */
    function isValidPaymentGateway($gateway)
    {
        $validGateways = ['razorpay', 'stripe', 'paypal', 'bank_transfer'];
        return in_array($gateway, $validGateways);
    }
}

if (!function_exists('validatePaymentAmount')) {
    /**
     * Validate payment amount
     * @param float $amount
     * @return bool
     */
    function validatePaymentAmount($amount)
    {
        return is_numeric($amount) && $amount > 0;
    }
}

if (!function_exists('calculateSubscriptionEndDate')) {
    /**
     * Calculate subscription end date
     * @param \Carbon\Carbon $startDate
     * @param string $period
     * @return \Carbon\Carbon
     */
    function calculateSubscriptionEndDate($startDate, $period)
    {
        switch ($period) {
            case 'monthly':
                return $startDate->copy()->addMonth();
            case 'quarterly':
                return $startDate->copy()->addMonths(3);
            case 'yearly':
                return $startDate->copy()->addYear();
            case 'weekly':
                return $startDate->copy()->addWeek();
            default:
                return $startDate->copy()->addMonth();
        }
    }
}

if (!function_exists('calculateDiscount')) {
    /**
     * Calculate discount amount
     * @param float $amount
     * @param float $discount
     * @param string $type
     * @return float
     */
    function calculateDiscount($amount, $discount, $type = 'percentage')
    {
        if ($discount <= 0) return 0;
        
        switch ($type) {
            case 'percentage':
                return ($amount * $discount) / 100;
            case 'fixed':
                return min($discount, $amount);
            default:
                return 0;
        }
    }
}
