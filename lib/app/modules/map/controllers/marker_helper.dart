import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/modules/map/controllers/map_controller.dart';

class CustomMarkerHelper {
  static Future<BitmapDescriptor> createCustomMarkerBitmap({
    required String text,
    required Color backgroundColor,
    required Color textColor,
    double size = 80,
  }) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    final Paint paint = Paint()..color = backgroundColor;
    final double radius = size / 2;

    // Draw circle background
    canvas.drawCircle(Offset(radius, radius), radius, paint);

    // Draw the triangle at the bottom
    final Path trianglePath = Path();
    trianglePath.moveTo(radius, size + 10);
    trianglePath.lineTo(radius - 10, radius + 10);
    trianglePath.lineTo(radius + 10, radius + 10);
    trianglePath.close();
    canvas.drawPath(trianglePath, paint);

    // Draw inner circle for icon
    final Paint circlePaint = Paint()..color = textColor;
    canvas.drawCircle(Offset(radius, radius), radius * 0.5, circlePaint);

    // Convert canvas to image
    final img = await pictureRecorder.endRecording().toImage(
      size.toInt(),
      (size + 20).toInt(),
    );
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());
  }

  // Create pickup marker bitmap
  static Future<BitmapDescriptor> createPickupMarker() async {
    return createCustomMarkerBitmap(
      text: '',
      backgroundColor: Colors.deepOrange,
      textColor: Colors.white,
    );
  }

  // Create destination marker bitmap
  static Future<BitmapDescriptor> createDestinationMarker() async {
    return createCustomMarkerBitmap(
      text: '',
      backgroundColor: Colors.purple,
      textColor: Colors.white,
    );
  }

  // Create blue marker bitmap (for other markers like driver)
  static Future<BitmapDescriptor> createBlueMarker() async {
    return createCustomMarkerBitmap(
      text: '',
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
  }

  // Remove existing markers and add new ones
  static void updateMarkersOnMap(MapController controller) {
    // First, clear any existing markers except for driver marker
    // (which is needed for the route visualization)
    controller.markers.removeWhere((marker) =>
    marker.markerId.value != 'driver' &&
        marker.markerId.value != 'current_location'
    );

    // Add pickup and destination markers if they exist and we're not in location selection mode
    if (controller.pickupLocation.value != null &&
        controller.tripStatus.value != TripStatus.selectingLocation) {
      controller.updatePickupMarker(controller.pickupLocation.value!);
    }

    if (controller.destination.value != null &&
        controller.tripStatus.value != TripStatus.selectingDestination) {
      controller.updateDestinationMarker(controller.destination.value!);
    }
  }
}