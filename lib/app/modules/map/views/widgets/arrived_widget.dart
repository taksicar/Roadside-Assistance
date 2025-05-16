import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class ArrivedWidget extends GetView<MapController> {
  const ArrivedWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
        padding: EdgeInsets.only(bottom: 20.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Success icon
            Transform.translate(
              offset: Offset(0, -80),
              child: Center(
                child: Image.asset(
                  ImageAssets.done,
                ),
              ),
            ),

            // Success message
            Transform.translate(
              offset: Offset(0, -80),
              child: CustomText(
                text: 'لقد وصلت بنجاح',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 8.h),

            // Payment amount
            Transform.translate(
              offset: Offset(0, -70),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'عليك دفع مبلغ\n',
                      style: TextStyle(fontSize: 18.sp, color: Colors.indigo),
                    ),
                    TextSpan(
                      text: controller.selectedServiceType.value == ServiceType.heavy ? '50\$' : '40\$',
                      style: TextStyle(
                        fontSize: 32.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Done button
            Transform.translate(
              offset: Offset(0, -50),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: CustomButton.gradientBtn(
                  text: 'تم',
                  onPressed: () {
                    // Reset to initial state and go to home
                    controller.tripStatus.value = TripStatus.selectingLocation;
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}