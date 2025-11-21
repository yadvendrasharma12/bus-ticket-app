import 'package:bus_booking_app/core/constant/app_colors.dart';
import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:bus_booking_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bus-image.png"),
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end, // 👈 move to bottom
            children: [
              CustomButton(
                text: "Sign Up",
                onPressed: () {
                  Get.to(SignUpScreen());
                },
                backgroundColor: Colors.yellow.shade800,
                textColor: Colors.black,

              ),
              CustomButton(
                text: "Sign In",
                onPressed: () {
                  Get.to(LoginScreen());
                },
                backgroundColor: Colors.transparent,
                textColor: Colors.yellow.shade800,
              ),
              const SizedBox(height: 40), // 👈 thoda space bottom se
            ],
          ),
        ),
      ),
    );
  }
}
