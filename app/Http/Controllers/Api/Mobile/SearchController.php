<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use App\Models\Exam;
use App\Models\Quiz;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class SearchController extends Controller
{
    /**
     * Mobile unified search (200-byte response target)
     */
    public function search(Request $request): JsonResponse
    {
        $query = $request->input('q', '');
        $type = $request->input('type', 'all'); // all, exams, quizzes, categories
        $limit = min($request->input('limit', 10), 20); // Max 20 results
        
        if (strlen($query) < 2) {
            return response()->json([
                'results' => [],
                'total' => 0,
                'message' => 'Query too short'
            ]);
        }
        
        $results = [];
        
        // Search exams
        if ($type === 'all' || $type === 'exams') {
            $exams = Exam::select('id', 'title', 'slug', 'total_questions', 'is_paid')
                ->where('is_active', true)
                ->where(function ($q) use ($query) {
                    $q->where('title', 'LIKE', "%{$query}%")
                      ->orWhere('description', 'LIKE', "%{$query}%");
                })
                ->limit($limit)
                ->get()
                ->map(function ($exam) {
                    return [
                        'type' => 'exam',
                        'id' => $exam->id,
                        'title' => $exam->title,
                        'slug' => $exam->slug,
                        'questions' => $exam->total_questions,
                        'free' => !$exam->is_paid
                    ];
                });
            
            $results = array_merge($results, $exams->toArray());
        }
        
        // Search quizzes
        if ($type === 'all' || $type === 'quizzes') {
            $quizzes = Quiz::select('id', 'title', 'slug', 'total_questions', 'is_paid')
                ->where('is_active', true)
                ->where(function ($q) use ($query) {
                    $q->where('title', 'LIKE', "%{$query}%")
                      ->orWhere('description', 'LIKE', "%{$query}%");
                })
                ->limit($limit)
                ->get()
                ->map(function ($quiz) {
                    return [
                        'type' => 'quiz',
                        'id' => $quiz->id,
                        'title' => $quiz->title,
                        'slug' => $quiz->slug,
                        'questions' => $quiz->total_questions,
                        'free' => !$quiz->is_paid
                    ];
                });
            
            $results = array_merge($results, $quizzes->toArray());
        }
        
        // Search categories
        if ($type === 'all' || $type === 'categories') {
            $categories = Category::select('id', 'name', 'slug')
                ->where('is_active', true)
                ->where('name', 'LIKE', "%{$query}%")
                ->limit($limit)
                ->get()
                ->map(function ($category) {
                    return [
                        'type' => 'category',
                        'id' => $category->id,
                        'title' => $category->name,
                        'slug' => $category->slug
                    ];
                });
            
            $results = array_merge($results, $categories->toArray());
        }
        
        // Limit total results
        $results = array_slice($results, 0, $limit);
        
        return response()->json([
            'results' => $results,
            'total' => count($results),
            'query' => $query
        ]);
    }
    
    /**
     * Mobile search suggestions (optimized)
     */
    public function suggestions(Request $request): JsonResponse
    {
        $query = $request->input('q', '');
        
        if (strlen($query) < 2) {
            return response()->json(['suggestions' => []]);
        }
        
        // Get popular exam titles
        $examSuggestions = Exam::select('title')
            ->where('is_active', true)
            ->where('title', 'LIKE', "{$query}%")
            ->orderBy('title')
            ->limit(5)
            ->pluck('title')
            ->toArray();
        
        // Get popular quiz titles
        $quizSuggestions = Quiz::select('title')
            ->where('is_active', true)
            ->where('title', 'LIKE', "{$query}%")
            ->orderBy('title')
            ->limit(5)
            ->pluck('title')
            ->toArray();
        
        // Get category names
        $categorySuggestions = Category::select('name')
            ->where('is_active', true)
            ->where('name', 'LIKE', "{$query}%")
            ->orderBy('name')
            ->limit(3)
            ->pluck('name')
            ->toArray();
        
        $allSuggestions = array_merge($examSuggestions, $quizSuggestions, $categorySuggestions);
        $uniqueSuggestions = array_unique($allSuggestions);
        $limitedSuggestions = array_slice($uniqueSuggestions, 0, 8);
        
        return response()->json([
            'suggestions' => array_values($limitedSuggestions)
        ]);
    }
    
    /**
     * Mobile popular searches (optimized)
     */
    public function popular(Request $request): JsonResponse
    {
        // This would typically come from a search analytics table
        // For now, return some popular categories and topics
        
        $popularCategories = Category::select('id', 'name', 'slug')
            ->where('is_active', true)
            ->withCount(['exams' => function ($query) {
                $query->where('is_active', true);
            }])
            ->orderBy('exams_count', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($category) {
                return [
                    'type' => 'category',
                    'id' => $category->id,
                    'title' => $category->name,
                    'slug' => $category->slug,
                    'count' => $category->exams_count
                ];
            });
        
        $popularExams = Exam::select('id', 'title', 'slug')
            ->where('is_active', true)
            ->withCount('examSessions')
            ->orderBy('exam_sessions_count', 'desc')
            ->limit(5)
            ->get()
            ->map(function ($exam) {
                return [
                    'type' => 'exam',
                    'id' => $exam->id,
                    'title' => $exam->title,
                    'slug' => $exam->slug,
                    'attempts' => $exam->exam_sessions_count
                ];
            });
        
        return response()->json([
            'popular' => [
                'categories' => $popularCategories,
                'exams' => $popularExams
            ]
        ]);
    }
    
    /**
     * Mobile filter options (optimized)
     */
    public function filters(Request $request): JsonResponse
    {
        $categories = Category::select('id', 'name')
            ->where('is_active', true)
            ->orderBy('name')
            ->get()
            ->map(function ($category) {
                return [
                    'id' => $category->id,
                    'name' => $category->name
                ];
            });
        
        return response()->json([
            'filters' => [
                'categories' => $categories,
                'types' => [
                    ['id' => 'exam', 'name' => 'Exams'],
                    ['id' => 'quiz', 'name' => 'Quizzes']
                ],
                'pricing' => [
                    ['id' => 'free', 'name' => 'Free'],
                    ['id' => 'paid', 'name' => 'Paid']
                ]
            ]
        ]);
    }
}