import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({super.key});

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController cPasswordController = TextEditingController();

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    passwordController.addListener(_checkInput);
    cPasswordController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty = passwordController.text.isNotEmpty &&
          cPasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    cPasswordController.dispose();
    super.dispose();
  }

  // 🔹 Password validation logic
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _validateAndReset() {
    FocusScope.of(context).unfocus();

    final password = passwordController.text.trim();
    final confirmPassword = cPasswordController.text.trim();

    // ✅ Empty fields
    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill in both password fields."),
        ),
      );
      return;
    }

    // ✅ Weak password check
    if (!_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Password must be at least 8 characters long and include:\n• 1 uppercase\n• 1 lowercase\n• 1 number\n• 1 special character",
          ),
        ),
      );
      return;
    }

    // ✅ Match check
    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Passwords do not match. Please try again."),
        ),
      );
      return;
    }

    // ✅ Success
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Password successfully reset!"),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text("Create New Password", style: AppStyle.appBarText()),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close),
          ),
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header Text
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: 300,
                  child: Text(
                    "Reset Password\nSLTB Express account",
                    style: AppStyle.userText1(),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // 🔹 Password Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: "Enter your password",
                      hint: "Enter your password",
                      controller: passwordController,
                      isPassword: true,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      label: "Confirm Password",
                      hint: "Re-enter your password",
                      controller: cPasswordController,
                      isPassword: true,
                    ),

                    const SizedBox(height: 50),

                    // 🔹 Reset Button
                    CustomButton(
                      text: "Reset Password",
                      backgroundColor: Colors.yellow.shade800,
                      textColor: Colors.black,
                      onPressed: _validateAndReset,
                    ),

                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
