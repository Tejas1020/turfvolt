import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.appBg,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.lime,
    secondary: AppColors.coral,
    surface: AppColors.cardBg,
    error: AppColors.coral,
  ),
  fontFamily: GoogleFonts.dmSans().fontFamily,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.borderDefault, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.borderDefault, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: AppColors.lime, width: 1),
    ),
    hintStyle: GoogleFonts.dmSans(color: AppColors.textDim, fontSize: 13),
    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lime,
      foregroundColor: AppColors.appBg,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: GoogleFonts.dmSans(fontSize: 14, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    ),
  ),
);
