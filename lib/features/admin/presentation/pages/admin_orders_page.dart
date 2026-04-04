import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_orders_cubit.dart';
import 'package:harvest/features/admin/presentation/cubit/admin_orders_state.dart';
import 'package:harvest/features/admin/presentation/widgets/animated_list_item.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/presentation/widgets/order_status_utils.dart';
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final cubit = sl<AdminOrdersCubit>();
        unawaited(cubit.loadOrders());
        return cubit;
      },
      child: const _AdminOrdersView(),
    );
  }
}

class _AdminOrdersView extends StatelessWidget {
  const _AdminOrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<AdminOrdersCubit, AdminOrdersState>(
        builder: (context, state) {
          if (state.status == AdminOrdersStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state.status == AdminOrdersStatus.error) {
            return Center(child: Text(state.errorMessage ?? ''));
          }
          if (state.orders.isEmpty) {
            return Center(child: Text(t.admin.noOrders));
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: state.orders.length,
            itemBuilder: (context, index) {
              final order = state.orders[index];
              return AnimatedListItem(
                index: index,
                child: _AdminOrderCard(order: order),
              );
            },
          );
        },
      ),
    );
  }
}

class _AdminOrderCard extends StatelessWidget {
  const _AdminOrderCard({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  t.orders.orderNumber(
                    number: order.id.substring(0, 8).toUpperCase(),
                  ),
                  style: AppTypography.titleMedium,
                ),
                Text(
                  CurrencyFormatter.format(order.totalAmount),
                  style: AppTypography.priceMedium,
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${t.admin.customer}: ${order.userId.substring(0, 8)}...'
              ' · ${t.orders.items(count: order.itemCount.toString())}',
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onBackgroundLight,
              ),
            ),
            Text(
              t.orders.placedOn(date: dateFormat.format(order.createdAt)),
              style: AppTypography.bodySmall.copyWith(
                color: AppColors.onBackgroundLight,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _StatusDropdown(order: order)),
                const SizedBox(width: 8),
                if (order.status != OrderStatus.cancelled &&
                    order.status != OrderStatus.delivered)
                  IconButton(
                    icon: const FaIcon(
                      FontAwesomeIcons.ban,
                      size: 16,
                      color: AppColors.error,
                    ),
                    tooltip: t.admin.cancelOrder,
                    onPressed: () => _confirmCancel(context, order.id),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmCancel(BuildContext context, String orderId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.admin.cancelOrder),
        content: Text(t.admin.cancelOrderConfirmation),
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
      unawaited(
        context.read<AdminOrdersCubit>().updateOrderStatus(
          orderId,
          OrderStatus.cancelled,
        ),
      );
    }
  }
}

class _StatusDropdown extends StatelessWidget {
  const _StatusDropdown({required this.order});

  final OrderEntity order;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<OrderStatus>(
      initialValue: order.status,
      decoration: InputDecoration(
        labelText: t.admin.changeStatus,
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        isDense: true,
      ),
      items: OrderStatus.values
          .map(
            (status) => DropdownMenuItem(
              value: status,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: status.color,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(status.label),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (newStatus) {
        if (newStatus != null && newStatus != order.status) {
          unawaited(
            context.read<AdminOrdersCubit>().updateOrderStatus(
              order.id,
              newStatus,
            ),
          );
        }
      },
    );
  }
}
