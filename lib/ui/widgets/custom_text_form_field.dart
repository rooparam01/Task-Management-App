import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:taskmanager/core/constants/common_colors.dart';

class CustomTextFormField extends StatelessWidget {
  const CustomTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.prefix,
    this.suffix,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.maxLines = 1,
    this.minLines = 1,
    this.maxLength,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.validator,
    this.onChanged,
    this.onTap,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.fillColor,
    this.borderRadius = 12,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;

  final String? hintText;
  final String? labelText;

  final Widget? prefix;
  final Widget? suffix;

  final TextInputType textInputType;
  final TextInputAction textInputAction;

  final bool obscureText;
  final int maxLines;
  final int minLines;
  final int? maxLength;

  final bool enabled;
  final bool readOnly;
  final bool autofocus;

  final double borderRadius;
  final Color? fillColor;

  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;
  final ValueChanged<String>? onFieldSubmitted;

  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      autofocus: autofocus,
      readOnly: readOnly,
      enabled: enabled,
      obscureText: obscureText,
      keyboardType: textInputType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: inputFormatters,
      cursorColor: AppColors.primary,

      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: AppColors.textPrimary,
      ),

      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,

        hintStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.hint,
        ),

        labelStyle: const TextStyle(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),

        prefixIcon: prefix,
        suffixIcon: suffix,

        filled: true,
        fillColor: fillColor ?? AppColors.inputFill,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),

        border: _border(AppColors.border),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, width: 1.5),
        errorBorder: _border(AppColors.error),
        focusedErrorBorder: _border(AppColors.error),

        errorStyle: const TextStyle(
          fontSize: 12,
          color: AppColors.error,
        ),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(borderRadius),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
