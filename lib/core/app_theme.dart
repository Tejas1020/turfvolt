import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.appBg,
  primaryColor: AppColors.summerOrange,
  colorScheme: ColorScheme.dark(
    primary: AppColors.summerOrange,
    secondary: AppColors.oceanBlue,
    tertiary: AppColors.success,
    surface: AppColors.cardBg,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onTertiary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  fontFamily: GoogleFonts.dmSans().fontFamily,
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderDefault, width: 0.5),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.borderDefault, width: 0.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.summerOrange, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.coral, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.coral, width: 2),
    ),
    hintStyle: GoogleFonts.dmSans(
      color: AppColors.textDim,
      fontSize: 14,
      letterSpacing: 0.3,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.summerOrange,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(64, 48), // 48dp minimum touch target
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.summerOrange,
      textStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(48, 48), // 48dp minimum touch target
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: const BorderSide(color: AppColors.borderLight, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(64, 48), // 48dp minimum touch target
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBg,
    elevation: 2,
    shadowColor: Colors.black.withOpacity(0.3),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.borderDefault, width: 0.5),
    ),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.borderDefault,
    thickness: 0.5,
    space: 1,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.cardBg,
    contentTextStyle: GoogleFonts.dmSans(
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
    elevation: 4,
    actionTextColor: AppColors.summerOrange,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.cardBg,
    elevation: 8,
    shadowColor: Colors.black.withOpacity(0.5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: GoogleFonts.dmSans(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    contentTextStyle: GoogleFonts.dmSans(
      color: AppColors.textMuted,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: AppColors.cardBg,
    selectedItemColor: AppColors.summerOrange,
    unselectedItemColor: AppColors.textMuted,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    titleTextStyle: TextStyle(
      color: AppColors.textPrimary,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.summerOrange,
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.summerOrange;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(Colors.white),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.summerOrange;
      }
      return AppColors.textDim;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.summerOrange;
      }
      return AppColors.textDim;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.summerOrange.withOpacity(0.5);
      }
      return AppColors.borderDark;
    }),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.summerOrange,
    linearTrackColor: AppColors.borderDark,
    circularTrackColor: AppColors.borderDark,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.summerOrange,
    inactiveTrackColor: AppColors.borderDark,
    thumbColor: AppColors.summerOrange,
    overlayColor: AppColors.summerOrange.withOpacity(0.2),
    valueIndicatorColor: AppColors.summerOrange,
    valueIndicatorTextStyle: GoogleFonts.dmSans(
      color: Colors.white,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.cardBg,
    selectedColor: AppColors.summerOrange,
    labelStyle: GoogleFonts.dmSans(
      color: AppColors.textPrimary,
      fontSize: 13,
      fontWeight: FontWeight.w500,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    side: const BorderSide(color: AppColors.borderDefault, width: 0.5),
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    titleTextStyle: GoogleFonts.dmSans(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    subtitleTextStyle: GoogleFonts.dmSans(
      color: AppColors.textMuted,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
);
