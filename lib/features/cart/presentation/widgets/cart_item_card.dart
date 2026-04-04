import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/quantity_selector.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/cart/domain/entities/cart_item_entity.dart';

class CartItemCard extends StatelessWidget {
  const CartItemCard({
    required this.item,
    required this.onDismissed,
    required this.onTap,
    required this.onIncrement,
    required this.onDecrement,
    super.key,
  });

  final CartItemEntity item;
  final VoidCallback onDismissed;
  final VoidCallback onTap;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(item.product.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
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
      child: GestureDetector(
        onTap: onTap,
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
                min: 0,
                onIncrement: onIncrement,
                onDecrement: onDecrement,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
