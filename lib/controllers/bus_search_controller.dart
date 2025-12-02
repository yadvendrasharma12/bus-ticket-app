import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:get/get.dart';

import 'package:http/http.dart' as http;

import '../utils/apis_url.dart';
import '../utils/shared_prefs.dart';

import '../models/onboard_bus_model.dart';


class BusSearchController extends GetxController {
  var isLoading = false.obs;
  var busList = <OnboardBus>[].obs;

  RxList<OnboardBus> recentSearches = <OnboardBus>[].obs;

  void addRecentSearch(OnboardBus bus) {
    recentSearches.removeWhere((b) => b.id == bus.id); // Duplicate avoid
    recentSearches.insert(0, bus); // Latest on top
    if (recentSearches.length > 5) recentSearches.removeLast();
  }
  Future<void> searchBuses({
    required String origin,
    required String destination,
    required String date,
    String? token,
  }) async {
    try {
      isLoading(true);

      final savedToken = token ?? await MySharedPref.getToken();

      if (savedToken == null || savedToken.isEmpty) {
        Get.snackbar(
          "Error",
          "Missing authentication token. Please login again.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      final url = Uri.parse(
        "${ApiUrls.searchBuses}"
            "?origin=${Uri.encodeComponent(origin)}"
            "&destination=${Uri.encodeComponent(destination)}"
            "&date=${Uri.encodeComponent(date)}"
            "&page=1&limit=10",
      );

      if (kDebugMode) {
        print("🔹 Calling API: $url");
        print("🔹 Token: $savedToken");
      }

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $savedToken",
        },
      );

      if (kDebugMode) {
        print("🔹 Response Code: ${response.statusCode}");
        print("🔹 Response Body: ${response.body}");
      }

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true && data["data"] != null) {
          busList.value = List<Map<String, dynamic>>.from(data["data"])
              .map((json) => OnboardBus.fromJson(Map<String, dynamic>.from(json)))
              .toList();
          if (kDebugMode) print("✅ Bus list loaded: ${busList.length} items");
        } else {
          busList.clear();
          Get.snackbar(
            "No Buses",
            "No buses found for this route",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      } else if (response.statusCode == 401) {
        Get.snackbar(
          "Unauthorized",
          "Session expired. Please login again.",
          snackPosition: SnackPosition.BOTTOM,
        );
        await MySharedPref.clearToken();
      } else {
        Get.snackbar(
          "Error",
          "Something went wrong: ${response.statusCode}",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      if (kDebugMode) print("❌ Exception: $e");
      Get.snackbar(
        "Error",
        "Failed to fetch buses: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading(false);
    }
  }
}
