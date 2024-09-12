import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static final SharedPreferencesHelper _instance =
      SharedPreferencesHelper._internal();

  factory SharedPreferencesHelper() {
    return _instance;
  }

  SharedPreferencesHelper._internal();
  final SharedPreferencesAsync _prefs = SharedPreferencesAsync();

  // String
  Future<void> setString(String key, String value) async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.setString(key, value);
  }

  Future<String?> getString(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.getString(key);
  }

  // Int
  Future<void> setInt(String key, int value) async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.setInt(key, value);
  }

  Future<int?> getInt(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.getInt(key);
  }

  // Double
  Future<void> setDouble(String key, double value) async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.setDouble(key, value);
  }

  Future<double?> getDouble(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.getDouble(key);
  }

  // Bool
  Future<void> setBool(String key, bool value) async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.setBool(key, value);
  }

  Future<bool?> getBool(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.getBool(key);
  }

  // List<String>
  Future<void> setStringList(String key, List<String> value) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.setStringList(key, value);
  }

  Future<List<String>?> getStringList(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    return prefs.getStringList(key);
  }

  // Remove
  Future<void> remove(String key) async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.remove(key);
  }

  // Clear all
  Future<void> clear() async {
    final SharedPreferencesAsync prefs = _prefs;
    await prefs.clear();
  }
}
