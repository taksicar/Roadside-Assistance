import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:roadside_assistance/app/core/utils/app_assets.dart';
import 'package:roadside_assistance/app/core/utils/app_colors.dart';
import 'package:roadside_assistance/app/core/utils/app_values.dart';

class CustomTextField extends StatefulWidget {
  final String? hint;
  final String? label;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final Function()? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final bool readOnly;
  final bool enabled;
  final Widget? prefix;
  final Widget? suffix;
  final int? maxLines;
  final int? minLines;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final bool autofocus;
  final EdgeInsetsGeometry? contentPadding;
  final FocusNode? focusNode;
  final bool isDense;
  final bool showCursor;
  final String? initialValue;
  final int? maxLength;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final BorderRadius? borderRadius;
  final Color? fillColor;
  final BoxConstraints? prefixIconConstraints;
  final BoxConstraints? suffixIconConstraints;
  final String? helperText;

  const CustomTextField({
    super.key,
    this.hint,
    this.label,
    this.errorText,
    this.obscureText = false,
    this.controller,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.inputFormatters,
    this.readOnly = false,
    this.enabled = true,
    this.prefix,
    this.suffix,
    this.maxLines = 1,
    this.minLines,
    this.style,
    this.hintStyle,
    this.labelStyle,
    this.autofocus = false,
    this.contentPadding,
    this.focusNode,
    this.isDense = false,
    this.showCursor = true,
    this.initialValue,
    this.maxLength,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.borderRadius,
    this.fillColor,
    this.prefixIconConstraints,
    this.suffixIconConstraints,
    this.helperText,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;
  late FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
    _focusNode = widget.focusNode ?? FocusNode();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    if (widget.focusNode == null) {
      _focusNode.removeListener(_onFocusChange);
      _focusNode.dispose();
    }
    super.dispose();
  }

  void _onFocusChange() {
    setState(() {
      _hasFocus = _focusNode.hasFocus;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onTap: widget.onTap,
      readOnly: widget.readOnly,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.inputFormatters,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      style:
          widget.style ??
          TextStyle(
            fontFamily: FontConstants.jfFlatRegular,
            fontSize: FontSize.s14,
            color: ColorManager.textPrimary,
          ),
      autofocus: widget.autofocus,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      maxLength: widget.maxLength,
      showCursor: widget.showCursor,
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle:
            widget.hintStyle ??
            TextStyle(
              fontFamily: FontConstants.jfFlatRegular,
              fontSize: FontSize.s14,
              color: ColorManager.textHint,
            ),
        labelText: widget.label,
        labelStyle:
            widget.labelStyle ??
            TextStyle(
              fontFamily: FontConstants.jfFlatRegular,
              fontSize: FontSize.s14,
              color:
                  _hasFocus ? ColorManager.primary : ColorManager.textSecondary,
            ),
        errorText: widget.errorText,
        helperText: widget.helperText,
        fillColor: widget.fillColor ?? ColorManager.white,
        filled: true,
        contentPadding:
            widget.contentPadding ??
            EdgeInsets.symmetric(
              horizontal: AppPadding.p16,
              vertical: AppPadding.p16,
            ),
        isDense: widget.isDense,
        prefixIcon:
            widget.prefix != null
                ? Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: widget.prefix,
                )
                : null,
        prefixIconConstraints: widget.prefixIconConstraints,
        suffixIcon: _buildSuffixIcon(),
        suffixIconConstraints: widget.suffixIconConstraints,
        border: OutlineInputBorder(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.grey300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.grey300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.primary),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius:
              widget.borderRadius ?? BorderRadius.circular(AppRadius.r8),
          borderSide: BorderSide(color: ColorManager.error),
        ),
      ),
    );
  }

  Widget? _buildSuffixIcon() {
    if (widget.obscureText) {
      return InkWell(
        onTap: () => setState(() => _obscureText = !_obscureText),
        child: Icon(
          _obscureText ? Icons.visibility_off : Icons.visibility,
          color: ColorManager.grey500,
        ),
      );
    } else if (widget.suffix != null) {
      return Padding(
        padding: const EdgeInsets.only(right: 16, left: 8),
        child: widget.suffix,
      );
    }
    return null;
  }

  // Factory methods for common text field types
  static Widget standard({
    String? hint,
    String? label,
    TextEditingController? controller,
    Function(String)? onChanged,
    TextInputType? keyboardType,
    String? errorText,
    bool enabled = true,
    Widget? prefix,
    Widget? suffix,
    int? maxLines = 1,
    int? minLines,
  }) {
    return CustomTextField(
      hint: hint,
      label: label,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      errorText: errorText,
      enabled: enabled,
      prefix: prefix,
      suffix: suffix,
      maxLines: maxLines,
      minLines: minLines,
    );
  }

  static Widget password({
    String? hint,
    String? label,
    TextEditingController? controller,
    Function(String)? onChanged,
    String? errorText,
    bool enabled = true,
  }) {
    return CustomTextField(
      hint: hint,
      label: label,
      controller: controller,
      onChanged: onChanged,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      errorText: errorText,
      enabled: enabled,
      prefix: Icon(Icons.lock_outline, color: ColorManager.grey500, size: 20),
    );
  }

  static Widget search({
    String? hint,
    TextEditingController? controller,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    Function()? onTap,
    bool readOnly = false,
    bool autofocus = false,
  }) {
    return CustomTextField(
      hint: hint ?? 'Search',
      controller: controller,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      autofocus: autofocus,
      prefix: Icon(Icons.search, color: ColorManager.grey500, size: 20),
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppPadding.p12,
        vertical: AppPadding.p12,
      ),
      isDense: true,
      textInputAction: TextInputAction.search,
    );
  }

  static Widget phone({
    String? hint,
    String? label,
    TextEditingController? controller,
    Function(String)? onChanged,
    String? errorText,
    bool enabled = true,
    Widget? prefix,
  }) {
    return CustomTextField(
      hint: hint ?? 'Phone Number',
      label: label,
      controller: controller,
      onChanged: onChanged,
      keyboardType: TextInputType.phone,
      errorText: errorText,
      enabled: enabled,
      prefix:
          prefix ??
          Icon(Icons.phone_android, color: ColorManager.grey500, size: 20),
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
    );
  }
}
