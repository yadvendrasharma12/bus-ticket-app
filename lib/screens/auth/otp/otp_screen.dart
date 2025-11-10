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
  bool isResending = false; // 🔹 To show loading for resend button

  final String email = Get.arguments?['email'] ?? '';
  final String? otpFromServer = Get.arguments?['otp']; // Optional (from backend)

  void _validateAndProceed() {
    if (otpCode.isEmpty || otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Please enter a valid 6-digit OTP"),
        backgroundColor: Colors.redAccent,
      ));
      return;
    }

    // ⚠️ Removed local OTP comparison check

    // ✅ Verify OTP via API
    authController.verifyOtp(
      email: email,
      otp: int.tryParse(otpCode) ?? 0,
      onSuccess: () {
        Get.to(
              () => const CreatePasswordScreen(),
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
    setState(() => isResending = true);

    await authController.resendOTP(
      email: email,
      onSuccess: (data) {
        setState(() => isResending = false);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),

          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), // content padding

          content: Text("OTP Resent Successfully"),
          backgroundColor: Colors.green,
        ));
      },
      onError: (error) {
        setState(() => isResending = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to resend OTP: $error"),
          backgroundColor: Colors.redAccent,
        ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("OTP Verification", style: AppStyle.appBarText()),
        leading: IconButton(
          onPressed: () => Get.back(),
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

            // ✅ OTP Input Fields
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

            // ✅ Verify Button
            Obx(() => CustomButton(
              text: authController.isLoading.value
                  ? "Please wait..."
                  : "Verify OTP",
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.black,
              onPressed: authController.isLoading.value
                  ? () {}
                  : _validateAndProceed,
            )),

            const SizedBox(height: 20),

            // ✅ Resend OTP Button
            Center(
              child: TextButton(
                onPressed: isResending ? null : _resendOtp,
                child: isResending
                    ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
                    : Text("Resend OTP",
                    style: TextStyle(
                        color: Colors.indigo.shade800,
                        fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
