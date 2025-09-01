<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Traits\MobileApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Cache;

class SettingsController extends Controller
{
    use MobileApiResponse;

    /**
     * Get app configuration for mobile
     */
    public function appConfig(Request $request)
    {
        $config = Cache::remember('mobile_app_config', 3600, function () {
            return [
                'app_version' => config('app.version', '1.0.0'),
                'min_supported_version' => config('mobile.min_version', '1.0.0'),
                'force_update' => config('mobile.force_update', false),
                'maintenance_mode' => config('mobile.maintenance', false),
                'features' => [
                    'offline_mode' => true,
                    'push_notifications' => true,
                    'dark_mode' => true,
                    'auto_sync' => true,
                ],
                'limits' => [
                    'max_offline_exams' => 10,
                    'max_cache_size_mb' => 100,
                    'session_timeout_minutes' => 30,
                ],
                'urls' => [
                    'privacy_policy' => config('app.url') . '/privacy',
                    'terms_of_service' => config('app.url') . '/terms',
                    'support' => config('app.url') . '/support',
                    'faq' => config('app.url') . '/faq',
                ],
            ];
        });

        return $this->mobileSuccess($config);
    }

    /**
     * Get user settings
     */
    public function getUserSettings(Request $request)
    {
        $user = Auth::user();
        
        $settings = $user->mobile_settings ?? [
            'theme' => 'light',
            'language' => 'en',
            'auto_sync' => true,
            'offline_mode' => false,
            'sound_effects' => true,
            'vibration' => true,
            'font_size' => 'medium',
        ];

        return $this->mobileSuccess($settings);
    }

    /**
     * Update user settings
     */
    public function updateUserSettings(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'theme' => 'in:light,dark,auto',
            'language' => 'string|max:5',
            'auto_sync' => 'boolean',
            'offline_mode' => 'boolean',
            'sound_effects' => 'boolean',
            'vibration' => 'boolean',
            'font_size' => 'in:small,medium,large',
        ]);

        if ($validator->fails()) {
            return $this->mobileValidationError($validator);
        }

        $user = Auth::user();
        $currentSettings = $user->mobile_settings ?? [];
        
        $newSettings = array_merge($currentSettings, $request->only([
            'theme', 'language', 'auto_sync', 'offline_mode', 
            'sound_effects', 'vibration', 'font_size'
        ]));
        
        $user->update(['mobile_settings' => $newSettings]);

        return $this->mobileSuccess($newSettings, 'Settings updated successfully');
    }

    /**
     * Get privacy settings
     */
    public function getPrivacySettings(Request $request)
    {
        $user = Auth::user();
        
        $privacy = $user->privacy_settings ?? [
            'profile_visibility' => 'public',
            'show_progress' => true,
            'show_achievements' => true,
            'allow_friend_requests' => true,
            'data_collection' => true,
            'analytics_tracking' => true,
        ];

        return $this->mobileSuccess($privacy);
    }

    /**
     * Update privacy settings
     */
    public function updatePrivacySettings(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'profile_visibility' => 'in:public,private,friends',
            'show_progress' => 'boolean',
            'show_achievements' => 'boolean',
            'allow_friend_requests' => 'boolean',
            'data_collection' => 'boolean',
            'analytics_tracking' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->mobileValidationError($validator);
        }

        $user = Auth::user();
        $currentPrivacy = $user->privacy_settings ?? [];
        
        $newPrivacy = array_merge($currentPrivacy, $request->only([
            'profile_visibility', 'show_progress', 'show_achievements',
            'allow_friend_requests', 'data_collection', 'analytics_tracking'
        ]));
        
        $user->update(['privacy_settings' => $newPrivacy]);

        return $this->mobileSuccess($newPrivacy, 'Privacy settings updated');
    }

    /**
     * Clear app cache
     */
    public function clearCache(Request $request)
    {
        $user = Auth::user();
        
        // Clear user-specific cache
        Cache::forget("user_stats_{$user->id}");
        Cache::forget("user_progress_{$user->id}");
        Cache::forget("user_activities_{$user->id}");
        
        return $this->mobileSuccess(null, 'Cache cleared successfully');
    }

    /**
     * Export user data
     */
    public function exportData(Request $request)
    {
        $user = Auth::user();
        
        $data = [
            'profile' => [
                'name' => $user->first_name . ' ' . $user->last_name,
                'email' => $user->email,
                'created_at' => $user->created_at,
            ],
            'exam_sessions' => $user->examSessions()->count(),
            'quiz_sessions' => $user->quizSessions()->count(),
            'settings' => $user->mobile_settings,
            'privacy' => $user->privacy_settings,
            'exported_at' => now(),
        ];

        return $this->mobileSuccess($data, 'Data exported successfully');
    }

    /**
     * Delete account request
     */
    public function deleteAccount(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'password' => 'required|string',
            'reason' => 'nullable|string|max:500',
        ]);

        if ($validator->fails()) {
            return $this->mobileValidationError($validator);
        }

        $user = Auth::user();
        
        if (!Hash::check($request->password, $user->password)) {
            return $this->mobileError('Invalid password', null, 401);
        }

        // Create deletion request (implement soft delete or queue for review)
        $user->update([
            'deletion_requested_at' => now(),
            'deletion_reason' => $request->reason,
        ]);

        return $this->mobileSuccess(null, 'Account deletion requested. You will receive confirmation within 24 hours.');
    }
}