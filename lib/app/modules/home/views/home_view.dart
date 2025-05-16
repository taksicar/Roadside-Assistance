import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
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

      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              10.height,
              Container(
                decoration: BoxDecoration(
                  color: ColorManager.white,

                  boxShadow: [
                    BoxShadow(
                      color: ColorManager.black.withValues(alpha: 0.12),
                      offset: Offset(0, 2),
                      blurRadius: 12,
                      spreadRadius: 1,
                    ),
                  ],
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: SvgPicture.asset(
                    IconAssets.profile,
                    height: 22.h,
                    width: 22.w,
                    fit: BoxFit.fill,
                  ),
                  onPressed: () {
                    Get.toNamed(Routes.PROFILE);
                  },
                ),
              ),
              20.height,
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
        height: 130.h,
        margin: EdgeInsets.symmetric(horizontal: 6.w),
        decoration: BoxDecoration(
          image: DecorationImage(image:AssetImage(ImageAssets.service_bg)),
          // color: ColorManager.secondary.withOpacity50,
          // color: ColorManager.white,
          
          borderRadius: BorderRadius.circular(12.r),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.black.withOpacity(0.1),
          //     blurRadius: 10,
          //     offset: const Offset(0, 4),
          //   ),
          // ],
        ),
        child: Row(
          children: [
            // Service icon
            Container(
              padding: EdgeInsets.symmetric(vertical: 8.h,horizontal: 12.w),
              child: SvgPicture.asset(icon, fit: BoxFit.contain,width: 150.w,),
            ),
            Spacer(),
            // Title and status
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomText(
                    text: title,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.white,
                  ),
                  if (!isAvailable)
                    Padding(
                      padding: EdgeInsets.only(top: 30.h),
                      child: CustomText(
                        text: 'قريبا',
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    )
                  else
                    InkWell(
                      onTap: () => Get.toNamed(Routes.MAP),
                      child: Transform.translate(
                        offset: Offset(0, 22.h),
                        child: Container(
                          // margin: EdgeInsets.only(top: 40.h),
                          padding: EdgeInsets.symmetric(
                            horizontal: 40.w,
                            vertical: 15.h,
                          ),
                          decoration: BoxDecoration(
                            color: ColorManager.primaryDark,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: CustomText(
                            text: 'دخول',
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
