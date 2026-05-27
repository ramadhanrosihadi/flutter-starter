import 'package:flutter/material.dart';

abstract final class AppColors {
  // Stark Minimalist Brand Colors
  static const Color primary = Color(0xFF111111); // Obsidian Black
  static const Color primaryLight = Color(0xFF333333); // Off-Black
  static const Color primaryDark = Color(0xFF000000); // Pure OLED Black

  // Secondary Minimalist Brand Colors
  static const Color secondary = Color(0xFF555555); // Deep Slate Grey
  static const Color secondaryLight = Color(0xFF888888); // Neutral Slate
  static const Color secondaryDark = Color(0xFF222222); // Dark Charcoal

  // Neutral Palette (Premium Zinc Tones)
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF4F4F5);
  static const Color grey200 = Color(0xFFE4E4E7);
  static const Color grey400 = Color(0xFFA1A1AA);
  static const Color grey600 = Color(0xFF71717A);
  static const Color grey800 = Color(0xFF27272A);
  static const Color grey900 = Color(0xFF09090B);

  // Semantic Accents (Refined & Controlled)
  static const Color success = Color(0xFF10B981); // Emerald
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Crimson Rose
  static const Color info = Color(0xFF3B82F6); // Clean Tech Blue

  // Surfaces
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF09090B);
}
