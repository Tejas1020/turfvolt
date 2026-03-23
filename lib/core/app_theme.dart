import 'package:flutter/material.dart';
import 'app_colors.dart';

ThemeData appTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.appBg,
  primaryColor: AppColors.lime,
  colorScheme: ColorScheme.dark(
    primary: AppColors.lime,
    secondary: AppColors.limeMuted,
    tertiary: AppColors.limeLight,
    surface: AppColors.cardBg,
    error: AppColors.error,
    onPrimary: AppColors.buttonTextDark,
    onSecondary: AppColors.buttonTextDark,
    onTertiary: AppColors.buttonTextDark,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),
  fontFamily: 'Rosnoc',
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.inputBg,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.borderSubtle, width: 1),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.lime, width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 1.5),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(color: AppColors.error, width: 2),
    ),
    hintStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textMuted,
      fontSize: 14,
      letterSpacing: 0.3,
      fontWeight: FontWeight.w400,
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.lime,
      foregroundColor: AppColors.buttonTextDark,
      elevation: 0,
      shadowColor: AppColors.lime.withAlpha(77),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24), // Pill shape
      ),
      textStyle: const TextStyle(fontFamily: 'Rosnoc',
        fontSize: 16,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.5,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
      minimumSize: const Size(64, 48),
    ),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.lime,
      textStyle: const TextStyle(fontFamily: 'Rosnoc',
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(48, 48),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.textPrimary,
      side: const BorderSide(color: AppColors.border, width: 1),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      textStyle: const TextStyle(fontFamily: 'Rosnoc',
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      minimumSize: const Size(64, 48),
    ),
  ),
  cardTheme: CardThemeData(
    color: AppColors.cardBg,
    elevation: 0,
    shadowColor: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: const BorderSide(color: AppColors.borderSubtle, width: 1),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
  ),
  dividerTheme: const DividerThemeData(
    color: AppColors.border,
    thickness: 0.5,
    space: 1,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: AppColors.cardBg,
    contentTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textPrimary,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    actionTextColor: AppColors.lime,
  ),
  dialogTheme: DialogThemeData(
    backgroundColor: AppColors.cardBg,
    elevation: 16,
    shadowColor: Colors.black.withAlpha(153),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    titleTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    contentTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textMuted,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    backgroundColor: AppColors.cardBg,
    selectedItemColor: AppColors.lime,
    unselectedItemColor: AppColors.textGrayDark,
    type: BottomNavigationBarType.fixed,
    elevation: 0,
    selectedLabelStyle: const TextStyle(fontFamily: 'Rosnoc', fontWeight: FontWeight.w600, fontSize: 11),
    unselectedLabelStyle: const TextStyle(fontFamily: 'Rosnoc', fontWeight: FontWeight.w400, fontSize: 11),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.appBg,
    elevation: 0,
    foregroundColor: AppColors.textPrimary,
    titleTextStyle: const TextStyle(
      fontFamily: 'Rosnoc',
      color: AppColors.textPrimary,
      fontSize: 20,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.2,
    ),
    iconTheme: const IconThemeData(color: AppColors.textPrimary),
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.lime,
    foregroundColor: AppColors.buttonTextDark,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
  ),
  checkboxTheme: CheckboxThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lime;
      }
      return Colors.transparent;
    }),
    checkColor: WidgetStateProperty.all(AppColors.buttonTextDark),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
  ),
  radioTheme: RadioThemeData(
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lime;
      }
      return AppColors.textDim;
    }),
  ),
  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.lime;
      }
      return AppColors.textDim;
    }),
    trackColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return AppColors.limeMuted;
      }
      return AppColors.borderDark;
    }),
  ),
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: AppColors.lime,
    linearTrackColor: AppColors.borderDark,
    circularTrackColor: AppColors.borderDark,
  ),
  sliderTheme: SliderThemeData(
    activeTrackColor: AppColors.lime,
    inactiveTrackColor: AppColors.borderDark,
    thumbColor: AppColors.lime,
    overlayColor: AppColors.lime.withAlpha(51),
    valueIndicatorColor: AppColors.lime,
    valueIndicatorTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.buttonTextDark,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: AppColors.cardBgElevated,
    selectedColor: AppColors.lime,
    labelStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textPrimary,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    side: const BorderSide(color: AppColors.borderSubtle, width: 1),
  ),
  listTileTheme: ListTileThemeData(
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    titleTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    subtitleTextStyle: const TextStyle(fontFamily: 'Rosnoc',
      color: AppColors.textMuted,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  ),
);