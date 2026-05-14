import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

class XTextFieldChat extends StatelessWidget {
  final TextEditingController? controller;
  final String hintText;
  final void Function(String)? onChanged;
  final Widget? suffixIcon;

  const XTextFieldChat({
    super.key,
    this.controller,
    this.hintText = "Message...",
    this.onChanged,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.darkDivider : AppColors.divider;
    final textColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
    final hintColor = isDark ? AppColors.darkTextHint : AppColors.textHint;

    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTypography.bodyLarge.copyWith(color: textColor),
      cursorColor: AppColors.primary,
      textInputAction: TextInputAction.send,
      maxLines: 4,
      minLines: 1,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.bodyLarge.copyWith(color: hintColor),
        filled: true,
        fillColor: fillColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24.0),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.0),
        ),
        suffixIcon: suffixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [suffixIcon!],
                ),
              )
            : null,
        suffixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}