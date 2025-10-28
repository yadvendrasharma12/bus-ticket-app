

import 'dart:async';

import 'package:bus_booking_app/screens/auth/welcome/welcome_screen.dart';
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
    Timer(Duration(seconds: 3), () {
     Get.to(WelcomeScreen());
    });
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
            width: 154,
            height: 123,
            child: Image.asset("assets/logo/bus-logo.jpg",
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}