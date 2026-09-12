import 'package:flutter/material.dart';

/// Centralized color palette based on the FoodAtlas design system.
class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFFFF7A00);
  static const Color primaryLight = Color(0xFFFF9A4A);
  static const Color primaryDark = Color(0xFFAD4F00);
  static const Color secondary = Color(0xFFFFF8F1);
  static const Color tertiary = Color(0xFF121212);
  static const Color neutral = Color(0xFF6B7280);

  // Light theme
  static const Color lightBackground = Color(0xFFF3F6FC);
  static const Color lightSurface = Color(0xFFFFFBF7);
  static const Color lightCard = Color(0xFFFFFCF8);
  static const Color lightTextPrimary = Color(0xFF121826);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightBorder = Color(0xFFFFC49B);
  static const Color lightMuted = Color(0xFFE9EEF8);

  // Dark theme
  static const Color darkBackground = Color(0xFF0B0D10);
  static const Color darkSurface = Color(0xFF121212);
  static const Color darkCard = Color(0xFF191B20);
  static const Color darkTextPrimary = Color(0xFFFFFBF7);
  static const Color darkTextSecondary = Color(0xFFA7AFBF);
  static const Color darkBorder = Color(0xFF2E333D);

  // Status
  static const Color error = Color(0xFFD7263D);
  static const Color success = Color(0xFF2FB344);
  static const Color warning = Color(0xFFFFB020);
  static const Color rating = Color(0xFFFFB020);
}
