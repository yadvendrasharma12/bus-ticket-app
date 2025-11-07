import 'dart:convert';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:bus_booking_app/utils/shared_prefs.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../screens/auth/welcome/welcome_screen.dart';

class AuthController extends GetxController {
  var userData = <String, dynamic>{
    "name": "Yadvendra Sharma",
    "location": "New Delhi",
    "profileImage": "https://example.com/photo.jpg", // or local path
  }.obs;
  var isLoading = false.obs;
  var token = "".obs; // ✅ Added token variable

  @override
  void onInit() {
    super.onInit();
    loadToken(); // ✅ Load token automatically on start
  }

  Future<void> loadToken() async {
    token.value = await MySharedPref.getToken() ?? "";
  }

  void _showSnack(String title, String message, Color color) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: color,
      colorText: Colors.white,
    );
  }

  // ✅ REGISTER USER
  Future<void> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.register),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name.trim(),
          "email": email.trim(),
          "mobile": mobile.trim(),
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("📩 Register Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data["data"]?["token"];
        if (token != null && token.isNotEmpty) {
          await MySharedPref.saveToken(token);
        }
        _showSnack("Success", data["message"] ?? "User registered successfully", Colors.green);
        onSuccess();
      } else {
        _showSnack("Error", data["message"] ?? "Registration failed", Colors.red);
      }
    } catch (e) {
      _showSnack("Error", "Something went wrong: $e", Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // ✅ LOGIN USER
  Future<void> loginUser({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.login),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);
      print("📩 Login Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data["data"]?["token"];
        if (token != null && token.isNotEmpty) {
          await MySharedPref.saveToken(token);
        }
        print(token);
        _showSnack("Success", data["message"] ?? "Login successful", Colors.green);
        onSuccess();
      } else {
        _showSnack("Error", data["message"] ?? "Login failed", Colors.red);
      }
    } catch (e) {
      _showSnack("Error", "Something went wrong: $e", Colors.red);
    } finally {
      isLoading(false);
    }
  }

  // ✅ LOGOUT
  Future<void> logout() async {
    await MySharedPref.clearToken();
    Get.offAll(() => const WelcomeScreen());
  }

  // ✅ FORGET PASSWORD → send OTP
  Future<void> forgetPassword({
    required String email,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.forgetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email.trim()}),
      );

      final data = jsonDecode(response.body);
      print("📩 ForgetPassword Response: ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        _showSnack("Success", data["message"], Colors.green);
        onSuccess(data["data"] ?? {});
      } else {
        final msg = data["message"] ?? "Failed to send OTP";
        _showSnack("Error", msg, Colors.red);
        onError(msg);
      }
    } catch (e) {
      _showSnack("Error", "Something went wrong: $e", Colors.red);
      onError(e);
    } finally {
      isLoading(false);
    }
  }

  // ✅ VERIFY OTP
  Future<void> verifyOtp({
    required String email,
    required int otp,
    required Function() onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse("https://fleetbus.onrender.com/api/auth/verify-otp"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "otp": otp,
        }),
      );

      final data = jsonDecode(response.body);
      print("🔍 Verify OTP Response: ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        _showSnack("Success", data["message"], Colors.green);
        onSuccess();
      } else {
        final msg = data["message"] ?? "Invalid OTP";
        _showSnack("Error", msg, Colors.red);
        onError(msg);
      }
    } catch (e) {
      _showSnack("Error", "Something went wrong: $e", Colors.red);
      onError(e);
    } finally {
      isLoading(false);
    }
  }


  // ✅ RESET PASSWORD
  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required VoidCallback onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.resetPassword),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "newPassword": newPassword, // ✅ backend expects this key
        }),
      );

      final data = jsonDecode(response.body);
      print("📩 ResetPassword Response: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        onSuccess();
      } else {
        final msg = data["message"] ?? "Invalid Password, please try again";
        onError(msg);
      }
    } catch (e) {
      onError("Something went wrong: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> resendOTP({
    required String email,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse("https://fleetbus.onrender.com/api/auth/resend-otp"), // ✅ Updated endpoint
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email.trim()}),
      );

      final data = jsonDecode(response.body);
      print("📩 Resend OTP Response: ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        _showSnack("Success", data["message"], Colors.green);
        onSuccess(data["data"] ?? {});
      } else {
        final msg = data["message"] ?? "Failed to resend OTP";
        _showSnack("Error", msg, Colors.red);
        onError(msg);
      }
    } catch (e) {
      _showSnack("Error", "Something went wrong: $e", Colors.red);
      onError(e);
    } finally {
      isLoading(false);
    }
  }


}
