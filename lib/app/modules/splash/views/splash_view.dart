import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 3000),
            curve: Curves.easeInOut,
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.55,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40.r),
                  bottomRight: Radius.circular(40.r),
                ),

              ),
              child: Center(
                child: Obx(() => controller.showLogo.value
                    ? TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(scale: value, child: child);
                  },
                  child: SvgPicture.asset(
                    IconAssets.logo,
                    width: 200.w,
                    height: 200.h,
                    fit: BoxFit.contain,
                    color: const Color(0xFF4842B7),
                  ),
                )
                    : const SizedBox.shrink()),
              ),
            ),
          ),

         Obx(() => AnimatedPositioned(
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
            bottom: controller.showSplashImage.value ? 0 : -300.h,
            left: 0,
            right: 0,
            child: Image.asset(
              ImageAssets.splash,
              fit: BoxFit.cover,
            ),
          )),
        ],
      ),
    );
  }
}
