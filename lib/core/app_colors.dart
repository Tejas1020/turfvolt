import 'package:flutter/material.dart';

class AppColors {
  // ── LUXURY DARK THEME - DETAILED SPEC ─────────────────────────────────────────
  // Rich dark premium sports app with neon green energy

  // ── BACKGROUND & SURFACES ────────────────────────────────────────────────────
  static const Color deepBlack = Color(0xFF000000);
  static const Color darkBg = Color(0xFF0A0A0A);
  static const Color appBg = Color(0xFF1A1A1A); // Deepest dark background

  // Card/widget surfaces — creates depth
  static const Color cardBg = Color(0xFF252525);
  static const Color cardBgLight = Color(0xFF2A2A2A);
  static const Color cardBgElevated = Color(0xFF333333); // Elevated elements

  // ── PRIMARY — NEON GREEN (#BAFA20) ────────────────────────────────────────────
  static const Color lime = Color(0xFFBAFA20); // Primary accent
  static const Color limeLight = Color(0xFFCEFC5A);
  static const Color limeDark = Color(0xFFAEDD46); // Slightly muted / hover
  static const Color limeMuted = Color(0xFF617B24); // Inactive/dark green
  static const Color limeChartBase = Color(0xFF617B24); // Chart bar bottom
  static const Color limeChartTop = Color(0xFFBAFA20); // Chart bar top

  // Button text color
  static const Color buttonTextDark = Color(0xFF1A2000); // Dark olive-black

  // ── SECONDARY ─────────────────────────────────────────────────────────────────
  static const Color textGray = Color(0xFF888888); // Muted gray for body
  static const Color textGrayDark = Color(0xFF555555); // Dark gray for inactive
  static const Color textGrayVeryDark = Color(0xFF333333);

  // ── ACCENT COLORS FOR TAGS ───────────────────────────────────────────────────
  static const Color tagAmber = Color(0xFFE8A020); // Medium difficulty
  static const Color tagGreen = Color(0xFF3A6E1A); // Easy difficulty
  static const Color tagRed = Color(0xFFBF3030); // Hard difficulty

  // ── PRIMARY ALIASES ───────────────────────────────────────────────────────────
  static const Color primary = lime;
  static const Color primaryDark = limeDark;
  static const Color primaryLight = limeLight;

  static const Color secondary = limeMuted;
  static const Color secondaryDark = Color(0xFF4A6019);
  static const Color secondaryLight = limeLight;

  static const Color accent = lime;
  static const Color accentDark = limeDark;
  static const Color accentLight = limeLight;

  static const Color highlight = lime;
  static const Color highlightDark = limeDark;
  static const Color highlightLight = limeLight;

  // ── BACKGROUNDS ───────────────────────────────────────────────────────────────
  static const Color cardBgGlass = Color(0x0DFFFFFF); // Faint glass
  static const Color inputBg = Color(0xFF333333); // Elevated input fields

  // ── SEMANTIC COLORS ───────────────────────────────────────────────────────────
  static const Color error = Color(0xFFBF3030);
  static const Color warning = tagAmber;
  static const Color success = lime;
  static const Color info = Color(0xFF7EC8E3);

  // ── TEXT COLORS ───────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFFFFFFFF); // White #FFFFFF
  static const Color textSecondary = Color(0xFFCCCCCC);
  static const Color textMuted = Color(0xFF888888); // Muted gray
  static const Color textDim = Color(0xFF5A5A5A);
  static const Color warmCream = textPrimary;
  static const Color softIvory = textSecondary;

  // ── SHIMMER COLORS ───────────────────────────────────────────────────────────
  static const Color shimmerBase = Color(0xFF2A2A2A);
  static const Color shimmerHighlight = Color(0xFF3A3A3A);

  // ── BORDERS ───────────────────────────────────────────────────────────────────
  static const Color border = Color(0xFF333333);
  static const Color borderLight = Color(0xFF444444);
  static const Color borderDark = Color(0xFF1A1A1A);
  static const Color borderDefault = Color(0x14FFFFFF); // rgba(255,255,255,0.05-0.08)
  static const Color borderSubtle = Color(0x0DFFFFFF);

  static const Color dimText = textMuted;

  // ── GRADIENT COLORS ───────────────────────────────────────────────────────────
  static const Color streakBgStart = cardBg;
  static const Color streakBgEnd = darkBg;
  static const Color streakSubtitle = textMuted;

  // ── NEUMORPHISM ───────────────────────────────────────────────────────────────
  static const Color neumoHighlight = Color(0xFF2A2A2A);
  static const Color neumoShadow = Color(0xFF080808);
  static const Color neumoBg = cardBg;

  // ── GLASS ─────────────────────────────────────────────────────────────────────
  static const Color glassFill = Color(0x1AFFFFFF);
  static const Color glassBorder = Color(0x33FFFFFF);
  static const Color glassHighlight = Color(0x0DFFFFFF);

  // ── CONSISTENCY MATRIX ───────────────────────────────────────────────────────
  static const Color matrixEmpty = Color(0xFF333333);
  static const Color matrixLow = lime;
  static const Color matrixMid = tagAmber;
  static const Color matrixHeavy = tagRed;

  // ── COMPONENT COLORS ─────────────────────────────────────────────────────────
  static const Color customBadgeBg = Color(0xFF252525);
  static const Color exerciseDoneBorder = lime;
  static const Color chartRestBar = Color(0xFF333333);
  static const Color chartActiveBarTop = limeChartTop;
  static const Color chartActiveBarBottom = limeChartBase;

  // ── MESH GRADIENT ORB COLORS ─────────────────────────────────────────────────
  static const Color orbCoral = Color(0x40FF6B6B);
  static const Color orbPurple = Color(0x408836FF);
  static const Color orbOrange = Color(0x40FF9F43);
  static const Color orbLime = Color(0x40BAFA20);
  static const Color orbLavender = Color(0x40DDA0DD);

  // ── MUSCLE GROUP COLORS ───────────────────────────────────────────────────────
  static const Map<String, List<Color>> muscleColors = {
    'Upper Chest':  [Color(0xFF252525), lime],
    'Lower Chest':  [Color(0xFF252525), limeDark],
    'Chest':        [Color(0xFF252525), lime],
    'Back':         [Color(0xFF252525), tagAmber],
    'Shoulders':    [Color(0xFF252525), lime],
    'Biceps':       [Color(0xFF252525), limeLight],
    'Triceps':      [Color(0xFF252525), limeDark],
    'Forearms':     [Color(0xFF252525), Color(0xFFB3E6FF)],
    'Quads':        [Color(0xFF252525), tagAmber],
    'Hamstrings':   [Color(0xFF252525), Color(0xFFFFB76B)],
    'Glutes':       [Color(0xFF252525), lime],
    'Calves':       [Color(0xFF252525), lime],
    'Core':         [Color(0xFF252525), Color(0xFFB3E6FF)],
    'Full Body':    [Color(0xFF252525), lime],
  };

  static Color muscleBg(String muscle) =>
      muscleColors[muscle]?[0] ?? cardBg;
  static Color muscleText(String muscle) =>
      muscleColors[muscle]?[1] ?? textMuted;

  // ── GRADIENTS ─────────────────────────────────────────────────────────────────

  // Primary CTA gradient — vibrant lime
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [lime, limeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Secondary gradient
  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [lime, limeDark],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Chart bar gradient — green to dark green
  static const LinearGradient chartBarGradient = LinearGradient(
    colors: [limeChartTop, limeChartBase],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // Accent gradient
  static const LinearGradient accentGradient = LinearGradient(
    colors: [tagAmber, Color(0xFFCC8800)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Streak gradient — subtle dark
  static const LinearGradient streakGradient = LinearGradient(
    colors: [cardBg, Color(0xFF1A1A1A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Avatar gradient — lime to amber
  static const LinearGradient avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [lime, tagAmber],
  );

  // Card gradient — subtle dark
  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBg, cardBgLight],
  );

  // Matrix gradient — lime to red intensity
  static const LinearGradient matrixGradient = LinearGradient(
    colors: [matrixEmpty, matrixLow, matrixMid, matrixHeavy],
  );

  // Hero text gradient — lime
  static const LinearGradient heroTextGradient = LinearGradient(
    colors: [lime, limeLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  // Mesh gradient orbs — for background atmosphere
  static const List<Color> meshOrbs = [
    orbLime,
    orbPurple,
    orbOrange,
    orbCoral,
  ];

  // ── LEGACY ALIASES ───────────────────────────────────────────────────────────
  static const Color deepSpace = appBg;
  static const Color coral = tagRed;
  static const Color summerOrange = tagAmber;
  static const Color limeDarkAccent = limeDark;
  static const Color limeMid = Color(0xFFB3E6CC);
  static const Color limeDim = Color(0xFFE6FFEE);
  static const Color oceanBlue = Color(0xFF7EC8E3);
  static const Color electricBlue = Color(0xFF8B5CF6);
  static const Color skyBlue = Color(0xFFB3E6FF);
  static const Color cyan = Color(0xFF7EC8E3);
  static const Color mint = lime;
  static const Color violet = Color(0xFFB3E6FF);
  static const Color navyDeep = darkBg;
  static const Color sunshineYellow = tagAmber;
  static const Color whiteText = textPrimary;
  static const Color pine = textGray;
  static const Color appBgDark = appBg;
  static const Color indigoInk = darkBg;
  static const Color cornflowerBlue = Color(0xFF7EC8E3);
  static const Color periwinkle = Color(0xFFB3E6FF);
  static const Color platinum = cardBg;
  static const Color princetonOrange = tagAmber;
  static const Color warmCoral = Color(0xFFBF3030);
  static const Color freshTeal = lime;
  static const Color softTeal = Color(0xFF7EC8E3);
  static const Color darkWarmGray = textPrimary;
  static const Color darkCharcoal = deepBlack;
  static const Color roseGold = lime;
  static const Color champagneGold = tagAmber;
  static const Color vibrantCoral = tagRed;
  static const Color coralLight = Color(0xFFFF6B6B);
  static const Color coralDark = Color(0xFFE55555);
  static const Color softLavender = Color(0xFFB3E6FF);
  static const Color lavenderLight = Color(0xFFCCE6FF);
  static const Color lavenderDark = Color(0xFF99CCE6);
  static const Color freshLime = lime;
  static const Color limeLightCustom = limeLight;
  static const Color mutedSage = textGray;
  static const Color midnightPurple = darkBg;
  static const Color richNavy = Color(0xFF16213E);
  static const Color electricOrange = tagAmber;
  static const Color orangeLight = Color(0xFFFFB76B);
  static const Color orangeDark = Color(0xFFCC8800);
}