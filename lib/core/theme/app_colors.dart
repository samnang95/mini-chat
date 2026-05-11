import 'package:flutter/material.dart';

/// Centralized color palette for the app.
/// Use these constants everywhere instead of raw Color values.
abstract class AppColors {
  // ── Brand (Primary Shades) ──────────────────────────────
  static const primaryLightest = Color(0xFFF0EFFF);
  static const primaryLighter = Color(0xFFD2D1FF);
  static const primaryLight = Color(0xFFA7A5FF);
  static const primary = Color(0xFF7C77FF); // Base
  static const primaryDark = Color(0xFF4E43FF);
  static const primaryDarker = Color(0xFF2100DD);
  static const primaryDarkest = Color(0xFF0F0082);
  static const secondary = Color(0xFF00CEC9);
  static const secondaryLight = Color(0xFF81ECEC);
  static const secondaryDark = Color(0xFF00B894);
    
  // ── Accent ──────────────────────────────────────────────
  static const accent = Color(0xFFFD79A8);

  // ── Semantic ────────────────────────────────────────────
  static const success = Color(0xFF00B894);
  static const warning = Color(0xFFFDAA5D);
  static const error = Color(0xFFE17055);
  static const info = Color(0xFF74B9FF);

  // ── Neutral (Light Mode) ────────────────────────────────
  static const white = Color(0xFFFFFFFF);
  static const background = Color(0xFFF8F9FD);
  static const surface = Color(0xFFFFFFFF);
  static const card = Color(0xFFFFFFFF);
  static const divider = Color(0xFFE8E8EE);
  static const border = Color(0xFFD1D1E0);
  static const disabled = Color(0xFFBDBDCF);

  // ── Text (Light Mode) ──────────────────────────────────
  static const textPrimary = Color(0xFF2D3436);
  static const textSecondary = Color(0xFF636E72);
  static const textHint = Color(0xFFB2BEC3);

  // ── Dark Mode ──────────────────────────────────────────
  static const darkBackground = Color(0xFF0D1117);
  static const darkSurface = Color(0xFF161B22);
  static const darkCard = Color(0xFF1C2333);
  static const darkDivider = Color(0xFF30363D);
  static const darkBorder = Color(0xFF3D4450);

  // ── Text (Dark Mode) ───────────────────────────────────
  static const darkTextPrimary = Color(0xFFF0F6FC);
  static const darkTextSecondary = Color(0xFF8B949E);
  static const darkTextHint = Color(0xFF484F58);

  // ── Chat Bubbles ───────────────────────────────────────
  static const bubbleSent = Color(0xFF6C5CE7);
  static const bubbleSentText = Color(0xFFFFFFFF);
  static const bubbleReceived = Color(0xFFF1F0F5);
  static const bubbleReceivedText = Color(0xFF2D3436);
  static const bubbleReceivedDark = Color(0xFF1C2333);
  static const bubbleReceivedTextDark = Color(0xFFF0F6FC);

  // ── Online Status ──────────────────────────────────────
  static const online = Color(0xFF00B894);
  static const offline = Color(0xFFB2BEC3);
  static const away = Color(0xFFFDAA5D);
}
