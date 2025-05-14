import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';

enum TripStatus {
  selectingLocation,
  selectingDestination,
  searchingDriver,
  driverOnTheWay,
  arrived,
}

class MapController extends GetxController {
  final mapController = Rxn<GoogleMapController>();
  final currentLocation = const LatLng(37.32, -122.03).obs; // Example location
  final destination = Rxn<LatLng>();
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  final tripStatus = TripStatus.selectingLocation.obs;

  final searchController = TextEditingController();
  final startLocationText = ''.obs;
  final destinationText = ''.obs;
  final isPickUpSelected = true.obs;

  final driverName = 'احمد محمود'.obs;
  final driverRating = '10 دقائق'.obs;
  final driverImage = 'assets/images/driver.jpg'.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with a marker at current location
    _addMarker(
      id: 'current_location',
      position: currentLocation.value,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );
  }

  @override
  void onClose() {
    mapController.value?.dispose();
    searchController.dispose();
    super.onClose();
  }

  void onMapCreated(GoogleMapController controller) {
    mapController.value = controller;
  }

  void _addMarker({
    required String id,
    required LatLng position,
    required BitmapDescriptor icon,
  }) {
    markers.add(
      Marker(
        markerId: MarkerId(id),
        position: position,
        icon: icon,
      ),
    );
  }

  void searchLocation(String address) {
    // In a real app, this would call a geocoding service
    // For this example, we'll just update the UI
    if (isPickUpSelected.value) {
      startLocationText.value = address;
    } else {
      destinationText.value = address;
    }
  }

  void confirmLocation() {
    if (tripStatus.value == TripStatus.selectingLocation) {
      // User is confirming pickup location
      tripStatus.value = TripStatus.selectingDestination;
    } else if (tripStatus.value == TripStatus.selectingDestination) {
      // User is confirming destination - start searching for driver
      tripStatus.value = TripStatus.searchingDriver;

      // Simulate finding a driver after 3 seconds
      Future.delayed(const Duration(seconds: 3), () {
        tripStatus.value = TripStatus.driverOnTheWay;
        _drawRoute();
      });
    }
  }

  void arrivedAtDestination() {
    tripStatus.value = TripStatus.arrived;
  }

  void _drawRoute() {
    // In a real app, this would use directions API
    // For this example, we'll create a simple polyline
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      color: Colors.blue,
      width: 5,
      points: [
        LatLng(currentLocation.value.latitude - 0.01, currentLocation.value.longitude - 0.01),
        LatLng(currentLocation.value.latitude - 0.005, currentLocation.value.longitude),
        currentLocation.value,
      ],
    );

    polylines.add(polyline);

    // Add driver marker
    _addMarker(
      id: 'driver',
      position: LatLng(currentLocation.value.latitude - 0.01, currentLocation.value.longitude - 0.01),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
    );
  }
}