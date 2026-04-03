import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class OrderConfirmationPage extends StatelessWidget {
  const OrderConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_circle,
                    size: 64,
                    color: AppColors.success,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  t.checkout.confirmation.title,
                  style: AppTypography.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Text(
                  t.checkout.confirmation.subtitle,
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  t.checkout.confirmation.description,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                HarvestButton(
                  label: t.checkout.confirmation.viewOrders,
                  onPressed: () => context.go(AppRoutes.orders),
                  width: double.infinity,
                ),
                const SizedBox(height: 12),
                HarvestButton(
                  label: t.checkout.confirmation.backToHome,
                  onPressed: () => context.go(AppRoutes.home),
                  isOutlined: true,
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
