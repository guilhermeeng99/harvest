import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({required this.title, this.trailing, super.key});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: AppTypography.titleLarge),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
