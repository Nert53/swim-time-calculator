import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

// this class allows to listen to changes in shared preferences
// using for split screen mode on iPad
class PreferenceService {
  static final StreamController<String> _keyChangeController = StreamController<String>.broadcast();

  static Stream<String> get onKeyChanged => _keyChangeController.stream;

  static Future<void> setBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
    
    _keyChangeController.add(key);
  }

  static Future<bool> getBool(String key, {bool defaultValue = false}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? defaultValue;
  }
}