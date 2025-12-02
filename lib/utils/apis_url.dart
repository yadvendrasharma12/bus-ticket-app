class ApiUrls {
  // 🔹 Auth Base
  static const String baseUrl = "https://api.grtourtravels.com/api/auth/";

  static const String register = "$baseUrl/register";
  static const String login = "$baseUrl/login";
  static const String forgetPassword = "$baseUrl/forgot-password";
  static const String veryFyOtp = "$baseUrl/verify-otp";
  static const String resetPassword = "$baseUrl/reset-password";
  static const String resendOTP = "$baseUrl/resend-otp";
  static const String profile = "$baseUrl/me";

  // 🔹 Onboard APIs
  static const String onboardBaseUrl = "https://api.grtourtravels.com/api/onboard";
  static const String searchBuses = "$onboardBaseUrl/search";
  static const String upcoming = "$onboardBaseUrl/upcoming";

  // 🔹 Driver APIs
  static const String driverBaseUrl = "https://api.grtourtravels.com/api/drivers/public";
  static const String driversList = "$driverBaseUrl/list";

  static const String routesBaseUrl = "https://api.grtourtravels.com/api/routes/stops/suggest";
  static const String ticketBooking = "https://api.grtourtravels.com/api/bookings/ticket";
  static const String ticketHistory = "https://api.grtourtravels.com/api/bookings/history";


  static const String baseUrls = "https://api.grtourtravels.com/api";
  static const String onboard = "$baseUrls/onboard";
  static const String ratings = "$baseUrls/ratings";

  static const String baseURL = "https://api.grtourtravels.com/api";
  static const String contactInfo = "$baseURL/auth/contact-info";
}


