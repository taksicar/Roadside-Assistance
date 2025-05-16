import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class SearchingDriverWidget extends GetView<MapController> {
  const SearchingDriverWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tow truck illustration
          Image.asset(
            ImageAssets.searchDriver,
            width: 240.w,
            height: 200.h,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: 240.w,
                height: 200.h,
                color: Colors.grey[300],
                child: Icon(
                  Icons.car_repair,
                  size: 80.sp,
                  color: Colors.grey[600],
                ),
              );
            },
          ),

          SizedBox(height: 24.h),

          // Loading indicator
          SizedBox(
            width: 240.w,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: LinearProgressIndicator(
                value: null, // Indeterminate
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primary),
                minHeight: 8.h,
              ),
            ),
          ),

          SizedBox(height: 16.h),

          // Text
          CustomText(
            text: 'جاري البحث عن سائق\nبمحيطك',
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.indigo,
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 24.h),

        ],
      ),
    );
  }
}