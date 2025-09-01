<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Hash;

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

    /**
     * Mobile-optimized user profile (200-byte response target)
     */
    public function mobileProfile(Request $request)
    {
        $user = $request->user();
        
        return response()->json([
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
                'active' => $user->is_active,
                'joined' => $user->created_at->format('Y-m-d')
            ]
        ]);
    }

    /**
     * Update mobile user profile (optimized)
     */
    public function updateMobileProfile(Request $request)
    {
        $user = $request->user();
        
        $validated = $request->validate([
            'first_name' => 'sometimes|string|max:50',
            'last_name' => 'sometimes|string|max:50',
            'email' => 'sometimes|email|unique:users,email,' . $user->id,
            'current_password' => 'required_with:password|string',
            'password' => 'sometimes|string|min:6|confirmed'
        ]);

        // Verify current password if changing password
        if (isset($validated['password'])) {
            if (!Hash::check($validated['current_password'], $user->password)) {
                return response()->json([
                    'message' => 'Current password is incorrect'
                ], 422);
            }
            $validated['password'] = Hash::make($validated['password']);
        }

        // Remove current_password from update data
        unset($validated['current_password']);
        
        $user->update($validated);
        
        return response()->json([
            'message' => 'Profile updated successfully',
            'user' => [
                'id' => $user->id,
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'role' => $user->role
            ]
        ]);
    }

    /**
     * Mobile user dashboard stats (optimized)
     */
    public function mobileStats(Request $request)
    {
        $user = $request->user();
        
        $stats = [
            'exams' => $user->examSessions()->where('status', 'completed')->count(),
            'quizzes' => $user->quizSessions()->where('status', 'completed')->count(),
            'avg_score' => round((
                $user->examSessions()->where('status', 'completed')->avg('score') +
                $user->quizSessions()->where('status', 'completed')->avg('score')
            ) / 2, 1) ?: 0,
            'passed' => (
                $user->examSessions()->where('status', 'completed')->where('is_passed', true)->count() +
                $user->quizSessions()->where('status', 'completed')->where('is_passed', true)->count()
            )
        ];
        
        return response()->json($stats);
    }

    /**
     * Mobile recent activities (optimized)
     */
    public function mobileActivities(Request $request)
    {
        $user = $request->user();
        
        $examSessions = $user->examSessions()
            ->with('exam:id,title')
            ->where('status', 'completed')
            ->select('id', 'exam_id', 'score', 'is_passed', 'completed_at')
            ->latest('completed_at')
            ->limit(5)
            ->get()
            ->map(function ($session) {
                return [
                    'type' => 'exam',
                    'title' => $session->exam->title,
                    'score' => $session->score,
                    'passed' => $session->is_passed,
                    'date' => $session->completed_at->format('M d')
                ];
            });

        $quizSessions = $user->quizSessions()
            ->with('quiz:id,title')
            ->where('status', 'completed')
            ->select('id', 'quiz_id', 'score', 'is_passed', 'completed_at')
            ->latest('completed_at')
            ->limit(5)
            ->get()
            ->map(function ($session) {
                return [
                    'type' => 'quiz',
                    'title' => $session->quiz->title,
                    'score' => $session->score,
                    'passed' => $session->is_passed,
                    'date' => $session->completed_at->format('M d')
                ];
            });

        $activities = $examSessions->concat($quizSessions)
            ->sortByDesc('date')
            ->take(10)
            ->values();

        return response()->json([
            'activities' => $activities
        ]);
    }
}
