import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';
import 'package:harvest_site/widgets/site_action_button.dart';

class CtaSection extends StatelessWidget {
  const CtaSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SiteColors.primaryDark,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      child: Column(
        children: [
          Text(
            'Ready to eat fresh\nand support local?',
            style: SiteTypography.headlineLarge.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of people who already rely on Harvest\n'
            'for fresh, local produce every week.',
            style: SiteTypography.bodyLarge.copyWith(color: Colors.white70),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 36),
          const SiteActionButton(label: 'Get Started Today'),
        ],
      ),
    );
  }
}
