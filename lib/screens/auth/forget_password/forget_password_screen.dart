import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../bottom_bar/bottom_nav_bar_screen.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../otp/otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AuthController authController = Get.put(AuthController());

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty = emailController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  // ✅ Email validation logic only
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Email is required";
    }
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) {
      return "Please enter a valid email address";
    }
    return null;
  }

  // ✅ API call logic separated from validator
  void _handleForgetPassword() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();

      authController.forgetPassword(
        email: email,
        onSuccess: () {
          Get.offAll(() => const OtpScreen());
        },
        onError: (error) {
          Get.snackbar(
            "Error",
            error,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text("Forget Password", style: AppStyle.appBarText()),
        actions: [
          IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SizedBox(
                    width: 300,
                    child: Text(
                      "Forget password\nSLTB Express account",
                      style: AppStyle.userText1(),
                      maxLines: 2,
                      textAlign: TextAlign.start,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Input field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomTextField(
                        label: "Enter your email address",
                        hint: "Enter your email address",
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        isPassword: false,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 30),

                      // Submit button
                      Obx(() => CustomButton(
                        text: authController.isLoading.value
                            ? "Please wait..."
                            : "Sign In",
                        backgroundColor: Colors.yellow.shade800,
                        textColor: Colors.black,
                        onPressed: authController.isLoading.value
                            ? (){}
                            : _handleForgetPassword,
                      )),


                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
