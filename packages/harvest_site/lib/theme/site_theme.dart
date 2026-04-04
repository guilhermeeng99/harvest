import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';

abstract final class SiteTheme {
  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: SiteColors.primary,
      surface: SiteColors.surface,
    ),
    scaffoldBackgroundColor: SiteColors.background,
    textTheme: TextTheme(
      displayLarge: SiteTypography.displayLarge,
      displayMedium: SiteTypography.displayMedium,
      headlineMedium: SiteTypography.headlineMedium,
      titleLarge: SiteTypography.titleLarge,
      bodyLarge: SiteTypography.bodyLarge,
      bodyMedium: SiteTypography.bodyMedium,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: SiteColors.primary,
        foregroundColor: SiteColors.surface,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: SiteTypography.button,
      ),
    ),
  );
}
