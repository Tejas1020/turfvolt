import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.appBg,
  primaryColor: AppColors.roseGold,
  colorScheme: ColorScheme.dark(
    primary: AppColors.roseGold,
    secondary: AppColors.champagneGold,
    tertiary: AppColors.accentLight,
    surface: AppColors.cardBg,
    error: AppColors.error,
    onPrimary: AppColors.deepBlack,
    onSecondary: AppColors.deepBlack,
    onTertiary: AppColors.deepBlack,
    onSurface: AppColors.warmCream,
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
      borderSide: const BorderSide(color: AppColors.roseGold, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
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
      backgroundColor: AppColors.roseGold,
      foregroundColor: AppColors.deepBlack,
      elevation: 4,
      shadowColor: AppColors.roseGold.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.3,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      minimumSize: const Size(64, 48),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.roseGold,
      textStyle: GoogleFonts.dmSans(
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(48, 48),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.warmCream,
      side: const BorderSide(color: AppColors.borderDefault, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      textStyle: GoogleFonts.dmSans(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(64, 48),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBg,
    elevation: 4,
    shadowColor: Colors.black.withAlpha(77),
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
      color: AppColors.warmCream,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    behavior: SnackBarBehavior.floating,
    elevation: 6,
    actionTextColor: AppColors.roseGold,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.cardBg,
    elevation: 12,
    shadowColor: Colors.black.withAlpha(102),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: GoogleFonts.dmSans(
      color: AppColors.warmCream,
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
    selectedItemColor: AppColors.roseGold,
    unselectedItemColor: AppColors.textMuted,
    type: BottomNavigationBarType.fixed,
    elevation: 8,
    selectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
    unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w400, fontSize: 12),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.cardBg,
    elevation: 0,
    foregroundColor: AppColors.warmCream,
    titleTextStyle: TextStyle(
      color: AppColors.warmCream,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    iconTheme: IconThemeData(color: AppColors.warmCream),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.roseGold,
    foregroundColor: AppColors.deepBlack,
    elevation: 6,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.roseGold;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.deepBlack),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.roseGold;
      }
      return AppColors.textDim;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.roseGold;
      }
      return AppColors.textDim;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.roseGold.withAlpha(128);
      }
      return AppColors.borderDark;
    }),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.roseGold,
    linearTrackColor: AppColors.borderDark,
    circularTrackColor: AppColors.borderDark,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.roseGold,
    inactiveTrackColor: AppColors.borderDark,
    thumbColor: AppColors.roseGold,
    overlayColor: AppColors.roseGold.withAlpha(51),
    valueIndicatorColor: AppColors.roseGold,
    valueIndicatorTextStyle: GoogleFonts.dmSans(
      color: AppColors.deepBlack,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.inputBg,
    selectedColor: AppColors.roseGold,
    labelStyle: GoogleFonts.dmSans(
      color: AppColors.warmCream,
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
      color: AppColors.warmCream,
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
