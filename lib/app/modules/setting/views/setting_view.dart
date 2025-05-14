import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/setting/controllers/setting_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),

              // Top navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Back button
                  Container(
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        IconAssets.arrowBack,
                        height: 20.h,
                        width: 20.w,
                      ),
                      onPressed: () {
                        Get.back();
                      },
                    ),
                  ),

                  // Profile button
                ],
              ),

              SizedBox(height: 20.h),

              // Page title
              Align(
                alignment: Alignment.topRight,
                child: CustomText(
                  text: 'الإشعارات',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 16.h),

              // Notification settings
              _buildToggleSetting(
                title: 'استقبال البريد الإلكتروني لمعلومات الرحلة',
                setting: controller.receiveEmailForTrip,
              ),

              _buildToggleSetting(
                title: 'استقبال النشرة الإخبارية',
                setting: controller.receiveNewsletter,
              ),

              _buildToggleSetting(
                title: 'استقبال رسالة الرحلة',
                setting: controller.receiveTripMessage,
              ),

              _buildToggleSetting(
                title: 'استقبال رسالة العمليات المالية للرحلة',
                setting: controller.receiveFinancialOperations,
              ),

              SizedBox(height: 24.h),

              // Map title
              Align(
                alignment: Alignment.topRight,
                child: CustomText(
                  text: 'الخارطة',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              SizedBox(height: 16.h),

              // Map settings
              _buildToggleSetting(
                title: 'التشغيل التلقائي لتحديد الموقع',
                setting: controller.autoLocationDetection,
              ),

              _buildToggleSetting(
                title: 'مشاهدة حركة المرور',
                setting: controller.showTraffic,
              ),

              _buildToggleSetting(
                title: 'الاختيار التلقائي لأقرب شارع',
                setting: controller.nearestStreetSelection,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleSetting({required String title, required RxBool setting}) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Setting title
          Expanded(
            child: CustomText(
              text: title,
              fontSize: 14,
              color: Colors.black87,
              textAlign: TextAlign.right,
            ),
          ),
          // Toggle switch
          Obx(
            () => Switch(
              value: setting.value,
              onChanged: (_) => controller.toggleSetting(setting),
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF8BC34A),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: Colors.grey[300],
            ),
          ),
        ],
      ),
    );
  }
}
