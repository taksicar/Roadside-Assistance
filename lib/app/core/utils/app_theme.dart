import 'package:flutter/material.dart';

import 'app_assets.dart';
import 'app_colors.dart';
import 'app_values.dart';

/// Manages the app theme
class AppTheme {
  // Text styles for various components
  static TextStyle get _headingTextStyle => TextStyle(
    fontFamily: FontConstants.jfFlatBold,
    color: ColorManager.textPrimary,
    fontSize: FontSize.s20,
    fontWeight: FontWeightManager.bold,
  );

  static TextStyle get _subheadingTextStyle => TextStyle(
    fontFamily: FontConstants.jfFlatMedium,
    color: ColorManager.textPrimary,
    fontSize: FontSize.s16,
    fontWeight: FontWeightManager.medium,
  );

  static TextStyle get _bodyTextStyle => TextStyle(
    fontFamily: FontConstants.jfFlatRegular,
    color: ColorManager.textPrimary,
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.regular,
  );

  static TextStyle get _buttonTextStyle => TextStyle(
    fontFamily: FontConstants.jfFlatBold,
    color: ColorManager.white,
    fontSize: FontSize.s16,
    fontWeight: FontWeightManager.bold,
  );

  static TextStyle get _hintTextStyle => TextStyle(
    fontFamily: FontConstants.jfFlatRegular,
    color: ColorManager.textHint,
    fontSize: FontSize.s14,
    fontWeight: FontWeightManager.regular,
  );

  // Light theme
  static ThemeData get lightTheme {
    return ThemeData(
      // Main colors
      primaryColor: ColorManager.primary,
      scaffoldBackgroundColor: ColorManager.background,
      colorScheme: ColorScheme.light(
        primary: ColorManager.primary,
        secondary: ColorManager.secondary,
        onPrimary: ColorManager.white,
        onSecondary: ColorManager.textPrimary,
        surface: ColorManager.card,
        onSurface: ColorManager.textPrimary,
        error: ColorManager.error,
        onError: ColorManager.white,
      ),

      // Default font
      fontFamily: FontConstants.jfFlatRegular,

      // Text theme
      textTheme: TextTheme(
        headlineLarge: _headingTextStyle.copyWith(fontSize: FontSize.s26),
        headlineMedium: _headingTextStyle.copyWith(fontSize: FontSize.s22),
        headlineSmall: _headingTextStyle.copyWith(fontSize: FontSize.s18),

        titleLarge: _subheadingTextStyle.copyWith(fontSize: FontSize.s16),
        titleMedium: _subheadingTextStyle.copyWith(fontSize: FontSize.s14),
        titleSmall: _subheadingTextStyle.copyWith(fontSize: FontSize.s12),

        bodyLarge: _bodyTextStyle.copyWith(fontSize: FontSize.s16),
        bodyMedium: _bodyTextStyle,
        bodySmall: _bodyTextStyle.copyWith(fontSize: FontSize.s12),

        labelLarge: _buttonTextStyle,
        labelMedium: _buttonTextStyle.copyWith(fontSize: FontSize.s14),
        labelSmall: _buttonTextStyle.copyWith(fontSize: FontSize.s12),
      ),

      // App bar theme
      appBarTheme: AppBarTheme(
        backgroundColor: ColorManager.primary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: _headingTextStyle.copyWith(
          color: ColorManager.white,
          fontSize: FontSize.s18,
        ),
        iconTheme: IconThemeData(color: ColorManager.white),
      ),

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: ColorManager.primary,
          foregroundColor: ColorManager.white,
          minimumSize: Size(double.infinity, AppSize.s50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.r8),
          ),
          elevation: 0,
          textStyle: _buttonTextStyle,
          padding: const EdgeInsets.symmetric(
            vertical: AppPadding.p14,
            horizontal: AppPadding.p16,
          ),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: ColorManager.primary,
          textStyle: _subheadingTextStyle.copyWith(color: ColorManager.primary),
        ),
      ),

      // Input decoration theme
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p16,
          vertical: AppPadding.p16,
        ),
        hintStyle: _hintTextStyle,
        labelStyle: _bodyTextStyle.copyWith(color: ColorManager.grey600),
        errorStyle: _bodyTextStyle.copyWith(color: ColorManager.error),

        // Borders
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.error),
        ),

        filled: true,
        fillColor: ColorManager.white,
      ),

      // Card theme
      cardTheme: CardTheme(
        color: ColorManager.white,
        shadowColor: ColorManager.shadow,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r12),
        ),
        margin: const EdgeInsets.all(AppMargin.m8),
      ),

      // Progress indicator theme
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: ColorManager.primary,
        circularTrackColor: ColorManager.grey200,
        linearTrackColor: ColorManager.grey200,
      ),

      // Divider theme
      dividerTheme: DividerThemeData(
        color: ColorManager.divider,
        thickness: 1,
        space: AppSize.s20,
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorManager.primary;
          }
          return ColorManager.white;
        }),
        checkColor: WidgetStateProperty.all(ColorManager.white),
        side: BorderSide(color: ColorManager.grey400, width: AppSize.s1_5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.r4),
        ),
      ),
    );
  }

  // Reusable text styles exposed for direct use
  static TextStyle get headingStyle => _headingTextStyle;
  static TextStyle get subheadingStyle => _subheadingTextStyle;
  static TextStyle get bodyStyle => _bodyTextStyle;
  static TextStyle get buttonStyle => _buttonTextStyle;
  static TextStyle get hintStyle => _hintTextStyle;
}
