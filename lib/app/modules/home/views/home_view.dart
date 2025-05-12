import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leadingWidth: 40.w,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ColorManager.textPrimary,
            size: 22.sp,
          ),
          onPressed: () {
            // Handle back button
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_outline,
              color: ColorManager.textPrimary,
              size: 26.sp,
            ),
            onPressed: () {
              // Navigate to profile
              Get.toNamed(Routes.PROFILE);
            },
          ),
          SizedBox(width: 8.w),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 8.h),

              // Services list
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: controller.servicesList.length,
                separatorBuilder: (context, index) => SizedBox(height: 12.h),
                itemBuilder: (context, index) {
                  final service = controller.servicesList[index];
                  return _buildServiceCard(
                    title: service.title,
                    icon: service.icon,
                    isAvailable: service.isAvailable,
                    onTap: () => controller.onServiceSelected(index),
                  );
                },
              ),

              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard({
    required String title,
    required String icon,
    required bool isAvailable,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: isAvailable ? onTap : null,
      child: Container(
        height: 80.h,
        decoration: BoxDecoration(
          color: ColorManager.secondary,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Title and status
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomText(
                      text: title,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: ColorManager.textPrimary,
                    ),
                    SizedBox(height: 8.h),
                    if (!isAvailable)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text: 'قريبا',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    else
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.primary,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: CustomText(
                          text: 'دخول',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Service icon
            Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(12.r),
                child: Image.asset(icon, color: ColorManager.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
