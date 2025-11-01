import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';

import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
import '../../../controllers/auth_controllers.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkInput);
    emailController.addListener(_checkInput);
    phoneController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
    confirmPasswordController.addListener(_checkInput);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          phoneController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          confirmPasswordController.text.isNotEmpty;
    });
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  // ✅ Validate fields & call API
  void _validateAndSignUp() {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (name.isEmpty ||
        email.isEmpty ||
        phone.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      Get.snackbar("Error", "Please fill all the fields.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (!_isValidEmail(email)) {
      Get.snackbar("Error", "Please enter a valid email address.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (!_isValidPhone(phone)) {
      Get.snackbar("Error", "Please enter a valid 10-digit phone number.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    if (password != confirmPassword) {
      Get.snackbar("Error", "Passwords do not match.",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    authController.registerUser(
      name: name,
      email: email,
      mobile: "+91$phone",
      password: password,
      onSuccess: () {
        Get.offAll(() => const BottomNavBarScreen());
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
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            Get.to(() => const LoginScreen());
          },
          child: Text(
            "Sign In",
            style: AppStyle.appBarText(),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Create your SLTB Express account", style: AppStyle.userText1()),
              const SizedBox(height: 30),

              // Fields
              CustomTextField(
                label: "Full Name",
                hint: "Enter your full name",
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Phone number",
                hint: "Enter your phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: passwordController,
                isPassword: true,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Re-enter Password",
                hint: "Confirm your password",
                controller: confirmPasswordController,
                isPassword: true,
              ),
              const SizedBox(height: 50),

              Center(
                child: Text(
                  "Let's search and book your travel ticket\nwith SLTB Express.",
                  style: AppStyle.userText2(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),

              // ✅ Reactive Sign Up Button
              Obx(() => CustomButton(
                text: authController.isLoading.value ? "Please wait..." : "Sign Up",
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,
                onPressed: authController.isLoading.value
                    ? () {}
                    : _validateAndSignUp,
              )),


              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
