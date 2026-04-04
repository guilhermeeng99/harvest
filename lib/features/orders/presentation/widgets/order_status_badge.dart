import 'package:flutter/material.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/presentation/widgets/order_status_utils.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: status.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.label,
        style: AppTypography.labelSmall.copyWith(color: status.color),
      ),
    );
  }
}
