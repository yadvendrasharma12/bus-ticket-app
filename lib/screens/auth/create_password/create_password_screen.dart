import 'package:bus_booking_app/controllers/auth_controllers.dart';
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
  final AuthController authController = Get.put(AuthController());

  bool isInputNotEmpty = false;
  late final String email;

  @override
  void initState() {
    super.initState();
    email = Get.arguments?['email'] ?? ''; // ✅ Safe initialization
    passwordController.addListener(_checkInput);
    cPasswordController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty =
          passwordController.text.isNotEmpty && cPasswordController.text.isNotEmpty;
    });
  }

  void _validateAndReset() {
    FocusScope.of(context).unfocus();

    final password = passwordController.text.trim();
    final confirmPassword = cPasswordController.text.trim();

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Please fill in both password fields."),
      ));
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Passwords do not match. Please try again."),
      ));
      return;
    }

    if (email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Something went wrong. Email not found."),
      ));
      return;
    }

    // ✅ Call reset password API
    authController.resetPassword(
      email: email,
      newPassword: password,
      onSuccess: () {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.green,
          content: Text("Password successfully reset!"),
        ));
        Future.delayed(const Duration(seconds: 1), () {
          Get.offAll(() => const LoginScreen());
        });
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(error.toString()),
        ));
      },
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Reset Password\nGR Tour & Travel",
              style: AppStyle.userText1(),
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 32),

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

            Obx(() => CustomButton(
              text: authController.isLoading.value
                  ? "Please wait..."
                  : "Reset Password",
              backgroundColor: Colors.yellow.shade800,
              textColor: Colors.black,
              onPressed:
              authController.isLoading.value ? () {} : _validateAndReset,
            )),
          ],
        ),
      ),
    );
  }
}
