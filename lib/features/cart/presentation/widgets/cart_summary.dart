import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class CartSummary extends StatelessWidget {
  const CartSummary({required this.state, super.key});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _SummaryRow(
              label: t.cart.subtotal,
              value: CurrencyFormatter.format(state.subtotal),
            ),
            const SizedBox(height: 4),
            _SummaryRow(
              label: t.cart.deliveryFee,
              value: state.deliveryFee == 0
                  ? t.cart.free
                  : CurrencyFormatter.format(state.deliveryFee),
            ),
            const Divider(height: 20),
            _SummaryRow(
              label: t.cart.total,
              value: CurrencyFormatter.format(state.total),
              isBold: true,
            ),
            const SizedBox(height: 16),
            HarvestButton(
              label: t.cart.checkout,
              onPressed: () => context.push(AppRoutes.checkout),
              width: double.infinity,
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
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
