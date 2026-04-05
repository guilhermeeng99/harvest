import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/product_details/presentation/widgets/nutrition_row.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class ProductContent extends StatelessWidget {
  const ProductContent({required this.product, super.key});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    final isWide = !context.isMobile;

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: isWide
                    ? _WideLayout(product: product)
                    : _NarrowLayout(product: product),
              ),
            ),
          ),
        ),
        Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: _BottomBar(product: product),
          ),
        ),
      ],
    );
  }
}

class _NarrowLayout extends StatelessWidget {
  const _NarrowLayout({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: _ProductImage(imageUrl: product.imageUrl),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: _ProductInfo(product: product),
        ),
      ],
    );
  }
}

class _WideLayout extends StatelessWidget {
  const _WideLayout({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: _ProductImage(imageUrl: product.imageUrl),
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(child: _ProductInfo(product: product)),
        ],
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  const _ProductImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (_, _) => const LoadingShimmer(height: double.infinity),
      errorWidget: (_, _, _) => const ColoredBox(
        color: AppColors.surfaceVariant,
        child: FaIcon(
          FontAwesomeIcons.image,
          size: 56,
        ),
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  const _BottomBar({required this.product});

  final ProductEntity product;

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
        child: HarvestButton(
          label: t.product.addToCart,
          icon: const FaIcon(
            FontAwesomeIcons.bagShopping,
            size: 18,
          ),
          onPressed: product.inStock
              ? () {
                  context.read<CartBloc>().add(CartItemAdded(product));
                  context.showSnackBar(t.product.added);
                }
              : null,
          width: double.infinity,
        ),
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  const _ProductInfo({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                product.name,
                style: AppTypography.headlineMedium,
              ),
            ),
            if (product.isOrganic)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  t.product.organic,
                  style: AppTypography.labelSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const FaIcon(
              FontAwesomeIcons.tractor,
              size: 14,
              color: AppColors.onBackgroundLight,
            ),
            const SizedBox(width: 4),
            Text(
              product.farmName,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.onBackgroundLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          CurrencyFormatter.format(product.price),
          style: AppTypography.priceLarge,
        ),
        Text(
          t.product.perUnit(unit: product.unit),
          style: AppTypography.bodySmall.copyWith(
            color: AppColors.onBackgroundLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          product.inStock ? t.product.inStock : t.product.outOfStock,
          style: AppTypography.labelSmall.copyWith(
            color: product.inStock ? AppColors.success : AppColors.error,
          ),
        ),
        const SizedBox(height: 20),
        Text(
          t.product.description,
          style: AppTypography.titleMedium,
        ),
        const SizedBox(height: 8),
        Text(
          product.description,
          style: AppTypography.bodyMedium.copyWith(
            color: AppColors.onBackgroundLight,
          ),
        ),
        if (product.nutritionFacts != null) ...[
          const SizedBox(height: 20),
          Text(
            t.product.nutritionFacts,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: 8),
          NutritionRow(
            label: t.product.calories,
            value: product.nutritionFacts!.calories,
          ),
          NutritionRow(
            label: t.product.protein,
            value: product.nutritionFacts!.protein,
          ),
          NutritionRow(
            label: t.product.fiber,
            value: product.nutritionFacts!.fiber,
          ),
          NutritionRow(
            label: t.product.vitamins,
            value: product.nutritionFacts!.vitamins,
          ),
        ],
      ],
    );
  }
}
