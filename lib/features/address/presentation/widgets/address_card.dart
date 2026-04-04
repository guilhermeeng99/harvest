import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class AddressCard extends StatelessWidget {
  const AddressCard({
    required this.address,
    required this.fullAddress,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
    this.label,
    super.key,
  });

  final String? label;
  final String address;
  final String fullAddress;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

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
            FaIcon(
              FontAwesomeIcons.locationDot,
              size: 20,
              color: isSelected
                  ? AppColors.primary
                  : AppColors.onBackgroundLight,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (label != null && label!.isNotEmpty)
                    Text(
                      label!,
                      style: AppTypography.labelLarge.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  Text(address, style: AppTypography.bodyLarge),
                  const SizedBox(height: 2),
                  Text(fullAddress, style: AppTypography.bodySmall),
                ],
              ),
            ),
            if (isSelected)
              const FaIcon(
                FontAwesomeIcons.circleCheck,
                color: AppColors.primary,
              )
            else
              IconButton(
                icon: const FaIcon(
                  FontAwesomeIcons.trashCan,
                  color: AppColors.onBackgroundLight,
                  size: 18,
                ),
                onPressed: onDelete,
              ),
          ],
        ),
      ),
    );
  }
}
