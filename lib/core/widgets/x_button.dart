import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mini_chat/core/theme/app_colors.dart';
import 'package:mini_chat/core/theme/app_dimens.dart';
import 'package:mini_chat/core/theme/app_typography.dart';

enum XButtonType {
  primary,
  secondary,
  outline,
  text,
}


class XButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final XButtonType type;
  final bool isLoading;
  final bool isFullWidth;
  final String? svgIconPath;

  const XButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = XButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    switch (type) {
      case XButtonType.primary:
        backgroundColor = AppColors.primary;
        foregroundColor = AppColors.white;
        borderSide = BorderSide.none;
        break;
      case XButtonType.secondary:
        backgroundColor = isDark ? AppColors.darkCard : AppColors.card;
        foregroundColor = isDark ? AppColors.darkTextPrimary : AppColors.textPrimary;
        borderSide = BorderSide.none;
        break;
      case XButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = const BorderSide(color: AppColors.primary, width: 1.5);
        break;
      case XButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.primary;
        borderSide = BorderSide.none;
        break;
    }

    // Handle disabled state
    if (onPressed == null && !isLoading) {
      backgroundColor = AppColors.disabled;
      foregroundColor = AppColors.white;
      if (type == XButtonType.outline || type == XButtonType.text) {
        backgroundColor = Colors.transparent;
        foregroundColor = AppColors.disabled;
        borderSide = type == XButtonType.outline
            ? const BorderSide(color: AppColors.disabled, width: 1.5)
            : BorderSide.none;
      }
    }

    // Button content (Icon + Text or Loading Spinner)
    Widget content = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (svgIconPath != null) ...[
                SvgPicture.asset(
                  svgIconPath!,
                  width: AppDimens.iconMedium,
                  height: AppDimens.iconMedium,
                  colorFilter: ColorFilter.mode(foregroundColor, BlendMode.srcIn),
                ),
                const SizedBox(width: AppDimens.spacing8),
              ],
              Text(
                label,
                style: AppTypography.button.copyWith(color: foregroundColor),
              ),
            ],
          );

    // Button style wrapper
    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: AppDimens.buttonHeight,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: type == XButtonType.primary ? AppDimens.elevationLow : 0,
          side: borderSide,
          shape: RoundedRectangleBorder(
            borderRadius: AppDimens.borderRadiusMedium,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.spacing24,
          ),
        ),
        child: content,
      ),
    );
  }
}
