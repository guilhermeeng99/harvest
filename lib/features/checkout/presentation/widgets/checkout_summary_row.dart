import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class CheckoutSummaryRow extends StatelessWidget {
  const CheckoutSummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    super.key,
  });

  final String label;
  final String value;
  final bool isBold;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isBold
              ? AppTypography.titleMedium
              : AppTypography.bodyMedium.copyWith(
                  color: AppColors.onBackgroundLight,
                ),
        ),
        Text(
          value,
          style: isBold ? AppTypography.priceMedium : AppTypography.bodyMedium,
        ),
      ],
    );
  }
}
