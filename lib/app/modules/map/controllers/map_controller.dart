import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

enum TripStatus {
  selectingLocation,
  selectingDestination,
  selectingServiceType, // إضافة حالة جديدة لاختيار نوع الخدمة
  searchingDriver,
  driverOnTheWay,
  arrived,
}

enum ServiceType {
  heavy, // ثقيل
  light, // خفيف
}

class MapController extends GetxController {
  // كونترولر الخريطة
  final Completer<GoogleMapController> mapControllerCompleter = Completer<GoogleMapController>();
  final Rx<CameraPosition> initialCameraPosition = CameraPosition(
    target: LatLng(33.3152, 44.3661), // بغداد (يمكنك تغييره للموقع الافتراضي الذي تريده)
    zoom: 14.0,
  ).obs;

  // الماركرز والمسارات
  final markers = <Marker>{}.obs;
  final polylines = <Polyline>{}.obs;

  // موقع المستخدم الحالي
  final currentLocation = Rxn<LatLng>();
  final destination = Rxn<LatLng>();

  // حالة الرحلة
  final tripStatus = TripStatus.selectingLocation.obs;

  // نوع الخدمة المختار
  final selectedServiceType = Rx<ServiceType?>(null);

  // مراقبة الموقع
  final location = Location();

  // بيانات المستخدم
  final searchController = TextEditingController();
  final startLocationText = ''.obs;
  final destinationText = ''.obs;
  final isPickUpSelected = true.obs;

  // بيانات السائق
  final driverName = 'احمد محمود'.obs;
  final driverRating = '10 دقائق'.obs;
  final driverImage = 'assets/images/driver.jpg'.obs;

  // أسعار الخدمة
  final heavyServicePrice = '50 دولار'.obs;
  final lightServicePrice = '40 دولار'.obs;

  // حالة التحميل
  final isMapReady = false.obs;
  final isLocationLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _setupLocationService();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  // إعداد خدمة الموقع
  Future<void> _setupLocationService() async {
    isLocationLoading.value = true;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        isLocationLoading.value = false;
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        isLocationLoading.value = false;
        return;
      }
    }

    // الحصول على الموقع الحالي
    try {
      final locationData = await location.getLocation();
      currentLocation.value = LatLng(
        locationData.latitude!,
        locationData.longitude!,
      );

      // تحديث موضع الكاميرا
      initialCameraPosition.value = CameraPosition(
        target: currentLocation.value!,
        zoom: 15.0,
      );

      // إضافة ماركر للموقع الحالي
      _addMarkerForCurrentLocation();

      // مراقبة تغييرات الموقع
      location.onLocationChanged.listen((LocationData newLocation) {
        currentLocation.value = LatLng(
          newLocation.latitude!,
          newLocation.longitude!,
        );
        _updateCurrentLocationMarker();
      });
    } catch (e) {
      print('Error getting location: $e');
    } finally {
      isLocationLoading.value = false;
    }
  }

  // إضافة ماركر للموقع الحالي
  void _addMarkerForCurrentLocation() {
    if (currentLocation.value == null) return;

    markers.add(
      Marker(
        markerId: const MarkerId('current_location'),
        position: currentLocation.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure),
        infoWindow: const InfoWindow(title: 'موقعك الحالي'),
      ),
    );
  }

  // تحديث ماركر الموقع الحالي
  void _updateCurrentLocationMarker() {
    if (currentLocation.value == null) return;

    // إزالة الماركر القديم إذا كان موجوداً
    markers.removeWhere((marker) => marker.markerId.value == 'current_location');

    // إضافة الماركر الجديد
    _addMarkerForCurrentLocation();
  }

  // تكبير الخريطة على الموقع الحالي
  Future<void> goToCurrentLocation() async {
    if (currentLocation.value == null) return;

    final GoogleMapController controller = await mapControllerCompleter.future;
    controller.animateCamera(
      CameraUpdate.newLatLngZoom(currentLocation.value!, 18),
    );
  }

  // البحث عن موقع
  void searchLocation(String address) {
    // هنا يمكنك استخدام الـ Geocoding API للبحث عن عنوان معين
    // لأغراض المثال، سنقوم بتخزين النص فقط
    if (isPickUpSelected.value) {
      startLocationText.value = address;
    } else {
      destinationText.value = address;
    }
  }

  // تأكيد الموقع
  void confirmLocation() {
    if (tripStatus.value == TripStatus.selectingLocation) {
      // المستخدم يؤكد موقع الانطلاق
      tripStatus.value = TripStatus.selectingDestination;

      // إضافة ماركر لموقع الانطلاق
      _addPickupMarker();
    } else if (tripStatus.value == TripStatus.selectingDestination) {
      // المستخدم يؤكد الوجهة - الانتقال إلى اختيار نوع الخدمة
      tripStatus.value = TripStatus.selectingServiceType;

      // إضافة ماركر للوجهة
      _addDestinationMarker();

      // رسم المسار بين نقطة البداية والنهاية
      _drawRouteBetweenPickupAndDestination();
    }
  }

  // تحديد نوع الخدمة (فقط تحديد بدون انتقال للبحث)
  void setSelectedServiceType(ServiceType type) {
    selectedServiceType.value = type;
  }

  // اختيار نوع الخدمة والانتقال للبحث عن سائق
  void confirmServiceType() {
    // التأكد من أن المستخدم قام باختيار نوع خدمة
    if (selectedServiceType.value == null) {
      // إذا لم يتم اختيار نوع خدمة، نختار النوع الثقيل افتراضياً
      selectedServiceType.value = ServiceType.heavy;
    }

    // بعد اختيار نوع الخدمة، ننتقل إلى مرحلة البحث عن سائق
    tripStatus.value = TripStatus.searchingDriver;

    // محاكاة العثور على سائق بعد 3 ثوانٍ
    Future.delayed(const Duration(seconds: 3), () {
      tripStatus.value = TripStatus.driverOnTheWay;
      _drawDriverRoute();
    });
  }

  // إضافة ماركر لموقع الانطلاق
  void _addPickupMarker() {
    if (currentLocation.value == null) return;

    // استخدام الموقع الحالي كموقع انطلاق
    markers.add(
      Marker(
        markerId: const MarkerId('pickup_location'),
        position: currentLocation.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(title: 'موقع الانطلاق'),
      ),
    );
  }

  // إضافة ماركر للوجهة
  void _addDestinationMarker() {
    // لأغراض المثال، سنستخدم موقعاً قريباً من الموقع الحالي
    if (currentLocation.value == null) return;

    destination.value = LatLng(
      currentLocation.value!.latitude + 0.01,
      currentLocation.value!.longitude + 0.01,
    );

    markers.add(
      Marker(
        markerId: const MarkerId('destination'),
        position: destination.value!,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        infoWindow: const InfoWindow(title: 'الوجهة'),
      ),
    );
  }

  // رسم المسار بين نقطة البداية والنهاية
  void _drawRouteBetweenPickupAndDestination() {
    if (currentLocation.value == null || destination.value == null) return;

    // رسم المسار - في تطبيق حقيقي، ستستخدم Directions API
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: [
          currentLocation.value!,
          destination.value!,
        ],
      ),
    );
  }

  // رسم مسار السائق
  void _drawDriverRoute() {
    if (currentLocation.value == null || destination.value == null) return;

    // إضافة ماركر للسائق
    final driverLocation = LatLng(
      currentLocation.value!.latitude - 0.005,
      currentLocation.value!.longitude - 0.005,
    );

    markers.add(
      Marker(
        markerId: const MarkerId('driver'),
        position: driverLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(title: 'السائق', snippet: driverName.value),
      ),
    );

    // رسم المسار بين السائق ونقطة الانطلاق ثم الوجهة
    polylines.clear(); // نمسح المسارات السابقة
    polylines.add(
      Polyline(
        polylineId: const PolylineId('route'),
        color: Colors.blue,
        width: 5,
        points: [
          driverLocation,
          currentLocation.value!,
          destination.value!,
        ],
      ),
    );

    // محاكاة وصول السائق بعد 10 ثوان
    simulateDriverArrival();
  }

  // وصول السائق إلى الوجهة
  void arrivedAtDestination() {
    tripStatus.value = TripStatus.arrived;
  }

  // محاكاة وصول السائق (للاختبار)
  void simulateDriverArrival() {
    Future.delayed(const Duration(seconds: 10), () {
      if (tripStatus.value == TripStatus.driverOnTheWay) {
        arrivedAtDestination();
      }
    });
  }
}