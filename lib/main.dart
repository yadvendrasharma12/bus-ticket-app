import 'package:bus_booking_app/controllers/auth_controllers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'controllers/booking_controller.dart';
import 'core/constant/routes/app_page.dart';
import 'core/constant/routes/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_service.dart';
import 'screens/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(AuthController());
  Get.put(BookingController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bus Booking App',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeService().theme,
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
      home: const SplashScreen(),
    );
  }
}
