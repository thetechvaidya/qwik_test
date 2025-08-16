<?php

namespace App\Services;

class QuestionParserService
{
    /**
     * Parse question content
     */
    public function parse(string $content): array
    {
        return [
            'content' => $content,
            'parsed_at' => now(),
            'parser' => 'QuestionParserService',
        ];
    }

    /**
     * Extract question metadata
     */
    public function extractMetadata(string $content): array
    {
        return [
            'word_count' => str_word_count($content),
            'character_count' => strlen($content),
            'has_images' => strpos($content, '<img') !== false,
            'has_math' => strpos($content, 'math') !== false,
        ];
    }
}
