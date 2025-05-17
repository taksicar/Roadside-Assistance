import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;
  final Gradient? gradient;
  final Color? textColor;
  final double width;
  final double height;
  final double fontSize;
  final Color? borderColor;
  final bool isDisable;
  final BorderRadiusGeometry? borderRadius;
  final List<BoxShadow>? boxShadow;

  const CustomButton({
    super.key,
    required this.text,
    this.color,
    this.gradient,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 45,
    this.fontSize = 14,
    this.borderColor,
    this.isDisable = false,
    this.borderRadius,
    this.textColor = ColorManager.white,
    this.boxShadow,
  }) : assert(
         color != null || gradient != null,
         'Either color or gradient must be provided',
       );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: gradient == null ? color : null,
          gradient: gradient,
          border: borderColor == null ? null : Border.all(color: borderColor!),
          borderRadius: borderRadius ?? BorderRadius.circular(12.r),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: Center(
            child:
                isDisable
                    ? const CircularProgressIndicator(color: ColorManager.white)
                    : CustomText(
                      text: text!,
                      color: textColor,
                      fontSize: fontSize.sp,
                      height: 1,
                      fontWeight: FontWeight.bold,
                    ),
          ),
        ),
      ),
    );
  }

  // Factory methods for common button types
  static Widget primary({
    required String text,
    required VoidCallback onPressed,
    double width = double.infinity,
    double height = 45,
    double fontSize = 14,
    bool isDisable = false,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      color: ColorManager.primary,
      width: width,
      height: height,
      fontSize: fontSize,
      isDisable: isDisable,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
    );
  }

  static Widget secondary({
    required String text,
    required VoidCallback onPressed,
    double width = double.infinity,
    double height = 45,
    double fontSize = 14,
    bool isDisable = false,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      color: ColorManager.secondary,
      textColor: ColorManager.textPrimary,
      width: width,
      height: height,
      fontSize: fontSize,
      isDisable: isDisable,
      borderRadius: borderRadius,
      boxShadow: boxShadow,
    );
  }

  static Widget outlined({
    required String text,
    required VoidCallback onPressed,
    Color? borderColor,
    Color? textColor,
    double width = double.infinity,
    double height = 45,
    double fontSize = 14,
    bool isDisable = false,
    BorderRadiusGeometry? borderRadius,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      color: Colors.transparent,
      textColor: textColor ?? ColorManager.primary,
      width: width,
      height: height,
      fontSize: fontSize,
      borderColor: borderColor ?? ColorManager.primary,
      isDisable: isDisable,
      borderRadius: borderRadius,
    );
  }

  static Widget textButton({
    required String text,
    required VoidCallback onPressed,
    Color? textColor,
    double fontSize = 14,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: textColor ?? ColorManager.primary,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      ),
      child: CustomText(
        text: text,
        color: textColor ?? ColorManager.primary,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  // New factory method for gradient button
  static Widget gradientBtn({
    required String text,
    required void Function()? onPressed,
    double width = double.infinity,
    double height = 45,
    double fontSize = 14,
    bool isDisable = false,
    BorderRadiusGeometry? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? customGradient,
    Color? textColor = ColorManager.white,
  }) {
    return CustomButton(
      text: text,
      onPressed: onPressed,
      gradient:
          customGradient ??
          const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF5856D6), // Lighter purple as shown in image
              Color(0xFF2E2D70), // Darker purple as shown in image
            ],
          ),
      boxShadow:
          boxShadow ??
          [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
      color: Colors.transparent,
      textColor: textColor,
      width: width,
      height: height,
      fontSize: fontSize,
      isDisable: isDisable,
      borderRadius: borderRadius,

    );
  }
}
