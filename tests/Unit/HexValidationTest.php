<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

/**
 * Unit tests for hex color validation and normalization
 * Testing scenarios referenced in Comment 1 verification
 */
class HexValidationTest extends TestCase
{
    /**
     * Test the JavaScript hex validation logic by simulating the normalization
     * This mirrors the normalizeHex function in resources/js/app.js
     */
    private function normalizeHex($hex)
    {
        if (!$hex) return null;
        
        // Remove single # prefix if present (but not multiple ##)
        $cleaned = strval($hex);
        if (substr($cleaned, 0, 1) === '#') {
            $cleaned = substr($cleaned, 1);
        }
        
        // Check for invalid patterns like starting with multiple #
        if (strpos($cleaned, '#') !== false) {
            return null; // Invalid if # appears in the middle or multiple #
        }
        
        // Validate hex characters only
        if (!preg_match('/^[0-9a-fA-F]+$/', $cleaned)) {
            return null;
        }
        
        // Handle different hex lengths
        switch (strlen($cleaned)) {
            case 3:
                // Convert #abc to #aabbcc
                return strtolower(str_repeat($cleaned[0], 2) . 
                       str_repeat($cleaned[1], 2) . 
                       str_repeat($cleaned[2], 2));
            case 6:
                // Standard 6-digit hex
                return strtolower($cleaned);
            case 8:
                // 8-digit hex with alpha, extract RGB part
                return strtolower(substr($cleaned, 0, 6));
            default:
                // Invalid length
                return null;
        }
    }

    /**
     * Test 3-digit hex normalization: #abc -> #aabbcc
     */
    public function test_three_digit_hex_normalization()
    {
        $this->assertEquals('aabbcc', $this->normalizeHex('#abc'));
        $this->assertEquals('aabbcc', $this->normalizeHex('abc'));
        $this->assertEquals('112233', $this->normalizeHex('123'));
        $this->assertEquals('ffffff', $this->normalizeHex('fff'));
        $this->assertEquals('000000', $this->normalizeHex('000'));
    }

    /**
     * Test 6-digit hex validation and passthrough
     */
    public function test_six_digit_hex_validation()
    {
        $this->assertEquals('aabbcc', $this->normalizeHex('#aabbcc'));
        $this->assertEquals('aabbcc', $this->normalizeHex('aabbcc'));
        $this->assertEquals('123456', $this->normalizeHex('123456'));
        $this->assertEquals('ffffff', $this->normalizeHex('ffffff'));
        $this->assertEquals('000000', $this->normalizeHex('000000'));
        $this->assertEquals('05887d', $this->normalizeHex('05887d'));
        $this->assertEquals('8d4aa5', $this->normalizeHex('8d4aa5'));
    }

    /**
     * Test 8-digit hex with alpha channel extraction
     */
    public function test_eight_digit_hex_alpha_extraction()
    {
        $this->assertEquals('aabbcc', $this->normalizeHex('#aabbccdd'));
        $this->assertEquals('aabbcc', $this->normalizeHex('aabbccdd'));
        $this->assertEquals('123456', $this->normalizeHex('12345678'));
        $this->assertEquals('ffffff', $this->normalizeHex('ffffff00'));
        $this->assertEquals('000000', $this->normalizeHex('000000ff'));
    }

    /**
     * Test invalid hex strings return null
     */
    public function test_invalid_hex_strings()
    {
        // Invalid characters
        $this->assertNull($this->normalizeHex('ghijkl'));
        $this->assertNull($this->normalizeHex('#gghhii'));
        $this->assertNull($this->normalizeHex('12x456'));
        $this->assertNull($this->normalizeHex('abc!@#'));
        
        // Invalid lengths
        $this->assertNull($this->normalizeHex('a'));      // too short
        $this->assertNull($this->normalizeHex('ab'));     // too short
        $this->assertNull($this->normalizeHex('abcd'));   // invalid length
        $this->assertNull($this->normalizeHex('abcde'));  // invalid length
        $this->assertNull($this->normalizeHex('abcdefg')); // invalid length (7 chars)
        $this->assertNull($this->normalizeHex('abcdefghi')); // too long (9 chars)
        
        // Edge cases
        $this->assertNull($this->normalizeHex(''));
        $this->assertNull($this->normalizeHex(null));
        $this->assertNull($this->normalizeHex('#'));
        $this->assertNull($this->normalizeHex('##abc'));
    }

    /**
     * Test case insensitivity
     */
    public function test_case_insensitivity()
    {
        $this->assertEquals('aabbcc', $this->normalizeHex('AABBCC'));
        $this->assertEquals('aabbcc', $this->normalizeHex('#AABBCC'));
        $this->assertEquals('aabbcc', $this->normalizeHex('AaBbCc'));
        $this->assertEquals('aabbcc', $this->normalizeHex('ABC'));
        $this->assertEquals('def123', $this->normalizeHex('DEF123'));
    }

    /**
     * Test fallback values are used for invalid inputs
     */
    public function test_fallback_handling()
    {
        // Test that invalid inputs would result in fallback values
        $invalidInputs = ['invalid', 'xyz123', '##bad##', '', null, 'toolong123456789'];
        
        foreach ($invalidInputs as $input) {
            $result = $this->normalizeHex($input);
            // Debug: echo the failing input
            if ($result !== null) {
                echo "Input: " . var_export($input, true) . " returned: " . var_export($result, true) . " instead of null\n";
            }
            $this->assertNull($result, "Input '$input' should be invalid");
        }
    }

    /**
     * Test real-world color values used in the application
     */
    public function test_application_color_values()
    {
        // Default application colors
        $this->assertEquals('05887d', $this->normalizeHex('05887d'));
        $this->assertEquals('8d4aa5', $this->normalizeHex('8d4aa5'));
        
        // Common theme colors
        $this->assertEquals('007bff', $this->normalizeHex('#007bff')); // Bootstrap blue
        $this->assertEquals('28a745', $this->normalizeHex('#28a745')); // Bootstrap green
        $this->assertEquals('dc3545', $this->normalizeHex('#dc3545')); // Bootstrap red
        $this->assertEquals('6c757d', $this->normalizeHex('#6c757d')); // Bootstrap gray
    }

    /**
     * Test edge cases for color manipulation functions
     */
    public function test_color_manipulation_inputs()
    {
        // Colors that might cause issues in shade generation
        $this->assertEquals('000000', $this->normalizeHex('000')); // Pure black
        $this->assertEquals('ffffff', $this->normalizeHex('fff')); // Pure white
        $this->assertEquals('ff0000', $this->normalizeHex('f00')); // Pure red
        $this->assertEquals('00ff00', $this->normalizeHex('0f0')); // Pure green
        $this->assertEquals('0000ff', $this->normalizeHex('00f')); // Pure blue
    }
}
