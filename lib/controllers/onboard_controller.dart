import 'package:get/get.dart';
import '../models/onboard_bus_model.dart';
import '../serives/onboard_service.dart';


class OnboardController extends GetxController {
  var isLoading = true.obs;
  var allBuses = <OnboardBus>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUpcomingBuses();
  }

  Future<void> fetchUpcomingBuses() async {
    try {
      isLoading(true);
      final data = await OnboardService.fetchUpcomingBuses();
      allBuses.assignAll(data.map((e) => OnboardBus.fromJson(e)).toList());
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }

  List<OnboardBus> get acBuses =>
      allBuses.where((bus) => bus.bus.acType.toLowerCase() == 'ac').toList();

  List<OnboardBus> get nonAcBuses =>
      allBuses.where((bus) => bus.bus.acType.toLowerCase() == 'non-ac').toList();
}
