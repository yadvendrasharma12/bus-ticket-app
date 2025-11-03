import 'dart:convert';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:bus_booking_app/utils/shared_prefs.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../bottom_bar/bottom_nav_bar_screen.dart';
import 'package:flutter/material.dart';

import '../screens/auth/welcome/welcome_screen.dart';

class AuthController extends GetxController {
  var isLoading = false.obs;

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
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "name": name,
          "email": email,
          "mobile": mobile,
          "password": password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final token = data["data"]["token"];
        if (token != null) await MySharedPref.saveToken(token);

        Get.snackbar(
          "Success",
          data["message"] ?? "User registered successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        onSuccess();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Registration failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
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
          "email": email,
          "password": password,
        }),

      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        print(response.request);
        final token = data["data"]["token"];
        if (token != null) await MySharedPref.saveToken(token);
        print("save token: $token");


        Get.snackbar(
          "Success",
          data["message"] ?? "Login successful",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        onSuccess();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Login failed",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    await MySharedPref.clearToken();
    Get.offAll(() => const WelcomeScreen()); // or LoginScreen
  }


  Future<void> forgetPassword({
    required String email,
    required VoidCallback onSuccess, required Null Function(dynamic error) onError,
  }) async {
    isLoading(true);

    try {
      final response = await http.post(
        Uri.parse(ApiUrls.forgetPassword),
        headers: {
          'Content-Type': 'application/json'
        },
        body: jsonEncode({
          "email": email,
        }),

      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        print(response.statusCode);
        print(response.body);
        print(response.request);
        final data = jsonDecode(response.body);
        print("📩 API Response: $data");


        Get.snackbar(
          "Success",
          data["message"] ?? "  OTP Send successfully",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        onSuccess();
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "OTP Not Send",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }



    }


  Future<void> verifyOtp({
    required String email,
    required int otp,
    required VoidCallback onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.veryFyOtp),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "otp": otp,
        }),
      );

      print("🔹 Response Code: ${response.statusCode}");
      print("🔹 Response Body: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (data["success"] == true) {
          Get.snackbar(
            "Success",
            data["message"] ?? "OTP verified successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          onSuccess();
        } else {
          final errorMsg = data["message"] ?? "Invalid OTP. Please try again.";
          Get.snackbar(
            "Error",
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          onError(errorMsg);
        }
      } else {
        final errorMsg =
            data["message"] ?? "Server error: ${response.statusCode}";
        Get.snackbar(
          "Error",
          errorMsg,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        onError(errorMsg);
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Something went wrong: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      onError(e);
    } finally {
      isLoading(false);
    }
  }




  Future<void> resetPassword({
      required String email,
      required String password,
      required VoidCallback onSuccess,
      required Function(dynamic error) onError,
    }) async {
      isLoading(true);

      try {
        final response = await http.post(
          Uri.parse(ApiUrls.resetPassword),
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode({
            "email": email,
             "password": password,
          }),
        );

        final data = jsonDecode(response.body);
        print("🔹 Response: ${response.body}");

        if (response.statusCode == 200 || response.statusCode == 201) {

          Get.snackbar(
            "Success",
            data["message"] ?? "Password Reset successfully",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          onSuccess();
        } else {
          // ❌ Server returned error
          final errorMsg = data["message"] ?? "Invalid Password, please try again";
          Get.snackbar(
            "Error",
            errorMsg,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          onError(errorMsg);
        }
      } catch (e) {
        // ❌ Network or parsing error
        Get.snackbar(
          "Error",
          "Something went wrong: $e",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        onError(e);
      } finally {
        isLoading(false);
      }
    }
  }



