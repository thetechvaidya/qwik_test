<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class UserController extends Controller
{
    /**
     * Get user profile
     */
    public function profile(Request $request): JsonResponse
    {
        $user = $request->user();
        $user->load(['roles', 'permissions']);

        return response()->json([
            'data' => $user,
        ]);
    }

    /**
     * Update user profile
     */
    public function updateProfile(Request $request): JsonResponse
    {
        $user = $request->user();

        $this->validate($request, [
            'name' => 'required|string|max:255',
            'email' => 'required|email|unique:users,email,' . $user->id,
            'phone' => 'nullable|string|max:20',
            'bio' => 'nullable|string|max:500',
        ]);

        $user->update($request->validated());

        return response()->json([
            'data' => $user,
            'message' => 'Profile updated successfully',
        ]);
    }

    /**
     * Get user statistics
     */
    public function statistics(Request $request): JsonResponse
    {
        $user = $request->user();

        $stats = [
            'total_exams_taken' => $user->examSessions()->count(),
            'total_quizzes_taken' => $user->quizSessions()->count(),
            'average_exam_score' => $user->examSessions()->avg('score') ?? 0,
            'average_quiz_score' => $user->quizSessions()->avg('score') ?? 0,
            'exams_passed' => $user->examSessions()->where('status', 'pass')->count(),
            'quizzes_passed' => $user->quizSessions()->where('status', 'pass')->count(),
        ];

        return response()->json([
            'data' => $stats,
        ]);
    }
}
