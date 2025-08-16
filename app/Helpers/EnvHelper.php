<?php

namespace App\Helpers;

use Illuminate\Support\Facades\File;

class EnvHelper
{
    protected $envPath;
    protected $envContent;

    public function __construct()
    {
        $this->envPath = base_path('.env');
        $this->load();
    }

    /**
     * Load the .env file content
     *
     * @return $this
     */
    public function load()
    {
        if (File::exists($this->envPath)) {
            $this->envContent = File::get($this->envPath);
        } else {
            $this->envContent = '';
        }

        return $this;
    }

    /**
     * Set a key-value pair in the .env file
     *
     * @param string $key
     * @param string $value
     * @return $this
     */
    public function setKey($key, $value)
    {
        $value = $this->formatValue($value);
        $keyPattern = "/^{$key}=.*/m";

        if (preg_match($keyPattern, $this->envContent)) {
            // Key exists, update it
            $this->envContent = preg_replace($keyPattern, "{$key}={$value}", $this->envContent);
        } else {
            // Key doesn't exist, append it
            $this->envContent .= "\n{$key}={$value}";
        }

        return $this;
    }

    /**
     * Save the changes to the .env file
     *
     * @return bool
     */
    public function save()
    {
        return File::put($this->envPath, $this->envContent) !== false;
    }

    /**
     * Format the value for the .env file
     *
     * @param mixed $value
     * @return string
     */
    protected function formatValue($value)
    {
        if (is_bool($value)) {
            return $value ? 'true' : 'false';
        }

        if (is_null($value)) {
            return 'null';
        }

        $value = (string) $value;

        // Quote the value if it contains spaces or special characters
        if (preg_match('/\s/', $value) || str_contains($value, '"') || str_contains($value, "'")) {
            $value = '"' . str_replace('"', '\"', $value) . '"';
        }

        return $value;
    }

    /**
     * Get a value from the .env file
     *
     * @param string $key
     * @return string|null
     */
    public function getValue($key)
    {
        $pattern = "/^{$key}=(.*)$/m";
        if (preg_match($pattern, $this->envContent, $matches)) {
            return trim($matches[1], '"\'');
        }

        return null;
    }

    /**
     * Static method to create an instance and load
     *
     * @return static
     */
    public static function create()
    {
        return new static();
    }
}
