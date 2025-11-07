import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  static const String _tokenKey = "token";
  static const String _profileImageKey = "profile_image";

  // 🔹 Token Handling
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // 🔹 Profile Image Handling
  static Future<void> saveProfileImage(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileImageKey, path);
  }

  static Future<String?> getProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_profileImageKey);
  }

  static Future<void> clearProfileImage() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileImageKey);
  }
}
