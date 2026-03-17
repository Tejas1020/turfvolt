import 'package:flutter/material.dart';

class AppColors {
  // ── Core Palette Tokens ───────────────────────────────────────
  // Deep Sea – app background everywhere
  static const Color appBg      = Color(0xFF0D1B2A);
  // Card Bg – cards, panels, bottom nav
  static const Color cardBg     = Color(0xFF142030);
  // Input Bg – text fields, search, dropdowns
  static const Color inputBg    = Color(0xFF0A1520);

  // Lemon Chiffon – primary CTA, key numbers, active states, logo
  static const Color lime       = Color(0xFFFFFFB3);
  static const Color accent     = Color(0xFFFFFFB3); // same as lime, explicit alias
  static const Color accentDark = Color(0xFFD4D46A); // pressed / avatar gradient end
  // Pine Blue – muted labels, secondary text, icons, some borders
  static const Color pine       = Color(0xFF538083);
  static const Color pineBg     = Color(0xFF538083); // explicit alias
  // Border – dividers, separators, default borders
  static const Color border     = Color(0xFF1E3A4A);

  // White & dim text
  static const Color whiteText  = Color(0xFFF5F5F0);
  static const Color dimText    = Color(0xFF3A4A55);

  // Error / Coral
  static const Color coral      = Color(0xFFFF6B47);

  // Selected background in plan builder rows
  static const Color selectedBg = Color(0xFF1A2D1A);

  // Avatar gradient end (dark lemon)
  static const Color limeDarkAccent = accentDark;

  // ── Convenience aliases used across the app ───────────────────
  static const Color textPrimary = whiteText;
  static const Color textMuted   = pine;
  static const Color textDim     = dimText;

  static const Color borderDefault = border;
  static const Color borderLime    = border; // for streak/CTA borders where not explicit

  // ── Legacy aliases (keep compilation happy) ───────────────────
  static const Color amber    = Color(0xFFFFA040); // amber (strength fair)
  static const Color mint     = Color(0xFF34EAA0); // mint (not used in muscle table, kept for safety)
  static const Color violet   = Color(0xFFA78BFA); // violet (not used in muscle table, kept for safety)
  static const Color limeMid  = limeDarkAccent;    // avatar gradient end → reuse
  static const Color limeDim  = matrixMid;         // matrix moderate cell
  static const Color limeDark = Color(0xFF8A8A52); // reports bar older sessions dim

  // Streak banner gradient tints
  static const Color streakBgStart = Color(0xFF131F0A);
  static const Color streakBgEnd   = Color(0xFF0E1A06);
  static const Color streakSubtitle = Color(0xFF6B8A40); // muted lime text

  // ── Neumorphism (soft shadows) ────────────────────────────────
  static const Color neumoHighlight = Color(0xFF1E2A36);
  static const Color neumoShadow    = Color(0xFF050A0D);
  static const Color neumoBg        = cardBg;

  // ── Glass (frosted) ───────────────────────────────────────────
  static const Color glassFill   = Color(0x0DFFFFFF); // ~5% white
  static const Color glassBorder = Color(0x151E3A4A); // subtle border in border color

  // ── Semantic / components ─────────────────────────────────────
  // Consistency matrix cells
  static const Color matrixEmpty = Color(0xFF181818); // rest day
  static const Color matrixLow   = Color(0xFF1E3306); // light day 1–3
  static const Color matrixMid   = Color(0xFF4A7A10); // moderate 4–8
  static const Color matrixHeavy = lime;              // 9+ heavy

  // Exercise row custom badge
  static const Color customBadgeBg = Color(0xFF1C2A1A);

  // Exercise tab “done” border in log screen
  static const Color exerciseDoneBorder = Color(0xFF0F6E56);

  // Activity bar chart “rest” bar
  static const Color chartRestBar = Color(0xFF1E3A4A);

  // ── Muscle Group Colors (chips) ───────────────────────────────
  // Format: [chipBg, chipText] – matches provided table.
  static const Map<String, List<Color>> muscleColors = {
    'Upper Chest':  [Color(0xFF1A2208), lime],
    'Lower Chest':  [Color(0xFF1F120A), coral],
    'Back':         [Color(0xFF0E1F0A), Color(0xFFA3E635)],
    'Shoulders':    [Color(0xFF1F1608), Color(0xFFFFA040)],
    'Biceps':       [Color(0xFF081F16), Color(0xFF34EAA0)],
    'Triceps':      [Color(0xFF1F100A), coral],
    'Quads':        [Color(0xFF130D20), Color(0xFFA78BFA)],
    'Hamstrings':   [Color(0xFF1F1608), Color(0xFFFFA040)],
    'Glutes':       [Color(0xFF1F120A), coral],
    'Calves':       [Color(0xFF1A2208), lime],
    'Core':         [Color(0xFF0E1F0A), Color(0xFFA3E635)],
    'Forearms':     [Color(0xFF1F1608), Color(0xFFFFA040)],
    'Full Body':    [Color(0xFF1A2208), lime],
  };

  static Color muscleBg(String muscle) =>
      muscleColors[muscle]?[0] ?? cardBg;
  static Color muscleText(String muscle) =>
      muscleColors[muscle]?[1] ?? textMuted;
}
