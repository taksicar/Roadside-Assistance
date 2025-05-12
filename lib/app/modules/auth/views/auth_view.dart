import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/utils/app_values.dart';
import 'package:roadside_assistance/app/modules/auth/views/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
// import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_button_widget.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';
import 'package:roadside_assistance/app/modules/auth/views/widgets/curved_painter_widget.dart';

import '../controllers/auth_controller.dart';

import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});
  @override
  Widget build(BuildContext context) {
    return true?LoginView(): Scaffold(
      body: Stack(
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
      Container(
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
                // Logo in circle
                SvgPicture.asset(IconAssets.smallLogo),

                SizedBox(height: 24.h),

                // Login Title
                CustomText(
                  text: 'تسجيل الدخول',
                  color: ColorManager.primary,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),

                SizedBox(height: 40.h),

                // Phone Number Label
                Align(
                  alignment: Alignment.centerRight,
                  child: CustomText(
                    text: 'رقم الهاتف',
                    color: ColorManager.textSecondary,
                    fontSize: 14,
                  ),
                ),

                SizedBox(height: 8.h),

                // // Phone Input Field
                // Container(
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Colors.grey[300]!),
                //     borderRadius: BorderRadius.circular(8.r),
                //   ),
                //   child: InternationalPhoneNumberInput(
                //     onInputChanged: (PhoneNumber number) {
                //       controller.updatePhoneNumber(
                //         number.phoneNumber ?? '',
                //       );
                //       controller.updateCountryCode(
                //         number.dialCode?.replaceAll('+', '') ?? '964',
                //       );
                //     },
                //     selectorConfig: const SelectorConfig(
                //       selectorType: PhoneInputSelectorType.DROPDOWN,
                //     ),
                //     ignoreBlank: false,
                //     autoValidateMode: AutovalidateMode.disabled,
                //     selectorTextStyle: TextStyle(
                //       color: ColorManager.textPrimary,
                //       fontSize: 16.sp,
                //     ),
                //     initialValue: PhoneNumber(
                //       isoCode: 'IQ',
                //       dialCode: '+964',
                //     ),
                //     textStyle: TextStyle(
                //       color: ColorManager.textPrimary,
                //       fontSize: 16.sp,
                //     ),
                //     inputDecoration: InputDecoration(
                //       border: InputBorder.none,
                //       hintText: '770078900',
                //       hintStyle: TextStyle(
                //         color: Colors.grey[400],
                //         fontSize: 16.sp,
                //       ),
                //       contentPadding: EdgeInsets.symmetric(
                //         horizontal: 16.w,
                //         vertical: 14.h,
                //       ),
                //     ),
                //   ),
                // ),

                SizedBox(height: 32.h),

                // Login Button
                Obx(
                      () => CustomButton(
                    text: 'تسجيل الدخول',
                    color: ColorManager.primary,
                    onPressed:
                    controller.isLoading.value
                        ? null
                        : () => controller.login(),
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

    ],
    ),


    );
  }
}
