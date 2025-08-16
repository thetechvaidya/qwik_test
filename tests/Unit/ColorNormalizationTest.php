<?php

namespace Tests\Unit;

use PHPUnit\Framework\TestCase;

/**
 * Tests for color value normalization logic
 * Mirrors the JavaScript implementation in ThemeSettingsForm.vue
 * 
 * @covers \App\Services\ColorNormalizationService (if extracted to service)
 */
class ColorNormalizationTest extends TestCase
{
    /**
     * PHP implementation mirroring the JavaScript normalizeColorValue method
     * Used for testing consistency between frontend and backend validation
     */
    private function normalizeColorValue($color)
    {
        if (empty($color) || !is_string($color)) {
            return '000000'; // Default fallback
        }
        
        // Remove all # prefixes and whitespace
        $normalized = strtolower(trim(preg_replace('/#+/', '', $color)));
        
        // Validate hex characters only
        if (!preg_match('/^[0-9a-f]*$/', $normalized)) {
            return '000000'; // Invalid characters fallback
        }
        
        // Handle different hex lengths
        if (strlen($normalized) === 3) {
            // Expand 3-digit to 6-digit: abc -> aabbcc
            $expanded = '';
            for ($i = 0; $i < 3; $i++) {
                $expanded .= $normalized[$i] . $normalized[$i];
            }
            $normalized = $expanded;
        } elseif (strlen($normalized) === 8) {
            // Remove alpha channel from 8-digit: aarrggbb -> rrggbb
            $normalized = substr($normalized, 2);
        } elseif (strlen($normalized) !== 6) {
            // Invalid length fallback
            return '000000';
        }
        
        return $normalized;
    }

    /**
     * PHP implementation mirroring the JavaScript ensureHashPrefix method
     */
    private function ensureHashPrefix($color)
    {
        if (empty($color)) {
            return '#000000';
        }
        return str_starts_with($color, '#') ? $color : "#$color";
    }

    /** @test */
    public function it_normalizes_valid_6_digit_hex_colors()
    {
        $this->assertEquals('ff0000', $this->normalizeColorValue('#ff0000'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('ff0000'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('#FF0000'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('FF0000'));
    }

    /** @test */
    public function it_expands_3_digit_hex_colors()
    {
        $this->assertEquals('ff0000', $this->normalizeColorValue('#f00'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('f00'));
        $this->assertEquals('aabbcc', $this->normalizeColorValue('#abc'));
        $this->assertEquals('aabbcc', $this->normalizeColorValue('abc'));
        $this->assertEquals('ffffff', $this->normalizeColorValue('#FFF'));
    }

    /** @test */
    public function it_removes_alpha_channel_from_8_digit_hex_colors()
    {
        $this->assertEquals('ff0000', $this->normalizeColorValue('#ffff0000'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('ffff0000'));
        $this->assertEquals('00ff00', $this->normalizeColorValue('#8000ff00'));
        $this->assertEquals('0000ff', $this->normalizeColorValue('ff0000ff'));
    }

    /** @test */
    public function it_handles_multiple_hash_prefixes()
    {
        $this->assertEquals('ff0000', $this->normalizeColorValue('##ff0000'));
        $this->assertEquals('ff0000', $this->normalizeColorValue('###ff0000'));
        $this->assertEquals('aabbcc', $this->normalizeColorValue('##abc'));
    }

    /** @test */
    public function it_returns_default_for_invalid_inputs()
    {
        // Null and empty values
        $this->assertEquals('000000', $this->normalizeColorValue(null));
        $this->assertEquals('000000', $this->normalizeColorValue(''));
        $this->assertEquals('000000', $this->normalizeColorValue('   '));
        
        // Non-string values (simulating JavaScript behavior)
        $this->assertEquals('000000', $this->normalizeColorValue(123));
        $this->assertEquals('000000', $this->normalizeColorValue([]));
        $this->assertEquals('000000', $this->normalizeColorValue(true));
    }

    /** @test */
    public function it_returns_default_for_invalid_hex_characters()
    {
        $this->assertEquals('000000', $this->normalizeColorValue('gghhii'));
        $this->assertEquals('000000', $this->normalizeColorValue('#xyz123'));
        $this->assertEquals('000000', $this->normalizeColorValue('ff00zz'));
        $this->assertEquals('000000', $this->normalizeColorValue('rgb(255,0,0)'));
        $this->assertEquals('000000', $this->normalizeColorValue('red'));
    }

    /** @test */
    public function it_returns_default_for_invalid_hex_lengths()
    {
        $this->assertEquals('000000', $this->normalizeColorValue('f'));         // 1 digit
        $this->assertEquals('000000', $this->normalizeColorValue('ff'));        // 2 digits
        $this->assertEquals('000000', $this->normalizeColorValue('ffff'));      // 4 digits
        $this->assertEquals('000000', $this->normalizeColorValue('fffff'));     // 5 digits
        $this->assertEquals('000000', $this->normalizeColorValue('fffffff'));   // 7 digits
        $this->assertEquals('000000', $this->normalizeColorValue('fffffffff')); // 9 digits
    }

    /** @test */
    public function it_handles_whitespace_correctly()
    {
        $this->assertEquals('ff0000', $this->normalizeColorValue('  ff0000  '));
        $this->assertEquals('ff0000', $this->normalizeColorValue("\t#ff0000\n"));
        $this->assertEquals('aabbcc', $this->normalizeColorValue('  abc  '));
        $this->assertEquals('ff0000', $this->normalizeColorValue('  ##ff0000  '));
    }

    /** @test */
    public function it_ensures_hash_prefix_correctly()
    {
        // With existing hash
        $this->assertEquals('#ff0000', $this->ensureHashPrefix('#ff0000'));
        $this->assertEquals('#abc123', $this->ensureHashPrefix('#abc123'));
        
        // Without hash
        $this->assertEquals('#ff0000', $this->ensureHashPrefix('ff0000'));
        $this->assertEquals('#abc123', $this->ensureHashPrefix('abc123'));
        
        // Empty values
        $this->assertEquals('#000000', $this->ensureHashPrefix(''));
        $this->assertEquals('#000000', $this->ensureHashPrefix(null));
    }

    /** @test */
    public function it_maintains_consistency_between_normalize_and_prefix_methods()
    {
        $testColors = ['#ff0000', 'abc', '##123456', 'AABBCC'];
        
        foreach ($testColors as $color) {
            $normalized = $this->normalizeColorValue($color);
            $withPrefix = $this->ensureHashPrefix($normalized);
            
            // Normalized should always be 6 characters
            $this->assertEquals(6, strlen($normalized));
            // With prefix should always start with #
            $this->assertStringStartsWith('#', $withPrefix);
            // Should be valid hex after normalization
            $this->assertMatchesRegularExpression('/^[0-9a-f]{6}$/', $normalized);
        }
    }

    /** @test */
    public function it_provides_comprehensive_edge_case_coverage()
    {
        // Test cases that could break the normalization
        $edgeCases = [
            ['input' => '#000', 'expected' => '000000'],          // Black (3-digit)
            ['input' => '#FFF', 'expected' => 'ffffff'],          // White (3-digit, uppercase)
            ['input' => '##000000', 'expected' => '000000'],      // Multiple prefixes
            ['input' => 'FF000000', 'expected' => '000000'],      // 8-digit (alpha removal)
            ['input' => '80FF0000', 'expected' => 'ff0000'],      // 8-digit with alpha
            ['input' => '  #abc  ', 'expected' => 'aabbcc'],      // Whitespace + 3-digit
            ['input' => null, 'expected' => '000000'],            // Null input
            ['input' => '', 'expected' => '000000'],              // Empty string
            ['input' => 'invalid', 'expected' => '000000'],       // Invalid characters
            ['input' => '1234567', 'expected' => '000000'],       // Invalid length
        ];

        foreach ($edgeCases as $case) {
            $result = $this->normalizeColorValue($case['input']);
            $this->assertEquals(
                $case['expected'], 
                $result,
                "Failed normalizing '{$case['input']}'. Expected '{$case['expected']}', got '$result'"
            );
        }
    }
}
