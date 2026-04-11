import 'dart:convert';
import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:bus_booking_app/utils/shared_prefs.dart';
import 'package:bus_booking_app/widgets/custom_toast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import '../screens/auth/welcome/welcome_screen.dart';

class AuthController extends GetxController {
  var userData = <String, dynamic>{
    "name": "Yadvendra Sharma",
    "location": "New Delhi",
    "profileImage": "https://example.com/photo.jpg",
  }
  .obs;
  var isLoading = false.obs;
  var isResendLoading = false.obs;
  var token = "".obs;

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  Future<void> loadToken() async {
    token.value = await MySharedPref.getToken() ?? "";
  }




  // Future<void> registerUser({
  //   required String name,
  //   required String email,
  //   required String mobile,
  //   required String password,
  //   required VoidCallback onSuccess,
  //
  // }) async {
  //   isLoading(true);
  //   try {
  //     final response = await http.post(
  //       Uri.parse(ApiUrls.register),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "name": name.trim(),
  //         "email": email.trim(),
  //         "mobile": mobile.trim(),
  //         "password": password,
  //       }),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("📩 Register Response: ${response.body}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final token = data["data"]?["token"];
  //       if (token != null && token.isNotEmpty) {
  //         await MySharedPref.saveToken(token);
  //       }
  //       AppToast.showSuccess(context, message)
  //       _showSnack("Success", data["message"] ?? "User registered successfully", Colors.green);
  //       onSuccess();
  //     } else {
  //       _showSnack("Error", data["message"] ?? "Registration failed", Colors.red);
  //     }
  //   } catch (e) {
  //     _showSnack("Error", "Something went wrong: $e", Colors.red);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> registerUser({
    required String name,
    required String email,
    required String mobile,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading(true);

      print("🚀 Starting Registration API...");
      print("📤 Payload:");
      print("Name: $name");
      print("Email: $email");
      print("Mobile: $mobile");

      final url = Uri.parse(ApiUrls.register);
      print("🌐 URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "name": name.trim(),
          "email": email.trim(),
          "mobile": mobile.trim(),
          "password": password,
        }),
      );

      print("📥 Response Status: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("📦 Parsed Response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Registration Success");

        final token = data["data"]?["token"];
        print("🔑 Token: $token");

        if (token != null && token.isNotEmpty) {
          await MySharedPref.saveToken(token);
          print("💾 Token Saved Successfully");
        } else {
          print("⚠️ Token not found in response");
        }

        onSuccess(); // ✅ call success callback
      } else {
        print("❌ API Error");
        print("❌ Message: ${data["message"]}");

        throw Exception(data["message"] ?? "Registration failed");
      }
    } catch (e, stackTrace) {
      print("🔥 Exception Occurred: $e");
      print("📍 StackTrace: $stackTrace");

      throw Exception(e.toString());
    } finally {
      isLoading(false);
      print("🔚 Registration API Completed");
    }
  }

  //
  // Future<void> loginUser({
  //   required String email,
  //   required String password,
  //   required VoidCallback onSuccess,
  // }) async {
  //   isLoading(true);
  //   try {
  //     final response = await http.post(
  //       Uri.parse(ApiUrls.login),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         "email": email.trim(),
  //         "password": password,
  //       }),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("📩 Login Response: ${response.body}");
  //
  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       final token = data["data"]?["token"];
  //       if (token != null && token.isNotEmpty) {
  //         await MySharedPref.saveToken(token);
  //       }
  //       print(token);
  //       _showSnack("Success", data["message"] ?? "Login successful", Colors.green);
  //       onSuccess();
  //     } else {
  //       _showSnack("Error", data["message"] ?? "Login failed", Colors.red);
  //     }
  //   } catch (e) {
  //     _showSnack("Error", "Something went wrong: $e", Colors.red);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> loginUser({
    required String email,
    required String password,
    required VoidCallback onSuccess,
  }) async {
    try {
      isLoading(true);

      print("🚀 Starting Login API...");
      print("📤 Payload:");
      print("Email: $email");

      final url = Uri.parse(ApiUrls.login);
      print("🌐 URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "password": password,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("📦 Parsed Response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Login Success");

        final token = data["data"]?["token"];
        print("🔑 Token: $token");

        if (token != null && token.isNotEmpty) {
          await MySharedPref.saveToken(token);
          print("💾 Token Saved Successfully");
        } else {
          print("⚠️ Token not found in response");
        }

        onSuccess();
      } else {
        print("❌ Login Failed");
        print("❌ Message: ${data["message"]}");

        throw Exception(data["message"] ?? "Login failed");
      }
    } catch (e, stackTrace) {
      print("🔥 Exception Occurred: $e");
      print("📍 StackTrace: $stackTrace");

      throw Exception(e.toString());
    } finally {
      isLoading(false);
      print("🔚 Login API Completed");
    }
  }

  Future<void> logout() async {
    await MySharedPref.clearToken();
    Get.offAll(() => LoginScreen());
  }



  Future<void> forgetPassword({
    required String email,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    try {
      isLoading(true);

      print("🚀 Starting Forget Password API...");
      print("📤 Payload:");
      print("Email: $email");

      final url = Uri.parse(ApiUrls.forgetPassword);
      print("🌐 URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("📦 Parsed Response: $data");

      if (response.statusCode == 200 && data["success"] == true) {
        print("✅ OTP Sent Successfully");

        final responseData = data["data"] ?? {};
        print("📦 Data: $responseData");

        onSuccess(responseData);
      } else {
        final message = data["message"] ?? "Failed to send OTP";

        print("❌ API Error");
        print("❌ Message: $message");

        onError(message);
      }

    } catch (e, stackTrace) {
      print("🔥 Exception Occurred: $e");
      print("📍 StackTrace: $stackTrace");

      onError("Something went wrong: $e");
    } finally {
      isLoading(false);
      print("🔚 Forget Password API Completed");
    }
  }

  // Future<void> forgetPassword({
  //   required String email,
  //   required Function(Map<String, dynamic> data) onSuccess,
  //   required Function(dynamic error) onError,
  // }) async {
  //   isLoading(true);
  //   try {
  //     final response = await http.post(
  //       Uri.parse(ApiUrls.forgetPassword),
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({"email": email.trim()}),
  //     );
  //
  //     final data = jsonDecode(response.body);
  //     print("📩 ForgetPassword Response: ${response.body}");
  //
  //     if (response.statusCode == 200 && data["success"] == true) {
  //       _showSnack("Success", data["message"], Colors.green);
  //       onSuccess(data["data"] ?? {});
  //     } else {
  //       final msg = data["message"] ?? "Failed to send OTP";
  //       _showSnack("Error", msg, Colors.red);
  //       onError(msg);
  //     }
  //   } catch (e) {
  //     _showSnack("Error", "Something went wrong: $e", Colors.red);
  //     onError(e);
  //   } finally {
  //     isLoading(false);
  //   }
  // }

  Future<void> verifyOtp({
    required String email,
    required int otp,
    required Function() onSuccess,
    required Function(dynamic error) onError,
  }) async {
    try {
      isLoading(true);

      print("🚀 Starting Verify OTP API...");
      print("📤 Payload:");
      print("Email: $email");
      print("OTP: $otp");

      final url = Uri.parse(ApiUrls.veryFyOtp);
      print("🌐 URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "otp": otp,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("📦 Parsed Response: $data");

      if (response.statusCode == 200 && data["success"] == true) {
        print("✅ OTP Verified Successfully");

        onSuccess();
      } else {
        final msg = data["message"] ?? "Invalid OTP";

        print("❌ OTP Verification Failed");
        print("❌ Message: $msg");

        onError(msg);
      }

    } catch (e, stackTrace) {
      print("🔥 Exception Occurred: $e");
      print("📍 StackTrace: $stackTrace");

      onError("Something went wrong: $e");
    } finally {
      isLoading(false);
      print("🔚 Verify OTP API Completed");
    }
  }


  Future<void> resetPassword({
    required String email,
    required String newPassword,
    required VoidCallback onSuccess,
    required Function(dynamic error) onError,
  }) async {
    try {
      isLoading(true);

      print("🚀 Starting Reset Password API...");
      print("📤 Payload:");
      print("Email: $email");
      print("New Password: ${newPassword.isNotEmpty ? '******' : 'EMPTY'}");

      final url = Uri.parse(ApiUrls.resetPassword);
      print("🌐 URL: $url");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "email": email.trim(),
          "newPassword": newPassword,
        }),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Raw Response: ${response.body}");

      final data = jsonDecode(response.body);

      print("📦 Parsed Response: $data");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Password Reset Successful");

        onSuccess();
      } else {
        final msg = data["message"] ?? "Invalid Password, please try again";

        print("❌ Reset Password Failed");
        print("❌ Message: $msg");

        onError(msg);
      }

    } catch (e, stackTrace) {
      print("🔥 Exception Occurred: $e");
      print("📍 StackTrace: $stackTrace");

      onError("Something went wrong: $e");
    } finally {
      isLoading(false);
      print("🔚 Reset Password API Completed");
    }
  }

  Future<void> resendOTP({
    required String email,
    required Function(Map<String, dynamic> data) onSuccess,
    required Function(dynamic error) onError,
  }) async {
    isResendLoading(true);
    try {
      final response = await http.post(
        Uri.parse(ApiUrls.resendOTP),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email.trim()}),
      );

      final data = jsonDecode(response.body);
      print("📩 Resend OTP Response: ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        onSuccess(data["data"] ?? {});
      } else {
        final msg = data["message"] ?? "Failed to resend OTP";

        onError(msg);
      }
    } catch (e) {

      onError(e);
    } finally {
      isResendLoading(false);
    }
  }


}
