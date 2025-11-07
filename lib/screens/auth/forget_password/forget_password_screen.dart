import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
  final AuthController authController = Get.put(AuthController());

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return "Email is required";
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value.trim())) return "Enter a valid email";
    return null;
  }

  void _handleForgetPassword() {
    if (_formKey.currentState!.validate()) {
      final email = emailController.text.trim();

      authController.forgetPassword(
        email: email,
        onSuccess: (data) {
          Get.offAll(() => const OtpScreen(), arguments: {
            'email': email,
            'otp': data['otp'], // optional: for debugging or autofill
          });
        },
        onError: (error) {
          Get.snackbar("Error", error.toString(),
              backgroundColor: Colors.redAccent, colorText: Colors.white);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text("Forget Password", style: AppStyle.appBarText()),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Forget password\nGR Tour & Travel",
                  style: AppStyle.userText1()),
              const SizedBox(height: 30),
              CustomTextField(
                label: "Enter your email address",
                hint: "Email address",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                isPassword: false,
                validator: _validateEmail,
              ),
              const SizedBox(height: 30),
              Obx(() => CustomButton(
                text: authController.isLoading.value
                    ? "Please wait..."
                    : "Send OTP",
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,
                onPressed: authController.isLoading.value
                    ? () {}
                    : _handleForgetPassword,
              )),
            ],
          ),
        ),
      ),
    );
  }
}
