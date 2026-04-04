import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/quantity_selector.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(t.cart.title),
        centerTitle: true,
      ),
      body: BlocBuilder<CartBloc, CartState>(
        builder: (context, state) {
          if (state.isEmpty) return const _EmptyCart();
          return _CartContent(state: state);
        },
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FaIcon(
              FontAwesomeIcons.bagShopping,
              size: 64,
              color: AppColors.onBackgroundLight,
            ),
            const SizedBox(height: 16),
            Text(
              t.cart.empty,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              t.cart.emptySubtitle,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onBackgroundLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            HarvestButton(
              label: t.cart.browseProducts,
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartContent extends StatelessWidget {
  const _CartContent({required this.state});

  final CartState state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: state.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final item = state.items[index];
              return Dismissible(
                key: ValueKey(item.product.id),
                direction: DismissDirection.endToStart,
                onDismissed: (_) => context.read<CartBloc>().add(
                  CartItemRemoved(item.product.id),
                ),
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.trash,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: item.product.imageUrl,
                          width: 72,
                          height: 72,
                          fit: BoxFit.cover,
                          errorWidget: (_, _, _) => Container(
                            width: 72,
                            height: 72,
                            color: AppColors.surfaceVariant,
                            child: const FaIcon(
                              FontAwesomeIcons.image,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.product.name,
                              style: AppTypography.titleMedium,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 2),
                            Text(
                              CurrencyFormatter.format(item.product.price),
                              style: AppTypography.priceSmall,
                            ),
                          ],
                        ),
                      ),
                      QuantitySelector(
                        quantity: item.quantity,
                        onIncrement: () => context.read<CartBloc>().add(
                          CartItemQuantityUpdated(
                            productId: item.product.id,
                            quantity: item.quantity + 1,
                          ),
                        ),
                        onDecrement: () => context.read<CartBloc>().add(
                          CartItemQuantityUpdated(
                            productId: item.product.id,
                            quantity: item.quantity - 1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        _CartSummary(state: state),
      ],
    );
  }
}

class _CartSummary extends StatelessWidget {
  const _CartSummary({required this.state});

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
