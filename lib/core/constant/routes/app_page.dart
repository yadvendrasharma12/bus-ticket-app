
import 'package:get/get.dart';
import 'package:bus_booking_app/screens/splash/splash_screen.dart';
import 'package:bus_booking_app/screens/onboarding/onboarding_screen.dart';
import 'package:bus_booking_app/screens/auth/login/login_screen.dart';
import 'package:bus_booking_app/screens/auth/ragister/ragister_screen.dart';
import 'package:bus_booking_app/bottom_bar/bottom_nav_bar_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.onboarding, page: () => const OnboardingScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.signup, page: () => const SignUpScreen()),
    GetPage(name: AppRoutes.home, page: () => const BottomNavBarScreen()),
  ];
}
