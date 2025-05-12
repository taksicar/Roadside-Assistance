import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/auth/views/widgets/curved_painter_widget.dart';

import '../controllers/auth_controller.dart';

class VerificationView extends GetView<AuthController> {
  const VerificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: Stack(
        children: [
          Stack(
            children: [
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: ColorManager.primary,
                  image: DecorationImage(
                    image: AssetImage(ImageAssets.paint),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),

          Center(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage(ImageAssets.background),
                  alignment: Alignment.bottomCenter,
                  opacity: 0.1,
                ),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(IconAssets.smallLogo),

                      SizedBox(height: 24.h),

                      CustomText(
                        text: 'ادخل الكود',
                        color: ColorManager.primary,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),

                      SizedBox(height: 40.h),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(
                          6,
                          (index) => _buildOtpTextField(context, index),
                        ),
                      ),

                      SizedBox(height: 16.h),

                      TextButton(
                        onPressed:
                            controller.isResendEnabled.value
                                ? () => controller.resendCode()
                                : null,
                        child: CustomText(
                          text: 'لم يصلني الكود؟ إرسال مرة أخرى',
                          color: ColorManager.primary,
                          fontSize: 14,
                        ),
                      ),

                      SizedBox(height: 32.h),

                      Obx(
                        () => CustomButton(
                          text: 'تأكيد',
                          color: ColorManager.primary,
                          onPressed:
                              controller.isLoading.value
                                  ? null
                                  : () => controller.verifyOtp(),
                          isDisable: controller.isLoading.value,
                          height: 50,
                          fontSize: 16,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOtpTextField(BuildContext context, int index) {
    return Container(
      width: 50.w,
      height: 50.h,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Center(
        child: TextField(
          controller: controller.otpControllers[index],
          keyboardType: TextInputType.number,
          textAlign: TextAlign.center,
          maxLength: 1,
          decoration: const InputDecoration(
            counterText: '',
            border: InputBorder.none,
          ),
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          onChanged: (value) {
            if (value.isNotEmpty) {
              if (index < 5) {
                FocusScope.of(context).nextFocus();
              } else {
                FocusScope.of(context).unfocus();
              }
            }

            controller.updateOtpValue();
          },
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      ),
    );
  }
}
