import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/screens/auth/forget_password/forget_password_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }


  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  void _validateAndLogin() {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        "Error",
        "Please fill in both email and password.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5), // smaller margins
        borderRadius: 10, // rounded corners
        snackStyle: SnackStyle.FLOATING, // floating snackbar
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5), // content padding
        maxWidth: 300, // max width of snackbar
        duration: const Duration(seconds: 2), // shorter duration
      );
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar(
        "Error",
        "Please enter a valid email address.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        borderRadius: 10,
        snackStyle: SnackStyle.FLOATING,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        maxWidth: 300,
        duration: const Duration(seconds: 2),
      );
      return;
    }

    // ✅ Call API
    authController.loginUser(
      email: email,
      password: password,
      onSuccess: () {
        Get.offAll(() => const BottomNavBarScreen());
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onTap: () {
            Get.to(() => const SignUpScreen());
          },
          child: Text("Sign Up", style: AppStyle.appBarText()),
        ),
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
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🔹 Header
              Text(
                "Sign in to your\nGR Tour & Travel",
                style: AppStyle.userText1(),
                maxLines: 2,
              ),
              const SizedBox(height: 25),

              // 🔹 Input Fields
              CustomTextField(
                label: "Email Address",
                hint: "Enter your email address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: passwordController,
                isPassword: true,
              ),

              // 🔹 Forget password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => const ForgetPasswordScreen()),
                  child: Text(
                    "Forgot password?",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Colors.indigo.shade500,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🔹 Info Text
              Center(
                child: Text(
                  "Let's search and book your travel ticket\nGR Tour & Travel.",
                  style: AppStyle.userText2(),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              // 🔹 Button
              Obx(() => CustomButton(
                text: authController.isLoading.value
                    ? "Please wait..."
                    : "Sign In",
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,
                onPressed: authController.isLoading.value
                    ? (){}
                    : _validateAndLogin,
              )),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
