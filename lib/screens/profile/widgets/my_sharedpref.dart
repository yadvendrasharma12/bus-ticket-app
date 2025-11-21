import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceProfile {
  static const String keyName = "user_name";
  static const String keyEmail = "user_email";
  static const String keyMobile = "user_mobile";
  static const String keyAddress = "user_address";
  static const String keyGender = "user_gender";
  static const String keyDob = "user_dob";
  static const String keyProfileImage = "user_profile_image";

  static Future<void> saveProfileData({
    required String name,
    required String email,
    required String mobile,
    required String address,
    required String gender,
    required String dob,
  }) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(keyName, name);
    await pref.setString(keyEmail, email);
    await pref.setString(keyMobile, mobile);
    await pref.setString(keyAddress, address);
    await pref.setString(keyGender, gender);
    await pref.setString(keyDob, dob);
  }

  static Future<Map<String, String?>> getProfileData() async {
    final pref = await SharedPreferences.getInstance();
    return {
      "name": pref.getString(keyName),
      "email": pref.getString(keyEmail),
      "mobile": pref.getString(keyMobile),
      "address": pref.getString(keyAddress),
      "gender": pref.getString(keyGender),
      "dob": pref.getString(keyDob),
    };
  }

  static Future<void> saveProfileImage(String path) async {
    final pref = await SharedPreferences.getInstance();
    await pref.setString(keyProfileImage, path);
  }

  static Future<String?> getProfileImage() async {
    final pref = await SharedPreferences.getInstance();
    return pref.getString(keyProfileImage);
  }
}
