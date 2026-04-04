import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/harvest_button.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/orders/presentation/widgets/order_status_utils.dart';
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class OrderStatusSection extends StatelessWidget {
  const OrderStatusSection({required this.status, super.key});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: status.color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(status.icon, size: 20, color: status.color),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.orders.details.status, style: AppTypography.bodySmall),
                const SizedBox(height: 4),
                Text(
                  status.label,
                  style: AppTypography.titleMedium.copyWith(
                    color: status.color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItemsSection extends StatelessWidget {
  const OrderItemsSection({required this.items, super.key});

  final List<OrderItemEntity> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.orders.details.items, style: AppTypography.titleMedium),
          const SizedBox(height: 12),
          ...items.map(_buildItem),
        ],
      ),
    );
  }

  Widget _buildItem(OrderItemEntity item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: FaIcon(
                FontAwesomeIcons.leaf,
                size: 16,
                color: AppColors.primaryLight,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name, style: AppTypography.bodyMedium),
                Text(
                  '${item.quantity} × ${CurrencyFormatter.format(item.price)}/${item.unit}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.format(item.totalPrice),
            style: AppTypography.priceMedium,
          ),
        ],
      ),
    );
  }
}

class OrderAddressSection extends StatelessWidget {
  const OrderAddressSection({required this.address, super.key});

  final DeliveryAddress address;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            t.orders.details.deliveryAddress,
            style: AppTypography.titleMedium,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const FaIcon(
                FontAwesomeIcons.locationDot,
                size: 14,
                color: AppColors.onBackgroundLight,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${address.street}, ${address.city} - ${address.zipCode}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.onBackgroundLight,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderSummarySection extends StatelessWidget {
  const OrderSummarySection({
    required this.order,
    required this.dateFormat,
    super.key,
  });

  final OrderEntity order;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.orders.placedOn(date: dateFormat.format(order.createdAt)),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onBackgroundLight,
                ),
              ),
              Text(
                t.orders.items(count: order.itemCount.toString()),
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.onBackgroundLight,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.cart.total, style: AppTypography.titleMedium),
              Text(
                CurrencyFormatter.format(order.totalAmount),
                style: AppTypography.priceLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderCancelSection extends StatelessWidget {
  const OrderCancelSection({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return HarvestButton(
      label: t.orders.details.cancelOrder,
      onPressed: () => _showCancelDialog(context),
      isOutlined: true,
      width: double.infinity,
    );
  }

  Future<void> _showCancelDialog(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.orders.details.cancelOrder),
        content: Text(t.orders.details.cancelConfirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(t.general.back),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(t.general.confirm),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.read<OrdersBloc>().add(OrderCancelRequested(orderId: orderId));
      context.pop();
    }
  }
}
