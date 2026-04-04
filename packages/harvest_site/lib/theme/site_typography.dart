import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:harvest_site/theme/site_colors.dart';

abstract final class SiteTypography {
  // Display
  static TextStyle get displayLarge => GoogleFonts.poppins(
    fontSize: 56,
    fontWeight: FontWeight.bold,
    color: SiteColors.onBackground,
    height: 1.15,
  );

  static TextStyle get displayMedium => GoogleFonts.poppins(
    fontSize: 40,
    fontWeight: FontWeight.bold,
    color: SiteColors.onBackground,
    height: 1.2,
  );

  // Headlines
  static TextStyle get headlineLarge => GoogleFonts.poppins(
    fontSize: 36,
    fontWeight: FontWeight.bold,
    color: SiteColors.onBackground,
    height: 1.2,
  );

  static TextStyle get headlineMedium => GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: SiteColors.onBackground,
  );

  // Title
  static TextStyle get titleLarge => GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: SiteColors.onBackground,
  );

  static TextStyle get titleMedium => GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: SiteColors.onBackground,
  );

  // Body
  static TextStyle get bodyLarge => GoogleFonts.inter(
    fontSize: 16,
    color: SiteColors.onBackgroundLight,
    height: 1.6,
  );

  static TextStyle get bodyMedium => GoogleFonts.inter(
    fontSize: 14,
    color: SiteColors.onBackgroundLight,
    height: 1.5,
  );

  static TextStyle get bodySmall => GoogleFonts.inter(
    fontSize: 13,
    color: SiteColors.onBackgroundLight,
    height: 1.5,
  );

  // Label
  static TextStyle get labelMedium =>
      GoogleFonts.poppins(fontSize: 13, fontWeight: FontWeight.w500);

  static TextStyle get labelSmall =>
      GoogleFonts.inter(fontSize: 12, color: SiteColors.onBackgroundLight);

  // Hero (web-specific large text)
  static TextStyle get hero => GoogleFonts.poppins(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: Colors.white,
    height: 1.15,
  );

  // Nav link
  static TextStyle get navLink => GoogleFonts.poppins(
    fontWeight: FontWeight.w500,
    color: SiteColors.onBackground,
  );

  static TextStyle get navLinkActive => GoogleFonts.poppins(
    fontWeight: FontWeight.w600,
    color: SiteColors.primary,
  );

  // Button
  static TextStyle get button =>
      GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);

  // Footer
  static TextStyle get footerBrand => GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  static TextStyle get footerBody =>
      GoogleFonts.inter(fontSize: 13, color: Colors.white54);

  static TextStyle get footerLink => GoogleFonts.inter(
    fontSize: 13,
    color: Colors.white70,
    decoration: TextDecoration.underline,
    decorationColor: Colors.white38,
  );

  static TextStyle get footerCopyright =>
      GoogleFonts.inter(fontSize: 12, color: Colors.white38);
}
