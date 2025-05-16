import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/utils/app_values.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';


class DriverOnTheWayWidget extends GetView<MapController> {
  const DriverOnTheWayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Route info card
        _buildRouteInfoCard(context),

        // Driver card
        _buildDriverCard(),

        SizedBox(height: 16.h),

        // Cancel trip button
        _buildCancelTripButton(),
      ],
    );
  }

  Widget _buildRouteInfoCard(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -Resources.getScreenHeight(context) / 2),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.all(8.w),
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
            // Origin and destination
            Row(
              children: [
                SizedBox(width: 8.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Obx(() => Text(
                          controller.pickupLocationText.value,
                          maxLines: 5,

                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,
                          ),
                          textAlign: TextAlign.right,
                        )),
                        SizedBox(width: 8.w),
                        Icon(Icons.add, size: 16.sp, color: Colors.grey),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Obx(() => Text(
                          controller.destinationText.value,
                          maxLines: 5,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black87,

                          ),
                          textAlign: TextAlign.right,
                          overflow: TextOverflow.clip,
                        )),
                        SizedBox(width: 8.w),
                        Icon(Icons.clear, size: 16.sp, color: Colors.grey),
                      ],
                    ),
                  ],
                ),
                Spacer(),
                // Vertical dots
                Column(
                  children: [
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 2.w,
                      height: 10.h,
                      color: Colors.indigo,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 2.w,
                      height: 10.h,
                      color: Colors.indigo,
                    ),
                    SizedBox(height: 4.h),
                    Container(
                      width: 8.w,
                      height: 8.h,
                      decoration: BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16.w),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDriverCard() {
    return Container(
      margin: EdgeInsets.only(right: 40.w),
      padding: EdgeInsets.only(right: 12.w, top: 10.h, bottom: 10.h),
      decoration: BoxDecoration(
        color: ColorManager.white,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(25.r),
          bottomRight: Radius.circular(25.r),
        ),
        boxShadow: [
          BoxShadow(
            color: ColorManager.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // Driver info
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                controller.driverName.value,
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 4.h),
              Divider(),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Call button
                  InkWell(
                    onTap: () {
                      // Handle calling driver
                    },
                    child: SvgPicture.asset(
                      IconAssets.phone,
                      width: 20.w,
                      height: 20.h,
                      fit: BoxFit.fill,
                    ),
                  ),
                  80.width,

                  Text(
                    controller.driverArrivalTime.value,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: ColorManager.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          18.width,
          // Driver image
          Image.asset(ImageAssets.driver, height: 100.h),
        ],
      ),
    );
  }

  Widget _buildCancelTripButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: CustomButton(
        text: 'إلغاء الرحلة',
        color: Colors.red[400],
        onPressed: () {
          // Go back to initial state
          controller.tripStatus.value = TripStatus.selectingLocation;
        },
      ),
    );
  }
}