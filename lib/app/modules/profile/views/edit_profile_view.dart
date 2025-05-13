import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';

import '../controllers/profile_controller.dart';

class EditProfileView extends GetView<ProfileController> {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: controller.profileFormKey,
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
                    // Container(
                    //   decoration: BoxDecoration(
                    //     color: ColorManager.white,
                    //     boxShadow: [
                    //       BoxShadow(
                    //         color: ColorManager.black.withOpacity(0.12),
                    //         offset: const Offset(0, 2),
                    //         blurRadius: 12,
                    //         spreadRadius: 1,
                    //       ),
                    //     ],
                    //     shape: BoxShape.circle,
                    //   ),
                    //   child: IconButton(
                    //     icon: SvgPicture.asset(
                    //       IconAssets.profile,
                    //       height: 20.h,
                    //       width: 20.w,
                    //     ),
                    //     onPressed: () {
                    //       // Profile action
                    //     },
                    //   ),
                    // ),
                  ],
                ),

                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 24.h),

                        // Name field
                        _buildFormField(
                          label: 'الاسم',
                          child: TextFormField(
                            controller: controller.nameController,
                            decoration: InputDecoration(
                              hintText: 'احمد محمود',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ColorManager.primary,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال الاسم';
                              }
                              return null;
                            },
                          ),
                        ),

                        20.height,

                        // Email field
                        _buildFormField(
                          label: 'الإيميل',
                          child: TextFormField(
                            controller: controller.emailController,
                            decoration: InputDecoration(
                              hintText: 'ahmed@mail.com',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ColorManager.primary,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            textAlign: TextAlign.right,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال البريد الإلكتروني';
                              }
                              if (!value.contains('@') || !value.contains('.')) {
                                return 'يرجى إدخال بريد إلكتروني صحيح';
                              }
                              return null;
                            },
                          ),
                        ),

                        20.height,

                        // Phone number field
                        _buildFormField(
                          label: 'رقم الهاتف',
                          child: Row(
                            children: [
                              // Phone number input
                              Expanded(
                                child: TextFormField(
                                  // controller: controller.phoneController,
                                  decoration: InputDecoration(
                                    hintText: '770078900',
                                    hintStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 14.sp,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                      borderSide: BorderSide(
                                        color: Colors.grey[300]!,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(8.r),
                                        bottomRight: Radius.circular(8.r),
                                      ),
                                      borderSide: BorderSide(
                                        color: ColorManager.primary,
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: 12.h,
                                    ),
                                  ),
                                  textAlign: TextAlign.right,
                                  keyboardType: TextInputType.phone,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'يرجى إدخال رقم الهاتف';
                                    }
                                    return null;
                                  },
                                ),
                              ),

                              // Country code selector
                              Container(
                                height: 48.h,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey[300]!,
                                  ),
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(8.r),
                                    bottomLeft: Radius.circular(8.r),
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                                  child: Row(
                                    children: [
                                      Text(
                                        '+964',
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Container(
                                        width: 24.w,
                                        height: 16.h,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            image: AssetImage(ImageAssets.flag),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                       20.height,

                        // Address field
                        _buildFormField(
                          label: 'العنوان',
                          child: TextFormField(
                            controller: controller.addressController,
                            decoration: InputDecoration(
                              hintText: 'العراق، بغداد، المنصور، شارع 40',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.r),
                                borderSide: BorderSide(
                                  color: ColorManager.primary,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 16.w,
                                vertical: 12.h,
                              ),
                            ),
                            textAlign: TextAlign.right,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'يرجى إدخال العنوان';
                              }
                              return null;
                            },
                          ),
                        ),

                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),

                // Save button
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Obx(
                        () => CustomButton(
                      text: 'حفظ التعديلات',
                      color: ColorManager.primary,
                      onPressed: controller.isLoading.value
                          ? null
                          : () => controller.updateProfile(),
                      isDisable: controller.isLoading.value,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
10.height,        child,
      ],
    );
  }
}