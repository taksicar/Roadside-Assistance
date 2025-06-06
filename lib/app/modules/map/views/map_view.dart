import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/arrived_widget.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/driver_on_way_widget.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/location_selection_widget.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/marker_widget.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/search_driver_widget.dart';
import 'package:roadside_assistance/app/modules/map/views/widgets/service_type_widget.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {

        return Stack(
          children: [
            // Google Map
            controller.tripStatus.value == TripStatus.searchingDriver
                ? SizedBox()
                : Obx(() {
                  if (controller.isLocationLoading.value) {
                    return Center(
                      child: CircularProgressIndicator(
                        color: ColorManager.primary,
                      ),
                    );
                  }

                  return Obx(
                    () => GoogleMap(
                      initialCameraPosition:
                          controller.initialCameraPosition.value,
                      markers: controller.markers,
                      polylines: controller.polylines,
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      zoomControlsEnabled: false,
                      mapToolbarEnabled: false,
                      compassEnabled: false,
                      onMapCreated: (GoogleMapController mapController) {
                        if (!controller.mapControllerCompleter.isCompleted) {
                          controller.mapControllerCompleter.complete(
                            mapController,
                          );
                          controller.isMapReady.value = true;
                          print('تم تهيئة الخريطة بنجاح!');
                        }
                      },
                      // Add camera movement tracking for marker animation
                      onCameraMove: controller.onCameraMove,
                      onCameraIdle: controller.onCameraIdle,
                      // Remove onTap handler as we'll use the center marker
                    ),
                  );
                }),

            // Center Marker (Fixed in the center of the screen)
            controller.isLocationLoading.value ?  SizedBox():_buildCenterMarker() ,

            // Top Navigation
            _buildTopNavigation(),

            // Current Location Button
            _buildCurrentLocationButton(),

            // UI Layers based on trip status
            Obx(() {
              switch (controller.tripStatus.value) {
                case TripStatus.selectingLocation:
                  return LocationSelectionWidget(isPickup: true);
                case TripStatus.selectingDestination:
                  return LocationSelectionWidget(isPickup: false);
                case TripStatus.selectingServiceType:
                  return ServiceTypeWidget();
                case TripStatus.searchingDriver:
                  return SearchingDriverWidget();
                case TripStatus.driverOnTheWay:
                  return DriverOnTheWayWidget();
                case TripStatus.arrived:
                  return ArrivedWidget();
              }
            }),
          ],
        );
      }),
    );
  }

  // Add the center marker widget
  Widget _buildCenterMarker() {
    return Obx(() {
      // Only show the center marker during location selection
      if (controller.tripStatus.value == TripStatus.selectingLocation ||
          controller.tripStatus.value == TripStatus.selectingDestination) {
        return Center(
          child: CenterMarkerWidget(
            isPickup: controller.isPickUpSelected.value,
            isMoving: controller.isCameraMoving.value,
            liftHeight: controller.centerMarkerHeight.value,
          ),
        );
      } else {
        return const SizedBox.shrink();
      }
    });
  }

  Widget _buildTopNavigation() {
    return SafeArea(
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
    );
  }

  Widget _buildCurrentLocationButton() {
    return (controller.tripStatus.value == TripStatus.selectingLocation ||
            controller.tripStatus.value == TripStatus.selectingDestination ||
            controller.tripStatus.value == TripStatus.selectingServiceType)
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
        : SizedBox();
  }
}
