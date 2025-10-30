import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../widgets/custom_button.dart';
import '../../../../widgets/custom_textfield.dart';
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
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();
    nameController.addListener(_checkInput);
    emailController.addListener(_checkInput);
    passwordController.addListener(_checkInput);
    phoneController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty = nameController.text.isNotEmpty &&
          emailController.text.isNotEmpty &&
          passwordController.text.isNotEmpty &&
          phoneController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  // ✅ Name validation
  bool _isValidName(String name) {
    final nameRegex = RegExp(r"^[a-zA-Z\s]{3,}$");
    return nameRegex.hasMatch(name);
  }

  // ✅ Email validation
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(email);
  }

  // ✅ Phone validation (10-digit)
  bool _isValidPhone(String phone) {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(phone);
  }

  // ✅ Password validation (strong password)
  bool _isValidPassword(String password) {
    final passwordRegex = RegExp(
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // 🔍 Validation and navigation
  void _validateAndSignUp() {
    FocusScope.of(context).unfocus();

    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final phone = phoneController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please fill all the fields."),
        ),
      );
      return;
    }

    if (!_isValidName(name)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please enter a valid name (min 3 letters)."),
        ),
      );
      return;
    }

    if (!_isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please enter a valid email address."),
        ),
      );
      return;
    }

    if (!_isValidPhone(phone)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text("Please enter a valid 10-digit phone number."),
        ),
      );
      return;
    }

    if (!_isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
              "Password must be at least 8 characters and include:\n• 1 uppercase • 1 lowercase • 1 number • 1 special symbol"),
        ),
      );
      return;
    }

    // ✅ If all valid
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: Colors.green,
        content: Text("Account created successfully!"),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      Get.offAll(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Sign Up",
          style: AppStyle.appBarText(),
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
              Text(
                "Let's create your\nSLTB Express account",
                style: AppStyle.userText1(),
              ),
              const SizedBox(height: 30),

              // 👤 Name Field
              CustomTextField(
                label: "Name",
                hint: "Enter your name",
                controller: nameController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 16),

              // 📧 Email Field
              CustomTextField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),

              // 📱 Phone Field
              CustomTextField(
                label: "Phone number",
                hint: "Enter your phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),

              // 🔑 Password Field
              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: passwordController,
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

              // 🟡 Sign Up Button
              CustomButton(
                text: "Sign Up",
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,
                onPressed: _validateAndSignUp,
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
