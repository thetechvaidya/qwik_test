import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';
import '../models/offline_exam_model.dart';
import '../models/offline_session_upload_model.dart';
import '../models/sync_status_model.dart';

abstract class OfflineRemoteDataSource {
  /// Download exam for offline use
  Future<OfflineExamModel> downloadExam(String examId);
  
  /// Upload offline exam session
  Future<void> uploadSession(OfflineSessionUploadModel session);
  
  /// Get sync status from server
  Future<List<SyncStatusModel>> getSyncStatuses(String userId);
  
  /// Update sync status on server
  Future<void> updateSyncStatus(SyncStatusModel syncStatus);
  
  /// Check for exam updates
  Future<Map<String, String>> checkExamVersions(List<String> examIds);
  
  /// Get available offline exams for user
  Future<List<String>> getAvailableOfflineExams(String userId);
}

class OfflineRemoteDataSourceImpl implements OfflineRemoteDataSource {
  final http.Client client;
  final NetworkInfo networkInfo;
  final String baseUrl;

  OfflineRemoteDataSourceImpl({
    required this.client,
    required this.networkInfo,
    required this.baseUrl,
  });

  @override
  Future<OfflineExamModel> downloadExam(String examId) async {
    await _ensureConnected();
    
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/offline/exams/$examId/download'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return OfflineExamModel.fromJson(jsonData['data']);
      } else if (response.statusCode == 404) {
        throw ServerException('Exam not found or not available for offline use');
      } else {
        throw ServerException('Failed to download exam: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error while downloading exam: $e');
    }
  }

  @override
  Future<void> uploadSession(OfflineSessionUploadModel session) async {
    await _ensureConnected();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/offline/sessions/upload'),
        headers: _getHeaders(),
        body: json.encode({
          'session': session.toJson(),
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Upload successful
        return;
      } else if (response.statusCode == 409) {
        throw ConflictException('Session already exists on server');
      } else {
        throw ServerException('Failed to upload session: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException || e is ConflictException) rethrow;
      throw ServerException('Network error while uploading session: $e');
    }
  }

  @override
  Future<List<SyncStatusModel>> getSyncStatuses(String userId) async {
    await _ensureConnected();
    
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/offline/sync-status/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> statusList = jsonData['data'];
        return statusList
            .map((json) => SyncStatusModel.fromJson(json))
            .toList();
      } else {
        throw ServerException('Failed to get sync statuses: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error while getting sync statuses: $e');
    }
  }

  @override
  Future<void> updateSyncStatus(SyncStatusModel syncStatus) async {
    await _ensureConnected();
    
    try {
      final response = await client.put(
        Uri.parse('$baseUrl/api/offline/sync-status/${syncStatus.sessionId}'),
        headers: _getHeaders(),
        body: json.encode({
          'status': syncStatus.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        // Update successful
        return;
      } else {
        throw ServerException('Failed to update sync status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error while updating sync status: $e');
    }
  }

  @override
  Future<Map<String, String>> checkExamVersions(List<String> examIds) async {
    await _ensureConnected();
    
    try {
      final response = await client.post(
        Uri.parse('$baseUrl/api/offline/exams/check-versions'),
        headers: _getHeaders(),
        body: json.encode({
          'exam_ids': examIds,
        }),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Map<String, String>.from(jsonData['data']);
      } else {
        throw ServerException('Failed to check exam versions: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error while checking exam versions: $e');
    }
  }

  @override
  Future<List<String>> getAvailableOfflineExams(String userId) async {
    await _ensureConnected();
    
    try {
      final response = await client.get(
        Uri.parse('$baseUrl/api/offline/exams/available/$userId'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> examIds = jsonData['data'];
        return examIds.cast<String>();
      } else {
        throw ServerException('Failed to get available offline exams: ${response.statusCode}');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException('Network error while getting available offline exams: $e');
    }
  }

  /// Ensure network connectivity
  Future<void> _ensureConnected() async {
    if (!await networkInfo.isConnected) {
      throw NetworkException('No internet connection available');
    }
  }

  /// Get common headers for API requests
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      // Add authentication headers here if needed
      // 'Authorization': 'Bearer $token',
    };
  }
}

/// Custom exceptions for offline operations
class ConflictException implements Exception {
  final String message;
  ConflictException(this.message);
  
  @override
  String toString() => 'ConflictException: $message';
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
  
  @override
  String toString() => 'NetworkException: $message';
}