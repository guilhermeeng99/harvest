import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';
import 'package:harvest_site/widgets/section_container.dart';

class HowItWorksSection extends StatelessWidget {
  const HowItWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      color: SiteColors.surfaceVariant,
      child: Column(
        children: [
          Text(
            'How It Works',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Three simple steps to fresh food at your door.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          const Wrap(
            spacing: 32,
            runSpacing: 32,
            alignment: WrapAlignment.center,
            children: [
              _StepCard(
                step: '01',
                icon: Icons.shopping_cart_rounded,
                title: 'Place Your Order',
                description:
                    'Browse fresh products from local farms, add to cart, '
                    'and choose your delivery address.',
              ),
              _StepCard(
                step: '02',
                icon: Icons.agriculture_rounded,
                title: 'Farmers Harvest',
                description:
                    'Your order triggers a real harvest. Farmers pick only '
                    'what you need, ensuring peak freshness.',
              ),
              _StepCard(
                step: '03',
                icon: Icons.home_rounded,
                title: 'Direct to You',
                description:
                    'Your fresh produce is delivered straight to your door. '
                    'No warehouses, no long storage.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({
    required this.step,
    required this.icon,
    required this.title,
    required this.description,
  });

  final String step;
  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: SiteColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: SiteColors.onBackground.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                step,
                style: SiteTypography.displayMedium.copyWith(
                  color: SiteColors.primary.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(width: 16),
              Icon(icon, color: SiteColors.primary, size: 32),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          Text(description, style: Theme.of(context).textTheme.bodyMedium),
        ],
      ),
    );
  }
}
