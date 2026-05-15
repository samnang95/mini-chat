import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  final Color? backgroundColor;
  final Color? textColor;

  const XButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = XButtonType.primary,
    this.isLoading = false,
    this.isFullWidth = true,
    this.svgIconPath,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color foregroundColor;
    BorderSide borderSide;

    final colorScheme = Theme.of(context).colorScheme;

    switch (type) {
      case XButtonType.primary:
        backgroundColor = colorScheme.primary;
        foregroundColor = colorScheme.onPrimary;
        borderSide = BorderSide.none;
        break;
      case XButtonType.secondary:
        backgroundColor = Theme.of(context).cardColor;
        foregroundColor = colorScheme.onSurface;
        borderSide = BorderSide.none;
        break;
      case XButtonType.outline:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide(color: colorScheme.primary, width: 1.5);
        break;
      case XButtonType.text:
        backgroundColor = Colors.transparent;
        foregroundColor = colorScheme.primary;
        borderSide = BorderSide.none;
        break;
    }

    if (this.backgroundColor != null) {
      backgroundColor = this.backgroundColor!;
    }
    if (this.textColor != null) {
      foregroundColor = this.textColor!;
    }

    // Handle disabled state
    if (onPressed == null && !isLoading) {
      backgroundColor = Theme.of(context).disabledColor.withValues(alpha: 0.12);
      foregroundColor = Theme.of(context).disabledColor;
      if (type == XButtonType.outline || type == XButtonType.text) {
        backgroundColor = Colors.transparent;
        borderSide = type == XButtonType.outline
            ? BorderSide(color: Theme.of(context).disabledColor, width: 1.5)
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
