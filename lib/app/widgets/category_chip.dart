import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    required this.label,
    required this.onTap,
    this.isSelected = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 16,
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.onBackgroundLight,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: AppTypography.labelLarge.copyWith(
                color: isSelected
                    ? AppColors.onPrimary
                    : AppColors.onBackground,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
