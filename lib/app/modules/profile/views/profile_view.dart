import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Top navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'حساب تجريبي',
                    color: ColorManager.primary,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
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
                ],
              ),




            45.height,

              // Card with profile menu items
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildProfileMenuItem(
                        title: 'تعديل المعلومات الشخصية',
                        iconPath: IconAssets.user,
                        iconColor: Colors.blue,
                        onTap: () => controller.goToEditProfile(),
                      ),

                      _buildProfileMenuItem(
                        title: 'الرسائل',
                        iconPath: IconAssets.chat,
                        iconColor: Colors.indigo,
                        onTap: () => controller.goToMessages(),
                      ),

                      _buildProfileMenuItem(
                        title: 'العناوين المفضلة',
                        iconPath: IconAssets.location,
                        iconColor: Colors.purple,
                        onTap: () => controller.goToSavedAddresses(),
                      ),

                      _buildProfileMenuItem(
                        title: 'إعدادات',
                        iconPath: IconAssets.setting,
                        iconColor: Colors.grey[700]!,
                        onTap: () => controller.goToSettings(),
                      ),

                      _buildProfileMenuItem(
                        title: 'مساعدة',
                        iconPath: IconAssets.support,
                        iconColor: Colors.teal,
                        onTap: () => controller.goToHelp(),
                      ),

                      _buildProfileMenuItem(
                        title: 'تسجيل الخروج',
                        iconPath: IconAssets.logout,
                        iconColor: Colors.redAccent,
                        onTap: () => controller.logout(),
                        showBorder: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required String title,
    required String iconPath,
    required Color iconColor,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        decoration: BoxDecoration(
          border:
              showBorder
                  ? Border(
                    bottom: BorderSide(
                      color: Colors.grey.withOpacity(0.2),
                      width: 1,
                    ),
                  )
                  : null,
        ),
        child: Row(
          children: [
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                // color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  height: 22.h,
                  width: 22.w,
                  fit: BoxFit.fill,
                ),
              ),
            ),

            SizedBox(width: 16.w),

            // Menu item title
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 16.sp,
                // color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
