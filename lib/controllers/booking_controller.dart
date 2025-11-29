import 'dart:convert';
import 'package:bus_booking_app/screens/booking_confirm_screen/booking_confirm_screen.dart';
import 'package:bus_booking_app/utils/apis_url.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    required List<String> seats,
  }) async {
    try {
      print("📢 [BOOKING STARTED]");

      isLoading.value = true;

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("token");

      print("🔑 Saved Token: $token");

      if (token == null || token.isEmpty) {
        print("❌ Token Missing!!!");
        Get.snackbar("Error", "User not logged in! Token missing.");
        return;
      }

      if (source.trim().isEmpty || destination.trim().isEmpty) {
        print("⚠️ WARNING: source/destination EMPTY aa raha hai!");
        print("   👉 source: '$source'");
        print("   👉 destination: '$destination'");
      }

      final body = {
        "passengerName": passengerName.trim(),
        "age": age,
        "contactNumber": "+91${contactNumber.trim()}",
        "altContactNumber":
        (altContactNumber != null && altContactNumber.isNotEmpty)
            ? "+91${altContactNumber.trim()}"
            : "",
        "gender": gender,
        "email": (email ?? "").trim(),
        "city": city.trim(),
        "state": state.trim(),
        "scheduleId": scheduleId,

        "source": source.trim(),
        "destination": destination.trim(),

        "seats": seats,
        "fare": fare,
        "travelDate": travelDate,
      };

      print("📝 Booking Request Body: ${jsonEncode(body)}");

      final url = Uri.parse(ApiUrls.ticketBooking);

      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      print("📩 Sending headers: $headers");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print("📥 Status Code: ${response.statusCode}");
      print("📥 Response: ${response.body}");

      final result = jsonDecode(response.body);

      if (response.statusCode == 201 && result["success"] == true) {
        Get.snackbar("Success", "Ticket booked successfully!");
        Get.offAll(() => BookingConfirmationScreen());
      } else {
        Get.snackbar("Error", result["message"] ?? "Booking failed");
      }
    } catch (e) {
      print("💥 EXCEPTION: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      print("⏹ Loading: ${isLoading.value}");
    }
  }
}
