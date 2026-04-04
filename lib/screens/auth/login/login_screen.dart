import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/screens/auth/create_password/create_password_screen.dart';
import 'package:bus_booking_app/screens/auth/forget_password/forget_password_screen.dart';
import 'package:bus_booking_app/screens/auth/otp/otp_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_toast.dart';

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


    if (email.isEmpty) {
      AppToast.showError(context, "Email is required");
      return;
    }


    if (!_isValidEmail(email)) {
      AppToast.showError(context, "Enter a valid email address");
      return;
    }

    if (password.isEmpty) {
      AppToast.showError(context, "Password is required");
      return;
    }


    authController.loginUser(
      email: email,
      password: password,
      onSuccess: () {
        AppToast.showSuccess(context, "Login successful ✅");
        Get.offAll(() => const BottomNavBarScreen());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: GestureDetector(
          onTap: () => Get.to(() =>  SignUpScreen()),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("Sign Up", style: AppStyle.appBarText()),
          ),
        ),

      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 21.0, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Sign in to your GR Tour & Travel",
                style: AppStyle.userText1(),
                maxLines: 2,
              ),
              const SizedBox(height: 25),

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
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Get.to(() => ForgetPasswordScreen()),
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

              Center(
                child: Text(
                  "Let's search and book your travel ticket\nGR Tour & Travel.",
                  style: AppStyle.userText2(),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 25),

              Obx(
                    () => CustomButton(
                  text: "Sign In",
                  backgroundColor: Colors.yellow.shade800,
                  textColor: Colors.black,
                  isLoading: authController.isLoading.value,
                  onPressed:  _validateAndLogin,
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}