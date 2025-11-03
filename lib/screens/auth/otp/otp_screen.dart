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

  // ⚡ Pass email from previous screen via Get.arguments or constructor
  final String email = Get.arguments?['email'] ?? '';

  void _validateAndProceed() {
    if (otpCode.isEmpty || otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter a valid 6-digit OTP"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // ✅ Backend OTP verify API call
    authController.verifyOtp(
      email: email,
      otp: int.parse(otpCode),
      onSuccess: () {
        Get.to(() => const CreatePasswordScreen());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text("OTP Verification", style: AppStyle.appBarText()),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.black),
          )
        ],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Verify OTP\nSLTB Express account", style: AppStyle.userText1()),
            const SizedBox(height: 30),

            // 🔹 OTP Input Field
            PinCodeFields(
              onChange: (value) {
                setState(() {
                  otpCode = value;
                  isInputNotEmpty = value.length == 6;
                });
              },
              onComplete: (code) {
                otpCode = code;
                setState(() {
                  isInputNotEmpty = true;
                });
              },
              length: 6,
              fieldHeight: 30,
              fieldWidth: 55,
              keyboardType: TextInputType.number,
              activeBorderColor: Colors.yellow.shade800,
              textStyle:
              const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // 🔹 Verify Button
            const SizedBox(height: 10),
            Obx(() => CustomButton(
              text: authController.isLoading.value ? "Please wait..." : "Verify OTP",
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.black,
              onPressed: authController.isLoading.value
                  ? () {}
                  : _validateAndProceed,
            )),

            // 🔹 Resend OTP
            Center(
              child: TextButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("OTP Resent Successfully"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: Text(
                  "Resend OTP",
                  style: TextStyle(
                    color: Colors.indigo.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
