import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/product_card.dart';
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

        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          sliver: SliverGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.72,
            children: state.allProducts.map((product) {
              return ProductCard(
                name: product.name,
                price: product.price,
                unit: product.unit,
                imageUrl: product.imageUrl,
                farmName: product.farmName,
                isOrganic: product.isOrganic,
                onTap: () =>
                    context.push(AppRoutes.productDetailsPath(product.id)),
                onAddToCart: () =>
                    context.read<CartBloc>().add(CartItemAdded(product)),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
