import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/widgets/custom_text_widget.dart';

class CustomButton extends StatelessWidget {
  final String? text;
  final VoidCallback? onPressed;
  final Color? color;
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
    required this.color,
    required this.onPressed,
    this.width = double.infinity,
    this.height = 45,
    this.fontSize = 14,
    this.borderColor,
    this.isDisable = false,
    this.borderRadius,
    this.textColor = ColorManager.white,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: width.w,
        height: height.h,
        decoration: BoxDecoration(
          boxShadow: boxShadow,
          color: color,
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
}
