import 'package:flutter/material.dart';
import 'package:harvest_site/theme/site_colors.dart';
import 'package:harvest_site/theme/site_typography.dart';

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqSection extends StatelessWidget {
  const FaqSection({
    required this.title,
    required this.icon,
    required this.items,
    super.key,
  });

  final String title;
  final IconData icon;
  final List<FaqItem> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: title, icon: icon),
        const SizedBox(height: 20),
        ...items.map(_FaqTile.new),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: SiteColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: SiteColors.primary, size: 22),
        ),
        const SizedBox(width: 14),
        Text(title, style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}

class _FaqTile extends StatelessWidget {
  const _FaqTile(this.item);

  final FaqItem item;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: SiteColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: SiteColors.onBackground.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        title: Text(item.question, style: SiteTypography.titleMedium),
        iconColor: SiteColors.primary,
        collapsedIconColor: SiteColors.onBackgroundLight,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
            child: Text(item.answer, style: SiteTypography.bodyMedium),
          ),
        ],
      ),
    );
  }
}
