import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static TextStyle get _base => GoogleFonts.poppins(color: AppColors.textPrimary);

  // Headings
  static TextStyle get h1 => _base.copyWith(fontSize: 26, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get h2 => _base.copyWith(fontSize: 22, fontWeight: FontWeight.w700, height: 1.25);
  static TextStyle get h3 => _base.copyWith(fontSize: 18, fontWeight: FontWeight.w600);

  // Body
  static TextStyle get bodyMedium => _base.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
        height: 1.5,
      );
  static TextStyle get bodySmall => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: AppColors.textSecondary,
      );

  // Labels / Inputs
  static TextStyle get label => _base.copyWith(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.4,
        color: AppColors.textSecondary,
      );
  static TextStyle get inputText => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w500);
  static TextStyle get hintText => _base.copyWith(fontSize: 14, fontWeight: FontWeight.w400, color: AppColors.textHint);

  // Buttons / Links
  static TextStyle get button => _base.copyWith(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: AppColors.textOnPrimary,
      );
  static TextStyle get link => _base.copyWith(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: AppColors.link,
      );

  // Brand / Logo
  static TextStyle get brandTitle => _base.copyWith(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
      );
}
