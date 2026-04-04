import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/widgets/section_container.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      child: Column(
        children: [
          Text(
            'Why Harvest?',
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Everything you need to eat fresh and eat well.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 56),
          const Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: [
              _FeatureCard(
                icon: Icons.agriculture_rounded,
                title: 'Direct from Farmers',
                description:
                    'No middlemen. Products go straight from the farm '
                    'to your door, keeping prices fair and quality high.',
              ),
              _FeatureCard(
                icon: Icons.eco_rounded,
                title: 'Organic & Fresh',
                description:
                    'Our farmers follow sustainable practices. You choose '
                    'the best: organic, seasonal, and always harvested to order.',
              ),
              _FeatureCard(
                icon: Icons.local_shipping_rounded,
                title: 'Fast Delivery',
                description:
                    'From harvest to your table in record time. Track '
                    'your order in real time right from the app.',
              ),
              _FeatureCard(
                icon: Icons.people_rounded,
                title: 'Support Your Community',
                description:
                    'Every purchase directly supports a local family farm. '
                    'Strong community, healthy economy.',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: SiteColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: SiteColors.onBackground.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: SiteColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: SiteColors.primary, size: 28),
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
