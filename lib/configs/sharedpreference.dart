import 'package:shared_preferences/shared_preferences.dart';
class StorageService {
  static const String tokenKey = 'token';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(tokenKey);
  }
}



/*class SharedPrefs {
  static Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_token', token);
  }

  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token');
  }

  static Future<void> clearToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token');
  }
}*/

