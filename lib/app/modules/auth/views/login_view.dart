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

class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

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
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        ColorManager.primaryDark,
                        ColorManager.primaryLight,
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 0.5],
                    ),
                  // color: ColorManager.primary,
                  image: DecorationImage(
                    image: AssetImage(ImageAssets.paint),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(ImageAssets.background),

                fit: BoxFit.fitWidth,
              ),
            ),
            child: Center(
              // bottom: 0,
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

                        // Phone Input Field with country code
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Row(
                            children: [
                              // Country code selector
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12.w,
                                  vertical: 8.h,
                                ),
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: BorderSide(color: Colors.grey[300]!),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    // Iraq flag
                                    Container(
                                      width: 24.w,
                                      height: 16.h,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(ImageAssets.flag),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8.w),
                                    // Country code
                                    Text(
                                      '+964',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Phone number input
                              Expanded(
                                child: Directionality(
                                  textDirection: TextDirection.ltr,
                                  child: TextFormField(
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      hintText: '770078900',
                                      hintStyle: TextStyle(
                                        color: Colors.grey[400],
                                        fontSize: 14.sp,
                                      ),
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 16.w,
                                        vertical: 14.h,
                                      ),
                                    ),
                                    onChanged: (value) {
                                      controller.updatePhoneNumber(value);
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 32.h),

                        // Login Button
                        Obx(
                          () => AbsorbPointer(
                            absorbing: controller.isLoading.value,
                            child: CustomButton.gradientBtn(
                              text: 'تسجيل الدخول',

                              onPressed: () => controller.login(),
                              isDisable: controller.isLoading.value,
                              height: 50,
                              fontSize: 16,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
