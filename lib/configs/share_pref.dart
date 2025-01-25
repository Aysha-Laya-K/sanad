import 'package:shared_preferences/shared_preferences.dart';

class UserTypeManager {
  static const String _userTypeKey = 'user_type';

  static Future<void> setUserType(String type) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userTypeKey, type);
  }

  static Future<String?> getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userTypeKey);
  }
}
