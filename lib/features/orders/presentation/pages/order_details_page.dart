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
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class OrderDetailsPage extends StatelessWidget {
  const OrderDetailsPage({required this.orderId, super.key});

  final String orderId;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        final order = state.orders.cast<OrderEntity?>().firstWhere(
              (o) => o?.id == orderId,
              orElse: () => null,
            );

        if (order == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(),
            body: Center(child: Text(t.general.error)),
          );
        }

        return _OrderDetailsView(order: order);
      },
    );
  }
}

class _OrderDetailsView extends StatelessWidget {
  const _OrderDetailsView({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          t.orders.orderNumber(
            number: order.id.substring(0, 8).toUpperCase(),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const FaIcon(FontAwesomeIcons.arrowLeft, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _StatusSection(order: order),
          const SizedBox(height: 20),
          _ItemsSection(items: order.items),
          const SizedBox(height: 20),
          _AddressSection(address: order.deliveryAddress),
          const SizedBox(height: 20),
          _SummarySection(order: order, dateFormat: dateFormat),
          if (order.status == OrderStatus.pending) ...[
            const SizedBox(height: 24),
            _CancelSection(orderId: order.id),
          ],
        ],
      ),
    );
  }
}

class _StatusSection extends StatelessWidget {
  const _StatusSection({required this.order});

  final OrderEntity order;

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
              color: _statusColor.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: FaIcon(_statusIcon, size: 20, color: _statusColor),
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
                  _statusLabel,
                  style: AppTypography.titleMedium.copyWith(
                    color: _statusColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color get _statusColor {
    return switch (order.status) {
      OrderStatus.pending => AppColors.warning,
      OrderStatus.confirmed => AppColors.primaryLight,
      OrderStatus.harvesting => AppColors.primary,
      OrderStatus.delivering => AppColors.secondary,
      OrderStatus.delivered => AppColors.success,
      OrderStatus.cancelled => AppColors.error,
    };
  }

  FaIconData get _statusIcon {
    return switch (order.status) {
      OrderStatus.pending => FontAwesomeIcons.clock,
      OrderStatus.confirmed => FontAwesomeIcons.circleCheck,
      OrderStatus.harvesting => FontAwesomeIcons.seedling,
      OrderStatus.delivering => FontAwesomeIcons.truck,
      OrderStatus.delivered => FontAwesomeIcons.check,
      OrderStatus.cancelled => FontAwesomeIcons.ban,
    };
  }

  String get _statusLabel {
    return switch (order.status) {
      OrderStatus.pending => t.orders.status.pending,
      OrderStatus.confirmed => t.orders.status.confirmed,
      OrderStatus.harvesting => t.orders.status.harvesting,
      OrderStatus.delivering => t.orders.status.delivering,
      OrderStatus.delivered => t.orders.status.delivered,
      OrderStatus.cancelled => t.orders.status.cancelled,
    };
  }
}

class _ItemsSection extends StatelessWidget {
  const _ItemsSection({required this.items});

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

class _AddressSection extends StatelessWidget {
  const _AddressSection({required this.address});

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

class _SummarySection extends StatelessWidget {
  const _SummarySection({
    required this.order,
    required this.dateFormat,
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

class _CancelSection extends StatelessWidget {
  const _CancelSection({required this.orderId});

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
      context
          .read<OrdersBloc>()
          .add(OrderCancelRequested(orderId: orderId));
      context.pop();
    }
  }
}
