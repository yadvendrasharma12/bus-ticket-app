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

}
