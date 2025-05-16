import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class ServiceTypeWidget extends GetView<MapController> {
  const ServiceTypeWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Trip route card - showing pickup and destination locations
        _buildRouteCard(),

        SizedBox(height: 16.h),

        // Service type selection panel
        _buildServiceTypePanel(),
      ],
    );
  }

  Widget _buildRouteCard() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Origin point
          Obx(() => ListTile(
            leading: Icon(Icons.add, size: 20.sp, color: Colors.grey),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.pickupLocationText.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                textAlign: TextAlign.right,
              ),
            ),
            trailing: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.indigo,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              // Go back to editing pickup location
              controller.tripStatus.value = TripStatus.selectingLocation;
              controller.isPickUpSelected.value = true;
            },
          )),

          // Destination point
          Obx(() => ListTile(
            leading: Icon(Icons.clear, size: 20.sp, color: Colors.grey),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                controller.destinationText.value,
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                textAlign: TextAlign.right,
              ),
            ),
            trailing: Container(
              width: 10.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: Colors.purple,
                shape: BoxShape.circle,
              ),
            ),
            onTap: () {
              // Go back to editing destination location
              controller.tripStatus.value = TripStatus.selectingDestination;
              controller.isPickUpSelected.value = false;
            },
          )),
        ],
      ),
    );
  }

  Widget _buildServiceTypePanel() {
    return Obx(()=> Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(50.r),
            topLeft: Radius.circular(50.r),
          ),
        ),
        child: Column(
          children: [
            Divider(thickness: 3, indent: 130.w, endIndent: 130.w),
            SizedBox(
              width: double.infinity,
              child: Column(
                children: [
                  // Heavy service option
                  _buildServiceOption(
                    isSelected: controller.selectedServiceType.value == ServiceType.heavy,
                    title: 'ثقيل',
                    subtitle: 'لنقل أوزان أكثر من 100 كيلو',
                    price: '50دولار',
                    imageAsset: ImageAssets.heavy,
                    onTap: () => controller.setSelectedServiceType(ServiceType.heavy),
                  ),

                  SizedBox(height: 8.h),

                  // Light service option
                  _buildServiceOption(
                    isSelected: controller.selectedServiceType.value == ServiceType.light,
                    title: 'خفيف',
                    subtitle: 'لنقل أوزان أقل من 100 كيلو',
                    price: '40دولار',
                    imageAsset: ImageAssets.light,
                    onTap: () => controller.setSelectedServiceType(ServiceType.light),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Confirm service button
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
              child: CustomButton.gradientBtn(
                text: controller.selectedServiceType.value == ServiceType.heavy
                    ? 'نقل ثقيل \$50'
                    : 'نقل خفيف \$40',
                onPressed: () => controller.confirmServiceType(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Service option item
  Widget _buildServiceOption({
    required String title,
    required bool isSelected,
    required String subtitle,
    required String price,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isSelected ? ColorManager.secondary.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(8.r),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // Service icon/image
                Image.asset(
                  imageAsset,
                  width: 70.w,
                  height: 70.h,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      title == 'ثقيل' ? Icons.fire_truck : Icons.local_shipping,
                      size: 45.sp,
                      color: ColorManager.primary,
                    );
                  },
                ),
                12.width,

                // Service details
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                ),

                Spacer(),

                // Price
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}