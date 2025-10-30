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
  bool isInputNotEmpty = false;
  String otpCode = '';

  // ✅ Dummy correct OTP (optional – for testing)
  final String correctOtp = "1234";

  void _validateAndProceed() {
    if (otpCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter OTP"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (otpCode.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("OTP must be 4 digits"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // ✅ Optional match check (you can remove this if OTP comes from backend)
    if (otpCode != correctOtp) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Invalid OTP, please try again"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    // ✅ Navigate if OTP is valid
    Get.to(const CreatePasswordScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text(
          "OTP Verification",
          style: AppStyle.appBarText(),
        ),
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
            Text(
              "Verify OTP\nSLTB Express account",
              style: AppStyle.userText1(),
            ),
            const SizedBox(height: 30),

            // 🔹 OTP Input Field
            PinCodeFields(
              onChange: (value) {
                setState(() {
                  otpCode = value;
                  isInputNotEmpty = value.length == 4;
                });
              },
              onComplete: (code) {
                otpCode = code;
                setState(() {
                  isInputNotEmpty = true;
                });
              },
              length: 4,
              fieldHeight: 60,
              fieldWidth: 55,
              keyboardType: TextInputType.number,
              obscureText: false,


              responsive: false,
              activeBorderColor: Colors.yellow.shade800,
              textStyle: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 40),

            // 🔹 Verify Button
            CustomButton(
              text: "Verify OTP",
              backgroundColor: isInputNotEmpty
                  ? Colors.yellow.shade800
                  : Colors.yellow.shade800,
              textColor: Colors.white,
              onPressed: _validateAndProceed, // ✅ Call validation
            ),

            const SizedBox(height: 10),

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
