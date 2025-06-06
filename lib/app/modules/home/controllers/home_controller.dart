import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/widgets/custom_snackbar_widget.dart';
import 'package:roadside_assistance/app/data/models/service_model.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // List of available services
  final servicesList = <ServiceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadServices();
  }

  // Load services from API or local data
  void _loadServices() {
    // In a real app, this would come from your API
    // For now, we'll hardcode the services based on the image
    servicesList.addAll([
      ServiceModel(
        id: '1',
        title: 'كرين سطحية',
        icon: IconAssets.image1,
        isAvailable: true,
      ),
      ServiceModel(
        id: '2',
        title: 'كرين تادانا',
        icon: IconAssets.image2,
        isAvailable: false,
      ),
      ServiceModel(
        id: '3',
        title: 'كرين سلة',
        icon: IconAssets.image3,
        isAvailable: false,
      ),
      ServiceModel(
        id: '4',
        title: 'نقل متعدد',
        icon: IconAssets.image4,
        isAvailable: false,
      ),
      ServiceModel(
        id: '5',
        title: 'توصيل بانزين',
        icon: IconAssets.image5,
        isAvailable: false,
      ),
      ServiceModel(
        id: '6',
        title: 'تبديل بنشر',
        icon: IconAssets.image6,
        isAvailable: false,
      ),
      ServiceModel(
        id: '7',
        title: 'فيتر جوال',
        icon: IconAssets.image7,
        isAvailable: false,
      ),
    ]);
  }

  // Handle service selection
  void onServiceSelected(int index) {
    final service = servicesList[index];

    if (!service.isAvailable) {
      CustomSnackBar.showCustomToast(
        message: 'هذه الخدمة ستكون متاحة قريبا',
        color: Get.theme.primaryColor,
      );
      return;
    }

    switch (service.id) {
      case '1': // Flatbed Tow
        Get.toNamed(Routes.MAP);
        break;
      default:
        CustomSnackBar.showCustomToast(
          message: 'هذه الخدمة ستكون متاحة قريبا',
          color: Get.theme.primaryColor,
        );
        break;
    }
  }
}
