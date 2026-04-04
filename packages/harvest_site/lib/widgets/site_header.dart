import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest_site/router/site_router.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';

class SiteHeader extends StatelessWidget {
  const SiteHeader({this.activeRoute = SiteRoutes.home, super.key});

  final String activeRoute;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SiteColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      child: Row(
        children: [
          const _Logo(),
          const Spacer(),
          _NavLink(
            label: 'Home',
            isActive: activeRoute == SiteRoutes.home,
            onTap: () => context.go(SiteRoutes.home),
          ),
          const SizedBox(width: 8),
          _NavLink(
            label: 'Help Center',
            isActive: activeRoute == SiteRoutes.help,
            onTap: () => context.go(SiteRoutes.help),
          ),
        ],
      ),
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go(SiteRoutes.home),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: SiteColors.primary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.eco_rounded, color: Colors.white, size: 22),
          ),
          const SizedBox(width: 10),
          Text(
            'Harvest',
            style: SiteTypography.titleLarge.copyWith(
              fontSize: 22,
              color: SiteColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(
        label,
        style: isActive ? SiteTypography.navLinkActive : SiteTypography.navLink,
      ),
    );
  }
}
