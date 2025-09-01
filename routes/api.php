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
Route::apiResource('categories', CategoryController::class)->only(['index', 'show'])->names('api.categories');
Route::apiResource('exams', ExamController::class)->only(['index', 'show'])->names('api.exams');
Route::apiResource('quizzes', QuizController::class)->only(['index', 'show'])->names('api.quizzes');

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
        Route::apiResource('categories', CategoryController::class)->except(['index', 'show'])->names('api.admin.categories');
    });
});

/*
|--------------------------------------------------------------------------
| API Versioning Routes
|--------------------------------------------------------------------------
*/
Route::prefix('v1')->group(function () {
    Route::apiResource('categories', CategoryController::class)->only(['index', 'show'])->names('api.v1.categories');
    Route::apiResource('exams', ExamController::class)->only(['index', 'show'])->names('api.v1.exams');
    Route::apiResource('quizzes', QuizController::class)->only(['index', 'show'])->names('api.v1.quizzes');
});

/*
|--------------------------------------------------------------------------
| Mobile API Routes (Optimized for 200-byte responses)
|--------------------------------------------------------------------------
*/
Route::prefix('mobile')->group(function () {
    // Public mobile routes
    Route::post('/auth/login', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'login']);
    Route::post('/auth/register', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'register']);
    
    // Public mobile content routes
    Route::get('/exams', [ExamController::class, 'mobileIndex']);
    Route::get('/exams/{id}', [ExamController::class, 'mobileShow']);
    Route::get('/quizzes', [QuizController::class, 'mobileIndex']);
    Route::get('/quizzes/{id}', [QuizController::class, 'mobileShow']);
    Route::get('/categories', [CategoryController::class, 'mobileIndex']);
    Route::get('/categories/{id}', [CategoryController::class, 'mobileShow']);
    
    // Public mobile search and content
    Route::get('/search', [\App\Http\Controllers\Api\Mobile\SearchController::class, 'search']);
    Route::get('/search/suggestions', [\App\Http\Controllers\Api\Mobile\SearchController::class, 'suggestions']);
    Route::get('/search/popular', [\App\Http\Controllers\Api\Mobile\SearchController::class, 'popular']);
    Route::get('/search/filters', [\App\Http\Controllers\Api\Mobile\SearchController::class, 'filters']);
    
    // Protected mobile routes
    Route::middleware(['auth:sanctum', 'mobile.api'])->group(function () {
        // Authentication
        Route::post('/auth/logout', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'logout']);
        Route::post('/auth/refresh', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'refresh']);
        Route::post('/auth/logout-all', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'logoutAll']);
        Route::get('/auth/me', [\App\Http\Controllers\Api\Mobile\AuthController::class, 'me']);
        
        // User Profile
        Route::get('/profile', [UserController::class, 'mobileProfile']);
        Route::put('/profile', [UserController::class, 'updateMobileProfile']);
        Route::get('/stats', [UserController::class, 'mobileStats']);
        Route::get('/activities', [UserController::class, 'mobileActivities']);
        
        // Mobile Dashboard
        Route::get('/dashboard/overview', [\App\Http\Controllers\Api\Mobile\DashboardController::class, 'overview']);
        Route::get('/dashboard/activity', [\App\Http\Controllers\Api\Mobile\DashboardController::class, 'recentActivity']);
        Route::get('/dashboard/progress', [\App\Http\Controllers\Api\Mobile\DashboardController::class, 'progress']);
        Route::get('/dashboard/performance', [\App\Http\Controllers\Api\Mobile\DashboardController::class, 'performance']);
        Route::get('/dashboard/achievements', [\App\Http\Controllers\Api\Mobile\DashboardController::class, 'achievements']);
        
        // Exam Sessions
        Route::post('/exams/{id}/start', [ExamController::class, 'mobileStart']);
        Route::get('/sessions/{examSession}/status', [ExamSessionController::class, 'mobileStatus']);
        Route::post('/sessions/{examSession}/answer', [ExamSessionController::class, 'mobileSubmitAnswer']);
        Route::get('/sessions/{examSession}/next', [ExamSessionController::class, 'mobileNextQuestion']);
        Route::post('/sessions/{examSession}/finish', [ExamSessionController::class, 'mobileFinish']);
        
        // Quiz Sessions
        Route::post('/quizzes/{id}/start', [QuizController::class, 'mobileStart']);
        
        // Offline Support
        Route::get('/offline/sync', [\App\Http\Controllers\Api\Mobile\OfflineController::class, 'syncData']);
        Route::get('/offline/cached', [\App\Http\Controllers\Api\Mobile\OfflineController::class, 'cachedContent']);
        Route::post('/offline/upload', [\App\Http\Controllers\Api\Mobile\OfflineController::class, 'uploadSession']);
        Route::get('/offline/storage', [\App\Http\Controllers\Api\Mobile\OfflineController::class, 'storageInfo']);
        
        // Notifications
        Route::get('/notifications', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'index']);
        Route::post('/notifications/{id}/read', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'markAsRead']);
        Route::post('/notifications/read-all', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'markAllAsRead']);
        Route::get('/notifications/unread-count', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'unreadCount']);
        Route::post('/notifications/register-device', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'registerDevice']);
        Route::put('/notifications/preferences', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'updatePreferences']);
        Route::get('/notifications/preferences', [\App\Http\Controllers\Api\Mobile\NotificationController::class, 'getPreferences']);
        
        // Settings
        Route::get('/settings/app-config', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'appConfig']);
        Route::get('/settings/user', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'getUserSettings']);
        Route::put('/settings/user', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'updateUserSettings']);
        Route::get('/settings/privacy', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'getPrivacySettings']);
        Route::put('/settings/privacy', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'updatePrivacySettings']);
        Route::post('/settings/clear-cache', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'clearCache']);
        Route::get('/settings/export-data', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'exportData']);
        Route::post('/settings/delete-account', [\App\Http\Controllers\Api\Mobile\SettingsController::class, 'deleteAccount']);
    });
});
