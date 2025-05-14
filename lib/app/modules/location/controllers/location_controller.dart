import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/extentions/space_extention.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_snackbar_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/data/models/address_model.dart';
import 'package:roadside_assistance/app/modules/location/views/add_location.dart';

class SavedAddressesController extends GetxController {
  final addressNameController = TextEditingController();
  final addressDetailsController = TextEditingController();
  final addressFormKey = GlobalKey<FormState>();
  final isLoading = false.obs;

  final addresses = <Address>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadAddresses();
  }

  void loadAddresses() {
    addresses.value = [
      Address(id: '1', name: '1124 البصرة', address: 'البصرة, العراق. 4+G6R6'),
      Address(id: '2', name: '1124 البصرة', address: 'البصرة, العراق. 4+G6R6'),
    ];
  }

  void saveAddress() {
    if (addressFormKey.currentState!.validate()) {
      isLoading.value = true;

      final newId = DateTime
          .now()
          .millisecondsSinceEpoch
          .toString();

      final newAddress = Address(
        id: newId,
        name: addressNameController.text,
        address: addressDetailsController.text,
      );

      addresses.add(newAddress);

      Future.delayed(const Duration(seconds: 1), () {
        isLoading.value = false;
        Get.back();
        CustomSnackBar.showCustomSnackBar(
          title: 'تم',
          message: 'تم حفظ العنوان بنجاح',
        );
      });
    }
  }

  void updateAddress(String id) {
    if (addressFormKey.currentState!.validate()) {
      isLoading.value = true;

      final index = addresses.indexWhere((address) => address.id == id);
      if (index != -1) {
        addresses[index] = Address(
          id: id,
          name: addressNameController.text,
          address: addressDetailsController.text,
        );

        addresses.refresh();
      }

      Future.delayed(const Duration(seconds: 1), () {
        isLoading.value = false;
        Get.back();
        Get.snackbar(
          'تم',
          'تم تحديث العنوان بنجاح',
          snackPosition: SnackPosition.BOTTOM,
        );
      });
    }
  }

  void deleteAddress(String id) {
    addresses.removeWhere((address) => address.id == id);

    CustomSnackBar.showCustomSnackBar(
      title: 'تم',
      message: 'تم حذف العنوان بنجاح',
    );
  }

  void goToAddAddress() {
    addressNameController.clear();
    addressDetailsController.clear();

    Get.to(() => const AddAddressView());
  }

  void confirmDeleteAddress(String id, String addressName) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Padding(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Warning icon
              Container(
                width: 60.w,
                height: 60.h,
                decoration: BoxDecoration(
                  color: Colors.red[50],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                  size: 30.sp,
                ),
              ),

              16.height,

              // Dialog title
              CustomText(
                text: 'حذف العنوان',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                textAlign: TextAlign.center,
              ),

              8.height,

              // Dialog content
              CustomText(
                text: 'هل أنت متأكد من حذف العنوان "$addressName"؟',
                fontSize: 14,
                color: Colors.black87,
                textAlign: TextAlign.center,
              ),

              24.height,

              // Action buttons
              Row(
                children: [
                  // Cancel button
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: ColorManager.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: CustomText(
                          text: 'إلغاء',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: ColorManager.primary,
                        ),
                      ),
                    ),
                  ),

                  16.width,

                  // Delete button
                  Expanded(
                    child: SizedBox(
                      height: 48.h,
                      child: ElevatedButton(
                        onPressed: () {
                          Get.back(); // Close dialog
                          deleteAddress(id); // Delete the address
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                        child: CustomText(
                          text: 'حذف',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  void goToEditAddress(Address address) {
    addressNameController.text = address.name;
    addressDetailsController.text = address.address;

    Get.to(() => AddAddressView(isEdit: true, addressId: address.id));
  }
}
