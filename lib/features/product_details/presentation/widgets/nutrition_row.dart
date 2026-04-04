import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class NutritionRow extends StatelessWidget {
  const NutritionRow({required this.label, this.value, super.key});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}
