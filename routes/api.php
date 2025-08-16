<?php
/**
 * File name: api.php
 * Last modified: 19/01/21, 5:57 PM
 * Author: NearCraft - https://codecanyon.net/user/nearcraft
 * Copyright (c) 2021
 */

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\ApiController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ExamController;
use App\Http\Controllers\Api\ExamSessionController;
use App\Http\Controllers\Api\QuizController;
use App\Http\Controllers\Api\UserController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/version', [ApiController::class, 'index'])->name('api.version');

/*
|--------------------------------------------------------------------------
| Public API Routes
|--------------------------------------------------------------------------
*/
Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);
Route::apiResource('exams', ExamController::class)->only(['index', 'show']);
Route::apiResource('quizzes', QuizController::class)->only(['index', 'show']);

/*
|--------------------------------------------------------------------------
| Protected API Routes (Require Authentication)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {
    // User profile routes
    Route::get('/profile', [UserController::class, 'profile']);
    Route::put('/profile', [UserController::class, 'updateProfile']);
    Route::get('/user/statistics', [UserController::class, 'statistics']);

    // Exam session routes
    Route::post('/exams/{exam}/sessions', [ExamController::class, 'startSession']);
    Route::post('/exam-sessions/{examSession}/answers', [ExamSessionController::class, 'submitAnswer']);
    Route::post('/exam-sessions/{examSession}/finish', [ExamSessionController::class, 'finish']);

    // Admin routes
    Route::middleware('role:admin')->prefix('admin')->group(function () {
        Route::apiResource('categories', CategoryController::class)->except(['index', 'show']);
    });
});

/*
|--------------------------------------------------------------------------
| API Versioning Routes
|--------------------------------------------------------------------------
*/
Route::prefix('v1')->group(function () {
    Route::apiResource('categories', CategoryController::class)->only(['index', 'show']);
    Route::apiResource('exams', ExamController::class)->only(['index', 'show']);
    Route::apiResource('quizzes', QuizController::class)->only(['index', 'show']);
});
