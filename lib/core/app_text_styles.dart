import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ── DISPLAY HERO (32sp/700) ───────────────────────────────────────────────────
  // Greetings, workout titles, major achievements - Using Rosnoc font
  static TextStyle displayHero = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 32,
    letterSpacing: 1,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // Gradient hero — used with GradientText widget for large display text
  static TextStyle gradientHero = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 32,
    letterSpacing: 1,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // App Logo - premium brand display with lime accent
  static TextStyle appLogo = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 32,
    letterSpacing: 3,
    color: AppColors.lime,
    fontWeight: FontWeight.w700,
    shadows: [
      Shadow(
        color: Color(0x66BAFA20),
        offset: Offset(0, 0),
        blurRadius: 12,
      ),
    ],
  );

  // ── HEADLINE (24sp/600) ────────────────────────────────────────────────────────
  // Section headers, card titles - white #FFFFFF
  static TextStyle headline = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 24,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  static TextStyle screenTitle = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 24,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    height: 1.2,
  );

  // Section header - Semi-bold 600, 18-20px, white
  static TextStyle sectionHeader = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 18,
    letterSpacing: 0.3,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    height: 1.3,
  );

  // ── STAT VALUE (28sp/700) ─────────────────────────────────────────────────────
  // Metrics, streaks, key numbers — lime for premium feel
  static TextStyle statValue = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.lime,
    letterSpacing: -0.5,
    height: 1.2,
  );

  // Streak number — large premium lime
  static TextStyle streakNumber = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 36,
    letterSpacing: 1,
    color: AppColors.lime,
    fontWeight: FontWeight.w700,
    shadows: [
      Shadow(
        color: Color(0x4DBAFA20),
        offset: Offset(0, 0),
        blurRadius: 12,
      ),
    ],
  );

  // Completion celebration title
  static TextStyle completionTitle = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 36,
    letterSpacing: 1,
    color: AppColors.lime,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // ── BODY PRIMARY (16sp/400) ──────────────────────────────────────────────────
  // Rosnoc font for body text - white
  static TextStyle bodyPrimary = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static TextStyle body = bodyPrimary;

  // ── BODY SECONDARY (14sp/400) ────────────────────────────────────────────────
  // Muted gray #888888 for metadata
  static TextStyle bodySecondary = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static TextStyle secondary = bodySecondary;

  // ── CARD TITLE (16sp/700) ────────────────────────────────────────────────────
  static TextStyle cardTitle = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 18,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static TextStyle exerciseName = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // ── BUTTON (16sp/600) ───────────────────────────────────────────────────────
  // Primary buttons have dark text on lime bg
  static TextStyle buttonPrimary = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.4,
    color: AppColors.buttonTextDark,
  );

  static TextStyle buttonSecondary = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ── LABEL (12sp/600) ─────────────────────────────────────────────────────────
  static TextStyle label = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ── CAPTION (12sp/500) ───────────────────────────────────────────────────────
  static TextStyle caption = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // Minimum text size is 11px
  static TextStyle micro = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 11,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextStyle chipText = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.3,
  );

  static TextStyle navLabel = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ── FORM/DIALOG TEXT ─────────────────────────────────────────────────────────
  static TextStyle inputHint = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle dialogContent = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.5,
  );

  // ── ACCENT / LINKS ───────────────────────────────────────────────────────────
  // Semi-bold, lime accent color for AI features and links
  static TextStyle accent = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.lime,
    letterSpacing: 0.3,
  );

  // ── DIFFICULTY TAGS ───────────────────────────────────────────────────────────
  static TextStyle tagEasy = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.tagGreen,
    letterSpacing: 0.3,
  );

  static TextStyle tagMedium = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.tagAmber,
    letterSpacing: 0.3,
  );

  static TextStyle tagHard = const TextStyle(
    fontFamily: 'Rosnoc',
    fontSize: 11,
    fontWeight: FontWeight.w600,
    color: AppColors.tagRed,
    letterSpacing: 0.3,
  );
}