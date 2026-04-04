import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';

class HelpHero extends StatelessWidget {
  const HelpHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SiteColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: Column(
        children: [
          const Icon(Icons.help_outline_rounded, color: Colors.white, size: 56),
          const SizedBox(height: 20),
          Text(
            'Help Center',
            style: SiteTypography.displayMedium.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Find answers to common questions about Harvest.',
            style: SiteTypography.bodyLarge.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
