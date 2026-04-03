import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.name,
    required this.price,
    required this.unit,
    required this.imageUrl,
    required this.farmName,
    required this.onTap,
    this.onAddToCart,
    this.isOrganic = false,
    super.key,
  });

  final String name;
  final double price;
  final String unit;
  final String imageUrl;
  final String farmName;
  final VoidCallback onTap;
  final VoidCallback? onAddToCart;
  final bool isOrganic;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.divider),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ImageSection(imageUrl: imageUrl, isOrganic: isOrganic),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTypography.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      farmName,
                      style: AppTypography.bodySmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '\$${price.toStringAsFixed(2)}/$unit',
                            style: AppTypography.priceSmall,
                          ),
                        ),
                        if (onAddToCart != null)
                          _AddButton(onPressed: onAddToCart!),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ImageSection extends StatelessWidget {
  const _ImageSection({required this.imageUrl, required this.isOrganic});

  final String imageUrl;
  final bool isOrganic;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: AspectRatio(
            aspectRatio: 1.2,
            child: CachedNetworkImage(
              imageUrl: imageUrl,
              fit: BoxFit.cover,
              placeholder: (_, __) => const ColoredBox(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.eco_outlined,
                    color: AppColors.onBackgroundLight,
                    size: 32,
                  ),
                ),
              ),
              errorWidget: (_, __, ___) => const ColoredBox(
                color: AppColors.surfaceVariant,
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: AppColors.onBackgroundLight,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (isOrganic)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.success,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Organic',
                style: AppTypography.labelSmall.copyWith(
                  color: AppColors.onPrimary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AddButton extends StatelessWidget {
  const _AddButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      width: 32,
      child: IconButton.filled(
        onPressed: onPressed,
        icon: const Icon(Icons.add, size: 16),
        style: IconButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
          padding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
