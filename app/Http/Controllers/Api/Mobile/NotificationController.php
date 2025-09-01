<?php

namespace App\Http\Controllers\Api\Mobile;

use App\Http\Controllers\Controller;
use App\Http\Traits\MobileApiResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;

class NotificationController extends Controller
{
    use MobileApiResponse;

    /**
     * Get user notifications for mobile
     */
    public function index(Request $request)
    {
        $user = Auth::user();
        
        $notifications = $user->notifications()
            ->latest()
            ->paginate(20);

        $data = $notifications->map(function ($notification) {
            return [
                'id' => $notification->id,
                'type' => $notification->type,
                'title' => $notification->data['title'] ?? 'Notification',
                'message' => $notification->data['message'] ?? '',
                'data' => $notification->data,
                'read_at' => $notification->read_at,
                'created_at' => $notification->created_at->format('Y-m-d H:i:s'),
            ];
        });

        return $this->mobilePaginated($notifications->setCollection($data));
    }

    /**
     * Mark notification as read
     */
    public function markAsRead(Request $request, $id)
    {
        $user = Auth::user();
        
        $notification = $user->notifications()->find($id);
        
        if (!$notification) {
            return $this->mobileError('Notification not found', null, 404);
        }

        $notification->markAsRead();

        return $this->mobileSuccess(null, 'Notification marked as read');
    }

    /**
     * Mark all notifications as read
     */
    public function markAllAsRead(Request $request)
    {
        $user = Auth::user();
        
        $user->unreadNotifications->markAsRead();

        return $this->mobileSuccess(null, 'All notifications marked as read');
    }

    /**
     * Get unread notifications count
     */
    public function unreadCount(Request $request)
    {
        $user = Auth::user();
        
        $count = $user->unreadNotifications->count();

        return $this->mobileSuccess(['count' => $count]);
    }

    /**
     * Register device for push notifications
     */
    public function registerDevice(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'device_token' => 'required|string',
            'device_type' => 'required|in:ios,android',
            'device_id' => 'required|string',
        ]);

        if ($validator->fails()) {
            return $this->mobileValidationError($validator);
        }

        $user = Auth::user();
        
        // Store or update device token
        $user->deviceTokens()->updateOrCreate(
            ['device_id' => $request->device_id],
            [
                'device_token' => $request->device_token,
                'device_type' => $request->device_type,
                'is_active' => true,
            ]
        );

        return $this->mobileSuccess(null, 'Device registered for notifications');
    }

    /**
     * Update notification preferences
     */
    public function updatePreferences(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'exam_reminders' => 'boolean',
            'quiz_results' => 'boolean',
            'new_content' => 'boolean',
            'marketing' => 'boolean',
        ]);

        if ($validator->fails()) {
            return $this->mobileValidationError($validator);
        }

        $user = Auth::user();
        
        $preferences = $user->notificationPreferences ?? [];
        
        foreach ($request->only(['exam_reminders', 'quiz_results', 'new_content', 'marketing']) as $key => $value) {
            if ($value !== null) {
                $preferences[$key] = $value;
            }
        }
        
        $user->update(['notification_preferences' => $preferences]);

        return $this->mobileSuccess($preferences, 'Notification preferences updated');
    }

    /**
     * Get notification preferences
     */
    public function getPreferences(Request $request)
    {
        $user = Auth::user();
        
        $preferences = $user->notification_preferences ?? [
            'exam_reminders' => true,
            'quiz_results' => true,
            'new_content' => true,
            'marketing' => false,
        ];

        return $this->mobileSuccess($preferences);
    }
}