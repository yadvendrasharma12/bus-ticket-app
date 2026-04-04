import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constant/app_colors.dart';
import '../../../core/constant/app_style.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/custom_toast.dart';
import '../otp/otp_screen.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() =>
      _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  final AuthController authController = Get.put(AuthController());

  bool isEmailValid = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_checkEmail);
  }

  void _checkEmail() {
    final email = emailController.text.trim();

    final emailRegExp =
    RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    setState(() {
      isEmailValid = emailRegExp.hasMatch(email);
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  void _handleForgetPassword() {
    FocusScope.of(context).unfocus();

    final email = emailController.text.trim();

    if (email.isEmpty) {
      AppToast.showError(context, "Email is required");
      return;
    }

    if (!isEmailValid) {
      AppToast.showError(context, "Enter a valid email");
      return;
    }

    authController.forgetPassword(
      email: email,
      onSuccess: (data) {
        AppToast.showSuccess(context, "OTP sent successfully ✅");

        Get.offAll(() => const OtpScreen(), arguments: {
          'email': email,
          'otp': data['otp'],
        });
      },
      onError: (error) {
        AppToast.showError(context, error.toString());
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: AppColors.background,
        title: Text("Forget Password", style: AppStyle.appBarText()),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_outlined, color: AppColors.textBlack),
          onPressed: () {
          Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Forget password GR Tour & Travel",
              style: AppStyle.userText1(),
            ),
            const SizedBox(height: 30),

            CustomTextField(
              label: "Enter your email address",
              hint: "Email address",
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              isPassword: false,
            ),

            const SizedBox(height: 30),

            Obx(
                  () => CustomButton(
                text: "Send OTP",
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,
                isLoading: authController.isLoading.value,
                onPressed:  _handleForgetPassword,
              ),
            ),

            // Obx(() => CustomButton(
            //   text: "Forget Password",
            //   isLoading: authController.isLoading.value,
            //   backgroundColor: isEmailValid
            //       ? Colors.yellow.shade800
            //       : Colors.yellow.shade800,
            //   textColor: Colors.black,
            //   onPressed: (!isEmailValid ||
            //       authController.isLoading.value)
            //       ? null // ❌ disabled
            //       : _handleForgetPassword,
            // )),


          ],
        ),
      ),
    );
  }
}