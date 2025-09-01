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

    /**
     * Mobile-optimized quiz listing (200-byte response target)
     */
    public function mobileIndex(Request $request)
    {
        $query = Quiz::select('id', 'title', 'slug', 'sub_category_id', 'total_questions', 'total_marks', 'is_paid', 'price')
            ->where('is_active', true)
            ->with('subCategory:id,name');

        // Apply filters
        if ($request->filled('category')) {
            $query->whereHas('subCategory', function ($q) use ($request) {
                $q->where('category_id', $request->category);
            });
        }

        if ($request->filled('subcategory')) {
            $query->where('sub_category_id', $request->subcategory);
        }

        if ($request->filled('free_only')) {
            $query->where('is_paid', false);
        }

        $quizzes = $query->orderBy('created_at', 'desc')
            ->paginate(20)
            ->through(function ($quiz) {
                return [
                    'id' => $quiz->id,
                    'title' => $quiz->title,
                    'slug' => $quiz->slug,
                    'category' => $quiz->subCategory->name ?? 'General',
                    'questions' => $quiz->total_questions,
                    'marks' => $quiz->total_marks,
                    'free' => !$quiz->is_paid,
                    'price' => $quiz->price
                ];
            });

        return response()->json([
            'quizzes' => $quizzes->items(),
            'pagination' => [
                'current' => $quizzes->currentPage(),
                'total' => $quizzes->lastPage(),
                'count' => $quizzes->total()
            ]
        ]);
    }

    /**
     * Mobile quiz details (optimized)
     */
    public function mobileShow($id)
    {
        $quiz = Quiz::select('id', 'title', 'slug', 'description', 'sub_category_id', 'total_questions', 'total_marks', 'total_duration', 'is_paid', 'price')
            ->with('subCategory:id,name,category_id')
            ->where('is_active', true)
            ->findOrFail($id);

        return response()->json([
            'quiz' => [
                'id' => $quiz->id,
                'title' => $quiz->title,
                'slug' => $quiz->slug,
                'description' => $quiz->description,
                'category' => $quiz->subCategory->name ?? 'General',
                'questions' => $quiz->total_questions,
                'marks' => $quiz->total_marks,
                'duration' => $quiz->total_duration,
                'free' => !$quiz->is_paid,
                'price' => $quiz->price
            ]
        ]);
    }

    /**
     * Start mobile quiz session
     */
    public function mobileStart(Request $request, $id)
    {
        $quiz = Quiz::where('is_active', true)->findOrFail($id);
        
        // Check if user already has an active session
        $existingSession = $request->user()->quizSessions()
            ->where('quiz_id', $quiz->id)
            ->where('status', 'active')
            ->first();

        if ($existingSession) {
            return response()->json([
                'session_id' => $existingSession->id,
                'message' => 'Resuming existing session'
            ]);
        }

        // Create new session
        $session = $request->user()->quizSessions()->create([
            'quiz_id' => $quiz->id,
            'status' => 'active',
            'started_at' => now(),
            'expires_at' => now()->addMinutes($quiz->total_duration)
        ]);

        return response()->json([
            'session_id' => $session->id,
            'expires_at' => $session->expires_at->toISOString(),
            'message' => 'Quiz session started'
        ]);
    }
}
