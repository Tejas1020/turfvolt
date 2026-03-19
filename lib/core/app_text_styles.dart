import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTextStyles {
  // ── DISPLAY HERO (32sp/700) ─────────────────────────────────────────────────────
  // Greetings, workout titles, major achievements
  // Used for: "Ready to crush it?", workout names, PR celebrations
  static TextStyle displayHero = GoogleFonts.bebasNeue(
    fontSize: 32,
    letterSpacing: 1,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // App Logo - special display with brand energy
  static TextStyle appLogo = GoogleFonts.bebasNeue(
    fontSize: 32,
    letterSpacing: 2,
    color: AppColors.summerOrange,
    fontWeight: FontWeight.w700,
    shadows: [
      Shadow(
        color: AppColors.summerOrange.withOpacity(0.3),
        offset: const Offset(0, 0),
        blurRadius: 8,
      ),
    ],
  );

  // ── HEADLINE (24sp/600) ─────────────────────────────────────────────────────────
  // Section headers, card titles
  // Used for: "Today's Workout", "Weekly Progress", "Active Challenges"
  static TextStyle headline = GoogleFonts.bebasNeue(
    fontSize: 24,
    letterSpacing: 0.5,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static TextStyle screenTitle = GoogleFonts.bebasNeue(
    fontSize: 26,
    letterSpacing: 0.8,
    color: AppColors.textPrimary,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // ── STAT VALUE (28sp/700) ───────────────────────────────────────────────────────
  // Metrics, streaks, key numbers
  // Used for: streak counts, weight PRs, rep maxes
  static TextStyle statValue = GoogleFonts.dmSans(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.summerOrange,
    letterSpacing: -0.5,
    height: 1.2,
  );

  static TextStyle streakNumber = GoogleFonts.bebasNeue(
    fontSize: 36,
    letterSpacing: 1,
    color: AppColors.summerOrange,
    fontWeight: FontWeight.w700,
    shadows: [
      Shadow(
        color: AppColors.summerOrange.withOpacity(0.4),
        offset: const Offset(0, 0),
        blurRadius: 12,
      ),
    ],
  );

  static TextStyle completionTitle = GoogleFonts.bebasNeue(
    fontSize: 36,
    letterSpacing: 1,
    color: AppColors.summerOrange,
    fontWeight: FontWeight.w700,
    height: 1.1,
  );

  // ── BODY PRIMARY (16sp/400) ─────────────────────────────────────────────────────
  // Main content, readable during movement
  // Used for: exercise descriptions, instructions, main text
  static TextStyle bodyPrimary = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.5, // 1.5x line height for readability during movement
  );

  static TextStyle body = bodyPrimary;

  // ── BODY SECONDARY (14sp/400) ───────────────────────────────────────────────────
  // Descriptions, meta information, subtitles
  // Used for: exercise sets info, timestamps, secondary content
  static TextStyle bodySecondary = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.5,
  );

  static TextStyle secondary = bodySecondary;

  // ── CARD TITLE (16sp/700) ───────────────────────────────────────────────────────
  // Card headers, exercise names
  static TextStyle cardTitle = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textPrimary,
    letterSpacing: 0.2,
    height: 1.3,
  );

  static TextStyle exerciseName = GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    letterSpacing: 0.3,
    height: 1.4,
  );

  // ── BUTTON (16sp/600) ───────────────────────────────────────────────────────────
  // All CTAs - 48dp minimum touch target enforced in theme
  static TextStyle buttonPrimary = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
    color: Colors.white,
  );

  static TextStyle buttonSecondary = GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.4,
    color: AppColors.textPrimary,
  );

  // ── LABEL (12sp/600) ────────────────────────────────────────────────────────────
  // Form labels, input headers
  static TextStyle label = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textMuted,
    letterSpacing: 0.5,
    height: 1.4,
  );

  // ── CAPTION (12sp/500) ──────────────────────────────────────────────────────────
  // Timestamps, labels, small metadata
  // Used for: "3 min ago", "5 exercises", date stamps
  static TextStyle caption = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textDim,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle micro = GoogleFonts.dmSans(
    fontSize: 11,
    color: AppColors.textDim,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextStyle chipText = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.3,
  );

  static TextStyle navLabel = GoogleFonts.dmSans(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.2,
  );

  // ── FORM/DIALOG TEXT ────────────────────────────────────────────────────────────
  static TextStyle inputHint = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textDim,
    letterSpacing: 0.3,
    height: 1.4,
  );

  static TextStyle dialogContent = GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    letterSpacing: 0.2,
    height: 1.5,
  );
}
