import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
          child: Form(
            key: controller.profileFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name field
                _buildFormField(
                  label: 'الاسم',
                  child: TextFormField(
                    controller: controller.nameController,
                    decoration: InputDecoration(
                      hintText: 'أحمد محمود',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
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

                SizedBox(height: 16.h),

                // Email field
                _buildFormField(
                  label: 'الإيميل',
                  child: TextFormField(
                    controller: controller.emailController,
                    decoration: InputDecoration(
                      hintText: 'ahmed@mail.com',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
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
                      // Basic email validation
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'يرجى إدخال بريد إلكتروني صحيح';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 16.h),

                // Phone number field
                // _buildFormField(
                //   label: 'رقم الهاتف',
                //   child: Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(color: Colors.grey[300]!),
                //       borderRadius: BorderRadius.circular(8.r),
                //     ),
                //     child: Directionality(
                //       textDirection: TextDirection.ltr,
                //       child: InternationalPhoneNumberInput(
                //         onInputChanged: (PhoneNumber number) {
                //           controller.phoneNumber.value =
                //               number.phoneNumber ?? '';
                //         },
                //         selectorConfig: const SelectorConfig(
                //           selectorType: PhoneInputSelectorType.DROPDOWN,
                //         ),
                //         ignoreBlank: false,
                //         autoValidateMode: AutovalidateMode.disabled,
                //         initialValue: PhoneNumber(
                //           isoCode: 'IQ',
                //           dialCode: '+964',
                //           phoneNumber: '770078900',
                //         ),
                //         textStyle: TextStyle(fontSize: 14.sp),
                //         inputDecoration: InputDecoration(
                //           border: InputBorder.none,
                //           contentPadding: EdgeInsets.symmetric(
                //             horizontal: 16.w,
                //             vertical: 12.h,
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(height: 16.h),

                // Address field
                _buildFormField(
                  label: 'العنوان',
                  child: TextFormField(
                    controller: controller.addressController,
                    decoration: InputDecoration(
                      hintText: 'العراق، بغداد، المنصور، شارع 40',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
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

                // Save button
                Obx(
                  () => CustomButton(
                    text: 'حفظ التعديلات',
                    color: ColorManager.primary,
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.updateProfile(),
                    isDisable: controller.isLoading.value,
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
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomText(
          text: label,
          fontSize: 14,
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }
}
