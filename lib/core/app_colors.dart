import 'package:flutter/material.dart';

class AppColors {
  // ── TRENDING DRIBBBLE PALETTE ─────────────────────────────────────────────────
  // Vibrant coral + deep purple — energetic, premium fitness aesthetic

  // ── CORE PALETTE ────────────────────────────────────────────────────────────────
  // Deep space — rich dark base
  static const Color deepSpace = Color(0xFF0D0D1A);
  static const Color midnightPurple = Color(0xFF1A1A2E);
  static const Color richNavy = Color(0xFF16213E);

  // Vibrant coral — primary, energetic
  static const Color vibrantCoral = Color(0xFFFF6B6B);
  static const Color coralLight = Color(0xFFFF8E8E);
  static const Color coralDark = Color(0xFFE55555);

  // Electric orange — accent, high energy
  static const Color electricOrange = Color(0xFFFF9F43);
  static const Color orangeLight = Color(0xFFFFB76B);
  static const Color orangeDark = Color(0xFFE68A35);

  // Warm lime — fresh, youthful
  static const Color freshLime = Color(0xFFA8E6CF);
  static const Color limeLight = Color(0xFFC8F0DF);
  static const Color limeDark = Color(0xFF7DD3B0);

  // Soft lavender — secondary, calming contrast
  static const Color softLavender = Color(0xFFDDA0DD);
  static const Color lavenderLight = Color(0xFFEEC4E8);
  static const Color lavenderDark = Color(0xFFCD8ACD);

  // Warm cream — text on dark
  static const Color warmCream = Color(0xFFF8F4E8);
  static const Color softIvory = Color(0xFFD4C8B8);
  static const Color mutedSage = Color(0xFF9CAF88);

  // ── PRIMARY - Vibrant Coral ─────────────────────────────────────────────────────────
  static const Color primary = vibrantCoral;
  static const Color primaryDark = coralDark;
  static const Color primaryLight = coralLight;

  // ── SECONDARY - Electric Orange ─────────────────────────────────────────────────────
  static const Color secondary = electricOrange;
  static const Color secondaryDark = orangeDark;
  static const Color secondaryLight = orangeLight;

  // ── ACCENT - Fresh Lime ─────────────────────────────────────────────────────────────
  static const Color accent = freshLime;
  static const Color accentDark = limeDark;
  static const Color accentLight = limeLight;

  // ── HIGHLIGHT ───────────────────────────────────────────────────────────────────────
  static const Color highlight = electricOrange;
  static const Color highlightDark = orangeDark;
  static const Color highlightLight = orangeLight;

  // ── BACKGROUNDS ───────────────────────────────────────────────────────────────
  static const Color appBg = deepSpace;
  static const Color cardBg = Color(0xFF1A1A2E);
  static const Color cardBgGlass = Color(0x26FFFFFF);
  static const Color inputBg = Color(0xFF252540);

  // ── SEMANTIC COLORS ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFFF6B6B);
  static const Color warning = electricOrange;
  static const Color success = Color(0xFFA8E6CF);
  static const Color info = Color(0xFF7EC8E3);
  static const Color coral = vibrantCoral;

  // ── TEXT COLORS ───────────────────────────────────────────────────────────────
  static const Color textPrimary = warmCream;
  static const Color textSecondary = softIvory;
  static const Color textMuted = Color(0xFF8A8A9A);
  static const Color textDim = Color(0xFF5A5A6A);

  // ── SHIMMER COLORS ───────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF2A2A45);
  static const Color shimmerHighlight = Color(0xFF3A3A55);

  // ── BORDERS ─────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF2A2A45);
  static const Color borderLight = Color(0xFF3A3A55);
  static const Color borderDark = Color(0xFF1A1A30);
  static const Color borderDefault = border;

  static const Color dimText = textMuted;

  // ── GRADIENT COLORS ─────────────────────────────────────────────────────────
  static const Color streakBgStart = Color(0xFF1A1A2E);
  static const Color streakBgEnd = Color(0xFF0D0D1A);
  static const Color streakSubtitle = softLavender;

  // ── NEUMORPHISM ─────────────────────────────────────────────────────────────
  static const Color neumoHighlight = Color(0xFF2A2A40);
  static const Color neumoShadow = Color(0xFF080810);
  static const Color neumoBg = cardBg;

  // ── GLASS ─────────────────────────────────────────────────────────────────────
  static const Color glassFill = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x0DFFFFFF);

  // ── CONSISTENCY MATRIX ─────────────────────────────────────────────────────────
  static const Color matrixEmpty = Color(0xFF2A2A45);
  static const Color matrixLow = freshLime;
  static const Color matrixMid = electricOrange;
  static const Color matrixHeavy = vibrantCoral;

  // ── COMPONENT COLORS ─────────────────────────────────────────────────────────
  static const Color customBadgeBg = Color(0xFF252540);
  static const Color exerciseDoneBorder = Color(0xFFA8E6CF);
  static const Color chartRestBar = Color(0xFF3A3A55);

  // ── MESH GRADIENT ORB COLORS ─────────────────────────────────────────────────
  // Vibrant orbs for mesh gradient background
  static const Color orbCoral = Color(0x40FF6B6B);
  static const Color orbPurple = Color(0x408836FF);
  static const Color orbOrange = Color(0x40FF9F43);
  static const Color orbLime = Color(0x40A8E6CF);
  static const Color orbLavender = Color(0x40DDA0DD);

  // ── MUSCLE GROUP COLORS ───────────────────────────────────────────────────────
  static const Map<String, List<Color>> muscleColors = {
    'Upper Chest':  [Color(0xFF252540), vibrantCoral],
    'Lower Chest':  [Color(0xFF252540), Color(0xFFE55555)],
    'Chest':        [Color(0xFF252540), vibrantCoral],
    'Back':         [Color(0xFF252540), electricOrange],
    'Shoulders':    [Color(0xFF252540), freshLime],
    'Biceps':       [Color(0xFF252540), Color(0xFFFF8E8E)],
    'Triceps':      [Color(0xFF252540), Color(0xFFE55555)],
    'Forearms':     [Color(0xFF252540), softLavender],
    'Quads':        [Color(0xFF252540), electricOrange],
    'Hamstrings':   [Color(0xFF252540), Color(0xFFFFB76B)],
    'Glutes':       [Color(0xFF252540), vibrantCoral],
    'Calves':       [Color(0xFF252540), freshLime],
    'Core':         [Color(0xFF252540), softLavender],
    'Full Body':    [Color(0xFF252540), vibrantCoral],
  };

  static Color muscleBg(String muscle) =>
      muscleColors[muscle]?[0] ?? cardBg;
  static Color muscleText(String muscle) =>
      muscleColors[muscle]?[1] ?? textMuted;

  // ── GRADIENTS ─────────────────────────────────────────────────────────────────

  // Primary CTA gradient — vibrant coral to orange
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [vibrantCoral, electricOrange],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary gradient — lime fresh
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [freshLime, Color(0xFF7DD3B0)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Accent gradient — lavender soft
  static const LinearGradient accentGradient = LinearGradient(
    colors: [softLavender, lavenderLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Streak gradient — coral glow
  static const LinearGradient streakGradient = LinearGradient(
    colors: [streakBgStart, streakBgEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Avatar gradient — coral to orange
  static const LinearGradient avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [vibrantCoral, electricOrange],
  );

  // Card gradient — subtle dark
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBg, Color(0xFF1E1E32)],
  );

  // Matrix gradient — lime to coral intensity
  static const LinearGradient matrixGradient = LinearGradient(
    colors: [matrixEmpty, matrixLow, matrixMid, matrixHeavy],
  );

  // Hero text gradient — coral to orange
  static const LinearGradient heroTextGradient = LinearGradient(
    colors: [vibrantCoral, electricOrange],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Mesh gradient orbs — for background atmosphere
  static const List<Color> meshOrbs = [
    orbCoral,
    orbPurple,
    orbOrange,
    orbLime,
  ];

  // ── LEGACY ALIASES ───────────────────────────────────────────────────────────
  static const Color summerOrange = electricOrange;
  static const Color lime = freshLime;
  static const Color deepBlack = deepSpace;
  static const Color limeDarkAccent = limeDark;
  static const Color limeMid = Color(0xFF8FDDB8);
  static const Color limeDim = limeLight;
  static const Color oceanBlue = Color(0xFF7EC8E3);
  static const Color electricBlue = Color(0xFF8B5CF6);
  static const Color skyBlue = lavenderLight;
  static const Color cyan = Color(0xFF7EC8E3);
  static const Color mint = freshLime;
  static const Color violet = softLavender;
  static const Color navyDeep = midnightPurple;
  static const Color sunshineYellow = electricOrange;
  static const Color whiteText = warmCream;
  static const Color pine = mutedSage;
  static const Color appBgDark = deepSpace;
  static const Color indigoInk = midnightPurple;
  static const Color cornflowerBlue = Color(0xFF7EC8E3);
  static const Color periwinkle = lavenderLight;
  static const Color platinum = cardBg;
  static const Color princetonOrange = vibrantCoral;
  static const Color warmCoral = vibrantCoral;
  static const Color freshTeal = freshLime;
  static const Color softTeal = Color(0xFF7EC8E3);
  static const Color darkWarmGray = warmCream;
  static const Color darkCharcoal = deepSpace;
  static const Color roseGold = vibrantCoral;
  static const Color champagneGold = electricOrange;
}
