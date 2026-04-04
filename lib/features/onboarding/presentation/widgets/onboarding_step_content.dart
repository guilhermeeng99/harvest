import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/onboarding/presentation/widgets/onboarding_step.dart';

class OnboardingStepContent extends StatelessWidget {
  const OnboardingStepContent({required this.step, super.key});

  final OnboardingStep step;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 160,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: step.icon,
          ),
          const SizedBox(height: 48),
          Text(
            step.title,
            style: AppTypography.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            step.description,
            style: AppTypography.bodyLarge.copyWith(
              color: AppColors.onBackgroundLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
