import 'dart:async';

import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pin_code_fields/flutter_pin_code_fields.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_toast.dart';
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
  int _remainingSeconds = 59;
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
      AppToast.showError(context, "Please enter a valid 6-digit OTP");
      return;
    }

    if (isOtpExpired) {
      AppToast.showError(context, "OTP has expired. Please request a new one.");
      return;
    }

    authController.verifyOtp(
      email: email,
      otp: int.tryParse(otpCode) ?? 0,
      onSuccess: () {
        AppToast.showSuccess(context, "OTP Verified ✅");

        Get.to(() => const CreatePasswordScreen(),
            arguments: {'email': email});
      },
      onError: (error) {
        AppToast.showError(context, error.toString());
      },
    );
  }


  void _resendOtp() async {
    AppToast.showInfo(context, "Please wait...");

    setState(() => isResending = true);

    try {
      await authController.resendOTP(
        email: email,
        onSuccess: (data) {
          setState(() => isResending = false);
          _startOtpCountdown();

          AppToast.showSuccess(context, "OTP Resent Successfully");
        },
        onError: (error) {
          setState(() => isResending = false);
          AppToast.showError(context, "Failed to resend OTP");
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
        centerTitle: false,
        automaticallyImplyLeading: false,

        backgroundColor: AppColors.background,
        title: Text("OTP Verification", style: AppStyle.appBarText()),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon:  Icon(Icons.arrow_back_ios_new_outlined, color: Colors.black),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Verify OTP GR Tour & Travel",
                style: AppStyle.userText1()),
            const SizedBox(height: 30),

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
              textStyle: AppStyle.textblue()
            ),

            const SizedBox(height: 30),


            Obx(() => CustomButton(
              text: "Verify OTP",
              isLoading: authController.isLoading.value,
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.black,
              onPressed: authController.isLoading.value
                  ? () {}
                  : _validateAndProceed,
            )),
            SizedBox(height: 8,),
            // Center(
            //   child: isOtpExpired
            //       ? TextButton(
            //     onPressed: isResending ? null : _resendOtp,
            //     child: Text(
            //       "Resend OTP",
            //       style: AppStyle.textblack(),
            //     ),
            //   )
            //       : Text(
            //     "Expires in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
            //     style: AppStyle.textblack(),
            //   ),
            // )

            SizedBox(
              height: 40, // ✅ fixed height (important)
              child: Center(
                child: isOtpExpired
                    ? TextButton(
                  onPressed: isResending ? null : _resendOtp,
                  child: Text(
                    "Resend OTP",
                    style: AppStyle.textblack(),
                  ),
                )
                    : Text(
                  "Expires in 00:${_remainingSeconds.toString().padLeft(2, '0')}",
                  style: AppStyle.textblack(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
