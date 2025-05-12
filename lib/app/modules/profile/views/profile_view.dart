import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: CustomText(
          text: 'الملف الشخصي',
          color: Colors.grey[700],
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.grey[700],
            size: 22.sp,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_outline, color: Colors.indigo, size: 24.sp),
            onPressed: () {
              // Profile photo editor or view
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User account title
              Center(
                child: CustomText(
                  text: 'حساب تجريبي',
                  color: ColorManager.primary,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 24.h),

              // Profile menu items
              _buildProfileMenuItem(
                title: 'تعديل المعلومات الشخصية',
                icon: Icons.person,
                iconColor: Colors.blue,
                onTap: () => controller.goToEditProfile(),
              ),

              _buildProfileMenuItem(
                title: 'الرسائل',
                icon: Icons.message,
                iconColor: Colors.indigo,
                onTap: () => controller.goToMessages(),
              ),

              _buildProfileMenuItem(
                title: 'العناوين المفضلة',
                icon: Icons.location_on,
                iconColor: Colors.purple,
                onTap: () => controller.goToSavedAddresses(),
              ),

              _buildProfileMenuItem(
                title: 'إعدادات',
                icon: Icons.settings,
                iconColor: Colors.grey[700]!,
                onTap: () => controller.goToSettings(),
              ),

              _buildProfileMenuItem(
                title: 'مساعدة',
                icon: Icons.help_outline,
                iconColor: Colors.teal,
                onTap: () => controller.goToHelp(),
              ),

              _buildProfileMenuItem(
                title: 'تسجيل الخروج',
                icon: Icons.logout,
                iconColor: Colors.redAccent,
                onTap: () => controller.logout(),
                showBorder: false,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenuItem({
    required String title,
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
    bool showBorder = true,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h),
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
            // Icon container
            Container(
              width: 36.w,
              height: 36.h,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(child: Icon(icon, color: iconColor, size: 20.sp)),
            ),

            SizedBox(width: 16.w),

            // Menu item title
            Expanded(
              child: CustomText(
                text: title,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),

            // Arrow icon
            Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16.sp),
          ],
        ),
      ),
    );
  }
}
