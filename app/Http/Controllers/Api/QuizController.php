<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Quiz;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class QuizController extends Controller
{
    /**
     * Display a listing of quizzes
     */
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->get('per_page', 15);

        $quizzes = Quiz::with('category')
            ->where('is_active', true)
            ->paginate($perPage);

        return response()->json([
            'data' => $quizzes->items(),
            'meta' => [
                'current_page' => $quizzes->currentPage(),
                'last_page' => $quizzes->lastPage(),
                'per_page' => $quizzes->perPage(),
                'total' => $quizzes->total(),
            ],
        ]);
    }

    /**
     * Display the specified quiz
     */
    public function show(Quiz $quiz): JsonResponse
    {
        $quiz->load(['category', 'questions']);

        return response()->json([
            'data' => $quiz,
        ]);
    }
}
