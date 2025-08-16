<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\ExamSession;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class ExamController extends Controller
{
    /**
     * Display a listing of exams
     */
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->get('per_page', 15);
        $search = $request->get('search');
        $categoryId = $request->get('category_id');
        $sort = $request->get('sort', 'title');
        $order = $request->get('order', 'asc');

        $query = Exam::with('category');

        if ($search) {
            $query->where('title', 'like', "%{$search}%");
        }

        if ($categoryId) {
            $query->where('category_id', $categoryId);
        }

        $query->where('is_active', true)
              ->orderBy($sort, $order);

        $exams = $query->paginate($perPage);

        return response()->json([
            'data' => $exams->items(),
            'meta' => [
                'current_page' => $exams->currentPage(),
                'last_page' => $exams->lastPage(),
                'per_page' => $exams->perPage(),
                'total' => $exams->total(),
            ],
        ]);
    }

    /**
     * Display the specified exam
     */
    public function show(Exam $exam): JsonResponse
    {
        $exam->load(['category', 'sections', 'questions']);

        return response()->json([
            'data' => $exam,
        ]);
    }

    /**
     * Start an exam session
     */
    public function startSession(Request $request, Exam $exam): JsonResponse
    {
        $user = $request->user();

        // Check if user already has an active session
        $existingSession = ExamSession::where('user_id', $user->id)
            ->where('exam_id', $exam->id)
            ->where('status', 'in_progress')
            ->first();

        if ($existingSession) {
            return response()->json([
                'data' => $existingSession,
                'message' => 'Session already exists',
            ]);
        }

        $session = ExamSession::create([
            'user_id' => $user->id,
            'exam_id' => $exam->id,
            'status' => 'in_progress',
            'started_at' => now(),
            'total_questions' => $exam->total_questions,
        ]);

        return response()->json([
            'data' => $session,
            'message' => 'Exam session started successfully',
        ], 201);
    }
}
