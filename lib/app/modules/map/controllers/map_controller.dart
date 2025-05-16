import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart' as l;
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:geocoding/geocoding.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

enum TripStatus {
  selectingLocation,
  selectingDestination,
  selectingServiceType,
  searchingDriver,
  driverOnTheWay,
  arrived,
}

enum ServiceType {
  heavy,
  light,
}

class MapController extends GetxController {

   Completer<GoogleMapController> mapControllerCompleter = Completer<GoogleMapController>();
  final Rx<CameraPosition> initialCameraPosition = CameraPosition(
    target: LatLng(33.3152, 44.3661),
    zoom: 18.0,
  ).obs;


  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;
  late BitmapDescriptor pickupIcon;
  late BitmapDescriptor destinationIcon;
  late BitmapDescriptor driverIcon;
  final _markersLoaded = false.obs;


  final double markerSize = 100.0;
  final double iconSize = 50.0;


  final currentLocation = Rxn<LatLng>();
  final pickupLocation = Rxn<LatLng>();
  final destination = Rxn<LatLng>();


  final tripStatus = TripStatus.selectingLocation.obs;


  final selectedServiceType = Rx<ServiceType?>(null);


  final location = l.Location();


  final searchController = TextEditingController();
  final pickupLocationText = ''.obs;
  final destinationText = ''.obs;
  final isPickUpSelected = true.obs;


  final driverName = 'احمد محمود'.obs;
  final driverArrivalTime = '10 دقائق'.obs;
  final driverImage = 'assets/images/driver.jpg'.obs;


  final heavyServicePrice = '50 دولار'.obs;
  final lightServicePrice = '40 دولار'.obs;


  final isMapReady = false.obs;
  final isLocationLoading = false.obs;


  final searchResults = <String>['بغداد-حي الدراغ - ساحة الفارس', 'بغداد, الكرادة', 'بغداد, زيونة'].obs;

  @override
  void onInit() {
    super.onInit();

    customMarker().then((_) {
      _setupLocationService();
    });


    searchController.addListener(_onSearchTextChanged);
  }

  @override
  void onClose() {
    searchController.removeListener(_onSearchTextChanged);
    searchController.dispose();
    super.onClose();
  }


  void _onSearchTextChanged() {
    if (searchController.text.isEmpty) {
      searchResults.clear();
      return;
    }

    // البحث عن النتائج المطابقة
    final query = searchController.text.toLowerCase();
    final matches = [
      'بغداد-حي الدراغ - ساحة الفارس',
      'بغداد, الكرادة',
      'بغداد, زيونة',
    ].where((place) => place.toLowerCase().contains(query)).toList();

    searchResults.value = matches;

    // إذا كان لدينا نتيجة واحدة فقط متطابقة بشكل كامل، ننتقل إليها مباشرة
    if (matches.length == 1 && matches[0].toLowerCase() == query) {
      searchLocation(matches[0]);
    }
    // أو إذا كان هناك أي نتائج، نذهب إلى أول نتيجة (لجعل التطبيق أكثر استجابة)
    else if (matches.isNotEmpty && searchController.text.length > 3) {
      // الانتقال إلى الموقع الأول في النتائج بعد تأخير قصير
      // لتجنب الانتقال المستمر أثناء الكتابة
      Future.delayed(Duration(milliseconds: 500), () {
        // تحقق من أن النص لم يتغير خلال فترة التأخير
        if (searchController.text.toLowerCase() == query) {
          searchLocation(matches[0]);
        }
      });
    }
  }


  Future<void> customMarker() async {
    try {

      final ImageConfiguration largeConfig = ImageConfiguration(
        size: Size(markerSize, markerSize),
        devicePixelRatio: 3.0,
      );


      final Uint8List pickupIconBytes = await getBytesFromAsset(ImageAssets.LocationSign, markerSize.toInt());
      pickupIcon = BitmapDescriptor.fromBytes(pickupIconBytes);


      final Uint8List destinationIconBytes = await getBytesFromAsset(ImageAssets.locationLogo, markerSize.toInt());
      destinationIcon = BitmapDescriptor.fromBytes(destinationIconBytes);



      driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);

      _markersLoaded.value = true;


      if (currentLocation.value != null) {
        _updateCurrentLocationMarker();
      }

      if (pickupLocation.value != null) {
        updatePickupMarker(pickupLocation.value!);
      }

      if (destination.value != null) {
        updateDestinationMarker(destination.value!);
      }
    } catch (e) {
      print('Error loading custom markers: $e');

      pickupIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen);
      destinationIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed);
      driverIcon = BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue);
      _markersLoaded.value = true;
    }
  }


  Future<void> _setupLocationService() async {
    isLocationLoading.value = true;

    bool _serviceEnabled;
    l.PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        isLocationLoading.value = false;
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == l.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != l.PermissionStatus .granted) {
        isLocationLoading.value = false;
        return;
      }
    }


    try {
      final locationData = await location.getLocation();
      LatLng initialLocation = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );


      currentLocation.value = initialLocation;



      pickupLocation.value = LatLng(initialLocation.latitude, initialLocation.longitude);
      pickupLocationText.value = 'موقعي الحالي';


      initialCameraPosition.value = CameraPosition(
        target: initialLocation,
        zoom: 15.0,
      );


      _addMarkerForCurrentLocation();


      if (_markersLoaded.value) {
        updatePickupMarker(pickupLocation.value!);
      }


      location.onLocationChanged.listen((l.LocationData newLocation) {
        LatLng newLatLng = LatLng(
          newLocation.latitude!,
          newLocation.longitude!,
        );


        currentLocation.value = newLatLng;
        _updateCurrentLocationMarker();


        if (pickupLocationText.value == 'موقعي الحالي') {

          pickupLocation.value = LatLng(newLatLng.latitude, newLatLng.longitude);
          if (_markersLoaded.value) {
            updatePickupMarker(pickupLocation.value!);
          }


          if (destination.value != null &&
              (tripStatus.value == TripStatus.selectingDestination ||
                  tripStatus.value == TripStatus.selectingServiceType)) {
            drawRouteBetweenPickupAndDestination();
          }
        }
      });
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLocationLoading.value = false;
    }
  }


  void _addMarkerForCurrentLocation() {
    if (currentLocation.value == null || !_markersLoaded.value) return;

    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentLocation.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        alpha: 0.7,
        infoWindow: const InfoWindow(title: 'موقعي الحالي'),
        zIndex: 1,

      ),
    );
  }


  void _updateCurrentLocationMarker() {
    if (currentLocation.value == null || !_markersLoaded.value) return;


    markers.removeWhere((marker) => marker.markerId.value == 'current_location');


    _addMarkerForCurrentLocation();
  }


  Future<void> goToCurrentLocation() async {
    if (currentLocation.value == null) return;

    final GoogleMapController controller = await mapControllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(currentLocation.value!, 18),
    );


    if (tripStatus.value == TripStatus.selectingLocation) {

      LatLng locationCopy = LatLng(
          currentLocation.value!.latitude,
          currentLocation.value!.longitude
      );

      pickupLocation.value = locationCopy;
      pickupLocationText.value = 'موقعي الحالي';


      if (_markersLoaded.value) {
        updatePickupMarker(locationCopy);
      }
    }
  }

  // Future<void> searchLocation(String query) async {
  //   try {
  //     // البحث عن المكان باستخدام Geocoding
  //     List<Location> locations = await locationFromAddress(query);
  //
  //     if (locations.isNotEmpty) {
  //       // الحصول على الموقع الأول من النتائج
  //       Location location = locations.first;
  //       LatLng position = LatLng(location.latitude, location.longitude);
  //
  //       // تحديث الموقع المختار (انطلاق أو وصول)
  //       if (isPickUpSelected.value) {
  //         pickupLocation.value = position;
  //         pickupLocationText.value = query; // استخدام نص البحث كاسم للمكان
  //         updatePickupMarker(position);
  //       } else {
  //         destination.value = position;
  //         destinationText.value = query; // استخدام نص البحث كاسم للمكان
  //         updateDestinationMarker(position);
  //       }
  //
  //       // تحريك الخريطة إلى الموقع المختار
  //       moveMapToLocation(position);
  //
  //       // رسم المسار إذا تم تحديد نقطتي الانطلاق والوصول
  //       if (pickupLocation.value != null && destination.value != null) {
  //         drawRouteBetweenPickupAndDestination();
  //       }
  //
  //       // مسح نتائج البحث
  //       searchResults.clear();
  //       searchController.clear();
  //     }
  //   } catch (e) {
  //     print('خطأ في البحث عن المكان: $e');
  //   }
  // }

  Future<void> searchLocation(String query) async {
    // Show loading indicator
    isLocationLoading.value = true;

    try {
      // Use Google Places API for more comprehensive results
      // This is a placeholder - you'd need to implement the Places API
      List<Location> locations = await locationFromAddress(query);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng position = LatLng(location.latitude, location.longitude);

        // Update the selected location (pickup or destination)
        if (isPickUpSelected.value) {
          pickupLocation.value = position;
          pickupLocationText.value = query;
          updatePickupMarker(position);
        } else {
          destination.value = position;
          destinationText.value = query;
          updateDestinationMarker(position);
        }

        // Move map to the selected location
        moveMapToLocation(position);

        // Draw route if both pickup and destination are set
        if (pickupLocation.value != null && destination.value != null) {
          drawRouteBetweenPickupAndDestination();
        }

        // Clear search results and search controller
        searchResults.clear();
        searchController.clear();
      } else {
        // Handle no results found
        Get.snackbar(
          'لم يتم العثور على المكان',
          'يرجى المحاولة بكلمات مختلفة أو تحديد الموقع على الخريطة',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      print('خطأ في البحث عن المكان: $e');
      Get.snackbar(
        'خطأ في البحث',
        'حدث خطأ أثناء البحث، يرجى المحاولة مرة أخرى',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      // Hide loading indicator
      isLocationLoading.value = false;
    }
  }
  Future<void> moveMapToLocation(LatLng position) async {
    print('بدء محاولة تحريك الخريطة إلى: ${position.latitude}, ${position.longitude}');

    // التحقق من صحة الإحداثيات
    if (position.latitude < -90 || position.latitude > 90 ||
        position.longitude < -180 || position.longitude > 180) {
      print('إحداثيات غير صالحة: ${position.latitude}, ${position.longitude}');
      Get.snackbar(
        'خطأ',
        'الإحداثيات المحددة غير صالحة',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      // تحقق إذا كانت الخريطة جاهزة
      if (!isMapReady.value) {
        print('الخريطة غير جاهزة، محاولة إعادة التهيئة');
        await _reinitializeMap();

        // انتظر قليلاً بعد إعادة التهيئة
        await Future.delayed(Duration(seconds: 1));

        if (!isMapReady.value) {
          print('الخريطة لا تزال غير جاهزة بعد إعادة التهيئة');
          Get.snackbar(
            'خطأ',
            'تعذر تهيئة الخريطة. يرجى إعادة تشغيل التطبيق',
            snackPosition: SnackPosition.BOTTOM,
          );
          return;
        }
      }

      // استراتيجية بديلة: تحديث موقع الكاميرا الأولي
      print('تحديث موقع الكاميرا الأولية');
      initialCameraPosition.value = CameraPosition(
        target: position,
        zoom: 16.0,
      );

      // محاولة تحريك الكاميرا باستخدام المتحكم إذا كان متاحًا
      if (mapControllerCompleter.isCompleted) {
        print('المتحكم مكتمل، محاولة استخدامه لتحريك الكاميرا');

        try {
          final GoogleMapController controller = await mapControllerCompleter.future;

          // استخدام طريقة أبسط للتحريك
          await controller.moveCamera(
            CameraUpdate.newLatLngZoom(position, 16.0),
          );

          print('تم تحريك الكاميرا بنجاح باستخدام moveCamera');
        } catch (innerError) {
          print('فشل تحريك الكاميرا باستخدام moveCamera: $innerError');

          // محاولة ثانية باستخدام animateCamera
          try {
            final GoogleMapController controller = await mapControllerCompleter.future;
            await controller.animateCamera(
              CameraUpdate.newLatLng(position),
            );
            print('تم تحريك الكاميرا بنجاح باستخدام animateCamera البسيط');
          } catch (e) {
            print('فشلت كل محاولات تحريك الكاميرا: $e');
            throw e; // إعادة رمي الخطأ ليتم التقاطه في الكتلة الخارجية
          }
        }
      } else {
        print('المتحكم غير مكتمل، الاعتماد على تحديث الكاميرا الأولية فقط');
      }

      print('تم تحريك الخريطة بنجاح!');

      // إظهار إشعار نجاح
      Get.snackbar(
        'تم',
        'تم تحريك الخريطة بنجاح',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.7),
        colorText: Colors.white,
      );

    } catch (e) {
      print('خطأ أثناء تحريك الخريطة: $e');

      // محاولة أخيرة: استخدام أسلوب إعادة إنشاء الخريطة بالكامل
      try {
        print('محاولة استراتيجية أخيرة: إعادة إنشاء الخريطة');
        await _recreateMap(position);
      } catch (finalError) {
        print('فشلت جميع المحاولات: $finalError');

        // إظهار رسالة خطأ للمستخدم
        Get.snackbar(
          'خطأ',
          'تعذر تحريك الخريطة. يرجى المحاولة مرة أخرى لاحقًا',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withOpacity(0.7),
          colorText: Colors.white,
        );
      }
    }
  }

// دالة مساعدة لإعادة تهيئة الخريطة
  Future<void> _reinitializeMap() async {
    try {
      // إذا كان المتحكم مكتملاً، أغلق المتحكم القديم أولاً
      if (mapControllerCompleter.isCompleted) {
        final oldController = await mapControllerCompleter.future;
        // oldController.dispose();
      }

      // إنشاء متحكم جديد
      mapControllerCompleter = Completer<GoogleMapController>();
      isMapReady.value = false;

      // إعادة تعيين الكاميرا الأولية
      if (currentLocation.value != null) {
        initialCameraPosition.value = CameraPosition(
          target: currentLocation.value!,
          zoom: 15.0,
        );
      }

      // إعادة تحميل العلامات
      await customMarker();

      print('تمت إعادة تهيئة الخريطة');
    } catch (e) {
      print('خطأ في إعادة تهيئة الخريطة: $e');
      throw e;
    }
  }

// دالة مساعدة لإعادة إنشاء الخريطة بالكامل
  Future<void> _recreateMap(LatLng targetPosition) async {
    try {
      // تحديث الموقع الأولي للكاميرا
      initialCameraPosition.value = CameraPosition(
        target: targetPosition,
        zoom: 16.0,
      );

      // إعادة تحميل الصفحة
      Get.offAndToNamed(Routes.MAP);

      print('تمت إعادة إنشاء الخريطة بموقع جديد');
    } catch (e) {
      print('خطأ في إعادة إنشاء الخريطة: $e');
      throw e;
    }
  }
  void updatePickupMarker(LatLng position) async {
    String address = await getLocationAddress(position);

    final marker = Marker(
      markerId: const MarkerId('pickup'),
      position: position,
      infoWindow: InfoWindow(
        title: 'نقطة الانطلاق',
        snippet: address,
      ),
      icon: pickupIcon,
    );

    markers.removeWhere((m) => m.markerId.value == 'pickup');
    markers.add(marker);

    // تحديث النص في الواجهة أيضًا إذا لم يتم ذلك بالفعل
    pickupLocationText.value = address;
  }

  void updateDestinationMarker(LatLng position) async {
    String address = await getLocationAddress(position);

    final marker = Marker(
      markerId: const MarkerId('destination'),
      position: position,
      infoWindow: InfoWindow(
        title: 'نقطة الوصول',
        snippet: address,
      ),
      icon: destinationIcon,
    );

    markers.removeWhere((m) => m.markerId.value == 'destination');
    markers.add(marker);

    // تحديث النص في الواجهة أيضًا إذا لم يتم ذلك بالفعل
    destinationText.value = address;
  }
  void toggleLocationSelection(bool isPickup) {
    isPickUpSelected.value = isPickup;


    searchController.clear();



    if (isPickup && pickupLocationText.value.isEmpty && currentLocation.value != null) {
      pickupLocation.value = currentLocation.value;
      pickupLocationText.value = 'موقعي الحالي';
      if (_markersLoaded.value) {
        updatePickupMarker(currentLocation.value!);
      }
    }
  }


  void confirmLocation() {
    if (tripStatus.value == TripStatus.selectingLocation) {

      if (pickupLocation.value == null) {

        pickupLocation.value = currentLocation.value;
        pickupLocationText.value = 'موقعي الحالي';
        if (_markersLoaded.value) {
          updatePickupMarker(pickupLocation.value!);
        }
      }


      tripStatus.value = TripStatus.selectingDestination;
      isPickUpSelected.value = false;

    } else if (tripStatus.value == TripStatus.selectingDestination) {

      if (destination.value == null) {


        return;
      }


      tripStatus.value = TripStatus.selectingServiceType;


      drawRouteBetweenPickupAndDestination();
    }
  }


  void setSelectedServiceType(ServiceType type) {
    selectedServiceType.value = type;
  }


  void confirmServiceType() {

    if (selectedServiceType.value == null) {
      selectedServiceType.value = ServiceType.heavy;
    }


    tripStatus.value = TripStatus.searchingDriver;


    Future.delayed(const Duration(seconds: 3), () {
      tripStatus.value = TripStatus.driverOnTheWay;
      drawDriverRoute();
    });
  }


  void drawRouteBetweenPickupAndDestination() {
    if (pickupLocation.value == null || destination.value == null) return;


    polylines.clear();


    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: ColorManager.primary,
        width: 5,
        points: [
          pickupLocation.value!,
          destination.value!,
        ],
        // patterns: [PatternItem.dash(15), PatternItem.gap(5)],
      ),
    );


    fitMapToShowRoute();
  }


  Future<void> fitMapToShowRoute() async {
    if (pickupLocation.value == null || destination.value == null) return;
    if (!mapControllerCompleter.isCompleted) return;

    final GoogleMapController controller = await mapControllerCompleter.future;


    final double minLat = pickupLocation.value!.latitude < destination.value!.latitude
        ? pickupLocation.value!.latitude
        : destination.value!.latitude;
    final double maxLat = pickupLocation.value!.latitude > destination.value!.latitude
        ? pickupLocation.value!.latitude
        : destination.value!.latitude;
    final double minLng = pickupLocation.value!.longitude < destination.value!.longitude
        ? pickupLocation.value!.longitude
        : destination.value!.longitude;
    final double maxLng = pickupLocation.value!.longitude > destination.value!.longitude
        ? pickupLocation.value!.longitude
        : destination.value!.longitude;


    final double latPadding = (maxLat - minLat) * 0.5;
    final double lngPadding = (maxLng - minLng) * 0.5;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - latPadding, minLng - lngPadding),
          northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
        ),
        50,
      ),
    );
  }


  void drawDriverRoute() {
    if (pickupLocation.value == null || destination.value == null || !_markersLoaded.value) return;


    final driverLocation = LatLng(
      pickupLocation.value!.latitude - 0.005,
      pickupLocation.value!.longitude - 0.005,
    );


    markers.removeWhere((marker) => marker.markerId.value == 'driver');


    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLocation,
        icon: driverIcon,
        infoWindow: InfoWindow(title: 'السائق', snippet: driverName.value),
        zIndex: 3,
      ),
    );


    polylines.clear();



    List<LatLng> routePoints = [
      driverLocation,

      LatLng(
          (driverLocation.latitude + pickupLocation.value!.latitude) / 2 + 0.002,
          (driverLocation.longitude + pickupLocation.value!.longitude) / 2 - 0.003
      ),
      pickupLocation.value!,

      LatLng(
          (pickupLocation.value!.latitude + destination.value!.latitude) / 2 - 0.001,
          (pickupLocation.value!.longitude + destination.value!.longitude) / 2 + 0.002
      ),
      destination.value!,
    ];


    polylines.add(
      Polyline(
        polylineId: const PolylineId('driver_to_pickup'),
        color: Colors.blue,
        width: 5,
        points: routePoints.sublist(0, 3),
      ),
    );


    polylines.add(
      Polyline(
        polylineId: const PolylineId('pickup_to_destination'),
        color: ColorManager.primary,
        width: 5,
        points: routePoints.sublist(2, 5),
        // patterns: [PatternItem.dash(15), PatternItem.gap(5)],
      ),
    );


    _fitMapToShowEntireRoute(routePoints);


    simulateDriverArrival();
  }


  Future<void> _fitMapToShowEntireRoute(List<LatLng> points) async {
    if (!mapControllerCompleter.isCompleted) return;

    final GoogleMapController controller = await mapControllerCompleter.future;


    double minLat = double.infinity;
    double maxLat = -double.infinity;
    double minLng = double.infinity;
    double maxLng = -double.infinity;

    for (LatLng point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLng) minLng = point.longitude;
      if (point.longitude > maxLng) maxLng = point.longitude;
    }


    final double latPadding = (maxLat - minLat) * 0.3;
    final double lngPadding = (maxLng - minLng) * 0.3;

    controller.animateCamera(
      CameraUpdate.newLatLngBounds(
        LatLngBounds(
          southwest: LatLng(minLat - latPadding, minLng - lngPadding),
          northeast: LatLng(maxLat + latPadding, maxLng + lngPadding),
        ),
        50,
      ),
    );
  }


  void arrivedAtDestination() {
    tripStatus.value = TripStatus.arrived;
  }


  void simulateDriverArrival() {
    Future.delayed(const Duration(seconds: 10), () {
      if (tripStatus.value == TripStatus.driverOnTheWay) {
        arrivedAtDestination();
      }
    });
  }


  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(
      data.buffer.asUint8List(),
      targetWidth: width,
    );
    ui.FrameInfo fi = await codec.getNextFrame();
    ByteData? byteData = await fi.image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }


  Future<BitmapDescriptor> getCustomMarkerIcon(String assetPath, int size) async {
    final Uint8List markerIcon = await getBytesFromAsset(assetPath, size);
    return BitmapDescriptor.fromBytes(markerIcon);
  }

  Future<String> getLocationAddress(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          position.latitude,
          position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        // بناء العنوان بالترتيب من الأكثر تحديداً إلى الأقل
        List<String> addressParts = [];

        // إضافة اسم الشارع إذا كان موجوداً
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }

        // إضافة المنطقة/الحي إذا كان موجوداً
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }

        // إضافة المدينة إذا كانت موجودة
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }

        // إضافة القضاء/المحافظة إذا كانت موجودة
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }

        if (addressParts.isEmpty) {
          return 'موقع محدد على الخريطة';
        }

        // دمج أجزاء العنوان
        return addressParts.join(' - ');
      }
    } catch (e) {
      print('خطأ في الحصول على العنوان: $e');
    }

    return 'موقع محدد على الخريطة';
  }

  void onMapTap(LatLng position) {
    // تحديث الموقع المحدد
    if (isPickUpSelected.value) {
      pickupLocation.value = position;
      if (_markersLoaded.value) {
        updatePickupMarker(position);
      }
    } else {
      destination.value = position;
      if (_markersLoaded.value) {
        updateDestinationMarker(position);
      }
    }

    // تحديث اسم الموقع في المربع النصي
    updateLocationNameFromMap(position);
  }

  void updateLocationNameFromMap(LatLng position) async {
    // عادة، يتم استخدام خدمة Geocoding للحصول على اسم الموقع من الإحداثيات
    // ولكن سنقوم بمحاكاة ذلك هنا لأغراض العرض

    // حساب المسافة بين المواقع المعروفة والموقع المحدد لاختيار الأقرب
    final knownLocations = {
      'بغداد-حي الدراغ - ساحة الفارس': LatLng(33.3152, 44.3661),
      'بغداد, الكرادة': LatLng(33.3052, 44.3961),
      'بغداد, زيونة': LatLng(33.3252, 44.4061),
      'موقعي الحالي': currentLocation.value ?? LatLng(33.3152, 44.3661),
    };

    String closestLocation = 'موقع غير معروف';
    double minDistance = double.infinity;

    knownLocations.forEach((name, loc) {
      // حساب المسافة بين النقطتين (بشكل مبسط)
      double distance = _calculateDistance(position, loc);
      if (distance < minDistance) {
        minDistance = distance;
        closestLocation = name;
      }
    });

    // إذا كانت المسافة كبيرة جدًا، نعتبره موقعًا غير معروف مع الإحداثيات
    if (minDistance > 0.01) { // حوالي 1 كم
      closestLocation = 'موقع مخصص (${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)})';
    }

    // تحديث النص في المربع المناسب
    if (isPickUpSelected.value) {
      pickupLocationText.value = closestLocation;
      pickupLocation.value = position;
      if (_markersLoaded.value) {
        updatePickupMarker(position);
      }
    } else {
      destinationText.value = closestLocation;
      destination.value = position;
      if (_markersLoaded.value) {
        updateDestinationMarker(position);
      }
    }

    // إذا كان لدينا نقطة الانطلاق والوصول، نرسم المسار
    if (pickupLocation.value != null && destination.value != null) {
      drawRouteBetweenPickupAndDestination();
    }
  }

  double _calculateDistance(LatLng p1, LatLng p2) {
    // حساب مبسط للمسافة الأقليدية بين نقطتين
    return math.sqrt((p1.latitude - p2.latitude) * (p1.latitude - p2.latitude) +
        (p1.longitude - p2.longitude) * (p1.longitude - p2.longitude));
  }
}