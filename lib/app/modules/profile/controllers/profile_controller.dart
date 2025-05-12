import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/widgets/custom_snackbar_widget.dart';
import 'package:roadside_assistance/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  // User data
  final userData = {}.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumber = ''.obs;
  final addressController = TextEditingController();

  // Form key for validation
  final profileFormKey = GlobalKey<FormState>();

  // Loading state
  final isLoading = false.obs;

  // Storage
  // final _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    addressController.dispose();
    super.onClose();
  }

  // Load user data from storage or API
  void _loadUserData() {
    try {
      // In a real app, this would load from your API
      // For now, let's load from storage or use defaults
      // final storedData = _storage.read('user_data');

      // if (storedData != null) {
      //   userData.value = Map<String, dynamic>.from(storedData);
      // } else {
      //   // Default data for demo
      //   userData.value = {
      //     'name': 'أحمد محمود',
      //     'email': 'ahmed@mail.com',
      //     'phone': '+964 770078900',
      //     'address': 'العراق، بغداد، المنصور، شارع 40',
      //   };
      // }

      // Set values to controllers
      nameController.text = userData['name'] ?? '';
      emailController.text = userData['email'] ?? '';
      addressController.text = userData['address'] ?? '';
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء تحميل بيانات المستخدم',
      );
    }
  }

  // Update profile
  void updateProfile() async {
    if (!profileFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Get form values
      final name = nameController.text;
      final email = emailController.text;
      final phone = phoneNumber.value;
      final address = addressController.text;

      // // Update userData
      // userData.update((val) {
      //   val!['name'] = name;
      //   val['email'] = email;
      //   val['phone'] = phone.isEmpty ? userData['phone'] : phone;
      //   val['address'] = address;

      // });

      // Save to storage
      // await _storage.write('user_data', userData);

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      CustomSnackBar.showCustomSnackBar(
        title: 'نجاح',
        message: 'تم تحديث المعلومات الشخصية بنجاح',
      );

      Get.back(); // Return to profile screen
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء تحديث المعلومات الشخصية',
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Navigation methods
  void goToEditProfile() {
    Get.toNamed(Routes.EDIT_PROFILE);
  }

  void goToMessages() {
    CustomSnackBar.showCustomToast(message: 'سيتم توفير هذه الخدمة قريبًا');
  }

  void goToSavedAddresses() {
    CustomSnackBar.showCustomToast(message: 'سيتم توفير هذه الخدمة قريبًا');
  }

  void goToSettings() {
    CustomSnackBar.showCustomToast(message: 'سيتم توفير هذه الخدمة قريبًا');
  }

  void goToHelp() {
    CustomSnackBar.showCustomToast(message: 'سيتم توفير هذه الخدمة قريبًا');
  }

  // Logout
  void logout() {
    Get.dialog(
      AlertDialog(
        title: const Text('تسجيل الخروج'),
        content: const Text('هل أنت متأكد من تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('إلغاء')),
          TextButton(
            onPressed: () async {
              // Clear user data
              // await _storage.remove('user_data');

              // Go to login screen
              Get.offAllNamed(Routes.LOGIN);
            },
            child: const Text('تأكيد'),
          ),
        ],
      ),
    );
  }
}
