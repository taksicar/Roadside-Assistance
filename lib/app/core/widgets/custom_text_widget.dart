import 'package:flutter/material.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final String? fontFamily;
  final double? height;
  final TextDecoration? decoration;
  final double? letterSpacing;

  const CustomText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.fontFamily,
    this.height,
    this.decoration,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style:
          style?.copyWith(
            color: color ?? style?.color,
            fontSize: fontSize ?? style?.fontSize,
            fontWeight: fontWeight ?? style?.fontWeight,
            fontFamily: fontFamily ?? style?.fontFamily,
            height: height ?? style?.height,
            decoration: decoration ?? style?.decoration,
            letterSpacing: letterSpacing ?? style?.letterSpacing,
          ) ??
          TextStyle(
            color: color ?? ColorManager.textPrimary,
            fontSize: fontSize ?? FontSize.s14,
            fontWeight: fontWeight ?? FontWeightManager.regular,
            fontFamily: fontFamily ?? FontConstants.jfFlatRegular,
            height: height,
            decoration: decoration,
            letterSpacing: letterSpacing,
          ),
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget heading(
    String text, {
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
  }) {
    return CustomText(
      text: text,
      style: TextStyle(
        fontFamily: FontConstants.jfFlatBold,
        fontSize: fontSize ?? FontSize.s20,
        fontWeight: fontWeight ?? FontWeightManager.bold,
        color: color ?? ColorManager.textPrimary,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget subheading(
    String text, {
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
  }) {
    return CustomText(
      text: text,
      style: TextStyle(
        fontFamily: FontConstants.jfFlatMedium,
        fontSize: fontSize ?? FontSize.s16,
        fontWeight: fontWeight ?? FontWeightManager.medium,
        color: color ?? ColorManager.textPrimary,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget body(
    String text, {
    Color? color,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
    double? fontSize,
    FontWeight? fontWeight,
    double? height,
  }) {
    return CustomText(
      text: text,
      style: TextStyle(
        fontFamily: FontConstants.jfFlatRegular,
        fontSize: fontSize ?? FontSize.s14,
        fontWeight: fontWeight ?? FontWeightManager.regular,
        color: color ?? ColorManager.textPrimary,
        height: height,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget button(
    String text, {
    Color? color,
    TextAlign? textAlign,
    double? fontSize,
    FontWeight? fontWeight,
  }) {
    return CustomText(
      text: text,
      style: TextStyle(
        fontFamily: FontConstants.jfFlatBold,
        fontSize: fontSize ?? FontSize.s16,
        fontWeight: fontWeight ?? FontWeightManager.bold,
        color: color ?? ColorManager.white,
      ),
      textAlign: textAlign ?? TextAlign.center,
    );
  }
}
