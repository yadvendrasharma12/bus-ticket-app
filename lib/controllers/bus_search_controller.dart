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
    recentSearches.removeWhere((b) => b.id == bus.id);
    recentSearches.insert(0, bus);
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
        throw Exception("Session expired. Please login again.");
      }

      final url = Uri.parse(
        "${ApiUrls.searchBuses}"
            "?origin=${Uri.encodeComponent(origin)}"
            "&destination=${Uri.encodeComponent(destination)}"
            "&date=${Uri.encodeComponent(date)}"
            "&page=1&limit=10",
      );

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $savedToken",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data["success"] == true && data["data"] != null) {
          busList.value = List<Map<String, dynamic>>.from(data["data"])
              .map((json) => OnboardBus.fromJson(json))
              .toList();
        } else {
          busList.clear();
        }
      } else {
        throw Exception("Server error: ${response.statusCode}");
      }
    } catch (e) {
      rethrow;
    } finally {
      isLoading(false);
    }
  }
}
