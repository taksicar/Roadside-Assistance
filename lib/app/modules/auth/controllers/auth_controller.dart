import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/widgets/custom_snackbar_widget.dart';

class AuthController extends GetxController {
  final phoneNumber = ''.obs;
  final countryCode = '964'.obs;
  final isLoading = false.obs;
  final isResendEnabled = true.obs;

  final otpValue = ''.obs;
  late List<TextEditingController> otpControllers;

  final isPhoneValid = false.obs;

  final resendCountdown = 60.obs;

  @override
  void onInit() {
    super.onInit();

    otpControllers = List.generate(6, (index) => TextEditingController());
  }

  @override
  void onClose() {
    for (var controller in otpControllers) {
      controller.dispose();
    }
    super.onClose();
  }

  void updatePhoneNumber(String value) {
    phoneNumber.value = value;
    validatePhone();
  }

  void updateCountryCode(String value) {
    countryCode.value = value;
    validatePhone();
  }

  void validatePhone() {
    final phonePattern = RegExp(r'^[0-9]{9,10}$');
    final phone = phoneNumber.value.replaceAll('+$countryCode', '').trim();
    isPhoneValid.value = phonePattern.hasMatch(phone);
  }

  void updateOtpValue() {
    String otp = '';
    for (var controller in otpControllers) {
      otp += controller.text;
    }
    otpValue.value = otp;
  }

  void clearOtp() {
    for (var controller in otpControllers) {
      controller.clear();
    }
    otpValue.value = '';
  }

  void login() async {
    try {
      if (phoneNumber.value.isEmpty || !isPhoneValid.value) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'خطأ',
          message: 'يرجى إدخال رقم هاتف صحيح',
        );
        return;
      }

      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      // Get.toNamed(Routes.VERIFICATION);

      _startResendCountdown();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء إرسال رمز التحقق. حاول مرة أخرى.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void verifyOtp() async {
    try {
      if (otpValue.value.length != 6) {
        CustomSnackBar.showCustomErrorSnackBar(
          title: 'خطأ',
          message: 'يرجى إدخال رمز التحقق المكون من 6 أرقام',
        );
        return;
      }

      isLoading.value = true;

      await Future.delayed(const Duration(seconds: 2));

      // Get.offAllNamed(Routes.HOME);
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'خطأ',
        message: 'رمز التحقق غير صحيح. حاول مرة أخرى.',
      );
    } finally {
      isLoading.value = false;
    }
  }

  void resendCode() async {
    try {
      isResendEnabled.value = false;

      await Future.delayed(const Duration(seconds: 1));

      clearOtp();

      CustomSnackBar.showCustomSnackBar(
        title: 'تم',
        message: 'تم إرسال رمز التحقق مرة أخرى',
      );

      _startResendCountdown();
    } catch (e) {
      CustomSnackBar.showCustomErrorSnackBar(
        title: 'خطأ',
        message: 'حدث خطأ أثناء إعادة إرسال رمز التحقق. حاول مرة أخرى.',
      );
      isResendEnabled.value = true;
    }
  }

  void _startResendCountdown() {
    resendCountdown.value = 60;
    isResendEnabled.value = false;

    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      resendCountdown.value--;

      if (resendCountdown.value <= 0) {
        isResendEnabled.value = true;
        return false;
      }
      return true;
    });
  }
}
