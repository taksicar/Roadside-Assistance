import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';

import 'custom_shimmer.dart';

class CustomCachedImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final String? placeholder;
  final String? errorWidget;
  final BorderRadius? borderRadius;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final Color? backgroundColor;
  final bool isCircular;
  final BoxBorder? border;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? margin;

  const CustomCachedImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.placeholder,
    this.errorWidget,
    this.borderRadius,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.backgroundColor,
    this.isCircular = false,
    this.border,
    this.boxShadow,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue =
        isCircular
            ? BorderRadius.circular(1000)
            : borderRadius ?? BorderRadius.circular(12.r);

    if (imageUrl == null || imageUrl!.isEmpty) {
      return _buildErrorWidget(borderRadiusValue);
    }

    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadiusValue,
        border: border,
        boxShadow: boxShadow,
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: borderRadiusValue,
        child: CachedNetworkImage(
          imageUrl: imageUrl!,
          fit: fit,
          width: width,
          height: height,
          placeholder: (context, url) => _buildPlaceholder(),
          errorWidget:
              (context, url, error) => _buildErrorWidget(borderRadiusValue),
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    if (placeholder != null) {
      return Image.asset(placeholder!, width: width, height: height, fit: fit);
    }

    return isCircular
        ? CustomShimmer.circular(
          size: width ?? height ?? 60.r,
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
        )
        : CustomShimmer.rectangular(
          width: width,
          height: height ?? 150.h,
          borderRadius: (borderRadius?.topLeft.x ?? 12).r,
          baseColor: shimmerBaseColor,
          highlightColor: shimmerHighlightColor,
        );
  }

  Widget _buildErrorWidget(BorderRadius borderRadius) {
    if (errorWidget != null) {
      return Image.asset(errorWidget!, width: width, height: height, fit: fit);
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: backgroundColor ?? ColorManager.grey200,
      ),
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: ColorManager.grey500,
          size: 24.sp,
        ),
      ),
    );
  }

  // Factory constructors for common use cases
  factory CustomCachedImage.avatar({
    required String? imageUrl,
    double size = 40,
    String? placeholder,
    String? errorWidget,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCachedImage(
      imageUrl: imageUrl,
      width: size.r,
      height: size.r,
      isCircular: true,
      placeholder: placeholder,
      errorWidget: errorWidget,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
    );
  }

  factory CustomCachedImage.square({
    required String? imageUrl,
    double size = 100,
    BoxFit fit = BoxFit.cover,
    double borderRadius = 12,
    String? placeholder,
    String? errorWidget,
    Color? backgroundColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCachedImage(
      imageUrl: imageUrl,
      width: size.r,
      height: size.r,
      fit: fit,
      borderRadius: BorderRadius.circular(borderRadius.r),
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
    );
  }

  factory CustomCachedImage.banner({
    required String? imageUrl,
    double? width,
    double height = 150,
    BoxFit fit = BoxFit.cover,
    double borderRadius = 12,
    String? placeholder,
    String? errorWidget,
    Color? backgroundColor,
    BoxBorder? border,
    List<BoxShadow>? boxShadow,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomCachedImage(
      imageUrl: imageUrl,
      width: width,
      height: height.h,
      fit: fit,
      borderRadius: BorderRadius.circular(borderRadius.r),
      placeholder: placeholder,
      errorWidget: errorWidget,
      backgroundColor: backgroundColor,
      border: border,
      boxShadow: boxShadow,
      margin: margin,
    );
  }
}
