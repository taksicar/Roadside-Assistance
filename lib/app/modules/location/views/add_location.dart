import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/data/models/address_model.dart';
import 'package:roadside_assistance/app/modules/location/controllers/location_controller.dart';

class AddAddressView extends GetView<SavedAddressesController> {
  final bool isEdit;
  final String? addressId;


  const AddAddressView( {
    super.key,
    this.isEdit = false,
    this.addressId ,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Form(
            key: controller.addressFormKey,
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
24.height,
                        // Name field
                        _buildFormField(
                          label: 'الاسم',
                          child: TextFormField(
                            controller: controller.addressNameController,
                            decoration: InputDecoration(
                              hintText: 'البصرة1124',
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

                        SizedBox(height: 16.h),

                        // Address field
                        _buildFormField(
                          label: 'العنوان',
                          child: TextFormField(
                            controller: controller.addressDetailsController,
                            decoration: InputDecoration(
                              hintText: 'البصرة - العراق .. سندويش بنك بنار',
                              hintStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14.sp,
                              ),
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(12.w),
                                child: SvgPicture.asset(
                                  IconAssets.location,
                                  height: 24.h,
                                  width: 24.w,
                                  color: Colors.grey,
                                ),
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
                      ],
                    ),
                  ),
                ),

                // Save button
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Obx(
                        () => AbsorbPointer(
                          absorbing: controller.isLoading.value,
                          child: CustomButton.gradientBtn(
                                                text: 'حفظ',
                                                onPressed: () {
                                                  if (isEdit && addressId != null) {
                                                    controller.updateAddress(addressId!);
                                                  } else {
                                                    controller.saveAddress();
                                                  }
                                                },
                                                isDisable: controller.isLoading.value,
                                              ),
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
          fontSize: 14.sp,
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
        SizedBox(height: 8.h),
        child,
      ],
    );
  }
}