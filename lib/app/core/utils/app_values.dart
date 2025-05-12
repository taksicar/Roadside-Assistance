import 'package:flutter/material.dart';

class AppMargin {
  static const double m8 = 8.0;
  static const double m12 = 12.0;
  static const double m14 = 14.0;
  static const double m16 = 16.0;
  static const double m18 = 18.0;
  static const double m20 = 20.0;
}

class AppPadding {
  static const double p4 = 4.0;
  static const double p8 = 8.0;
  static const double p12 = 12.0;
  static const double p14 = 14.0;
  static const double p16 = 16.0;
  static const double p18 = 18.0;
  static const double p20 = 20.0;
  static const double p24 = 24.0;
  static const double p28 = 28.0;
  static const double p30 = 30.0;
  static const double p60 = 60.0;
  static const double p100 = 100.0;
}

class AppSize {
  static const double s0 = 0;
  static const double s1 = 1;
  static const double s1_5 = 1.5;
  static const double s4 = 4.0;
  static const double s8 = 8.0;
  static const double s12 = 12.0;
  static const double s14 = 14.0;
  static const double s16 = 16.0;
  static const double s18 = 18.0;
  static const double s20 = 20.0;
  static const double s28 = 28.0;
  static const double s40 = 40.0;
  static const double s50 = 50.0;
  static const double s60 = 60.0;
  static const double s65 = 65.0;
  static const double s90 = 90.0;
  static const double s100 = 100.0;
  static const double s120 = 120.0;
  static const double s140 = 140.0;
  static const double s160 = 160.0;
  static const double s190 = 190.0;
}

class AppRadius {
  static const double r4 = 4.0;
  static const double r8 = 8.0;
  static const double r10 = 10.0;
  static const double r12 = 12.0;
  static const double r14 = 14.0;
  static const double r16 = 16.0;
  static const double r20 = 20.0;
  static const double r25 = 25.0;
  static const double r30 = 30.0;
  static const double r40 = 40.0;
  static const double r50 = 50.0;
  static const double r100 = 100.0;
}

class AppDuration {
  static const int d300 = 300;
  static const int d500 = 500;
  static const int d800 = 800;
  static const int d3000 = 3000;
}

/// Helper class for setting up your app resources
class Resources {
  /// Initialize resources that need to be set up before app starts
  static Future<void> init() async {
    return Future.value();
  }

  /// Get the screen width
  static double getScreenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  /// Get the screen height
  static double getScreenHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  /// Calculate responsive size based on screen width
  static double getResponsiveSize(BuildContext context, double percentage) {
    return getScreenWidth(context) * percentage;
  }

  /// Check if the device is in RTL mode (right-to-left)
  static bool isRTL(BuildContext context) {
    return Directionality.of(context) == TextDirection.rtl;
  }
}
