import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/screens/auth/forget_password/forget_password_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:bus_booking_app/screens/homepage/home_screen.dart';
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

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  // ✅ Email validation function
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ✅ Password validation function
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  void _validateAndLogin() {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // 🟥 Check empty fields
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill in both email and password."),
        ),
      );
      return;
    }

    // 🟥 Invalid email
    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please enter a valid email address."),
        ),
      );
      return;
    }

    // 🟥 Weak password
    if (!_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              "Password must be at least 8 characters long and include:\n• 1 uppercase\n• 1 lowercase\n• 1 number\n• 1 special character."),
        ),
      );
      return;
    }

    // ✅ Success — Navigate to Home/BottomNav
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Login Successful!"),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => const BottomNavBarScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text("Sign In", style: AppStyle.appBarText()),
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
                    "Sign in to your\nSLTB Express account",
                    style: AppStyle.userText1(),
                    maxLines: 2,
                    textAlign: TextAlign.start,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🔹 Email and Password Fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 21.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                      keyboardType: TextInputType.text,
                    ),

                    const SizedBox(height: 10),

                    GestureDetector(
                      onTap: () => Get.to(() => const ForgetPasswordScreen()),
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(right: 10, top: 6),
                          child: Text(
                            "Forget password?",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w800,
                              fontSize: 17,
                              color: Colors.indigo.shade500,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    Center(
                      child: Text(
                        "Let's search and book your travel ticket\nwith SLTB Express.",
                        style: AppStyle.userText2(),
                        textAlign: TextAlign.center,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // 🔹 Login Button with validation
                    CustomButton(
                      text: "Sign In",
                      backgroundColor: Colors.yellow.shade800,
                      textColor: Colors.black,
                      onPressed: _validateAndLogin,
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
