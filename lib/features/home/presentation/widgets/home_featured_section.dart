import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/home/presentation/widgets/section_header.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HomeFeaturedSection extends StatelessWidget {
  const HomeFeaturedSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev.featuredProducts != curr.featuredProducts,
      builder: (context, state) {
        if (state.featuredProducts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: t.home.featured),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: state.featuredProducts.length,
                separatorBuilder: (_, __) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final product = state.featuredProducts[index];
                  return SizedBox(
                    width: 170,
                    child: ProductCard(
                      name: product.name,
                      price: product.price,
                      unit: product.unit,
                      imageUrl: product.imageUrl,
                      farmName: product.farmName,
                      isOrganic: product.isOrganic,
                      onTap: () => context.push(
                        AppRoutes.productDetailsPath(product.id),
                      ),
                      onAddToCart: () =>
                          context.read<CartBloc>().add(CartItemAdded(product)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
