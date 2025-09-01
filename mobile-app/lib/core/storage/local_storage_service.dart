import 'package:hive_flutter/hive_flutter.dart';
import '../constants/app_constants.dart';
import '../error/exceptions.dart';

/// Local storage service using Hive
class LocalStorageService {
  Box? _authBox;
  Box? _userBox;
  Box? _examBox;
  Box? _settingsBox;

  /// Initialize all Hive boxes
  Future<void> init() async {
    try {
      _authBox = await Hive.openBox(AppConstants.authBoxName);
      _userBox = await Hive.openBox(AppConstants.userBoxName);
      _examBox = await Hive.openBox(AppConstants.examBoxName);
      _settingsBox = await Hive.openBox(AppConstants.settingsBoxName);
    } catch (e) {
      throw CacheException('Failed to initialize local storage: $e');
    }
  }

  /// Auth Box Operations
  Future<void> saveAuthData(String key, dynamic value) async {
    try {
      await _authBox?.put(key, value);
    } catch (e) {
      throw CacheException('Failed to save auth data: $e');
    }
  }

  T? getAuthData<T>(String key) {
    try {
      return _authBox?.get(key) as T?;
    } catch (e) {
      throw CacheException('Failed to get auth data: $e');
    }
  }

  Future<void> clearAuthData() async {
    try {
      await _authBox?.clear();
    } catch (e) {
      throw CacheException('Failed to clear auth data: $e');
    }
  }

  /// User Box Operations
  Future<void> saveUserData(String key, dynamic value) async {
    try {
      await _userBox?.put(key, value);
    } catch (e) {
      throw CacheException('Failed to save user data: $e');
    }
  }

  T? getUserData<T>(String key) {
    try {
      return _userBox?.get(key) as T?;
    } catch (e) {
      throw CacheException('Failed to get user data: $e');
    }
  }

  Future<void> clearUserData() async {
    try {
      await _userBox?.clear();
    } catch (e) {
      throw CacheException('Failed to clear user data: $e');
    }
  }

  /// Exam Box Operations
  Future<void> saveExamData(String key, dynamic value) async {
    try {
      await _examBox?.put(key, value);
    } catch (e) {
      throw CacheException('Failed to save exam data: $e');
    }
  }

  T? getExamData<T>(String key) {
    try {
      return _examBox?.get(key) as T?;
    } catch (e) {
      throw CacheException('Failed to get exam data: $e');
    }
  }

  List<T> getAllExamData<T>() {
    try {
      return _examBox?.values.cast<T>().toList() ?? [];
    } catch (e) {
      throw CacheException('Failed to get all exam data: $e');
    }
  }

  Future<void> clearExamData() async {
    try {
      await _examBox?.clear();
    } catch (e) {
      throw CacheException('Failed to clear exam data: $e');
    }
  }

  /// Settings Box Operations
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      await _settingsBox?.put(key, value);
    } catch (e) {
      throw CacheException('Failed to save setting: $e');
    }
  }

  T? getSetting<T>(String key) {
    try {
      return _settingsBox?.get(key) as T?;
    } catch (e) {
      throw CacheException('Failed to get setting: $e');
    }
  }

  Future<void> clearSettings() async {
    try {
      await _settingsBox?.clear();
    } catch (e) {
      throw CacheException('Failed to clear settings: $e');
    }
  }

  /// Clear all data
  Future<void> clearAllData() async {
    try {
      await Future.wait([
        clearAuthData(),
        clearUserData(),
        clearExamData(),
        clearSettings(),
      ]);
    } catch (e) {
      throw CacheException('Failed to clear all data: $e');
    }
  }

  /// Close all boxes
  Future<void> close() async {
    try {
      await Future.wait([
        _authBox?.close() ?? Future.value(),
        _userBox?.close() ?? Future.value(),
        _examBox?.close() ?? Future.value(),
        _settingsBox?.close() ?? Future.value(),
      ]);
    } catch (e) {
      throw CacheException('Failed to close storage: $e');
    }
  }
}