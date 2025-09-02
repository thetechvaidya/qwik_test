/// API endpoints for the mobile application
class ApiEndpoints {
  // Base paths
  static const String _apiPrefix = '/api/mobile';
  
  // Authentication endpoints
  static const String login = '$_apiPrefix/auth/login';
  static const String register = '$_apiPrefix/auth/register';
  static const String logout = '$_apiPrefix/auth/logout';
  static const String refreshToken = '$_apiPrefix/auth/refresh';
  static const String forgotPassword = '$_apiPrefix/auth/forgot-password';
  static const String resetPassword = '$_apiPrefix/auth/reset-password';
  static const String verifyEmail = '$_apiPrefix/auth/verify-email';
  static const String resendVerification = '$_apiPrefix/auth/resend-verification';
  
  // User endpoints
  static const String profile = '$_apiPrefix/user/profile';
  static const String updateProfile = '$_apiPrefix/user/profile';
  static const String changePassword = '$_apiPrefix/user/change-password';
  static const String deleteAccount = '$_apiPrefix/user/delete-account';
  static const String uploadAvatar = '$_apiPrefix/user/avatar';
  
  // Exam endpoints
  static const String exams = '$_apiPrefix/exams';
  static String examDetail(String examId) => '$_apiPrefix/exams/$examId';
  static const String featuredExams = '$_apiPrefix/exams/featured';
  static const String popularExams = '$_apiPrefix/exams/popular';
  static const String recentExams = '$_apiPrefix/exams/recent';
  static String examQuestions(String examId) => '$_apiPrefix/exams/$examId/questions';
  static String startExam(String examId) => '$_apiPrefix/exams/$examId/start';
  static String submitExam(String examId) => '$_apiPrefix/exams/$examId/submit';
  static String examResult(String examId) => '$_apiPrefix/exams/$examId/result';
  static String examResults(String examId) => '$_apiPrefix/exams/$examId/results';
  static String favoriteExam(String examId) => '$_apiPrefix/exams/$examId/favorite';
  static String unfavoriteExam(String examId) => '$_apiPrefix/exams/$examId/unfavorite';
  
  // Quiz endpoints
  static const String quizzes = '$_apiPrefix/quizzes';
  static String quizDetail(String quizId) => '$_apiPrefix/quizzes/$quizId';
  static const String featuredQuizzes = '$_apiPrefix/quizzes/featured';
  static const String popularQuizzes = '$_apiPrefix/quizzes/popular';
  static String quizQuestions(String quizId) => '$_apiPrefix/quizzes/$quizId/questions';
  static String startQuiz(String quizId) => '$_apiPrefix/quizzes/$quizId/start';
  static String submitQuiz(String quizId) => '$_apiPrefix/quizzes/$quizId/submit';
  static String quizResult(String quizId) => '$_apiPrefix/quizzes/$quizId/result';
  
  // Category endpoints
  static const String categories = '$_apiPrefix/categories';
  static String categoryDetail(String categoryId) => '$_apiPrefix/categories/$categoryId';
  static String categoryExams(String categoryId) => '$_apiPrefix/categories/$categoryId/exams';
  static String categoryQuizzes(String categoryId) => '$_apiPrefix/categories/$categoryId/quizzes';
  
  // Search endpoints
  static const String search = '$_apiPrefix/search';
  static const String searchSuggestions = '$_apiPrefix/search/suggestions';
  static const String searchHistory = '$_apiPrefix/search/history';
  static const String trendingSearches = '$_apiPrefix/search/trending';
  static const String popularSearches = '$_apiPrefix/search/popular';
  static const String searchAnalytics = '$_apiPrefix/search/analytics';
  
  // Favorites endpoints
  static const String favorites = '$_apiPrefix/favorites';
  static const String favoriteExams = '$_apiPrefix/favorites/exams';
  static const String favoriteQuizzes = '$_apiPrefix/favorites/quizzes';
  
  // History endpoints
  static const String history = '$_apiPrefix/history';
  static const String examHistory = '$_apiPrefix/history/exams';
  static const String quizHistory = '$_apiPrefix/history/quizzes';
  
  // Analytics endpoints
  static const String analytics = '$_apiPrefix/analytics';
  static const String userStats = '$_apiPrefix/analytics/stats';
  static const String performance = '$_apiPrefix/analytics/performance';
  static const String progress = '$_apiPrefix/analytics/progress';
  
  // Notification endpoints
  static const String notifications = '$_apiPrefix/notifications';
  static String markNotificationRead(String notificationId) => '$_apiPrefix/notifications/$notificationId/read';
  static const String markAllNotificationsRead = '$_apiPrefix/notifications/read-all';
  static String deleteNotification(String notificationId) => '$_apiPrefix/notifications/$notificationId';
  
  // Settings endpoints
  static const String settings = '$_apiPrefix/settings';
  static const String updateSettings = '$_apiPrefix/settings';
  static const String notificationSettings = '$_apiPrefix/settings/notifications';
  static const String privacySettings = '$_apiPrefix/settings/privacy';
  
  // Feedback endpoints
  static const String feedback = '$_apiPrefix/feedback';
  static const String reportIssue = '$_apiPrefix/feedback/report';
  static const String suggestions = '$_apiPrefix/feedback/suggestions';
  
  // App endpoints
  static const String appVersion = '$_apiPrefix/app/version';
  static const String appConfig = '$_apiPrefix/app/config';
  static const String maintenance = '$_apiPrefix/app/maintenance';
  
  // File upload endpoints
  static const String uploadFile = '$_apiPrefix/upload';
  static const String uploadImage = '$_apiPrefix/upload/image';
  static const String uploadDocument = '$_apiPrefix/upload/document';
  
  // Helper methods for dynamic endpoints
  static String examsByCategory(String categoryId) => '$_apiPrefix/categories/$categoryId/exams';
  static String quizzesByCategory(String categoryId) => '$_apiPrefix/categories/$categoryId/quizzes';
  static String userExamAttempts(String examId) => '$_apiPrefix/exams/$examId/attempts';
  static String userQuizAttempts(String quizId) => '$_apiPrefix/quizzes/$quizId/attempts';
  
  // Pagination and filtering helpers
  static String withPagination(String endpoint, {int? page, int? limit}) {
    final params = <String>[];
    if (page != null) params.add('page=$page');
    if (limit != null) params.add('limit=$limit');
    return params.isEmpty ? endpoint : '$endpoint?${params.join('&')}';
  }
  
  static String withFilters(String endpoint, Map<String, dynamic> filters) {
    if (filters.isEmpty) return endpoint;
    
    final params = filters.entries
        .where((entry) => entry.value != null)
        .map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value.toString())}')
        .toList();
    
    return params.isEmpty ? endpoint : '$endpoint?${params.join('&')}';
  }
  
  static String withQuery(String endpoint, String query) {
    return '$endpoint?q=${Uri.encodeComponent(query)}';
  }
}