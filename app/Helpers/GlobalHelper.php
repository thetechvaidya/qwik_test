<?php
/**
 * File name: GlobalHelper.php
 * Last modified: 14/06/21, 7:36 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

if (!function_exists('formattedSeconds')) {
    /**
     * Seconds to Human Readable Time Format
     * @param $seconds
     * @return array
     */
    function formattedSeconds($seconds)
    {
        $hours = floor($seconds / 3600);
        $minutes = floor(($seconds / 60) % 60);
        $sec = $seconds % 60;
        return [
            'seconds' => $seconds,
            'short_readable' => "$hours:$minutes:$sec",
            'detailed_readable' => $hours > 0 ? "$hours Hrs $minutes Min" : ($minutes > 0 ? "$minutes Min $sec Sec" : "$sec Sec")
        ];
    }
}

if (!function_exists('calculateSpeedPerHour')) {
    /**
     * Calculate questions speed per hour
     * @param $totalAnswered
     * @param $totalSeconds
     * @return float|int
     */
    function calculateSpeedPerHour($totalAnswered, $totalSeconds)
    {
        return $totalAnswered !== 0 ? ($totalAnswered * 3600) / $totalSeconds : 0;
    }
}

if (!function_exists('calculateAccuracy')) {
    /**
     * Calculate accuracy of a test
     * @param $correctAnswered
     * @param $totalAnswered
     * @return float|int
     */
    function calculateAccuracy($correctAnswered, $totalAnswered)
    {
        return $totalAnswered != 0 ? ($correctAnswered / $totalAnswered) * 100 : 0;
    }
}

if (!function_exists('calculatePercentage')) {
    /**
     * Calculate percentage
     * @param $x
     * @param $y
     * @return float|int
     */
    function calculatePercentage($x, $y)
    {
        return $y != 0 ? $x / $y * 100 : 0;
    }
}

if (!function_exists('calculatePercentileRank')) {
    /**
     * Calculate percentile
     * @param $array
     * @param $key
     * @return float|int
     */
    function calculatePercentileRank($array, $key)
    {
        $n = count($array);
        $l = binarySearchCount($array, $n, $key);
        return round(($l / $n) * 100, 0); // Percentile Rank Formula
    }
}

if (!function_exists('hex2rgba')) {
    /**
     * Convert hex color to rgb(a)
     *
     * @param $color
     * @param bool $opacity
     * @return float|int
     */
    function hex2rgba($color, $opacity = false) {

        $default = 'rgb(0,0,0)';

        //Return default if no color provided
        if(empty($color))
            return $default;

        //Sanitize $color if "#" is provided
        if ($color[0] == '#' ) {
            $color = substr( $color, 1 );
        }

        //Check if color has 6 or 3 characters and get values
        if (strlen($color) == 6) {
            $hex = array( $color[0] . $color[1], $color[2] . $color[3], $color[4] . $color[5] );
        } elseif ( strlen( $color ) == 3 ) {
            $hex = array( $color[0] . $color[0], $color[1] . $color[1], $color[2] . $color[2] );
        } else {
            return $default;
        }

        //Convert hexadec to rgb
        $rgb =  array_map('hexdec', $hex);

        //Check if opacity is set(rgba or rgb)
        if($opacity){
            if(abs($opacity) > 1)
        		$opacity = 1.0;
        	$output = 'rgba('.implode(",",$rgb).','.$opacity.')';
        } else {
            $output = 'rgb('.implode(",",$rgb).')';
        }

        //Return rgb(a) color string
        return $output;
    }
}

if (!function_exists('binarySearchCount')) {
    /**
     * A binary search function to return number of elements less than or equal to given key
     *
     * @param $arr
     * @param $n
     * @param $key
     * @return float|int
     */
    function binarySearchCount($arr, $n, $key)
    {
        $left = 0;
        $right = $n - 1;

        $count = 0;

        while ($left <= $right) {
            $mid = round(($right + $left) / 2, 0);
            // Check if middle element is less than or equal to key
            if ($arr[$mid] <= $key) {
                ; // At least (mid + 1) elements are there whose values are less than or equal to key
                $count = $mid+1;
                $left = $mid + 1;
            } // If key is smaller, ignore right half
            else
                $right = $mid - 1;
        }
        return $count;
    }
}

if (!function_exists('getAppName')) {
    /**
     * Get application name
     * @return string
     */
    function getAppName()
    {
        return config('app.name', 'Laravel Application');
    }
}

if (!function_exists('formatBytes')) {
    /**
     * Format bytes to human readable format
     * @param int $bytes
     * @param int $precision
     * @return string
     */
    function formatBytes($bytes, $precision = 2)
    {
        if ($bytes === null || $bytes <= 0) return '0 B';
        
        $units = ['B', 'KB', 'MB', 'GB', 'TB', 'PB'];
        
        for ($i = 0; $bytes > 1024 && $i < count($units) - 1; $i++) {
            $bytes /= 1024;
        }
        
        return round($bytes, $precision) . ' ' . $units[$i];
    }
}

if (!function_exists('formatDateTime')) {
    /**
     * Format datetime for display
     * @param mixed $date
     * @param string $format
     * @return string
     */
    function formatDateTime($date, $format = 'Y-m-d H:i:s')
    {
        if (empty($date)) return '';
        
        if (is_string($date)) {
            $date = \Carbon\Carbon::parse($date);
        }
        
        return $date->format($format);
    }
}

if (!function_exists('getAppConfig')) {
    /**
     * Get application configuration value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getAppConfig($key, $default = null)
    {
        return config($key, $default);
    }
}

if (!function_exists('getExamSetting')) {
    /**
     * Get exam setting value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getExamSetting($key, $default = null)
    {
        return config("exam.{$key}", $default);
    }
}

if (!function_exists('getPaymentConfig')) {
    /**
     * Get payment configuration value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getPaymentConfig($key, $default = null)
    {
        return config("payment.{$key}", $default);
    }
}

if (!function_exists('humanFileSize')) {
    /**
     * Format file size to human readable format
     * @param int $bytes
     * @param int $decimals
     * @return string
     */
    function humanFileSize($bytes, $decimals = 2)
    {
        return formatBytes($bytes, $decimals);
    }
}

if (!function_exists('isValidFileExtension')) {
    /**
     * Check if file extension is valid
     * @param string $extension
     * @param array $allowedExtensions
     * @return bool
     */
    function isValidFileExtension($extension, $allowedExtensions)
    {
        return in_array(strtolower($extension), array_map('strtolower', $allowedExtensions));
    }
}

if (!function_exists('getMimeType')) {
    /**
     * Get MIME type for file
     * @param string $filename
     * @return string
     */
    function getMimeType($filename)
    {
        $extension = pathinfo($filename, PATHINFO_EXTENSION);
        
        $mimeTypes = [
            'jpg' => 'image/jpeg',
            'jpeg' => 'image/jpeg',
            'png' => 'image/png',
            'gif' => 'image/gif',
            'pdf' => 'application/pdf',
            'doc' => 'application/msword',
            'docx' => 'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
            'xls' => 'application/vnd.ms-excel',
            'xlsx' => 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
        ];
        
        return $mimeTypes[strtolower($extension)] ?? 'application/octet-stream';
    }
}

if (!function_exists('cacheRemember')) {
    /**
     * Cache remember helper
     * @param string $key
     * @param int $minutes
     * @param callable $callback
     * @return mixed
     */
    function cacheRemember($key, $minutes, $callback)
    {
        return \Illuminate\Support\Facades\Cache::remember($key, $minutes * 60, $callback);
    }
}

if (!function_exists('optimizeQuery')) {
    /**
     * Optimize query with eager loading
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @param array $relationships
     * @return \Illuminate\Database\Eloquent\Builder
     */
    function optimizeQuery($query, $relationships = [])
    {
        if (!empty($relationships)) {
            $query->with($relationships);
        }
        
        return $query;
    }
}

if (!function_exists('getMemoryUsage')) {
    /**
     * Get current memory usage
     * @return string
     */
    function getMemoryUsage()
    {
        $memory = memory_get_usage(true);
        return formatBytes($memory);
    }
}

if (!function_exists('sanitizeInput')) {
    /**
     * Sanitize user input
     * @param string $input
     * @return string
     */
    function sanitizeInput($input)
    {
        return strip_tags($input);
    }
}

if (!function_exists('validateCsrfToken')) {
    /**
     * Validate CSRF token
     * @param \Illuminate\Http\Request $request
     * @return bool
     */
    function validateCsrfToken($request)
    {
        $token = $request->header('X-CSRF-TOKEN') ?: $request->input('_token');
        return hash_equals(csrf_token(), $token);
    }
}

if (!function_exists('encryptSensitiveData')) {
    /**
     * Encrypt sensitive data
     * @param string $data
     * @return string
     */
    function encryptSensitiveData($data)
    {
        return encrypt($data);
    }
}

if (!function_exists('decryptSensitiveData')) {
    /**
     * Decrypt sensitive data
     * @param string $encryptedData
     * @return string
     */
    function decryptSensitiveData($encryptedData)
    {
        return decrypt($encryptedData);
    }
}

if (!function_exists('calculatePercentage')) {
    /**
     * Calculate percentage
     * @param mixed $value
     * @param mixed $total
     * @return float
     */
    function calculatePercentage($value, $total)
    {
        if (is_null($value) || is_null($total) || $total == 0) {
            return 0.0;
        }
        return round(($value / $total) * 100, 2);
    }
}

if (!function_exists('getAppConfig')) {
    /**
     * Get application configuration value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getAppConfig($key, $default = null)
    {
        return config($key, $default);
    }
}

if (!function_exists('getExamSetting')) {
    /**
     * Get exam setting value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getExamSetting($key, $default = null)
    {
        return config("exam.{$key}", $default);
    }
}

if (!function_exists('getPaymentConfig')) {
    /**
     * Get payment configuration value
     * @param string $key
     * @param mixed $default
     * @return mixed
     */
    function getPaymentConfig($key, $default = null)
    {
        return config("payment.{$key}", $default);
    }
}

if (!function_exists('cacheRemember')) {
    /**
     * Remember value in cache
     * @param string $key
     * @param int $minutes
     * @param callable $callback
     * @return mixed
     */
    function cacheRemember($key, $minutes, $callback)
    {
        return \Cache::remember($key, now()->addMinutes($minutes), $callback);
    }
}

if (!function_exists('optimizeQuery')) {
    /**
     * Optimize database query with eager loading
     * @param \Illuminate\Database\Eloquent\Builder $query
     * @param array $relations
     * @return \Illuminate\Database\Eloquent\Builder
     */
    function optimizeQuery($query, array $relations = [])
    {
        if (!empty($relations)) {
            $query->with($relations);
        }
        return $query;
    }
}

if (!function_exists('getMemoryUsage')) {
    /**
     * Get current memory usage
     * @return string
     */
    function getMemoryUsage()
    {
        $bytes = memory_get_usage(true);
        return formatBytes($bytes);
    }
}

if (!function_exists('switchLocale')) {
    /**
     * Switch application locale
     * @param string $locale
     * @return void
     */
    function switchLocale($locale)
    {
        if (in_array($locale, config('app.available_locales', ['en']))) {
            \App::setLocale($locale);
            session(['locale' => $locale]);
        }
    }
}

if (!function_exists('isRtlLanguage')) {
    /**
     * Check if language is right-to-left
     * @param string $locale
     * @return bool
     */
    function isRtlLanguage($locale)
    {
        $rtlLanguages = ['ar', 'he', 'fa', 'ur', 'ku', 'dv'];
        return in_array($locale, $rtlLanguages);
    }
}

if (!function_exists('translationExists')) {
    /**
     * Check if translation key exists
     * @param string $key
     * @param string|null $locale
     * @return bool
     */
    function translationExists($key, $locale = null)
    {
        $locale = $locale ?: \App::getLocale();
        return \Lang::has($key, $locale);
    }
}
