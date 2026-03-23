import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static late Box _settingsBox;
  static late Box _cacheBox;
  static late Box _userBox;

  static Future<void> init() async {
    await Hive.initFlutter();
    _settingsBox = await Hive.openBox('settings');
    _cacheBox = await Hive.openBox('cache');
    _userBox = await Hive.openBox('user');
  }

  static Future<void> setSetting(String key, dynamic value) async => await _settingsBox.put(key, value);
  static dynamic getSetting(String key, {dynamic defaultValue}) => _settingsBox.get(key, defaultValue: defaultValue);
  static Future<void> setCache(String key, dynamic value) async => await _cacheBox.put(key, value);
  static dynamic getCache(String key) => _cacheBox.get(key);
  static Future<void> clearCache() async => await _cacheBox.clear();
  static Future<void> setUserData(String key, dynamic value) async => await _userBox.put(key, value);
  static dynamic getUserData(String key) => _userBox.get(key);
  static Future<void> clearUserData() async => await _userBox.clear();

  static bool get isDarkMode => getSetting('darkMode', defaultValue: false);
  static Future<void> setDarkMode(bool value) async => await setSetting('darkMode', value);
  static String get language => getSetting('language', defaultValue: 'ar');
  static Future<void> setLanguage(String value) async => await setSetting('language', value);
}
