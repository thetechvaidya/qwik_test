<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class DashboardController extends Controller
{
    /**
     * Mobile dashboard overview (200-byte response target)
     */
    public function overview(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Get basic stats
        $examCount = $user->examSessions()->where('status', 'completed')->count();
        $quizCount = $user->quizSessions()->where('status', 'completed')->count();
        $totalAttempts = $examCount + $quizCount;
        
        // Calculate average score
        $examAvg = $user->examSessions()->where('status', 'completed')->avg('score') ?? 0;
        $quizAvg = $user->quizSessions()->where('status', 'completed')->avg('score') ?? 0;
        $avgScore = $totalAttempts > 0 ? round(($examAvg + $quizAvg) / 2, 1) : 0;
        
        // Get pass count
        $examsPassed = $user->examSessions()->where('status', 'completed')->where('is_passed', true)->count();
        $quizzesPassed = $user->quizSessions()->where('status', 'completed')->where('is_passed', true)->count();
        $totalPassed = $examsPassed + $quizzesPassed;
        
        return response()->json([
            'stats' => [
                'total' => $totalAttempts,
                'passed' => $totalPassed,
                'avg_score' => $avgScore,
                'pass_rate' => $totalAttempts > 0 ? round(($totalPassed / $totalAttempts) * 100, 1) : 0
            ],
            'breakdown' => [
                'exams' => $examCount,
                'quizzes' => $quizCount
            ]
        ]);
    }

    /**
     * Mobile recent activity feed (optimized)
     */
    public function recentActivity(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Get recent exam sessions
        $recentExams = $user->examSessions()
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
                    'date' => $session->completed_at->format('M d, Y')
                ];
            });

        // Get recent quiz sessions
        $recentQuizzes = $user->quizSessions()
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
                    'date' => $session->completed_at->format('M d, Y')
                ];
            });

        // Combine and sort by date
        $activities = $recentExams->concat($recentQuizzes)
            ->sortByDesc('date')
            ->take(10)
            ->values();

        return response()->json([
            'activities' => $activities
        ]);
    }

    /**
     * Mobile progress tracking (optimized)
     */
    public function progress(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Get monthly progress (last 6 months)
        $monthlyData = [];
        for ($i = 5; $i >= 0; $i--) {
            $month = now()->subMonths($i);
            $monthStart = $month->startOfMonth()->copy();
            $monthEnd = $month->endOfMonth()->copy();
            
            $examCount = $user->examSessions()
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$monthStart, $monthEnd])
                ->count();
                
            $quizCount = $user->quizSessions()
                ->where('status', 'completed')
                ->whereBetween('completed_at', [$monthStart, $monthEnd])
                ->count();
            
            $monthlyData[] = [
                'month' => $month->format('M'),
                'exams' => $examCount,
                'quizzes' => $quizCount,
                'total' => $examCount + $quizCount
            ];
        }
        
        return response()->json([
            'monthly' => $monthlyData
        ]);
    }

    /**
     * Mobile performance analytics (optimized)
     */
    public function performance(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Get performance by category
        $categoryPerformance = $user->examSessions()
            ->with(['exam.subCategory.category:id,name'])
            ->where('status', 'completed')
            ->get()
            ->groupBy(function ($session) {
                return $session->exam->subCategory->category->name ?? 'General';
            })
            ->map(function ($sessions, $category) {
                $avgScore = $sessions->avg('score');
                $passRate = $sessions->where('is_passed', true)->count() / $sessions->count() * 100;
                
                return [
                    'category' => $category,
                    'attempts' => $sessions->count(),
                    'avg_score' => round($avgScore, 1),
                    'pass_rate' => round($passRate, 1)
                ];
            })
            ->values()
            ->take(5);
        
        return response()->json([
            'categories' => $categoryPerformance
        ]);
    }

    /**
     * Mobile achievements/badges (optimized)
     */
    public function achievements(Request $request): JsonResponse
    {
        $user = $request->user();
        
        $totalCompleted = $user->examSessions()->where('status', 'completed')->count() +
                         $user->quizSessions()->where('status', 'completed')->count();
        
        $totalPassed = $user->examSessions()->where('status', 'completed')->where('is_passed', true)->count() +
                      $user->quizSessions()->where('status', 'completed')->where('is_passed', true)->count();
        
        $perfectScores = $user->examSessions()->where('status', 'completed')->where('score', 100)->count() +
                        $user->quizSessions()->where('status', 'completed')->where('score', 100)->count();
        
        $achievements = [];
        
        // First attempt achievement
        if ($totalCompleted >= 1) {
            $achievements[] = ['name' => 'First Steps', 'desc' => 'Complete first test', 'earned' => true];
        }
        
        // 10 attempts achievement
        if ($totalCompleted >= 10) {
            $achievements[] = ['name' => 'Dedicated', 'desc' => 'Complete 10 tests', 'earned' => true];
        }
        
        // Perfect score achievement
        if ($perfectScores >= 1) {
            $achievements[] = ['name' => 'Perfect', 'desc' => 'Score 100%', 'earned' => true];
        }
        
        // High pass rate achievement
        $passRate = $totalCompleted > 0 ? ($totalPassed / $totalCompleted) * 100 : 0;
        if ($passRate >= 80 && $totalCompleted >= 5) {
            $achievements[] = ['name' => 'Consistent', 'desc' => '80% pass rate', 'earned' => true];
        }
        
        return response()->json([
            'achievements' => $achievements,
            'progress' => [
                'next_milestone' => $totalCompleted < 10 ? 10 : ($totalCompleted < 50 ? 50 : 100),
                'current' => $totalCompleted
            ]
        ]);
    }
}