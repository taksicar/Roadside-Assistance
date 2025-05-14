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
import 'package:roadside_assistance/app/modules/location/views/add_location.dart';

class SavedAddressesView extends GetView<SavedAddressesController> {
  const SavedAddressesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
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
              ],
            ),

            24.height,

            CustomButton.gradientBtn(
              text: '+ اضافة عنوان',
              fontSize: 16.sp,
              onPressed: () => controller.goToAddAddress(),
            ),

            16.height,

            // Address Cards List
            Expanded(
              child: Obx(
                    () => controller.addresses.isEmpty
                    ? Center(
                  child: CustomText(
                    text: 'لا توجد عناوين محفوظة',
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                )
                    : ListView.builder(
                  itemCount: controller.addresses.length,
                  itemBuilder: (context, index) {
                    final address = controller.addresses[index];
                    return _buildAddressCard(address);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressCard(Address address) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: address.name,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                GestureDetector(
                  onTap: () => controller.confirmDeleteAddress(address.id, address.name),
                  child: SvgPicture.asset(
                    IconAssets.delete,
                    height: 24.h,
                    width: 24.w,
                  ),
                ),
              ],
            ),

            SizedBox(height: 4.h),
            Divider(),

            // Address details
            GestureDetector(
              onTap: () => controller.goToEditAddress(address),
              child: CustomText(
                text: address.address,
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}