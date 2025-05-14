import 'package:get/get.dart';

class SettingsController extends GetxController {
  // Notification settings
  final receiveEmailForTrip = true.obs;
  final receiveNewsletter = true.obs;
  final receiveTripMessage = true.obs;
  final receiveFinancialOperations = true.obs;

  // Map settings
  final autoLocationDetection = true.obs;
  final showTraffic = true.obs;
  final nearestStreetSelection = true.obs;

  void toggleSetting(RxBool setting) {
    setting.value = !setting.value;
  }
}