import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class CheckoutPaymentOption extends StatelessWidget {
  const CheckoutPaymentOption({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final String label;
  final Widget icon;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.divider,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            icon,
            const SizedBox(width: 12),
            Text(label, style: AppTypography.bodyLarge),
            const Spacer(),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
              ),
          ],
        ),
      ),
    );
  }
}
