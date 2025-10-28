import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/screens/auth/forget_password/forget_password_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:bus_booking_app/screens/homepage/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

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

  final TextEditingController passwordController = TextEditingController();
  final TextEditingController phonePasswordController = TextEditingController();

  bool isInputNotEmpty = false;

  @override
  void initState() {
    super.initState();

    passwordController.addListener(_checkInput);
    phonePasswordController.addListener(_checkInput);
  }

  void _checkInput() {
    setState(() {
      isInputNotEmpty =
              passwordController.text.isNotEmpty &&
              phonePasswordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    phonePasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text("Sign Up",style: AppStyle.appBarText(),),
        actions: [
          IconButton(onPressed: (){
            Get.back();
          }, icon: Icon(Icons.close))
        ],
      ),
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Align(
                        alignment: Alignment.center, // center only heading
                        child: SizedBox(
                          width: 300,
                          child: Text(

                            "Signin to your\nSLTB Express account",
                            style: AppStyle.userText1(),
                            maxLines: 2,
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 21.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // 👈 all children start from left
                    children: [
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: "Enter your phone number",
                        hint: "Enter your phone number",
                        controller: phonePasswordController,
                        keyboardType: TextInputType.phone,
                        isPassword: false,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "phone number is required";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),

                      const SizedBox(height: 8),
                      CustomTextField(
                        label: "Password",
                        hint: "Enter your password",
                        controller: passwordController,
                        keyboardType: TextInputType.text,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Password is required";
                          }
                          return null;
                        },
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
                          text: "Sign In",
                          backgroundColor:
                          isInputNotEmpty ? Colors.yellow.shade800 : Colors.yellow.shade800 ,
                          textColor: Colors.black,
                          onPressed:(){
                            Get.offAll(BottomNavBarScreen());
                          }
                      ),
                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ],
            ),
          )

      ),

      // ⭐ BottomSheet for button

    );
  }
}
