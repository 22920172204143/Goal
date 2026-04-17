import 'package:flutter/material.dart';

ThemeData buildSmallGoalTheme() {
  const background = Color(0xFF111827);
  const surface = Color(0xFF1C2638);
  const card = Color(0xFF26364F);
  const accent = Color(0xFF76E4AE);
  const gold = Color(0xFFF2CD79);

  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      secondary: gold,
      surface: surface,
      onPrimary: Color(0xFF0F1A19),
    ),
  );

  return base.copyWith(
    cardTheme: const CardThemeData(
      color: card,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF182235),
      indicatorColor: gold,
      surfaceTintColor: Colors.transparent,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return const IconThemeData(color: Color(0xFF1A1D21));
        }
        return const IconThemeData(color: Colors.white70);
      }),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        return TextStyle(
          fontSize: 12,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w800
              : FontWeight.w600,
          color: states.contains(WidgetState.selected)
              ? const Color(0xFF1A1D21)
              : Colors.white70,
        );
      }),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: background,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: const Color(0xFF132118),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      ),
    ),
    chipTheme: base.chipTheme.copyWith(
      backgroundColor: surface,
      selectedColor: accent.withValues(alpha: 0.18),
      side: BorderSide.none,
      labelStyle: const TextStyle(fontWeight: FontWeight.w600),
    ),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
  );
}
