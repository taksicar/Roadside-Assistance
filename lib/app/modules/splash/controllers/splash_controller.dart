import 'dart:async';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

class SplashController extends GetxController {
  final animationValue = 0.0.obs;

  final showLoading = false.obs;
  final showSplashImage = false.obs;
  final showLogo = false.obs;

  Timer? _animationTimer;
  Timer? _navigationTimer;

  @override
  void onInit() {
    super.onInit();
    _startAnimation();
  }

  @override
  void onClose() {
    if (_animationTimer != null) {
      _animationTimer!.cancel();
    }
    if (_navigationTimer != null) {
      _navigationTimer!.cancel();
    }
    super.onClose();
  }

  void _startAnimation() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    showSplashImage.value = true;

    await Future.delayed(const Duration(milliseconds: 1500));
    showLogo.value = true;

    _navigationTimer = Timer(const Duration(seconds: 4), () {
      _navigateToNextScreen();
    });
  }


  void _navigateToNextScreen() {
    print("Navigating to AUTH route");

    if (Get.routeTree.routes.any((route) => route.name == Routes.AUTH)) {
      print("AUTH route exists, navigating");
    } else {
      print("AUTH route does not exist in routes");
    }

    Get.offAllNamed(Routes.AUTH);
  }
}
