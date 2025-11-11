import 'dart:async';
import 'package:bus_booking_app/screens/auth/welcome/welcome_screen.dart';
import 'package:bus_booking_app/screens/onboarding/onboarding_screen.dart';
import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'package:bus_booking_app/utils/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constant/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// ✅ Check if user already logged in
  Future<void> _checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // splash delay
    final token = await MySharedPref.getToken();

    if (token != null && token.isNotEmpty) {

      Get.offAll(() => const BottomNavBarScreen());
    } else {
      Get.offAll(() => const OnboardingScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SizedBox(
            width: 160,
            height: 126,
            child: Image.asset(
              "assets/logo/GR Tour & Travel.jpg",
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
