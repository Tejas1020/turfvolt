import 'package:flutter/material.dart';

class AppColors {
  // ── PREMIUM LUXURY PALETTE ─────────────────────────────────────────────────────
  // Deep charcoal + rose gold — rich, aspirational, premium fitness

  // ── CORE PALETTE ────────────────────────────────────────────────────────────────
  // Rich charcoal — warm, deep, luxurious base (not pure black)
  static const Color richCharcoal = Color(0xFF1A1A1E);
  // Deep warm black — for elevated surfaces
  static const Color deepBlack    = Color(0xFF111114);
  // Rose gold — premium, aspirational, gender-neutral luxury
  static const Color roseGold     = Color(0xFFE8A87C);
  // Champagne gold — warm metallic highlight
  static const Color champagneGold= Color(0xFFD4AF37);
  // Warm cream — easy on eyes, luxurious
  static const Color warmCream   = Color(0xFFF5F0E8);
  // Soft ivory — muted cream for subtitles
  static const Color softIvory    = Color(0xFFB8B0A4);

  // ── PRIMARY - Rose Gold ─────────────────────────────────────────────────────────
  // Warm, luxurious. Use for primary CTAs, active states
  static const Color primary       = roseGold;
  static const Color primaryDark    = Color(0xFFD4956A);
  static const Color primaryLight  = Color(0xFFF0BB93);

  // ── SECONDARY - Champagne Gold ─────────────────────────────────────────────────
  // Warm metallic. Use for accents, highlights, premium elements
  static const Color secondary     = champagneGold;
  static const Color secondaryDark = Color(0xFFC49F2F);
  static const Color secondaryLight= Color(0xFFE8CC72);

  // ── ACCENT - Rose Gold Light ──────────────────────────────────────────────────
  // Gentle luxury. Use for badges, soft accents
  static const Color accent        = Color(0xFFF0CBB5);
  static const Color accentDark    = Color(0xFFD4A07A);
  static const Color accentLight   = Color(0xFFF7DDD0);

  // ── HIGHLIGHT - Champagne Gold ────────────────────────────────────────────────
  // Premium depth. Use for emphasis, luxury accents
  static const Color highlight     = champagneGold;
  static const Color highlightDark = Color(0xFFB8962B);
  static const Color highlightLight= Color(0xFFE8D080);

  // ── DEEP ───────────────────────────────────────────────────────────────────────
  static const Color deep          = richCharcoal;

  // ── BACKGROUNDS ───────────────────────────────────────────────────────────────
  // Deep warm black — rich, luxurious dark base
  static const Color appBg         = Color(0xFF111114);
  // Rich charcoal — card surfaces on dark
  static const Color cardBg        = Color(0xFF1E1E24);
  // Slightly lighter charcoal — input fields
  static const Color inputBg       = Color(0xFF28282E);

  // ── SEMANTIC COLORS ────────────────────────────────────────────────────────────
  static const Color error         = Color(0xFFE57373);
  static const Color warning       = roseGold;
  static const Color success       = Color(0xFF4CAF50);
  static const Color info          = champagneGold;
  static const Color coral         = Color(0xFFE8A87C);

  // ── NEUTRALS ───────────────────────────────────────────────────────────────────
  // Warm cream for primary text on dark backgrounds
  static const Color textPrimary   = warmCream;
  // Soft ivory for secondary text
  static const Color textMuted     = Color(0xFFB8B0A4);
  // Dimmer ivory for tertiary text
  static const Color textDim       = Color(0xFF7A7068);

  // Warm dark borders
  static const Color border        = Color(0xFF3A3A42);
  static const Color borderLight   = Color(0xFF4A4A54);
  static const Color borderDark    = Color(0xFF2A2A32);
  static const Color borderDefault = border;

  static const Color dimText       = textMuted;

  // ── GRADIENT COLORS ───────────────────────────────────────────────────────────
  static const Color streakBgStart = Color(0xFF1E1E24);
  static const Color streakBgEnd  = Color(0xFF111114);
  static const Color streakSubtitle= Color(0xFFB8B0A4);

  // ── NEUMORPHISM ────────────────────────────────────────────────────────────────
  // On dark bg, highlight is lighter, shadow is darker
  static const Color neumoHighlight = Color(0xFF2E2E36);
  static const Color neumoShadow    = Color(0xFF0A0A0E);
  static const Color neumoBg        = cardBg;

  // ── GLASS ──────────────────────────────────────────────────────────────────────
  static const Color glassFill     = Color(0x1AFFFFFF);
  static const Color glassBorder   = Color(0x33FFFFFF);

  // ── CONSISTENCY MATRIX ─────────────────────────────────────────────────────────
  static const Color matrixEmpty   = Color(0xFF3A3A42);
  static const Color matrixLow     = Color(0xFF6BCFC4);
  static const Color matrixMid     = Color(0xFFD4AF37);
  static const Color matrixHeavy   = roseGold;

  // ── COMPONENT COLORS ──────────────────────────────────────────────────────────
  static const Color customBadgeBg = Color(0xFF28282E);
  static const Color exerciseDoneBorder = Color(0xFF4CAF50);
  static const Color chartRestBar  = Color(0xFF3A3A42);

  // ── MUSCLE GROUP COLORS ────────────────────────────────────────────────────────
  // Rose gold family for upper body, champagne gold for lower, ivory for core
  static const Map<String, List<Color>> muscleColors = {
    'Upper Chest':  [Color(0xFF28282E), roseGold],
    'Lower Chest':  [Color(0xFF28282E), Color(0xFFD4956A)],
    'Chest':        [Color(0xFF28282E), roseGold],
    'Back':         [Color(0xFF28282E), champagneGold],
    'Shoulders':    [Color(0xFF28282E), warmCream],
    'Biceps':       [Color(0xFF28282E), Color(0xFFE8A87C)],
    'Triceps':      [Color(0xFF28282E), Color(0xFFD4956A)],
    'Forearms':     [Color(0xFF28282E), warmCream],
    'Quads':        [Color(0xFF28282E), champagneGold],
    'Hamstrings':   [Color(0xFF28282E), Color(0xFFC49F2F)],
    'Glutes':       [Color(0xFF28282E), roseGold],
    'Calves':       [Color(0xFF28282E), champagneGold],
    'Core':         [Color(0xFF28282E), warmCream],
    'Full Body':    [Color(0xFF28282E), roseGold],
  };

  static Color muscleBg(String muscle) =>
      muscleColors[muscle]?[0] ?? cardBg;
  static Color muscleText(String muscle) =>
      muscleColors[muscle]?[1] ?? textMuted;

  // ── GRADIENTS ─────────────────────────────────────────────────────────────────
  static const LinearGradient streakGradient = LinearGradient(
    colors: [streakBgStart, streakBgEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Rose gold to warm champagne gradient — premium CTA look
  static const LinearGradient avatarGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [roseGold, champagneGold],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [cardBg, Color(0xFF26262C)],
  );

  static const LinearGradient matrixGradient = LinearGradient(
    colors: [matrixEmpty, matrixLow, matrixMid, matrixHeavy],
  );

  // Primary CTA gradient — rose gold shimmer
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [roseGold, Color(0xFFF0BB93)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [champagneGold, secondaryLight],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [accentLight, accent],
  );

  // ── LEGACY ALIASES ────────────────────────────────────────────────────────────
  static const Color summerOrange  = roseGold;
  static const Color lime          = roseGold;
  static const Color limeDark      = primaryDark;
  static const Color limeDarkAccent= primaryDark;
  static const Color limeMid       = champagneGold;
  static const Color limeDim       = accentLight;
  static const Color oceanBlue     = champagneGold;
  static const Color electricBlue  = champagneGold;
  static const Color skyBlue       = accent;
  static const Color cyan          = secondaryLight;
  static const Color mint          = Color(0xFF4CAF50);
  static const Color violet        = Color(0xFFCF9E8B);
  static const Color navyDeep      = richCharcoal;
  static const Color sunshineYellow= champagneGold;
  static const Color whiteText     = warmCream;
  static const Color pine          = textMuted;
  static const Color appBgDark     = Color(0xFF111114);
  // Old palette redirects
  static const Color indigoInk     = richCharcoal;
  static const Color cornflowerBlue= champagneGold;
  static const Color periwinkle    = accentLight;
  static const Color platinum      = Color(0xFF1E1E24);
  static const Color princetonOrange= roseGold;
  static const Color warmCoral     = roseGold;
  static const Color freshTeal     = champagneGold;
  static const Color softTeal      = accent;
  static const Color darkWarmGray  = warmCream;
  static const Color darkCharcoal  = richCharcoal;
}
