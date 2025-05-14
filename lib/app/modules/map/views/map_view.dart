
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Google Map
          Obx(() => GoogleMap(
            initialCameraPosition: CameraPosition(
              target: controller.currentLocation.value,
              zoom: 14.0,
            ),
            onMapCreated: controller.onMapCreated,
            markers: controller.markers,
            polylines: controller.polylines,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
          )),

          // Top Navigation
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        IconAssets.profile,
                        height: 20.h,
                        width: 20.w,
                      ),
                      onPressed: () {
                        // Profile action
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Current Location Button
          Positioned(
            bottom: 120.h,
            right: 16.w,
            child: Container(
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
                  IconAssets.location,
                  height: 24.h,
                  width: 24.w,
                  color: Colors.indigo,
                ),
                onPressed: () {
                  // Center map on current location
                },
              ),
            ),
          ),

          // UI Layers based on trip status
          Obx(() {
            switch (controller.tripStatus.value) {
              case TripStatus.selectingLocation:
                return _buildSelectLocationUI(isPickup: true);
              case TripStatus.selectingDestination:
                return _buildSelectLocationUI(isPickup: false);
              case TripStatus.searchingDriver:
                return _buildSearchingDriverUI();
              case TripStatus.driverOnTheWay:
                return _buildDriverOnTheWayUI();
              case TripStatus.arrived:
                return _buildArrivedUI();
            }
          }),
        ],
      ),
    );
  }

  Widget _buildSelectLocationUI({required bool isPickup}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Search bar
        Container(
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
          child: TextField(
            controller: controller.searchController,
            textAlign: TextAlign.right,
            decoration: InputDecoration(
              hintText: isPickup
                  ? 'بغداد-حي الدراغ - ساحة الفارس'
                  : 'نقطة الوصول',
              prefixIcon: Icon(
                Icons.search,
                color: Colors.grey[600],
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 12.h,
              ),
            ),
          ),
        ),

        SizedBox(height: 8.h),

        // Location list
        Container(
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
              // Location option
              ListTile(
                leading: isPickup
                    ? const Icon(Icons.location_on_outlined, color: Colors.indigo)
                    : const Icon(Icons.search, color: Colors.indigo),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    isPickup
                        ? 'بغداد-حي الدراغ'
                        : 'نقطة الوصول',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ),
                trailing: Container(
                  width: 10.w,
                  height: 10.h,
                  decoration: const BoxDecoration(
                    color: Colors.indigo,
                    shape: BoxShape.circle,
                  ),
                ),
                onTap: () => controller.searchLocation(isPickup
                    ? 'بغداد-حي الدراغ'
                    : 'نقطة الوصول'
                ),
              ),

              // Dot separator
              Padding(
                padding: EdgeInsets.only(right: 70.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: 2.w,
                      height: 2.h,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      width: 2.w,
                      height: 2.h,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      width: 2.w,
                      height: 2.h,
                      decoration: const BoxDecoration(
                        color: Colors.indigo,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // Confirm button
        Padding(
          padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
          child: CustomButton(
            text: isPickup ? 'تثبيت الانطلاق' : 'تثبيت الوصول',
            color: ColorManager.primary,
            onPressed: () => controller.confirmLocation(),
          ),
        ),
      ],
    );
  }

  Widget _buildSearchingDriverUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tow truck illustration
          Image.asset(
            'assets/images/tow_truck.png',
            width: 240.w,
            height: 200.h,
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
        ],
      ),
    );
  }

  Widget _buildDriverOnTheWayUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Route info card
        Container(
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
                          Text(
                            '7w27+834. بغداد, الكرادة',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
                          SizedBox(width: 8.w),
                          Icon(Icons.add, size: 16.sp, color: Colors.grey),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Text(
                            '7w27+834. بغداد, زيونة',
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.right,
                          ),
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

        SizedBox(height: 16.h),

        // Driver card
        Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w),
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: ColorManager.white,
            borderRadius: BorderRadius.circular(8.r),
            boxShadow: [
              BoxShadow(
                color: ColorManager.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              // Call button
              Container(
                width: 36.w,
                height: 36.h,
                decoration: BoxDecoration(
                  color: Colors.indigo.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.phone,
                  color: Colors.indigo,
                  size: 20.sp,
                ),
              ),

              SizedBox(width: 12.w),

              // Driver info
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'احمد محمود',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    '10 دقائق',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.indigo,
                    ),
                  ),
                ],
              ),

              Spacer(),

              // Driver image
              Container(
                width: 48.w,
                height: 48.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/driver.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildArrivedUI() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32.w),
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Wallet icon
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: Colors.indigo.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/images/wallet.svg',
                  width: 40.w,
                  height: 40.h,
                  color: Colors.indigo,
                ),
              ),
            ),

            SizedBox(height: 16.h),

            // Success message
            CustomText(
              text: 'لقد وصلت بنجاح',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.indigo,
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 8.h),

            // Payment amount
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'عليك دفع مبلغ\n',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.indigo,
                    ),
                  ),
                  TextSpan(
                    text: '50\$',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}