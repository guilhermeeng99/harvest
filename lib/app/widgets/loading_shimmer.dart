import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:shimmer/shimmer.dart';

class LoadingShimmer extends StatelessWidget {
  const LoadingShimmer({
    this.width,
    this.height,
    this.borderRadius = 8,
    super.key,
  });

  const LoadingShimmer.card({super.key})
    : width = double.infinity,
      height = 200,
      borderRadius = 16;

  const LoadingShimmer.text({super.key})
    : width = 120,
      height = 16,
      borderRadius = 4;

  final double? width;
  final double? height;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.shimmerBase,
      highlightColor: AppColors.shimmerHighlight,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120,
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 14,
                    width: double.infinity,
                    color: AppColors.surface,
                  ),
                  const SizedBox(height: 8),
                  Container(height: 12, width: 80, color: AppColors.surface),
                  const SizedBox(height: 8),
                  Container(height: 14, width: 60, color: AppColors.surface),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
