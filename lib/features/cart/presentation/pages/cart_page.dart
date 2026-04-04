import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/cart/presentation/widgets/cart_item_card.dart';
import 'package:harvest/features/cart/presentation/widgets/cart_summary.dart';
import 'package:harvest/features/cart/presentation/widgets/empty_cart.dart';
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
          if (state.isEmpty) return const EmptyCart();
          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (_, index) {
                    final item = state.items[index];
                    return CartItemCard(
                      item: item,
                      onDismissed: () => context.read<CartBloc>().add(
                        CartItemRemoved(item.product.id),
                      ),
                      onTap: () => context.push(
                        AppRoutes.productDetailsPath(item.product.id),
                      ),
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
                    );
                  },
                ),
              ),
              CartSummary(state: state),
            ],
          );
        },
      ),
    );
  }
}
