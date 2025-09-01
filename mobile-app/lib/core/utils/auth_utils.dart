import 'dart:convert';
import 'package:jwt_decoder/jwt_decoder.dart';

/// Utility class for authentication-related operations
class AuthUtils {
  /// Private constructor to prevent instantiation
  AuthUtils._();

  /// Check if a JWT token is expired
  static bool isTokenExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      // If we can't decode the token, consider it expired
      return true;
    }
  }

  /// Get the expiration time of a JWT token
  static DateTime? getTokenExpirationTime(String token) {
    try {
      return JwtDecoder.getExpirationDate(token);
    } catch (e) {
      return null;
    }
  }

  /// Get the time remaining until token expires
  static Duration? getTimeUntilExpiration(String token) {
    final expirationTime = getTokenExpirationTime(token);
    if (expirationTime == null) return null;
    
    final now = DateTime.now();
    if (expirationTime.isBefore(now)) {
      return Duration.zero;
    }
    
    return expirationTime.difference(now);
  }

  /// Check if token needs refresh (expires within the given threshold)
  static bool needsRefresh(String token, {Duration threshold = const Duration(minutes: 5)}) {
    final timeUntilExpiration = getTimeUntilExpiration(token);
    if (timeUntilExpiration == null) return true;
    
    return timeUntilExpiration <= threshold;
  }

  /// Extract user ID from JWT token
  static String? getUserIdFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['sub'] ?? decodedToken['user_id'] ?? decodedToken['id'];
    } catch (e) {
      return null;
    }
  }

  /// Extract user email from JWT token
  static String? getUserEmailFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['email'];
    } catch (e) {
      return null;
    }
  }

  /// Extract user roles from JWT token
  static List<String> getUserRolesFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final roles = decodedToken['roles'] ?? decodedToken['authorities'] ?? [];
      
      if (roles is List) {
        return roles.cast<String>();
      } else if (roles is String) {
        return [roles];
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  /// Check if user has a specific role
  static bool hasRole(String token, String role) {
    final roles = getUserRolesFromToken(token);
    return roles.contains(role);
  }

  /// Check if user has any of the specified roles
  static bool hasAnyRole(String token, List<String> requiredRoles) {
    final userRoles = getUserRolesFromToken(token);
    return requiredRoles.any((role) => userRoles.contains(role));
  }

  /// Check if user has all of the specified roles
  static bool hasAllRoles(String token, List<String> requiredRoles) {
    final userRoles = getUserRolesFromToken(token);
    return requiredRoles.every((role) => userRoles.contains(role));
  }

  /// Validate token format (basic JWT structure check)
  static bool isValidTokenFormat(String token) {
    if (token.isEmpty) return false;
    
    final parts = token.split('.');
    return parts.length == 3;
  }

  /// Get token payload without verification
  static Map<String, dynamic>? getTokenPayload(String token) {
    try {
      return JwtDecoder.decode(token);
    } catch (e) {
      return null;
    }
  }

  /// Check if token is issued after a specific time
  static bool isTokenIssuedAfter(String token, DateTime time) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final iat = decodedToken['iat'];
      
      if (iat == null) return false;
      
      final issuedAt = DateTime.fromMillisecondsSinceEpoch(iat * 1000);
      return issuedAt.isAfter(time);
    } catch (e) {
      return false;
    }
  }

  /// Get token issued at time
  static DateTime? getTokenIssuedAt(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      final iat = decodedToken['iat'];
      
      if (iat == null) return null;
      
      return DateTime.fromMillisecondsSinceEpoch(iat * 1000);
    } catch (e) {
      return null;
    }
  }

  /// Calculate token age
  static Duration? getTokenAge(String token) {
    final issuedAt = getTokenIssuedAt(token);
    if (issuedAt == null) return null;
    
    return DateTime.now().difference(issuedAt);
  }

  /// Check if token is fresh (issued within the given duration)
  static bool isTokenFresh(String token, {Duration maxAge = const Duration(hours: 1)}) {
    final age = getTokenAge(token);
    if (age == null) return false;
    
    return age <= maxAge;
  }

  /// Generate a secure random string for state parameters
  static String generateSecureRandomString(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    
    return List.generate(length, (index) {
      return chars[(random + index) % chars.length];
    }).join();
  }

  /// Validate email format
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate password strength
  static bool isStrongPassword(String password) {
    // At least 8 characters, contains uppercase, lowercase, number, and special character
    final passwordRegex = RegExp(
      r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    );
    return passwordRegex.hasMatch(password);
  }

  /// Get password strength score (0-4)
  static int getPasswordStrength(String password) {
    int score = 0;
    
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[a-z]'))) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'\d'))) score++;
    if (password.contains(RegExp(r'[@$!%*?&]'))) score++;
    
    return score;
  }

  /// Sanitize user input to prevent XSS
  static String sanitizeInput(String input) {
    return input
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;')
        .replaceAll("'", '&#x27;')
        .replaceAll('&', '&amp;');
  }

  /// Format time remaining until token expires
  static String formatTimeUntilExpiration(String token) {
    final timeUntilExpiration = getTimeUntilExpiration(token);
    if (timeUntilExpiration == null) return 'Invalid token';
    
    if (timeUntilExpiration.isNegative || timeUntilExpiration == Duration.zero) {
      return 'Expired';
    }
    
    final hours = timeUntilExpiration.inHours;
    final minutes = timeUntilExpiration.inMinutes % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }
}