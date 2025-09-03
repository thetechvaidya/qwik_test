import 'package:dio/dio.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/search_suggestion_model.dart';

/// Abstract interface for search remote data source
abstract class SearchRemoteDataSource {
  /// Get search suggestions from API
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    String? query,
    int limit = 10,
  });

  /// Get trending search queries
  Future<List<String>> getTrendingSearches({int limit = 10});

  /// Report search analytics
  Future<void> reportSearchAnalytics({
    required String query,
    String? categoryId,
    int? resultCount,
    bool? hasResults,
  });
}

/// Implementation of search remote data source using Dio
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio _dio;

  SearchRemoteDataSourceImpl({
    required Dio dio,
  }) : _dio = dio;

  @override
  Future<List<SearchSuggestionModel>> getSearchSuggestions({
    String? query,
    int limit = 10,
  }) async {
    try {
      final queryParams = <String, dynamic>{
        'limit': limit,
      };
      
      if (query != null && query.isNotEmpty) {
        queryParams['query'] = query;
      }

      final response = await _dio.get(
        ApiEndpoints.searchSuggestions,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final suggestions = data['suggestions'] as List<dynamic>? ?? [];
        
        return suggestions
            .map((json) => SearchSuggestionModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw ServerException(
          message: 'Failed to get search suggestions',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<List<String>> getTrendingSearches({int limit = 10}) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.trendingSearches,
        queryParameters: {
          'limit': limit,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final trending = data['trending'] as List<dynamic>? ?? [];
        
        return trending.map((item) => item.toString()).toList();
      } else {
        throw ServerException(
          message: 'Failed to get trending searches',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Unexpected error occurred: $e');
    }
  }

  @override
  Future<void> reportSearchAnalytics({
    required String query,
    String? categoryId,
    int? resultCount,
    bool? hasResults,
  }) async {
    try {
      final data = {
        'query': query,
        'timestamp': DateTime.now().toIso8601String(),
      };
      
      if (categoryId != null) {
        data['category_id'] = categoryId;
      }
      
      if (resultCount != null) {
        data['result_count'] = resultCount;
      }
      
      if (hasResults != null) {
        data['has_results'] = hasResults;
      }

      final response = await _dio.post(
        ApiEndpoints.searchAnalytics,
        data: data,
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw ServerException(
          message: 'Failed to report search analytics',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      // Don't throw for analytics failures, just log
    } catch (e) {
      // Don't throw for analytics failures, just log
    }
  }

  /// Handle Dio exceptions and convert to appropriate exceptions
  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(message: 'Connection timeout. Please check your internet connection.');
      
      case DioExceptionType.connectionError:
        return NetworkException(message: 'No internet connection. Please check your network settings.');
      
      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] as String? ?? 'Server error occurred';
        
        switch (statusCode) {
          case 400:
            return ValidationException(
              message: message,
              errors: e.response?.data?['errors'] as Map<String, dynamic>?,
            );
          case 401:
            return UnauthorizedException(message: message);
          case 403:
            return UnauthorizedException(message: 'Access forbidden');
          case 404:
            return ServerException(message: 'Resource not found', statusCode: 404);
          case 422:
            return ValidationException(
              message: message,
              errors: e.response?.data?['errors'] as Map<String, dynamic>?,
            );
          case 429:
            return ServerException(message: 'Too many requests. Please try again later.', statusCode: 429);
          case 500:
          case 502:
          case 503:
          case 504:
            return ServerException(message: 'Server error. Please try again later.', statusCode: statusCode);
          default:
            return ServerException(message: message, statusCode: statusCode);
        }
      
      case DioExceptionType.cancel:
        return NetworkException(message: 'Request was cancelled');
      
      case DioExceptionType.unknown:
      default:
        return NetworkException(message: 'Network error occurred. Please try again.');
    }
  }
}