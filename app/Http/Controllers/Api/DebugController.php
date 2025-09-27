<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\QuestionType;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class DebugController extends Controller
{
    public function __construct()
    {
        $this->middleware(['role:admin|instructor']);
    }

    /**
     * Check question types in database
     */
    public function checkQuestionTypes(): JsonResponse
    {
        try {
            $questionTypes = QuestionType::all(['id', 'name', 'code', 'is_active']);
            
            return response()->json([
                'success' => true,
                'count' => $questionTypes->count(),
                'active_count' => $questionTypes->where('is_active', true)->count(),
                'question_types' => $questionTypes,
                'message' => 'Question types retrieved successfully'
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage(),
                'message' => 'Failed to retrieve question types'
            ], 500);
        }
    }

    /**
     * Create default question types if none exist
     */
    public function createDefaultQuestionTypes(): JsonResponse
    {
        try {
            $existingCount = QuestionType::count();
            
            if ($existingCount > 0) {
                return response()->json([
                    'success' => true,
                    'created' => 0,
                    'existing' => $existingCount,
                    'message' => 'Question types already exist'
                ]);
            }

            $defaultQuestionTypes = [
                [
                    'name' => 'Multiple Single Answer',
                    'code' => 'MSA',
                    'type' => 'objective',
                    'short_description' => 'Single correct answer from multiple options',
                    'is_active' => true
                ],
                [
                    'name' => 'Multiple Multiple Answer',
                    'code' => 'MMA', 
                    'type' => 'objective',
                    'short_description' => 'Multiple correct answers from multiple options',
                    'is_active' => true
                ],
                [
                    'name' => 'True or False',
                    'code' => 'TOF',
                    'type' => 'objective',
                    'short_description' => 'True or False questions',
                    'is_active' => true
                ],
                [
                    'name' => 'Fill in the Blanks',
                    'code' => 'FIB',
                    'type' => 'subjective',
                    'short_description' => 'Fill missing words in sentences',
                    'is_active' => true
                ],
                [
                    'name' => 'Short Answer',
                    'code' => 'SAQ',
                    'type' => 'subjective', 
                    'short_description' => 'Brief written responses',
                    'is_active' => true
                ],
                [
                    'name' => 'Long Answer',
                    'code' => 'LAQ',
                    'type' => 'subjective',
                    'short_description' => 'Detailed written responses',
                    'is_active' => true
                ],
                [
                    'name' => 'Match the Following',
                    'code' => 'MTF',
                    'type' => 'objective',
                    'short_description' => 'Match items from two columns',
                    'is_active' => true
                ],
                [
                    'name' => 'Ordering',
                    'code' => 'ORD',
                    'type' => 'objective',
                    'short_description' => 'Arrange items in correct order',
                    'is_active' => true
                ]
            ];

            $created = 0;
            foreach ($defaultQuestionTypes as $questionType) {
                QuestionType::create($questionType);
                $created++;
            }

            return response()->json([
                'success' => true,
                'created' => $created,
                'message' => "Successfully created {$created} default question types"
            ]);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => $e->getMessage(),
                'message' => 'Failed to create default question types'
            ], 500);
        }
    }
}