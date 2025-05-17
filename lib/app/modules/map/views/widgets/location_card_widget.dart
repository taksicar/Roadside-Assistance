import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class LocationCardWidget extends GetView<MapController> {
  final bool isEditable;

  const LocationCardWidget({
    Key? key,
    this.isEditable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          if (controller.pickupLocationText.value.isNotEmpty)
            ListTile(
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
                  color: ColorManager.secondary,
                  shape: BoxShape.circle,
                ),
              ),
              onTap: isEditable ? () => controller.toggleLocationSelection(true) : null,
            ),

          // Destination location
          if (controller.destinationText.value.isNotEmpty)
            ListTile(
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
              onTap: isEditable ? () => controller.toggleLocationSelection(false) : null,
            ),
        ],
      ),
    );
  }
}