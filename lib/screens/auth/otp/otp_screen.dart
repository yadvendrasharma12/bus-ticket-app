import 'dart:async';

import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../create_password/create_password_screen.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final AuthController authController = Get.put(AuthController());
  String otpCode = '';
  bool isInputNotEmpty = false;
  bool isResending = false;

  final String email = Get.arguments?['email'] ?? '';
  final String? otpFromServer = Get.arguments?['otp'];

  Timer? _timer;
  int _remainingSeconds = 59; // 59-second countdown
  bool isOtpExpired = false;

  @override
  void initState() {
    super.initState();
    _startOtpCountdown();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startOtpCountdown() {
    _remainingSeconds = 59;
    isOtpExpired = false;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        setState(() => isOtpExpired = true);
        _timer?.cancel();
      }
    });
  }

  void _validateAndProceed() {
    if (otpCode.isEmpty || otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid 6-digit OTP"),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    if (isOtpExpired) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("OTP has expired. Please request a new one."),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    authController.verifyOtp(
      email: email,
      otp: int.tryParse(otpCode) ?? 0,
      onSuccess: () {
        Get.to(() => const CreatePasswordScreen(),
          arguments: {'email': email},
        );
      },
      onError: (error) {
        Get.snackbar(
          "Error",
          error.toString(),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      },
    );
  }

  /// 🔹 Function to resend OTP
  void _resendOtp() async {
    // Show "Please wait..." SnackBar immediately
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Please wait..."),
        duration: Duration(seconds: 2),
      ),
    );

    setState(() => isResending = true);

    try {
      await authController.resendOTP(
        email: email,
        onSuccess: (data) {
          setState(() => isResending = false);
          _startOtpCountdown(); // restart timer on resend

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: const Text("OTP Resent Successfully"),
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        onError: (error) {
          setState(() => isResending = false);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text("Failed to resend OTP: $error"),
              backgroundColor: Colors.redAccent,
              duration: const Duration(seconds: 2),
            ),
          );
        },
      );
    } catch (e) {
      setState(() => isResending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,

        backgroundColor: AppColors.background,
        title: Text("OTP Verification", style: AppStyle.appBarText()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Verify OTP\nGR Tour & Travel",
                style: AppStyle.userText1()),
            const SizedBox(height: 30),

            // OTP Input Fields
            PinCodeFields(
              onChange: (value) {
                setState(() {
                  otpCode = value;
                  isInputNotEmpty = value.length == 6;
                });
              },
              onComplete: (code) {
                setState(() {
                  otpCode = code;
                  isInputNotEmpty = true;
                });
              },
              length: 6,
              fieldHeight: 50,
              fieldWidth: 45,
              keyboardType: TextInputType.number,
              activeBorderColor: Colors.yellow.shade800,
              textStyle: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 40),

            // Verify Button
            Obx(() => CustomButton(
              text: "Verify OTP",
              isLoading: authController.isLoading.value,
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.black,
              onPressed: authController.isLoading.value
                  ? () {}
                  : _validateAndProceed,
            )),

            Center(
              child: isOtpExpired
                  ? TextButton(
                onPressed: isResending ? null : _resendOtp,
                child: const Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Colors.indigo,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
                  : Text(
                "Expires in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )


          ],
        ),
      ),
    );
  }
}
