import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/di/injection_container.dart';
import 'package:harvest/app/routes/app_routes.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/app/theme/app_typography.dart';
import 'package:harvest/app/widgets/error_view.dart';
import 'package:harvest/app/widgets/loading_shimmer.dart';
import 'package:harvest/core/utils/currency_formatter.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/gen/i18n/strings.g.dart';
import 'package:intl/intl.dart';

class OrdersPage extends StatelessWidget {
  const OrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<OrdersBloc>()..add(const OrdersLoadRequested()),
      child: const _OrdersView(),
    );
  }
}

class _OrdersView extends StatelessWidget {
  const _OrdersView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: Text(t.orders.title), centerTitle: true),
      body: BlocBuilder<OrdersBloc, OrdersState>(
        builder: (context, state) {
          if (state.status == OrdersStatus.loading) {
            return const _LoadingList();
          }
          if (state.status == OrdersStatus.error) {
            return ErrorView(
              message: state.errorMessage ?? t.general.error,
              onRetry: () =>
                  context.read<OrdersBloc>().add(const OrdersLoadRequested()),
            );
          }
          if (state.orders.isEmpty) {
            return const _EmptyOrders();
          }
          return _OrdersList(orders: state.orders);
        },
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const FaIcon(
            FontAwesomeIcons.receipt,
            size: 64,
            color: AppColors.onBackgroundLight,
          ),
          const SizedBox(height: 16),
          Text(t.orders.empty, style: AppTypography.headlineSmall),
          const SizedBox(height: 8),
          Text(
            t.orders.emptySubtitle,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrdersList extends StatelessWidget {
  const _OrdersList({required this.orders});

  final List<OrderEntity> orders;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: orders.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, index) => _OrderCard(
        order: orders[index],
        onTap: () => context.push(
          AppRoutes.orderDetailsPath(orders[index].id),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order, required this.onTap});

  final OrderEntity order;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();
    return GestureDetector(
      onTap: onTap,
      child: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
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
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            t.orders.items(count: order.itemCount.toString()),
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            t.orders.placedOn(date: dateFormat.format(order.createdAt)),
            style: AppTypography.bodySmall.copyWith(
              color: AppColors.onBackgroundLight,
            ),
          ),
          const Divider(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(t.cart.total, style: AppTypography.bodyMedium),
              Text(
                CurrencyFormatter.format(order.totalAmount),
                style: AppTypography.priceMedium,
              ),
            ],
          ),
        ],
      ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final OrderStatus status;

  Color get _color {
    return switch (status) {
      OrderStatus.pending => AppColors.warning,
      OrderStatus.confirmed => AppColors.primaryLight,
      OrderStatus.harvesting => AppColors.primary,
      OrderStatus.delivering => AppColors.secondary,
      OrderStatus.delivered => AppColors.success,
      OrderStatus.cancelled => AppColors.error,
    };
  }

  String get _label {
    return switch (status) {
      OrderStatus.pending => t.orders.status.pending,
      OrderStatus.confirmed => t.orders.status.confirmed,
      OrderStatus.harvesting => t.orders.status.harvesting,
      OrderStatus.delivering => t.orders.status.delivering,
      OrderStatus.delivered => t.orders.status.delivered,
      OrderStatus.cancelled => t.orders.status.cancelled,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        _label,
        style: AppTypography.labelSmall.copyWith(color: _color),
      ),
    );
  }
}

class _LoadingList extends StatelessWidget {
  const _LoadingList();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 3,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (_, _) =>
          const LoadingShimmer(height: 140, borderRadius: 12),
    );
  }
}
