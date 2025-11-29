import 'package:bus_booking_app/models/upcomming_modal.dart';
import 'package:get/get.dart';

import '../serives/onboard_service.dart';

class OnboardController extends GetxController {
  var isLoading = true.obs;
  var allBuses = <UpCommingBus>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingBuses();
  }

  Future<void> fetchUpcomingBuses() async {
    try {
      isLoading(true);
      final data = await OnboardService.fetchUpcomingBuses();
      allBuses.assignAll(data.map((e) => UpCommingBus.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar("Errors", e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<UpCommingBus> get acBuses =>
      allBuses.where((bus) => bus.bus?.acType.toLowerCase() == 'ac').toList();

  List<UpCommingBus> get nonAcBuses =>
      allBuses.where((bus) => bus.bus?.acType.toLowerCase() == 'non-ac').toList();
}
