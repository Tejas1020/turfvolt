import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // Display — Bebas Neue
  static TextStyle appLogo = GoogleFonts.bebasNeue(
    fontSize: 28, letterSpacing: 2, color: AppColors.textPrimary,
  );
  static TextStyle screenTitle = GoogleFonts.bebasNeue(
    fontSize: 22, letterSpacing: 1.5, color: AppColors.textPrimary,
  );
  static TextStyle completionTitle = GoogleFonts.bebasNeue(
    fontSize: 32, letterSpacing: 2, color: AppColors.textPrimary,
  );
  static TextStyle streakNumber = GoogleFonts.bebasNeue(
    fontSize: 32, letterSpacing: 1, color: AppColors.textPrimary,
  );

  // Body — DM Sans
  static TextStyle statValue = GoogleFonts.dmSans(
    fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.lime,
  );
  static TextStyle cardTitle = GoogleFonts.dmSans(
    fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.textPrimary,
  );
  static TextStyle exerciseName = GoogleFonts.dmSans(
    fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.textPrimary,
  );
  static TextStyle body = GoogleFonts.dmSans(
    fontSize: 13, fontWeight: FontWeight.w400, color: AppColors.textPrimary,
  );
  static TextStyle label = GoogleFonts.dmSans(
    fontSize: 13, fontWeight: FontWeight.w500, color: AppColors.textMuted,
  );
  static TextStyle secondary = GoogleFonts.dmSans(
    fontSize: 12, color: AppColors.textMuted,
  );
  static TextStyle micro = GoogleFonts.dmSans(
    fontSize: 11, color: AppColors.textDim,
  );
  static TextStyle chipText = GoogleFonts.dmSans(
    fontSize: 11, fontWeight: FontWeight.w500,
  );
  static TextStyle navLabel = GoogleFonts.dmSans(
    fontSize: 10, fontWeight: FontWeight.w400,
  );
}
