import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:bus_booking_app/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/constant/routes/app_page.dart';
import 'core/constant/routes/app_routes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Get.put(AuthController());


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: AppRoutes.splash, // 👈 Start from splash
      getPages: AppPages.pages,
      debugShowCheckedModeBanner: false,
      title: 'Bus Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
