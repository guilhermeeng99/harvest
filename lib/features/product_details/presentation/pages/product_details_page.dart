import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';
import 'package:harvest/core/extensions/context_extensions.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/cart/presentation/bloc/cart_bloc.dart';
import 'package:harvest/features/home/domain/entities/product_entity.dart';
import 'package:harvest/features/home/domain/usecases/get_product_by_id_usecase.dart';
import 'package:harvest/gen/i18n/strings.g.dart';

class ProductDetailsPage extends StatefulWidget {
  const ProductDetailsPage({required this.productId, super.key});

  final String productId;

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  ProductEntity? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final result = await sl<GetProductByIdUseCase>()(widget.productId);
    if (!mounted) return;

    result.fold(
      (failure) => setState(() {
        _loading = false;
        _error = failure.message;
      }),
      (product) => setState(() {
        _loading = false;
        _product = product;
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? ErrorView(message: _error!, onRetry: _loadProduct)
              : _product != null
                  ? _ProductContent(product: _product!)
                  : const SizedBox.shrink(),
    );
  }
}

class _ProductContent extends StatelessWidget {
  const _ProductContent({required this.product});

  final ProductEntity product;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: CachedNetworkImage(
                    imageUrl: product.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) =>
                        const LoadingShimmer(height: double.infinity),
                    errorWidget: (_, __, ___) => const ColoredBox(
                      color: AppColors.surfaceVariant,
                      child: Icon(Icons.image, size: 64),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
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
                          const Icon(
                            Icons.agriculture,
                            size: 16,
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
                        product.inStock
                            ? t.product.inStock
                            : t.product.outOfStock,
                        style: AppTypography.labelSmall.copyWith(
                          color: product.inStock
                              ? AppColors.success
                              : AppColors.error,
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
                        _NutritionRow(
                          label: t.product.calories,
                          value: product.nutritionFacts!.calories,
                        ),
                        _NutritionRow(
                          label: t.product.protein,
                          value: product.nutritionFacts!.protein,
                        ),
                        _NutritionRow(
                          label: t.product.fiber,
                          value: product.nutritionFacts!.fiber,
                        ),
                        _NutritionRow(
                          label: t.product.vitamins,
                          value: product.nutritionFacts!.vitamins,
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
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
              icon: Icons.shopping_bag_outlined,
              onPressed: product.inStock
                  ? () {
                      context.read<CartBloc>().add(CartItemAdded(product));
                      context.showSnackBar(t.product.added);
                    }
                  : null,
              width: double.infinity,
            ),
          ),
        ),
      ],
    );
  }
}

class _NutritionRow extends StatelessWidget {
  const _NutritionRow({required this.label, this.value});

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.bodyMedium),
          Text(
            value!,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}
