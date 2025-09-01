<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;
use Illuminate\Support\Facades\Cache;

class OfflineController extends Controller
{
    /**
     * Get offline sync data (essential content for mobile cache)
     */
    public function syncData(Request $request): JsonResponse
    {
        $lastSync = $request->input('last_sync'); // ISO timestamp
        $cacheKey = 'mobile_sync_' . ($lastSync ? md5($lastSync) : 'full');
        
        return Cache::remember($cacheKey, 300, function () use ($lastSync) {
            $syncTime = now()->toISOString();
            
            // Get categories (always include for offline)
            $categories = Category::select('id', 'name', 'slug', 'updated_at')
                ->where('is_active', true)
                ->when($lastSync, function ($query) use ($lastSync) {
                    $query->where('updated_at', '>', $lastSync);
                })
                ->orderBy('name')
                ->get()
                ->map(function ($category) {
                    return [
                        'id' => $category->id,
                        'name' => $category->name,
                        'slug' => $category->slug,
                        'updated' => $category->updated_at->toISOString()
                    ];
                });
            
            // Get essential exam data
            $exams = Exam::select('id', 'title', 'slug', 'sub_category_id', 'total_questions', 'total_marks', 'is_paid', 'price', 'updated_at')
                ->where('is_active', true)
                ->when($lastSync, function ($query) use ($lastSync) {
                    $query->where('updated_at', '>', $lastSync);
                })
                ->with('subCategory:id,name,category_id')
                ->orderBy('created_at', 'desc')
                ->limit(50) // Limit for mobile storage
                ->get()
                ->map(function ($exam) {
                    return [
                        'id' => $exam->id,
                        'title' => $exam->title,
                        'slug' => $exam->slug,
                        'category' => $exam->subCategory->name ?? 'General',
                        'questions' => $exam->total_questions,
                        'marks' => $exam->total_marks,
                        'free' => !$exam->is_paid,
                        'price' => $exam->price,
                        'updated' => $exam->updated_at->toISOString()
                    ];
                });
            
            // Get essential quiz data
            $quizzes = Quiz::select('id', 'title', 'slug', 'sub_category_id', 'total_questions', 'total_marks', 'is_paid', 'price', 'updated_at')
                ->where('is_active', true)
                ->when($lastSync, function ($query) use ($lastSync) {
                    $query->where('updated_at', '>', $lastSync);
                })
                ->with('subCategory:id,name,category_id')
                ->orderBy('created_at', 'desc')
                ->limit(50) // Limit for mobile storage
                ->get()
                ->map(function ($quiz) {
                    return [
                        'id' => $quiz->id,
                        'title' => $quiz->title,
                        'slug' => $quiz->slug,
                        'category' => $quiz->subCategory->name ?? 'General',
                        'questions' => $quiz->total_questions,
                        'marks' => $quiz->total_marks,
                        'free' => !$quiz->is_paid,
                        'price' => $quiz->price,
                        'updated' => $quiz->updated_at->toISOString()
                    ];
                });
            
            return [
                'sync_time' => $syncTime,
                'categories' => $categories,
                'exams' => $exams,
                'quizzes' => $quizzes,
                'total_items' => $categories->count() + $exams->count() + $quizzes->count()
            ];
        });
    }
    
    /**
     * Get cached content for offline viewing
     */
    public function cachedContent(Request $request): JsonResponse
    {
        $type = $request->input('type', 'popular'); // popular, recent, bookmarked
        $limit = min($request->input('limit', 20), 50);
        
        $cacheKey = "mobile_cached_{$type}_{$limit}";
        
        return Cache::remember($cacheKey, 600, function () use ($type, $limit) {
            $content = [];
            
            switch ($type) {
                case 'popular':
                    // Most attempted exams
                    $popularExams = Exam::select('id', 'title', 'slug', 'total_questions')
                        ->where('is_active', true)
                        ->withCount('examSessions')
                        ->orderBy('exam_sessions_count', 'desc')
                        ->limit($limit / 2)
                        ->get()
                        ->map(function ($exam) {
                            return [
                                'type' => 'exam',
                                'id' => $exam->id,
                                'title' => $exam->title,
                                'slug' => $exam->slug,
                                'questions' => $exam->total_questions,
                                'attempts' => $exam->exam_sessions_count
                            ];
                        });
                    
                    // Most attempted quizzes
                    $popularQuizzes = Quiz::select('id', 'title', 'slug', 'total_questions')
                        ->where('is_active', true)
                        ->withCount('quizSessions')
                        ->orderBy('quiz_sessions_count', 'desc')
                        ->limit($limit / 2)
                        ->get()
                        ->map(function ($quiz) {
                            return [
                                'type' => 'quiz',
                                'id' => $quiz->id,
                                'title' => $quiz->title,
                                'slug' => $quiz->slug,
                                'questions' => $quiz->total_questions,
                                'attempts' => $quiz->quiz_sessions_count
                            ];
                        });
                    
                    $content = $popularExams->concat($popularQuizzes)->take($limit);
                    break;
                    
                case 'recent':
                    // Recently added content
                    $recentExams = Exam::select('id', 'title', 'slug', 'total_questions', 'created_at')
                        ->where('is_active', true)
                        ->orderBy('created_at', 'desc')
                        ->limit($limit / 2)
                        ->get()
                        ->map(function ($exam) {
                            return [
                                'type' => 'exam',
                                'id' => $exam->id,
                                'title' => $exam->title,
                                'slug' => $exam->slug,
                                'questions' => $exam->total_questions,
                                'added' => $exam->created_at->format('M d, Y')
                            ];
                        });
                    
                    $recentQuizzes = Quiz::select('id', 'title', 'slug', 'total_questions', 'created_at')
                        ->where('is_active', true)
                        ->orderBy('created_at', 'desc')
                        ->limit($limit / 2)
                        ->get()
                        ->map(function ($quiz) {
                            return [
                                'type' => 'quiz',
                                'id' => $quiz->id,
                                'title' => $quiz->title,
                                'slug' => $quiz->slug,
                                'questions' => $quiz->total_questions,
                                'added' => $quiz->created_at->format('M d, Y')
                            ];
                        });
                    
                    $content = $recentExams->concat($recentQuizzes)
                        ->sortByDesc('added')
                        ->take($limit)
                        ->values();
                    break;
                    
                default:
                    $content = collect([]);
            }
            
            return [
                'type' => $type,
                'content' => $content,
                'total' => $content->count(),
                'cached_at' => now()->toISOString()
            ];
        });
    }
    
    /**
     * Upload offline session data (when back online)
     */
    public function uploadSession(Request $request): JsonResponse
    {
        $validated = $request->validate([
            'session_type' => 'required|in:exam,quiz',
            'session_id' => 'required|integer',
            'answers' => 'required|array',
            'answers.*.question_id' => 'required|integer',
            'answers.*.answer' => 'required|string',
            'answers.*.timestamp' => 'required|date',
            'completed_offline' => 'required|boolean',
            'offline_duration' => 'required|integer' // seconds
        ]);
        
        $user = $request->user();
        
        // Find the session
        $sessionModel = $validated['session_type'] === 'exam' ? 'examSessions' : 'quizSessions';
        $session = $user->$sessionModel()->find($validated['session_id']);
        
        if (!$session) {
            return response()->json([
                'success' => false,
                'message' => 'Session not found'
            ], 404);
        }
        
        // Process offline answers
        $processedAnswers = 0;
        foreach ($validated['answers'] as $answer) {
            // Save or update the answer
            $sessionQuestionModel = $validated['session_type'] === 'exam' ? 'examSessionQuestions' : 'quizSessionQuestions';
            
            $session->$sessionQuestionModel()->updateOrCreate(
                [
                    $validated['session_type'] . '_question_id' => $answer['question_id']
                ],
                [
                    'selected_answer' => $answer['answer'],
                    'answered_at' => $answer['timestamp']
                ]
            );
            
            $processedAnswers++;
        }
        
        // Update session if completed offline
        if ($validated['completed_offline']) {
            $session->update([
                'status' => 'completed',
                'completed_at' => now(),
                'offline_duration' => $validated['offline_duration']
            ]);
        }
        
        return response()->json([
            'success' => true,
            'processed_answers' => $processedAnswers,
            'session_updated' => $validated['completed_offline'],
            'message' => 'Offline data uploaded successfully'
        ]);
    }
    
    /**
     * Get offline storage info
     */
    public function storageInfo(Request $request): JsonResponse
    {
        $user = $request->user();
        
        // Calculate user's offline data size (approximate)
        $userSessions = $user->examSessions()->count() + $user->quizSessions()->count();
        $estimatedSize = $userSessions * 2; // KB per session (rough estimate)
        
        return response()->json([
            'storage' => [
                'used_kb' => $estimatedSize,
                'sessions' => $userSessions,
                'max_offline_items' => 100,
                'cache_duration' => '24 hours'
            ],
            'recommendations' => [
                'clear_cache' => $estimatedSize > 500, // If > 500KB
                'sync_frequency' => 'daily',
                'max_offline_sessions' => 10
            ]
        ]);
    }
}