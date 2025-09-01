import 'package:hive/hive.dart';
import '../../../../core/error/exceptions.dart';
import '../models/search_history_model.dart';
import '../models/search_suggestion_model.dart';

/// Abstract interface for search local data source
abstract class SearchLocalDataSource {
  /// Save search query to history
  Future<void> saveSearchHistory(SearchHistoryModel searchHistory);

  /// Get search history with optional limit
  Future<List<SearchHistoryModel>> getSearchHistory({int? limit});

  /// Clear all search history
  Future<void> clearSearchHistory();

  /// Remove specific search history item
  Future<void> removeSearchHistory(String id);

  /// Update search history frequency
  Future<void> updateSearchHistoryFrequency(String query, String? categoryId);

  /// Cache search suggestions
  Future<void> cacheSearchSuggestions(List<SearchSuggestionModel> suggestions);

  /// Get cached search suggestions
  Future<List<SearchSuggestionModel>> getCachedSearchSuggestions({String? query});

  /// Clear cached search suggestions
  Future<void> clearSearchSuggestions();

  /// Get popular search queries
  Future<List<String>> getPopularSearchQueries({int limit = 10});

  /// Check if search history exists for query
  Future<bool> hasSearchHistory(String query, {String? categoryId});
}

/// Implementation of search local data source using Hive
class SearchLocalDataSourceImpl implements SearchLocalDataSource {
  static const String _searchHistoryBoxName = 'search_history';
  static const String _searchSuggestionsBoxName = 'search_suggestions';
  static const String _searchCacheTimestampKey = 'search_cache_timestamp';
  static const Duration _cacheValidDuration = Duration(hours: 24);

  late Box<SearchHistoryModel> _searchHistoryBox;
  late Box<SearchSuggestionModel> _searchSuggestionsBox;
  late Box<dynamic> _metadataBox;

  SearchLocalDataSourceImpl() {
    _initializeBoxes();
  }

  /// Initialize Hive boxes
  void _initializeBoxes() {
    _searchHistoryBox = Hive.box<SearchHistoryModel>(_searchHistoryBoxName);
    _searchSuggestionsBox = Hive.box<SearchSuggestionModel>(_searchSuggestionsBoxName);
    _metadataBox = Hive.box('metadata');
  }

  @override
  Future<void> saveSearchHistory(SearchHistoryModel searchHistory) async {
    try {
      // Check if query already exists
      final existingKey = _findExistingSearchHistory(
        searchHistory.query,
        searchHistory.categoryId,
      );

      if (existingKey != null) {
        // Update existing entry
        final existing = _searchHistoryBox.get(existingKey)!;
        final updated = existing.copyWith(
          frequency: existing.frequency + 1,
          searchedAt: DateTime.now(),
        );
        await _searchHistoryBox.put(existingKey, updated);
      } else {
        // Add new entry
        await _searchHistoryBox.put(searchHistory.id, searchHistory);
      }

      // Limit history size (keep only last 100 entries)
      await _limitHistorySize();
    } catch (e) {
      throw CacheException('Failed to save search history: $e');
    }
  }

  @override
  Future<List<SearchHistoryModel>> getSearchHistory({int? limit}) async {
    try {
      final allHistory = _searchHistoryBox.values.toList();
      
      // Sort by frequency and recency
      allHistory.sort((a, b) {
        // First sort by frequency (descending)
        final frequencyComparison = b.frequency.compareTo(a.frequency);
        if (frequencyComparison != 0) return frequencyComparison;
        
        // Then by recency (descending)
        return b.searchedAt.compareTo(a.searchedAt);
      });

      if (limit != null && limit > 0) {
        return allHistory.take(limit).toList();
      }
      
      return allHistory;
    } catch (e) {
      throw CacheException('Failed to get search history: $e');
    }
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await _searchHistoryBox.clear();
    } catch (e) {
      throw CacheException('Failed to clear search history: $e');
    }
  }

  @override
  Future<void> removeSearchHistory(String id) async {
    try {
      await _searchHistoryBox.delete(id);
    } catch (e) {
      throw CacheException('Failed to remove search history: $e');
    }
  }

  @override
  Future<void> updateSearchHistoryFrequency(String query, String? categoryId) async {
    try {
      final existingKey = _findExistingSearchHistory(query, categoryId);
      
      if (existingKey != null) {
        final existing = _searchHistoryBox.get(existingKey)!;
        final updated = existing.copyWith(
          frequency: existing.frequency + 1,
          searchedAt: DateTime.now(),
        );
        await _searchHistoryBox.put(existingKey, updated);
      }
    } catch (e) {
      throw CacheException('Failed to update search history frequency: $e');
    }
  }

  @override
  Future<void> cacheSearchSuggestions(List<SearchSuggestionModel> suggestions) async {
    try {
      // Clear existing suggestions
      await _searchSuggestionsBox.clear();
      
      // Cache new suggestions
      for (final suggestion in suggestions) {
        await _searchSuggestionsBox.put(suggestion.id, suggestion);
      }
      
      // Update cache timestamp
      await _metadataBox.put(_searchCacheTimestampKey, DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      throw CacheException('Failed to cache search suggestions: $e');
    }
  }

  @override
  Future<List<SearchSuggestionModel>> getCachedSearchSuggestions({String? query}) async {
    try {
      // Check if cache is still valid
      if (!_isCacheValid()) {
        return [];
      }

      final allSuggestions = _searchSuggestionsBox.values.toList();
      
      if (query != null && query.isNotEmpty) {
        // Filter suggestions based on query
        final filteredSuggestions = allSuggestions.where((suggestion) {
          return suggestion.text.toLowerCase().contains(query.toLowerCase()) ||
              (suggestion.examTitle?.toLowerCase().contains(query.toLowerCase()) ?? false) ||
              (suggestion.categoryName?.toLowerCase().contains(query.toLowerCase()) ?? false);
        }).toList();
        
        // Sort by relevance and popularity
        filteredSuggestions.sort((a, b) {
          // Exact matches first
          final aExact = a.text.toLowerCase() == query.toLowerCase();
          final bExact = b.text.toLowerCase() == query.toLowerCase();
          if (aExact && !bExact) return -1;
          if (!aExact && bExact) return 1;
          
          // Then by starts with
          final aStartsWith = a.text.toLowerCase().startsWith(query.toLowerCase());
          final bStartsWith = b.text.toLowerCase().startsWith(query.toLowerCase());
          if (aStartsWith && !bStartsWith) return -1;
          if (!aStartsWith && bStartsWith) return 1;
          
          // Then by type priority
          final typeComparison = b.type.toEntity().priority.compareTo(a.type.toEntity().priority);
          if (typeComparison != 0) return typeComparison;
          
          // Finally by popularity
          return b.popularity.compareTo(a.popularity);
        });
        
        return filteredSuggestions;
      }
      
      // Sort all suggestions by type priority and popularity
      allSuggestions.sort((a, b) {
        final typeComparison = b.type.toEntity().priority.compareTo(a.type.toEntity().priority);
        if (typeComparison != 0) return typeComparison;
        return b.popularity.compareTo(a.popularity);
      });
      
      return allSuggestions;
    } catch (e) {
      throw CacheException('Failed to get cached search suggestions: $e');
    }
  }

  @override
  Future<void> clearSearchSuggestions() async {
    try {
      await _searchSuggestionsBox.clear();
      await _metadataBox.delete(_searchCacheTimestampKey);
    } catch (e) {
      throw CacheException('Failed to clear search suggestions: $e');
    }
  }

  @override
  Future<List<String>> getPopularSearchQueries({int limit = 10}) async {
    try {
      final allHistory = _searchHistoryBox.values.toList();
      
      // Group by query and sum frequencies
      final queryFrequencies = <String, int>{};
      for (final history in allHistory) {
        queryFrequencies[history.query] = 
            (queryFrequencies[history.query] ?? 0) + history.frequency;
      }
      
      // Sort by frequency and get top queries
      final sortedQueries = queryFrequencies.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));
      
      return sortedQueries
          .take(limit)
          .map((entry) => entry.key)
          .toList();
    } catch (e) {
      throw CacheException('Failed to get popular search queries: $e');
    }
  }

  @override
  Future<bool> hasSearchHistory(String query, {String? categoryId}) async {
    try {
      return _findExistingSearchHistory(query, categoryId) != null;
    } catch (e) {
      return false;
    }
  }

  /// Find existing search history key
  String? _findExistingSearchHistory(String query, String? categoryId) {
    for (final entry in _searchHistoryBox.toMap().entries) {
      final history = entry.value;
      if (history.query.toLowerCase() == query.toLowerCase() &&
          history.categoryId == categoryId) {
        return entry.key;
      }
    }
    return null;
  }

  /// Limit history size to prevent unlimited growth
  Future<void> _limitHistorySize() async {
    const maxHistorySize = 100;
    
    if (_searchHistoryBox.length > maxHistorySize) {
      final allHistory = _searchHistoryBox.values.toList();
      
      // Sort by frequency and recency (ascending to remove least important)
      allHistory.sort((a, b) {
        final frequencyComparison = a.frequency.compareTo(b.frequency);
        if (frequencyComparison != 0) return frequencyComparison;
        return a.searchedAt.compareTo(b.searchedAt);
      });
      
      // Remove oldest/least frequent entries
      final entriesToRemove = allHistory.take(allHistory.length - maxHistorySize);
      for (final entry in entriesToRemove) {
        await _searchHistoryBox.delete(entry.id);
      }
    }
  }

  /// Check if cache is still valid
  bool _isCacheValid() {
    final timestamp = _metadataBox.get(_searchCacheTimestampKey) as int?;
    if (timestamp == null) return false;
    
    final cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
    final now = DateTime.now();
    
    return now.difference(cacheTime) < _cacheValidDuration;
  }
}