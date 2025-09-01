import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String _appBoxName = 'app_box';
  static const String _userBoxName = 'user_box';
  static const String _authBoxName = 'auth_box';

  late Box<dynamic> _appBox;
  late Box<dynamic> _userBox;
  late Box<dynamic> _authBox;

  Box<dynamic> get appBox => _appBox;
  Box<dynamic> get userBox => _userBox;
  Box<dynamic> get authBox => _authBox;

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Open boxes
    _appBox = await Hive.openBox(_appBoxName);
    _userBox = await Hive.openBox(_userBoxName);
    _authBox = await Hive.openBox(_authBoxName);
  }

  Future<void> clearAll() async {
    await _appBox.clear();
    await _userBox.clear();
    await _authBox.clear();
  }

  Future<void> close() async {
    await _appBox.close();
    await _userBox.close();
    await _authBox.close();
  }
}