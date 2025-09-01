<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Category;
use Illuminate\Http\Request;
use Illuminate\Http\JsonResponse;

class CategoryController extends Controller
{
    /**
     * Display a listing of categories
     */
    public function index(Request $request): JsonResponse
    {
        $perPage = $request->get('per_page', 15);
        $search = $request->get('search');

        $query = Category::query();

        if ($search) {
            $query->where('name', 'like', "%{$search}%");
        }

        $categories = $query->where('is_active', true)
            ->paginate($perPage);

        return response()->json([
            'data' => $categories->items(),
            'meta' => [
                'current_page' => $categories->currentPage(),
                'last_page' => $categories->lastPage(),
                'per_page' => $categories->perPage(),
                'total' => $categories->total(),
            ],
        ]);
    }

    /**
     * Store a newly created category
     */
    public function store(Request $request): JsonResponse
    {
        $this->validate($request, [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $category = Category::create($request->validated());

        return response()->json([
            'data' => $category,
            'message' => 'Category created successfully',
        ], 201);
    }

    /**
     * Display the specified category
     */
    public function show(Category $category): JsonResponse
    {
        return response()->json([
            'data' => $category,
        ]);
    }

    /**
     * Update the specified category
     */
    public function update(Request $request, Category $category): JsonResponse
    {
        $this->validate($request, [
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
        ]);

        $category->update($request->validated());

        return response()->json([
            'data' => $category,
            'message' => 'Category updated successfully',
        ]);
    }

    /**
     * Remove the specified category
     */
    public function destroy(Category $category): JsonResponse
    {
        $category->delete();

        return response()->json([
            'message' => 'Category deleted successfully',
        ]);
    }

    /**
     * Mobile-optimized category listing (200-byte response target)
     */
    public function mobileIndex(Request $request)
    {
        $categories = Category::select('id', 'name', 'slug')
            ->where('is_active', true)
            ->orderBy('name')
            ->get()
            ->map(function ($category) {
                return [
                    'id' => $category->id,
                    'name' => $category->name,
                    'slug' => $category->slug
                ];
            });

        return response()->json([
            'categories' => $categories,
            'total' => $categories->count()
        ]);
    }

    /**
     * Mobile category with subcategories (optimized)
     */
    public function mobileShow($id)
    {
        $category = Category::select('id', 'name', 'slug', 'description')
            ->with(['subCategories:id,name,slug,category_id'])
            ->where('is_active', true)
            ->findOrFail($id);

        return response()->json([
            'category' => [
                'id' => $category->id,
                'name' => $category->name,
                'slug' => $category->slug,
                'description' => $category->description,
                'subcategories' => $category->subCategories->map(function ($sub) {
                    return [
                        'id' => $sub->id,
                        'name' => $sub->name,
                        'slug' => $sub->slug
                    ];
                })
            ]
        ]);
    }
}
