import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';
import 'package:harvest_site/widgets/section_container.dart';
import 'package:harvest_site/widgets/site_action_button.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isDesktop = width > 900;

    return SectionContainer(
      color: SiteColors.primary,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 80 : 24,
        vertical: isDesktop ? 100 : 64,
      ),
      child: isDesktop
          ? Row(
              children: [
                const Expanded(child: _HeroText()),
                const SizedBox(width: 64),
                _HeroIllustration(),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _HeroText(),
                const SizedBox(height: 40),
                Center(child: _HeroIllustration()),
              ],
            ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: SiteColors.primaryLight.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Fresh from the farm',
            style: SiteTypography.labelMedium.copyWith(color: Colors.white70),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Real food,\ndirect from\nyour community',
          style: SiteTypography.hero,
        ),
        const SizedBox(height: 20),
        Text(
          'Harvest connects you directly with a trusted network of '
          'local farmers. Get truly fresh produce and support a fair '
          'food system.',
          style: SiteTypography.bodyLarge.copyWith(color: Colors.white70),
        ),
        const SizedBox(height: 36),
        const SiteActionButton(label: 'Download the App'),
      ],
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 320,
      decoration: BoxDecoration(
        color: SiteColors.primaryLight.withValues(alpha: 0.25),
        shape: BoxShape.circle,
      ),
      child: const Icon(
        Icons.local_grocery_store_rounded,
        size: 140,
        color: Colors.white,
      ),
    );
  }
}
