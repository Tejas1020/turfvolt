import 'package:flutter/material.dart';

class AppColors {
  // ── REFRESHING SUMMER PALETTE ────────────────────────────────────────────────────
  // Modern, fresh, energetic - inspired by summer vibes

  // ── PRIMARY - Summer Orange ──────────────────────────────────────────────────────
  // Energetic, warm, inviting. Use for primary CTAs, active states
  static const Color summerOrange  = Color(0xFFE8932B);
  static const Color primary       = Color(0xFFE8932B);
  static const Color primaryDark   = Color(0xFFD08224); // pressed states
  static const Color primaryLight  = Color(0xFFF0A84A); // highlights

  // ── SECONDARY - Ocean Blue ───────────────────────────────────────────────────────
  // Calm, trustworthy, professional. Use for secondary actions, data viz
  static const Color oceanBlue     = Color(0xFF5B9DBD);
  static const Color secondary     = Color(0xFF5B9DBD);
  static const Color secondaryDark = Color(0xFF4A8AA8); // pressed states
  static const Color secondaryLight= Color(0xFF7AB5D1); // highlights

  // ── ACCENT - Sky Blue ────────────────────────────────────────────────────────────
  // Fresh, light, airy. Use for highlights, backgrounds, accents
  static const Color skyBlue       = Color(0xFFA8D5E5);
  static const Color accent        = Color(0xFFA8D5E5);
  static const Color accentDark    = Color(0xFF8FC4D9); // pressed states
  static const Color accentLight   = Color(0xFFC4E3F0); // highlights

  // ── HIGHLIGHT - Sunshine Yellow ──────────────────────────────────────────────────
  // Joyful, optimistic, attention-grabbing. Use for badges, celebrations
  static const Color sunshineYellow= Color(0xFFF4C534);
  static const Color highlight       = Color(0xFFF4C534);
  static const Color highlightDark   = Color(0xFFD9AD2E); // pressed states
  static const Color highlightLight  = Color(0xFFF7D55A); // highlights

  // ── DEEP - Navy Blue ─────────────────────────────────────────────────────────────
  // Strong, stable, grounding. Use for text, borders, depth
  static const Color navyDeep      = Color(0xFF1B2A3A);
  static const Color deep          = Color(0xFF1B2A3A);

  // ── BACKGROUNDS ──────────────────────────────────────────────────────────────────
  // Clean, modern backgrounds
  static const Color appBg         = Color(0xFF0F171E);   // Main app background
  static const Color cardBg        = Color(0xFF1B2A3A);   // Card surfaces
  static const Color inputBg       = Color(0xFF0F171E);   // Input fields

  // ── SEMANTIC COLORS ──────────────────────────────────────────────────────────────
  static const Color error         = Color(0xFFE74C3C);
  static const Color warning       = Color(0xFFF39C12);
  static const Color success       = Color(0xFF27AE60);
  static const Color info          = oceanBlue;
  static const Color coral         = Color(0xFFFF6B6B);

  // ── NEUTRALS ─────────────────────────────────────────────────────────────────────
  static const Color whiteText     = Color(0xFFFFFFFF);
  static const Color textPrimary   = whiteText;
  static const Color textMuted     = Color(0xFF95A5A6);
  static const Color textDim       = Color(0xFF7F8C8D);

  static const Color border        = Color(0xFF2C3E50);
  static const Color borderLight   = Color(0xFF34495E);
  static const Color borderDark    = Color(0xFF1A252F);
  static const Color borderDefault = border;

  static const Color dimText       = textMuted;
  static const Color pine          = textMuted;

  // ── GRADIENT COLORS ──────────────────────────────────────────────────────────────
  static const Color streakBgStart = Color(0xFF1B2A3A);
  static const Color streakBgEnd   = Color(0xFF0F171E);
  static const Color streakSubtitle= Color(0xFF7F8C8D);

  // ── NEUMORPHISM ──────────────────────────────────────────────────────────────────
  static const Color neumoHighlight = Color(0xFF2C3E50);
  static const Color neumoShadow    = Color(0xFF0A0F14);
  static const Color neumoBg        = cardBg;

  // ── GLASS ────────────────────────────────────────────────────────────────────────
  static const Color glassFill     = Color(0x0DFFFFFF);
  static const Color glassBorder   = Color(0x1A34495E);

  // ── CONSISTENCY MATRIX ───────────────────────────────────────────────────────────
  static const Color matrixEmpty   = Color(0xFF2C3E50);
  static const Color matrixLow     = Color(0xFF5B9DBD);
  static const Color matrixMid     = Color(0xFFA8D5E5);
  static const Color matrixHeavy   = summerOrange;

  // ── COMPONENT COLORS ─────────────────────────────────────────────────────────────
  static const Color customBadgeBg = Color(0xFF1B2A3A);
  static const Color exerciseDoneBorder = success;
  static const Color chartRestBar  = Color(0xFF2C3E50);

  // ── MUSCLE GROUP COLORS ──────────────────────────────────────────────────────────
  static const Map<String, List<Color>> muscleColors = {
    'Upper Chest':  [Color(0xFF1B2A3A), summerOrange],
    'Lower Chest':  [Color(0xFF1B2A3A), coral],
    'Back':         [Color(0xFF1B2A3A), oceanBlue],
    'Shoulders':    [Color(0xFF1B2A3A), sunshineYellow],
    'Biceps':       [Color(0xFF1B2A3A), success],
    'Triceps':      [Color(0xFF1B2A3A), coral],
    'Quads':        [Color(0xFF1B2A3A), Color(0xFF9B59B6)],
    'Hamstrings':   [Color(0xFF1B2A3A), sunshineYellow],
    'Glutes':       [Color(0xFF1B2A3A), coral],
    'Calves':       [Color(0xFF1B2A3A), summerOrange],
    'Core':         [Color(0xFF1B2A3A), oceanBlue],
    'Forearms':     [Color(0xFF1B2A3A), sunshineYellow],
    'Full Body':    [Color(0xFF1B2A3A), summerOrange],
  };

  static Color muscleBg(String muscle) =>
      muscleColors[muscle]?[0] ?? cardBg;
  static Color muscleText(String muscle) =>
      muscleColors[muscle]?[1] ?? textMuted;

  // ── GRADIENTS ────────────────────────────────────────────────────────────────────
  static const LinearGradient streakGradient = LinearGradient(
    colors: [streakBgStart, streakBgEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [summerOrange, sunshineYellow],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBg, Color(0xFF2C3E50)],
  );

  static const LinearGradient matrixGradient = LinearGradient(
    colors: [matrixEmpty, matrixLow, matrixMid, matrixHeavy],
  );

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [summerOrange, primaryLight],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [oceanBlue, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [success, Color(0xFF2ECC71)],
  );

  // ── LEGACY ALIASES ───────────────────────────────────────────────────────────────
  static const Color lime            = summerOrange;
  static const Color electricBlue    = oceanBlue;
  static const Color cyan            = secondaryLight;
  static const Color limeMid         = oceanBlue;
  static const Color limeDim         = matrixMid;
  static const Color limeDark        = primaryDark;
  static const Color limeDarkAccent  = primaryDark;
  static const Color mint            = success;
  static const Color violet          = Color(0xFF9B59B6);
}
