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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        elevation: 0,
        title: Text(
          "Sign In",
          style: AppStyle.appBarText(),
        ),
        actions: [
          IconButton(
            onPressed: () => Get.back(),
            icon: const Icon(Icons.close, color: Colors.black),
          ),
        ],
      ),

      // ✅ Use SafeArea + SingleChildScrollView for proper layout
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

              // ✅ Input Fields
              CustomTextField(
                label: "Name",
                hint: "Enter your name",
                controller: nameController,
                keyboardType: TextInputType.name,
                validator: (value) =>
                value == null || value.isEmpty ? "Name is required" : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Email",
                hint: "Enter your email",
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                validator: (value) =>
                value == null || value.isEmpty ? "Email is required" : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Phone number",
                hint: "Enter your phone number",
                controller: phoneController,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? "Phone number is required"
                    : null,
              ),
              const SizedBox(height: 16),

              CustomTextField(
                label: "Password",
                hint: "Enter your password",
                controller: passwordController,
                isPassword: true,
                validator: (value) => value == null || value.isEmpty
                    ? "Password is required"
                    : null,
              ),
              const SizedBox(height: 50),

              Center(
                child: Text(
                  "Let's search and book your travel ticket\nwith tickets.",
                  style: AppStyle.userText2(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),


              CustomButton(
                text: "Sign Up",
                backgroundColor:
                isInputNotEmpty ? Colors.yellow.shade800 : Colors.yellow.shade800 ,
                textColor: Colors.black,
                onPressed:(){}
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
