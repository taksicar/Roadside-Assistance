import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';

class CenterMarkerWidget extends StatelessWidget {
  final bool isPickup;
  final bool isMoving;
  final double liftHeight;

  const CenterMarkerWidget({
    Key? key,
    required this.isPickup,
    required this.isMoving,
    required this.liftHeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Choose color based on whether this is a pickup or destination marker
    final Color markerColor = isPickup
        ? ColorManager.secondary  // Use red color for pickup point as shown in image
        : Colors.purple;          // Use purple color for destination

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOutCubic,
      margin: EdgeInsets.only(bottom: liftHeight), // Lift effect
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(isPickup?IconAssets.pin:IconAssets.pin2,),

          // Add a small shadow/reflection under the marker when it's lifted
          if (isMoving)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10.w,
              height: 3.h,
              margin: EdgeInsets.only(top: 2.h),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(5.r),
                // Blur effect for shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Custom clipper to create the triangle pointer at the bottom of pin
class TriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}