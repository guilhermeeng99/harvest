import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_site/router/site_router.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';

class SiteFooter extends StatelessWidget {
  const SiteFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: SiteColors.onBackground,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.eco_rounded,
                color: SiteColors.primaryLight,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text('Harvest', style: SiteTypography.footerBrand),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'Fresh from the farm. Direct to your community.',
            style: SiteTypography.footerBody,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FooterLink(
                label: 'Home',
                onTap: () => context.go(SiteRoutes.home),
              ),
              const SizedBox(width: 24),
              _FooterLink(
                label: 'Help Center',
                onTap: () => context.go(SiteRoutes.help),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            '© 2026 Harvest. All rights reserved.',
            style: SiteTypography.footerCopyright,
          ),
        ],
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(label, style: SiteTypography.footerLink),
    );
  }
}
