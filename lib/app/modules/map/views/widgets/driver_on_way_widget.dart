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
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class DriverOnTheWayWidget extends GetView<MapController> {
  const DriverOnTheWayWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // When this widget is shown, configure the map to show only route between pickup and destination
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _configureRouteDisplay();
    });

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildRouteInfoCard(context),
        
        // Driver card
        _buildDriverCard(),

        SizedBox(height: 50.h),

      ],
    );
  }
  Widget _buildRouteInfoCard(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, -Resources.getScreenHeight(context) /1.9),
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


  void _configureRouteDisplay() async {
    // Make sure map controller is available
    if (!controller.mapControllerCompleter.isCompleted) return;

    try {
      final GoogleMapController mapController = await controller.mapControllerCompleter.future;

      // Disable my location dot/marker
      // await mapController.setMyLocationEnabled(false);

      // Clear all existing markers and polylines
      controller.markers.clear();
      controller.polylines.clear();

      // Add only pickup and destination markers
      _addPickupAndDestinationMarkers();

      // Draw direct route between pickup and destination only
      _drawDirectRoute();

      // Fit map to show the route
      controller.fitMapToShowRoute();

    } catch (e) {
      print('خطأ في إعداد عرض المسار: $e');
    }
  }

  void _addPickupAndDestinationMarkers() {
    if (controller.pickupLocation.value == null ||
        controller.destination.value == null) return;

    // Add pickup marker
    controller.markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: controller.pickupLocation.value!,
        icon: controller.pickupIcon,
        zIndex: 2,
      ),
    );

    // Add destination marker
    controller.markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: controller.destination.value!,
        icon: controller.destinationIcon,
        zIndex: 2,
      ),
    );
  }

  void _drawDirectRoute() {
    if (controller.pickupLocation.value == null ||
        controller.destination.value == null) return;

    // Calculate midpoint for curve
    final midLat = (controller.pickupLocation.value!.latitude + controller.destination.value!.latitude) / 2;
    final midLng = (controller.pickupLocation.value!.longitude + controller.destination.value!.longitude) / 2;

    // Add slight offset for a natural curve
    final latDiff = controller.destination.value!.latitude - controller.pickupLocation.value!.latitude;
    final lngDiff = controller.destination.value!.longitude - controller.pickupLocation.value!.longitude;

    // Create perpendicular offset for natural curve
    final double perpLat = -lngDiff * 0.2; // Perpendicular vector = (-dy, dx)
    final double perpLng = latDiff * 0.2;

    // Create waypoint with offset
    final waypoint = LatLng(midLat + perpLat, midLng + perpLng);

    // Create a curved route with the waypoint
    controller.polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.indigo, // Blue as in the image
        width: 5,
        points: [
          controller.pickupLocation.value!,
          waypoint,
          controller.destination.value!,
        ],
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
          // Reset map view and go back to initial state
          _resetMapView();
          controller.tripStatus.value = TripStatus.selectingLocation;
        },
      ),
    );
  }

  // Reset map view when canceling trip
  void _resetMapView() async {
    if (!controller.mapControllerCompleter.isCompleted) return;

    try {
      final GoogleMapController mapController = await controller.mapControllerCompleter.future;

      // Re-enable location if needed
      // await mapController.setMyLocationEnabled(true);

      // Clear routes and reset other map settings
      controller.markers.clear();
      controller.polylines.clear();

    } catch (e) {
      print('خطأ في إعادة ضبط عرض الخريطة: $e');
    }
  }
}