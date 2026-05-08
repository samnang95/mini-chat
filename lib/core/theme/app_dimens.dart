import 'package:flutter/material.dart';
import 'package:mini_chat/core/theme/app_colors.dart';

/// Spacing, radius, elevation, and duration constants.
abstract class AppDimens {
  // ── Spacing ─────────────────────────────────────────────
  static const spacing4 = 4.0;
  static const spacing8 = 8.0;
  static const spacing12 = 12.0;
  static const spacing16 = 16.0;
  static const spacing20 = 20.0;
  static const spacing24 = 24.0;
  static const spacing32 = 32.0;
  static const spacing48 = 48.0;
  static const spacing64 = 64.0;

  // ── Border Radius ──────────────────────────────────────
  static const radiusSmall = 8.0;
  static const radiusMedium = 12.0;
  static const radiusLarge = 16.0;
  static const radiusXL = 24.0;
  static const radiusFull = 999.0;

  static final borderRadiusSmall = BorderRadius.circular(radiusSmall);
  static final borderRadiusMedium = BorderRadius.circular(radiusMedium);
  static final borderRadiusLarge = BorderRadius.circular(radiusLarge);
  static final borderRadiusXL = BorderRadius.circular(radiusXL);
  static final borderRadiusFull = BorderRadius.circular(radiusFull);

  // ── Elevation ──────────────────────────────────────────
  static const elevationNone = 0.0;
  static const elevationLow = 2.0;
  static const elevationMedium = 4.0;
  static const elevationHigh = 8.0;

  // ── Icon Sizes ─────────────────────────────────────────
  static const iconSmall = 16.0;
  static const iconMedium = 24.0;
  static const iconLarge = 32.0;

  // ── Avatar Sizes ───────────────────────────────────────
  static const avatarSmall = 32.0;
  static const avatarMedium = 44.0;
  static const avatarLarge = 64.0;

  // ── Button Heights ─────────────────────────────────────
  static const buttonHeight = 48.0;
  static const buttonHeightSmall = 36.0;

  // ── Input Heights ──────────────────────────────────────
  static const inputHeight = 52.0;

  // ── App Bar ────────────────────────────────────────────
  static const appBarHeight = 56.0;

  // ── Chat Bubble ────────────────────────────────────────
  static const bubbleMaxWidth = 0.75; // 75% of screen width
  static const bubbleRadius = 18.0;

  // ── Shadows ────────────────────────────────────────────
  static final shadowLight = [
    BoxShadow(
      color: AppColors.textPrimary.withValues(alpha: 0.04),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static final shadowMedium = [
    BoxShadow(
      color: AppColors.textPrimary.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  // ── Animation Durations ────────────────────────────────
  static const durationFast = Duration(milliseconds: 150);
  static const durationMedium = Duration(milliseconds: 300);
  static const durationSlow = Duration(milliseconds: 500);
}
