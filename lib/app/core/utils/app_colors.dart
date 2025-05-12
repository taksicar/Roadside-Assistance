import 'package:flutter/material.dart';

class ColorManager {
  // Primary and secondary colors
  static const Color primary = Color(0xFF5E5CE6);
  static const Color primaryLight = Color(0xFF7A78EC);
  static const Color primaryDark = Color(0xFF4240A9);

  static const Color secondary = Color(0xFFFFCC00);
  static const Color secondaryLight = Color(0xFFFFD84D);
  static const Color secondaryDark = Color(0xFFCC9900);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color background = Color(0xFFF8F9FD);
  static const Color card = Color(0xFFFFFFFF);

  // Text colors
  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textHint = Color(0xFFAAAAAA);

  // Gray scales
  static const Color grey50 = Color(0xFFF9FAFB);
  static const Color grey100 = Color(0xFFF3F4F6);
  static const Color grey200 = Color(0xFFE5E7EB);
  static const Color grey300 = Color(0xFFD1D5DB);
  static const Color grey400 = Color(0xFF9CA3AF);
  static const Color grey500 = Color(0xFF6B7280);
  static const Color grey600 = Color(0xFF4B5563);
  static const Color grey700 = Color(0xFF374151);
  static const Color grey800 = Color(0xFF1F2937);
  static const Color grey900 = Color(0xFF111827);

  // Status colors
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  // Divider color
  static const Color divider = Color(0xFFE0E0E0);

  // Shadow color
  static const Color shadow = Color(0x1A000000);
}

/// Extension to provide opacity variations of colors
extension ColorExtension on Color {
  Color get withOpacity10 => withValues(alpha: 0.1);
  Color get withOpacity20 => withValues(alpha: 0.2);
  Color get withOpacity30 => withValues(alpha: 0.3);
  Color get withOpacity40 => withValues(alpha: 0.4);
  Color get withOpacity50 => withValues(alpha: 0.5);
  Color get withOpacity60 => withValues(alpha: 0.6);
  Color get withOpacity70 => withValues(alpha: 0.7);
  Color get withOpacity80 => withValues(alpha: 0.8);
  Color get withOpacity90 => withValues(alpha: 0.9);
}
