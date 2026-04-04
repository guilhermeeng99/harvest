import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class ProfileUserCard extends StatelessWidget {
  const ProfileUserCard({required this.name, required this.email, super.key});

  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 32,
            backgroundColor: AppColors.primaryLight.withValues(alpha: 0.2),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: AppTypography.headlineMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.titleLarge),
                const SizedBox(height: 4),
                Text(
                  email,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
