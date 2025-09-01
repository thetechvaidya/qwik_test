# Mobile API Documentation

## Overview

This document provides comprehensive documentation for the Mobile API endpoints designed specifically for mobile applications. All mobile API endpoints are prefixed with `/api/mobile/` and are optimized for mobile performance with lightweight responses and efficient data structures.

## Base URL
```
https://your-domain.com/api/mobile/
```

## Authentication

The Mobile API uses Laravel Sanctum for authentication. Most endpoints require a Bearer token in the Authorization header.

### Headers
```
Authorization: Bearer {your-token}
Content-Type: application/json
Accept: application/json
```

## Rate Limiting

- **Mobile API**: 120 requests per minute
- **Authentication endpoints**: Standard rate limiting applies

---

## Authentication Endpoints

### POST /auth/login
Authenticate user and receive access token.

**Request Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "remember_me": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "user": {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "email": "user@example.com"
    },
    "token": "1|abc123...",
    "expires_at": "2024-01-15T10:30:00Z"
  }
}
```

### POST /auth/register
Register a new user account.

**Request Body:**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "email": "user@example.com",
  "password": "password123",
  "password_confirmation": "password123",
  "terms_accepted": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "user": {
      "id": 1,
      "first_name": "John",
      "last_name": "Doe",
      "email": "user@example.com"
    },
    "token": "1|abc123..."
  }
}
```

### POST /auth/logout
Logout current session.

**Response:**
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

### POST /auth/refresh
Refresh authentication token.

**Response:**
```json
{
  "success": true,
  "message": "Token refreshed",
  "data": {
    "token": "2|def456...",
    "expires_at": "2024-01-15T10:30:00Z"
  }
}
```

### GET /auth/me
Get current authenticated user information.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "full_name": "John Doe",
    "email": "user@example.com",
    "avatar": "https://example.com/avatar.jpg"
  }
}
```

---

## Content Endpoints

### GET /exams
Get list of available exams (mobile-optimized).

**Query Parameters:**
- `page` (int): Page number (default: 1)
- `per_page` (int): Items per page (default: 15, max: 50)
- `category_id` (int): Filter by category
- `difficulty` (string): Filter by difficulty (easy, medium, hard)
- `is_free` (boolean): Filter free/paid exams

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "title": "JavaScript Fundamentals",
      "description": "Learn the basics of JavaScript programming...",
      "duration": 60,
      "total_questions": 25,
      "difficulty": "medium",
      "category": {
        "id": 1,
        "name": "Programming"
      },
      "is_free": true,
      "price": null,
      "passing_score": 70
    }
  ],
  "pagination": {
    "current_page": 1,
    "last_page": 5,
    "per_page": 15,
    "total": 75,
    "has_more": true
  }
}
```

### GET /exams/{id}
Get detailed exam information.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "title": "JavaScript Fundamentals",
    "description": "Complete description of the exam...",
    "duration": 60,
    "total_questions": 25,
    "difficulty": "medium",
    "category": {
      "id": 1,
      "name": "Programming"
    },
    "is_free": true,
    "price": null,
    "passing_score": 70,
    "attempts_allowed": 3,
    "is_active": true
  }
}
```

### GET /quizzes
Get list of available quizzes (mobile-optimized).

**Query Parameters:** Same as exams endpoint

**Response:** Similar structure to exams endpoint

### GET /categories
Get list of categories (mobile-optimized).

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Programming",
      "description": "Programming related content",
      "exams_count": 15,
      "quizzes_count": 8
    }
  ]
}
```

---

## User Profile Endpoints

### GET /profile
Get user profile information.

**Response:**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "first_name": "John",
    "last_name": "Doe",
    "full_name": "John Doe",
    "email": "user@example.com",
    "avatar": "https://example.com/avatar.jpg",
    "phone": "+1234567890",
    "date_of_birth": "1990-01-01",
    "gender": "male",
    "country": "USA",
    "city": "New York"
  }
}
```

### PUT /profile
Update user profile.

**Request Body:**
```json
{
  "first_name": "John",
  "last_name": "Doe",
  "phone": "+1234567890",
  "date_of_birth": "1990-01-01",
  "gender": "male",
  "country": "USA",
  "city": "New York"
}
```

### GET /stats
Get user statistics.

**Response:**
```json
{
  "success": true,
  "data": {
    "total_exams": 15,
    "total_quizzes": 8,
    "avg_exam_score": 85.5,
    "avg_quiz_score": 92.3,
    "passed_exams": 12,
    "passed_quizzes": 7
  }
}
```

### GET /activities
Get user recent activities.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "type": "exam_completed",
      "title": "JavaScript Fundamentals",
      "score": 85,
      "status": "passed",
      "completed_at": "2024-01-10T14:30:00Z"
    }
  ]
}
```

---

## Dashboard Endpoints

### GET /dashboard/overview
Get dashboard overview with key metrics.

**Response:**
```json
{
  "success": true,
  "data": {
    "stats": {
      "total_exams": 15,
      "total_quizzes": 8,
      "avg_score": 87.5,
      "pass_rate": 85
    },
    "recent_activity": [
      {
        "type": "exam_completed",
        "title": "JavaScript Fundamentals",
        "score": 85,
        "date": "2024-01-10"
      }
    ]
  }
}
```

### GET /dashboard/progress
Get monthly progress data.

**Response:**
```json
{
  "success": true,
  "data": {
    "monthly_data": [
      {
        "month": "2024-01",
        "exams_taken": 5,
        "avg_score": 85.2,
        "pass_rate": 80
      }
    ]
  }
}
```

---

## Exam Session Endpoints

### POST /exams/{id}/start
Start a new exam session.

**Request Body:**
```json
{
  "device_id": "device123",
  "offline_mode": false,
  "time_zone": "America/New_York"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "session_id": 123,
    "exam_id": 1,
    "started_at": "2024-01-10T14:00:00Z",
    "expires_at": "2024-01-10T15:00:00Z",
    "current_question": 1,
    "total_questions": 25
  }
}
```

### GET /sessions/{sessionId}/status
Get current session status.

**Response:**
```json
{
  "success": true,
  "data": {
    "session_id": 123,
    "status": "in_progress",
    "current_question": 5,
    "total_questions": 25,
    "answered_questions": 4,
    "time_remaining": 3420,
    "can_finish": false
  }
}
```

### POST /sessions/{sessionId}/answer
Submit answer for current question.

**Request Body:**
```json
{
  "question_id": 1,
  "answer": "option_a",
  "time_spent": 45,
  "is_flagged": false
}
```

**Response:**
```json
{
  "success": true,
  "message": "Answer submitted successfully",
  "data": {
    "next_question": 2,
    "progress": 20
  }
}
```

### GET /sessions/{sessionId}/next
Get next question in the session.

**Response:**
```json
{
  "success": true,
  "data": {
    "question_id": 2,
    "question_text": "What is the output of console.log(typeof null)?",
    "options": [
      {"key": "a", "text": "null"},
      {"key": "b", "text": "object"},
      {"key": "c", "text": "undefined"},
      {"key": "d", "text": "string"}
    ],
    "question_number": 2,
    "total_questions": 25
  }
}
```

### POST /sessions/{sessionId}/finish
Finish the exam session.

**Response:**
```json
{
  "success": true,
  "data": {
    "session_id": 123,
    "score": 85,
    "percentage": 85,
    "status": "passed",
    "correct_answers": 21,
    "total_questions": 25,
    "time_taken": 2340,
    "completed_at": "2024-01-10T14:39:00Z"
  }
}
```

---

## Search Endpoints

### GET /search
Unified search across exams, quizzes, and categories.

**Query Parameters:**
- `q` (string): Search query
- `type` (string): Filter by type (exam, quiz, category)
- `category_id` (int): Filter by category
- `limit` (int): Number of results (default: 10, max: 20)

**Response:**
```json
{
  "success": true,
  "data": {
    "exams": [
      {
        "id": 1,
        "title": "JavaScript Fundamentals",
        "type": "exam",
        "category": "Programming"
      }
    ],
    "quizzes": [],
    "categories": []
  }
}
```

### GET /search/suggestions
Get search suggestions.

**Query Parameters:**
- `q` (string): Partial search query

**Response:**
```json
{
  "success": true,
  "data": [
    "JavaScript",
    "Java Programming",
    "JavaScript Advanced"
  ]
}
```

---

## Notifications Endpoints

### GET /notifications
Get user notifications.

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": "uuid-123",
      "type": "exam_reminder",
      "title": "Exam Reminder",
      "message": "Your JavaScript exam starts in 1 hour",
      "read_at": null,
      "created_at": "2024-01-10T13:00:00Z"
    }
  ]
}
```

### POST /notifications/register-device
Register device for push notifications.

**Request Body:**
```json
{
  "device_token": "fcm_token_here",
  "device_type": "android",
  "device_id": "unique_device_id"
}
```

---

## Settings Endpoints

### GET /settings/app-config
Get app configuration.

**Response:**
```json
{
  "success": true,
  "data": {
    "app_version": "1.0.0",
    "min_supported_version": "1.0.0",
    "force_update": false,
    "maintenance_mode": false,
    "features": {
      "offline_mode": true,
      "push_notifications": true
    },
    "limits": {
      "max_offline_exams": 10,
      "max_cache_size_mb": 100,
      "session_timeout_minutes": 30
    }
  }
}
```

### GET /settings/user
Get user settings.

**Response:**
```json
{
  "success": true,
  "data": {
    "theme": "light",
    "language": "en",
    "auto_sync": true,
    "offline_mode": false,
    "sound_effects": true,
    "vibration": true,
    "font_size": "medium"
  }
}
```

---

## Offline Support Endpoints

### GET /offline/sync
Sync data for offline use.

**Query Parameters:**
- `last_sync` (datetime): Last sync timestamp

**Response:**
```json
{
  "success": true,
  "data": {
    "exams": [],
    "categories": [],
    "user_progress": {},
    "sync_timestamp": "2024-01-10T14:00:00Z"
  }
}
```

### POST /offline/upload
Upload offline session data.

**Request Body:**
```json
{
  "sessions": [
    {
      "exam_id": 1,
      "answers": [
        {"question_id": 1, "answer": "a", "time_spent": 30}
      ],
      "completed_at": "2024-01-10T14:30:00Z",
      "offline_session_id": "local_123"
    }
  ]
}
```

---

## Error Responses

All endpoints return consistent error responses:

```json
{
  "success": false,
  "message": "Error description",
  "errors": {
    "field_name": ["Validation error message"]
  }
}
```

### Common HTTP Status Codes
- `200` - Success
- `201` - Created
- `400` - Bad Request
- `401` - Unauthorized
- `403` - Forbidden
- `404` - Not Found
- `422` - Validation Error
- `429` - Too Many Requests
- `500` - Internal Server Error

---

## Mobile-Specific Features

### Response Optimization
- Lightweight JSON responses optimized for mobile bandwidth
- Compressed data structures with essential fields only
- Pagination with `has_more` indicators for infinite scrolling

### Caching Headers
- `Cache-Control` headers for optimal caching
- `X-Mobile-API` header for mobile-specific responses
- `X-Device-Type` header for device detection

### Rate Limiting
- Mobile-optimized rate limits (120 requests/minute)
- Graceful degradation when limits are exceeded

### Offline Support
- Data synchronization endpoints
- Offline session upload capabilities
- Cached content management

---

## SDK Integration Examples

### JavaScript/React Native
```javascript
// Authentication
const login = async (email, password) => {
  const response = await fetch('/api/mobile/auth/login', {
    method: 'POST',
    headers: {
      'Content-Type': 'application/json',
    },
    body: JSON.stringify({ email, password })
  });
  return response.json();
};

// Get exams
const getExams = async (token, page = 1) => {
  const response = await fetch(`/api/mobile/exams?page=${page}`, {
    headers: {
      'Authorization': `Bearer ${token}`,
      'Accept': 'application/json'
    }
  });
  return response.json();
};
```

### Flutter/Dart
```dart
// Authentication
Future<Map<String, dynamic>> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('/api/mobile/auth/login'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'email': email, 'password': password}),
  );
  return jsonDecode(response.body);
}

// Get exams
Future<Map<String, dynamic>> getExams(String token, {int page = 1}) async {
  final response = await http.get(
    Uri.parse('/api/mobile/exams?page=$page'),
    headers: {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json'
    },
  );
  return jsonDecode(response.body);
}
```

---

## Testing

Use tools like Postman, Insomnia, or curl to test the API endpoints:

```bash
# Login
curl -X POST "/api/mobile/auth/login" \
  -H "Content-Type: application/json" \
  -d '{"email":"user@example.com","password":"password123"}'

# Get exams (with token)
curl -X GET "/api/mobile/exams" \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Accept: application/json"
```

---

## Support

For API support and questions:
- Email: api-support@yourapp.com
- Documentation: https://your-domain.com/docs
- Status Page: https://status.yourapp.com

---

*Last updated: January 2024*
*API Version: 1.0*