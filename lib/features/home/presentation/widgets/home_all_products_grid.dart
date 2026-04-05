import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/home/presentation/widgets/section_header.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HomeAllProductsHeader extends StatelessWidget {
  const HomeAllProductsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionHeader(title: t.home.allProducts);
  }
}

class HomeAllProductsGrid extends StatelessWidget {
  const HomeAllProductsGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev.allProducts != curr.allProducts,
      builder: (context, state) {
        if (state.allProducts.isEmpty) {
          return const SliverToBoxAdapter(child: SizedBox.shrink());
        }

        final crossAxisCount = context.isMobile
            ? 2
            : context.isTablet
            ? 3
            : 6;

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid.count(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: state.allProducts.map((product) {
              return BlocBuilder<CartBloc, CartState>(
                buildWhen: (prev, curr) {
                  final prevQty = prev.items
                      .where((i) => i.product.id == product.id)
                      .fold(0, (sum, i) => sum + i.quantity);
                  final currQty = curr.items
                      .where((i) => i.product.id == product.id)
                      .fold(0, (sum, i) => sum + i.quantity);
                  return prevQty != currQty;
                },
                builder: (context, cartState) {
                  final cartQuantity = cartState.items
                      .where((i) => i.product.id == product.id)
                      .fold(0, (sum, i) => sum + i.quantity);
                  return ProductCard(
                    name: product.name,
                    price: product.price,
                    unit: product.unit,
                    imageUrl: product.imageUrl,
                    farmName: product.farmName,
                    isOrganic: product.isOrganic,
                    cartQuantity: cartQuantity,
                    onTap: () =>
                        context.push(AppRoutes.productDetailsPath(product.id)),
                    onAddToCart: () =>
                        context.read<CartBloc>().add(CartItemAdded(product)),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
