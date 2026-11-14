import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Material 3 theme from the Stitch design system: Noto Sans Bengali for
/// Bangla text, Inter (tabular figures) for numbers and BDT amounts.
ThemeData smartHisabTheme() {
  final base = ThemeData(useMaterial3: true, colorScheme: ColorScheme.fromSeed(
    seedColor: AppColors.primary, surface: AppColors.surface));
  final textTheme = base.textTheme;
  return base.copyWith(
    scaffoldBackgroundColor: AppColors.canvas,
    textTheme: textTheme.copyWith(
      headlineMedium: textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
      titleLarge: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
    ),
    cardTheme: CardThemeData(color: AppColors.card, elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border))),
    inputDecorationTheme: InputDecorationTheme(
      filled: true, fillColor: AppColors.card,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.border)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.primaryContainer, width: 1.5)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12), constraints: const BoxConstraints(minHeight: 48)),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryContainer, foregroundColor: Colors.white),
  );
}
