import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/location_card_widget.dart';

class LocationSelectionWidget extends GetView<MapController> {
  final bool isPickup;

  const LocationSelectionWidget({
    Key? key,
    required this.isPickup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Search bar
        _buildSearchBar(),

        SizedBox(height: 8.h),

        // Location selection tabs and search results
        // _buildLocationSelectionTabs(),

        SizedBox(height: 16.h),

        // Selected locations card
        if (controller.pickupLocationText.value.isNotEmpty ||
            controller.destinationText.value.isNotEmpty)
          LocationCardWidget(),

        SizedBox(height: 16.h),

        // Confirm button
        _buildConfirmButton(),
      ],
    );
  }

  Widget _buildSearchBar() {
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
      child: Row(
        children: [
          // Current location button for pickup
          if (isPickup)
            Padding(
              padding: EdgeInsets.only(left: 8.w),
              child: InkWell(
                onTap: () async {
                  if (controller.currentLocation.value != null) {
                    controller.pickupLocation.value = controller.currentLocation.value;

                    String address = await controller.getLocationAddress(controller.currentLocation.value!);
                    controller.pickupLocationText.value = address;

                    controller.updatePickupMarker(controller.currentLocation.value!);
                    controller.searchController.clear();
                  }
                },
                child: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: ColorManager.primary.withOpacity(0.1),
                  ),
                  child: Icon(
                    Icons.my_location,
                    size: 20.sp,
                    color: ColorManager.primary,
                  ),
                ),
              ),
            ),

          // Search TextField
          Expanded(
            child: TextField(
              controller: controller.searchController,
              textAlign: TextAlign.right,
              decoration: InputDecoration(
                hintText: isPickup ? 'بغداد-حي الدراغ - ساحة الفارس' : 'نقطة الوصول',
                suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
                prefixIcon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  child: CircleAvatar(
                    radius: 4.r,
                    backgroundColor: isPickup ? ColorManager.secondary : Colors.purple,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: 12.h,
                ),
              ),
              onSubmitted: (text) {
                if (text.isNotEmpty) {
                  controller.searchLocation(text);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSelectionTabs() {
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
          // Pickup/Destination Tabs
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
            child: Row(
              children: [
                // Destination tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleLocationSelection(false),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: !isPickup ? ColorManager.primary.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'نقطة الوصول',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: !isPickup ? ColorManager.primary : Colors.grey,
                          fontWeight: !isPickup ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                // Pickup tab
                Expanded(
                  child: GestureDetector(
                    onTap: () => controller.toggleLocationSelection(true),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 10.h),
                      decoration: BoxDecoration(
                        color: isPickup ? ColorManager.primary.withOpacity(0.15) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        'نقطة الانطلاق',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isPickup ? ColorManager.primary : Colors.grey,
                          fontWeight: isPickup ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Divider(height: 1),

          // Search results list
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: controller.searchResults.length,
            itemBuilder: (context, index) {
              final location = controller.searchResults[index];
              return ListTile(
                leading: Icon(
                  isPickup ? Icons.location_on_outlined : Icons.search,
                  color: isPickup ? ColorManager.secondary : Colors.purple,
                ),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    location,
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                    textAlign: TextAlign.right,
                  ),
                ),
                trailing: Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: isPickup ? ColorManager.secondary : Colors.purple,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () => controller.searchLocation(location),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
      child: CustomButton.gradientBtn(
        text: isPickup ? 'تثبيت الانطلاق' : 'تثبيت الوصول',
        // color: ColorManager.primary,
        onPressed: () => controller.confirmLocation(),
      ),
    );
  }
}