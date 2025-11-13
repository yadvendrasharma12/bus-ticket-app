import 'dart:convert';
import 'package:bus_booking_app/screens/booking_confirm_screen/booking_confirm_screen.dart';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class BookingController extends GetxController {
  var isLoading = false.obs;

  Future<void> bookTicket({
    required String passengerName,
    required int age,
    required String contactNumber,
    String? altContactNumber,
    required String gender,
    String? email,
    required String city,
    required String state,
    required String scheduleId,
    required String source,
    required String destination,
    required double fare,
    required String travelDate,
    required List<String> seats, // ✅ Dynamic seats from SelectSeatsScreen
  }) async {
    try {
      if (kDebugMode) {
        print("📢 [BOOKING STARTED]");
      }
      if (kDebugMode) {
        print("------------------------------------------------");
      }

      isLoading.value = true;
      if (kDebugMode) {
        print("⏳ Loading: ${isLoading.value}");
      }

      // 🧾 Prepare request body
      final body = {
        "passengerName": passengerName.trim(),
        "age": age,
        "contactNumber": "+91${contactNumber.trim()}",
        "altContactNumber": (altContactNumber != null && altContactNumber.isNotEmpty)
            ? "+91${altContactNumber.trim()}"
            : "",
        "gender": gender,
        "email": email ?? "",
        "city": city.trim(),
        "state": state.trim(),
        "scheduleId": scheduleId,
        "source": source.trim(),
        "destination": destination.trim(),
        "seats": seats, // ✅ Use only the seats passed from screen
        "fare": fare,
        "travelDate": travelDate,
      };

      print("📝 Booking Request Body:");
      print(jsonEncode(body));

      final url = Uri.parse(ApiUrls.ticketBooking);
      print("🌍 API URL: $url");

      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (kDebugMode) {
        print("✅ Response Status Code: ${response.statusCode}");
      }
      if (kDebugMode) {
        print("✅ Raw Response Body: ${response.body}");
      }

      final result = jsonDecode(response.body);
      if (kDebugMode) {
        print("📦 Decoded JSON Response: $result");
      }

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          (result['success'] == true || result['status'] == "success")) {
        if (kDebugMode) {
          print("🎉 Booking Successful!");
        }
        Get.snackbar("✅ Success", "Ticket booked successfully!");
        Get.off(() => const BookingConfirmationScreen());
      } else {
        if (kDebugMode) {
          print("⚠️ Booking Failed!");
        }
        Get.snackbar("Error", result['message'] ?? "Booking failed");
      }
    } catch (e, stackTrace) {
      if (kDebugMode) {
        print("💥 Exception Caught: $e");
      }
      if (kDebugMode) {
        print("🧱 Stack Trace:\n$stackTrace");
      }
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      if (kDebugMode) {
        print("⏹ Loading: ${isLoading.value}");
      }
      if (kDebugMode) {
        print("------------------------------------------------");
      }
      if (kDebugMode) {
        print("📢 [BOOKING END]");
      }
    }
  }
}
