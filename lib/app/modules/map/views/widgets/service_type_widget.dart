import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
        // Location route card at top (non-editable)
        _buildRouteCard(),

        SizedBox(height: 16.h),

        // Service selection panel
        _buildServicePanel(),
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
          // Pickup location
          Obx(() => ListTile(
            leading: Icon(Icons.location_on, size: 20.sp, color: ColorManager.primary),
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
            // Disable onTap - locations are now fixed
            onTap: null,
            dense: true,
          )),

          // Divider
          Divider(height: 1),

          // Destination location
          Obx(() => ListTile(
            leading: Icon(Icons.location_on, size: 20.sp, color: ColorManager.primary.withOpacity(0.7)),
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
            // Disable onTap - locations are now fixed
            onTap: null,
            dense: true,
          )),
        ],
      ),
    );
  }

  Widget _buildServicePanel() {
    return Obx(() => Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(50.r),
          topLeft: Radius.circular(50.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        children: [
          // Handle indicator at top
          Container(
            margin: EdgeInsets.only(top: 8.h, bottom: 16.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.3),
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),


          SizedBox(height: 16.h),

          // Service options
          Column(
            children: [
              // Heavy transport option
              _buildServiceOption(
                isSelected: controller.selectedServiceType.value == ServiceType.heavy,
                title: 'ثقيل',
                subtitle: 'لنقل أوزان أكثر من 100 كيلو',
                price: '50 دولار',
                imageAsset: ImageAssets.heavy,
                onTap: () => controller.setSelectedServiceType(ServiceType.heavy),
              ),

              SizedBox(height: 12.h),

              // Light transport option
              _buildServiceOption(
                isSelected: controller.selectedServiceType.value == ServiceType.light,
                title: 'خفيف',
                subtitle: 'لنقل أوزان أقل من 100 كيلو',
                price: '40 دولار',
                imageAsset: ImageAssets.light,
                onTap: () => controller.setSelectedServiceType(ServiceType.light),
              ),
            ],
          ),

          SizedBox(height: 24.h),

          // Confirm button with dynamic text
          Padding(
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
            child: CustomButton.gradientBtn(
              text: controller.selectedServiceType.value == ServiceType.heavy
                  ? 'نقل ثقيل \$50'
                  : controller.selectedServiceType.value == ServiceType.light
                  ? 'نقل خفيف \$40'
                  : 'اختر نوع الخدمة',
              onPressed: controller.selectedServiceType.value != null
                  ? () => controller.confirmServiceType()
                  : null, // Disable if no selection
            ),
          ),
        ],
      ),
    ));
  }

  Widget _buildServiceOption({
    required bool isSelected,
    required String title,
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
        border: Border.all(
          color: isSelected ? ColorManager.primary : Colors.grey.withOpacity(0.2),
          width: isSelected ? 2.0 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: isSelected ? ColorManager.primary.withOpacity(0.1) : Colors.transparent,
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
                    // Fallback icon if image fails to load
                    return Icon(
                      title == 'ثقيل' ? Icons.fire_truck : Icons.local_shipping,
                      size: 45.sp,
                      color: ColorManager.primary,
                    );
                  },
                ),

                SizedBox(width: 12.w),

                // Service details
                Expanded(
                  child: Column(
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
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 8.w),

                // Price
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.primary,
                  ),
                ),

                if (isSelected)
                  Padding(
                    padding: EdgeInsets.only(right: 8.w),
                    child: Icon(
                      Icons.check_circle,
                      color: ColorManager.primary,
                      size: 24.sp,
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