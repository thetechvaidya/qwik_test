<?php
/**
 * File name: SyllabusTrait.php
 * Last modified: 02/02/22, 4:08 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2022
 */

namespace App\Traits;

use App\Models\SubCategory;
use Illuminate\Database\Eloquent\ModelNotFoundException;
use Illuminate\Support\Facades\Cookie;

trait SyllabusTrait
{
    /**
     * Get user selected syllabus
     *
     */
    public function selectedSyllabus()
    {
        $categoryId = Cookie::get('category_id');

        if ($categoryId) {
            $category = SubCategory::find($categoryId);
            if ($category) {
                return $category;
            }
        }

        $defaultCategory = SubCategory::active()
            ->has('sections')
            ->orderBy('name')
            ->first();

        if ($defaultCategory) {
            Cookie::queue('category_id', $defaultCategory->id, 60 * 24 * 30);
            Cookie::queue('category_name', $defaultCategory->name, 60 * 24 * 30);

            return $defaultCategory;
        }

        throw new ModelNotFoundException('No active syllabus available.');
    }
}
