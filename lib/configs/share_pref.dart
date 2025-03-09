import 'package:shared_preferences/shared_preferences.dart';

class UserTypeManager {
  static const String _userTypeKey = 'user_type';
  static const String _tokenKey = 'token';

  static Future<void> setUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, type);
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }


  static Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}


