import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/product_card.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/presentation/bloc/home_bloc.dart';
import 'package:harvest/features/home/presentation/widgets/section_header.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class HomePopularSection extends StatelessWidget {
  const HomePopularSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      buildWhen: (prev, curr) => prev.allProducts != curr.allProducts,
      builder: (context, state) {
        final organicProducts = state.allProducts
            .where((p) => p.isOrganic)
            .toList();
        if (organicProducts.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: t.home.popular,
              trailing: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      t.home.organic,
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 230,
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                scrollDirection: Axis.horizontal,
                itemCount: organicProducts.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, index) {
                  final product = organicProducts[index];
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
