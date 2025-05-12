import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class CustomShimmer extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;
  final Color? baseColor;
  final Color? highlightColor;
  final bool isCircle;
  final EdgeInsetsGeometry? margin;

  const CustomShimmer({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    this.baseColor,
    this.highlightColor,
    this.isCircle = false,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? ColorManager.grey200,
      highlightColor: highlightColor ?? ColorManager.grey50,
      child: Container(
        width: isCircle ? height : width,
        height: height,
        margin: margin,
        decoration: ShapeDecoration(
          color: ColorManager.grey300,
          shape: isCircle ? const CircleBorder() : shapeBorder,
        ),
      ),
    );
  }

  // Factory constructor for circular shimmer
  factory CustomShimmer.circular({
    required double size,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomShimmer(
      width: size,
      height: size,
      isCircle: true,
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }

  // Factory constructor for rectangular shimmer with rounded corners
  factory CustomShimmer.rectangular({
    double? width,
    required double height,
    double borderRadius = 8,
    Color? baseColor,
    Color? highlightColor,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomShimmer(
      width: width ?? double.infinity,
      height: height,
      shapeBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
      ),
      baseColor: baseColor,
      highlightColor: highlightColor,
      margin: margin,
    );
  }
}

// Builder class for common shimmer patterns
class ShimmerWidgets {
  // Build a shimmer for text lines
  static Widget textLine({
    double? width,
    double height = 14,
    double borderRadius = 4,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomShimmer.rectangular(
      width: width,
      height: height.h,
      borderRadius: borderRadius.r,
      margin: margin,
    );
  }

  // Build multiple text lines with spacing
  static Widget textLines({
    required int lines,
    double? width,
    double height = 14,
    double spacing = 8,
    double lastLineWidth = 0.7, // 70% of the width for the last line
    double borderRadius = 4,
    EdgeInsetsGeometry? margin,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(lines, (index) {
        // Make the last line shorter if lastLineWidth < 1.0
        final isLastLine = index == lines - 1;
        final lineWidth =
            isLastLine && lastLineWidth < 1.0
                ? (width ?? double.infinity) * lastLineWidth
                : width;

        return Padding(
          padding: EdgeInsets.only(bottom: index < lines - 1 ? spacing.h : 0),
          child: CustomShimmer.rectangular(
            width: lineWidth,
            height: height.h,
            borderRadius: borderRadius.r,
            margin: margin,
          ),
        );
      }),
    );
  }

  // Build a shimmer for list item (circle + text lines)
  static Widget listItem({
    double? width,
    double height = 80,
    double imageSize = 50,
    int lines = 2,
    double spacing = 8,
    double borderRadius = 8,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      height: height.h,
      margin: margin ?? EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomShimmer.circular(size: imageSize.r),
          SizedBox(width: 16.w),
          Expanded(
            child: ShimmerWidgets.textLines(
              lines: lines,
              height: 14,
              spacing: spacing,
              borderRadius: borderRadius,
            ),
          ),
        ],
      ),
    );
  }

  // Build a shimmer for a card
  static Widget card({
    double? width,
    required double height,
    double borderRadius = 12,
    EdgeInsetsGeometry? margin,
  }) {
    return CustomShimmer.rectangular(
      width: width,
      height: height.h,
      borderRadius: borderRadius.r,
      margin: margin,
    );
  }

  // Build a shimmer for grid item
  static Widget gridItem({
    double? width,
    required double height,
    double imageHeight = 120,
    int textLines = 2,
    double spacing = 8,
    double borderRadius = 12,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      width: width,
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomShimmer.rectangular(
            width: width,
            height: imageHeight.h,
            borderRadius: borderRadius.r,
          ),
          SizedBox(height: 12.h),
          ShimmerWidgets.textLines(
            lines: textLines,
            spacing: spacing,
            borderRadius: 4,
          ),
        ],
      ),
    );
  }

  // Build a shimmer for profile header
  static Widget profileHeader({
    double avatarSize = 80,
    int textLines = 3,
    double spacing = 8,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomShimmer.circular(size: avatarSize.r),
          SizedBox(width: 16.w),
          Expanded(
            child: ShimmerWidgets.textLines(
              lines: textLines,
              spacing: spacing,
              borderRadius: 4,
            ),
          ),
        ],
      ),
    );
  }

  // Build shimmer loading indicator
  static Widget loadingIndicator({
    double size = 40,
    EdgeInsetsGeometry? margin,
  }) {
    return Container(
      margin: margin,
      child: Center(child: CustomShimmer.circular(size: size.r)),
    );
  }
}
