class ApiUrls {
  // 🔹 Auth Base
  static const String baseUrl = "https://fleetbus.onrender.com/api/auth";

  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String forgetPassword = "$baseUrl/forgot-password";
  static const String veryFyOtp = "$baseUrl/verify-otp";
  static const String resetPassword = "$baseUrl/reset-password";
  static const String resendOTP = "$baseUrl/resend-otp";
  static const String profile = "$baseUrl/me";

  // 🔹 Onboard APIs
  static const String onboardBaseUrl = "https://fleetbus.onrender.com/api/onboard";
  static const String searchBuses = "$onboardBaseUrl/search";
  static const String upcoming = "$onboardBaseUrl/upcoming";

  // 🔹 Driver APIs
  static const String driverBaseUrl = "https://fleetbus.onrender.com/api/drivers/public";
  static const String driversList = "$driverBaseUrl/list";

  static const String routesBaseUrl = "https://fleetbus.onrender.com/api/routes/stops/suggest";
  static const String ticketBooking = "https://fleetbus.onrender.com/api/bookings/ticket";

}
