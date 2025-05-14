import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/utils/app_values.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => Stack(
          children: [
            // Google Map
            controller.tripStatus.value == TripStatus.searchingDriver ? SizedBox():  Obx(() {
              if (controller.isLocationLoading.value) {
                return Center(
                  child: CircularProgressIndicator(color: ColorManager.primary),
                );
              }

              return GoogleMap(
                initialCameraPosition: controller.initialCameraPosition.value,
                markers: controller.markers,
                polylines: controller.polylines,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                compassEnabled: false,
                onMapCreated: (GoogleMapController mapController) {
                  if (!controller.mapControllerCompleter.isCompleted) {
                    controller.mapControllerCompleter.complete(mapController);
                    controller.isMapReady.value = true;
                  }
                },
              );
            }),

            // Top Navigation
            SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
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
                          Get.toNamed(Routes.PROFILE);
                        },
                      ),
                    ),

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
              ),
            ),

            // Current Location Button
            (controller.tripStatus.value == TripStatus.selectingLocation ||
                    controller.tripStatus.value ==
                        TripStatus.selectingDestination ||
                    controller.tripStatus.value ==
                        TripStatus.selectingServiceType)
                ? Positioned(
                  bottom: 210.h,
                  right: 16.w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorManager.white,
                      border: Border.all(color: ColorManager.primary),
                      borderRadius: BorderRadius.all(Radius.circular(12.r)),
                      boxShadow: [
                        BoxShadow(
                          color: ColorManager.black.withOpacity(0.12),
                          offset: const Offset(0, 2),
                          blurRadius: 12,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(
                        IconAssets.myLocation,
                        height: 24.h,
                        width: 24.w,
                        color: Colors.indigo,
                      ),
                      onPressed: controller.goToCurrentLocation,
                    ),
                  ),
                )
                : SizedBox(),

            // UI Layers based on trip status
            Obx(() {
              switch (controller.tripStatus.value) {
                case TripStatus.selectingLocation:
                  return _buildSelectLocationUI(isPickup: true);
                case TripStatus.selectingDestination:
                  return _buildSelectLocationUI(isPickup: false);
                case TripStatus.selectingServiceType:
                  return _buildSelectServiceTypeUI();
                case TripStatus.searchingDriver:
                  return _buildSearchingDriverUI();
                case TripStatus.driverOnTheWay:
                  return _buildDriverOnTheWayUI(context);
                case TripStatus.arrived:
                  return _buildArrivedUI();
              }
            }),
          ],
        ),
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
              hintText:
                  isPickup ? 'بغداد-حي الدراغ - ساحة الفارس' : 'نقطة الوصول',
              suffixIcon: Icon(Icons.search, color: Colors.grey[600]),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 18.h),
                child: CircleAvatar(
                  radius: 4.r,
                  backgroundColor: ColorManager.secondary,
                ),
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
                leading: Icon(
                  isPickup ? Icons.location_on_outlined : Icons.search,
                  color: Colors.indigo,
                ),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    isPickup ? 'بغداد-حي الدراغ' : 'نقطة الوصول',
                    style: TextStyle(fontSize: 14.sp, color: Colors.black87),
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
                onTap:
                    () => controller.searchLocation(
                      isPickup ? 'بغداد-حي الدراغ' : 'نقطة الوصول',
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

  // واجهة اختيار نوع الخدمة (ثقيل/خفيف)
  Widget _buildSelectServiceTypeUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // بطاقة عناوين الرحلة
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
              ListTile(
                leading: Icon(Icons.add, size: 20.sp, color: Colors.grey),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'بغداد, الكرادة .7W27+834',
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
              ),
              ListTile(
                leading: Icon(Icons.clear, size: 20.sp, color: Colors.grey),
                title: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'بغداد, زيونة .7W27+834',
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
              ),
            ],
          ),
        ),

        SizedBox(height: 16.h),

        // أنواع الخدمة
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w,vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(50.r),
              topLeft: Radius.circular(50.r),
            ),
            
          ),
          child: Column(
            children: [
              Divider(thickness: 3,indent: 130.w,endIndent: 130.w,),
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    // خدمة ثقيل
                    _buildServiceOption(
                      isSelected:controller.selectedServiceType ==ServiceType.heavy,

                      title: 'ثقيل',
                      subtitle: 'لنقل أوزان أكثر من 100 كيلو',
                      price: '50دولار',
                      imageAsset: ImageAssets.heavy,
                      onTap:
                          () => controller.setSelectedServiceType(ServiceType.heavy),
                    ),

                    SizedBox(height: 8.h),

                    // خدمة خفيف
                    _buildServiceOption(
                      isSelected:controller.selectedServiceType ==ServiceType.light,
                      title: 'خفيف',
                      subtitle: 'لنقل أوزان أقل من 100 كيلو',
                      price: '40دولار',
                      imageAsset: ImageAssets.light,
                      onTap:
                          () => controller.setSelectedServiceType(ServiceType.light),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              // زر تأكيد الخدمة الثقيلة
              Padding(
                padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 16.h),
                child: CustomButton.gradientBtn(
                  text:controller.selectedServiceType ==ServiceType.heavy? 'نقل ثقيل \$50':'نقل خفيف \$40',
                  onPressed:
                      () => controller.confirmServiceType(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // بناء خيار الخدمة
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
        color:isSelected? ColorManager.secondary.withOpacity20:Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8.r),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: Row(
              children: [
                // أيقونة الخدمة
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

                // تفاصيل الخدمة
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
                // السعر
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

  Widget _buildSearchingDriverUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tow truck illustration - using local asset
          Image.asset(
            ImageAssets.searchDriver,
            width: 240.w,
            height: 200.h,
            // Add fallback if image not available
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
        ],
      ),
    );
  }

  Widget _buildDriverOnTheWayUI(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Route info card
        Transform.translate(
          offset: Offset(0, -Resources.getScreenHeight(context) / 1.8),
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
        ),

        // Driver card
        Container(
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
                    'احمد محمود',
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
                      SvgPicture.asset(
                        IconAssets.phone,
                        width: 20.w,
                        height: 20.h,
                        fit: BoxFit.fill,
                      ),
                      80.width,

                      Text(
                        '10 دقائق',
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
        ),

        SizedBox(height: 16.h),
      ],
    );
  }

  Widget _buildArrivedUI() {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 40.w),
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
            Transform.translate(
              offset: Offset(0, -80),
              child: Center(
                child: Image.asset(
                  ImageAssets.done,
                ),
              ),
            ),


            // Success message
            Transform.translate(
              offset: Offset(0, -80),
              child: CustomText(
                text: 'لقد وصلت بنجاح',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.indigo,
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 8.h),

            // Payment amount
      Transform.translate(
        offset: Offset(0, -70),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'عليك دفع مبلغ\n',
                      style: TextStyle(fontSize: 18.sp, color: Colors.indigo),
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
            ),
          ],
        ),
      ),
    );
  }
}
