import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:harvest/app/theme/app_colors.dart';
import 'package:harvest/features/checkout/domain/entities/order_entity.dart';
import 'package:harvest/features/orders/presentation/bloc/orders_bloc.dart';
import 'package:harvest/features/orders/presentation/widgets/order_detail_sections.dart';
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
          OrderStatusSection(status: order.status),
          const SizedBox(height: 20),
          OrderItemsSection(items: order.items),
          const SizedBox(height: 20),
          OrderAddressSection(address: order.deliveryAddress),
          const SizedBox(height: 20),
          OrderSummarySection(order: order, dateFormat: dateFormat),
          if (order.status == OrderStatus.pending) ...[
            const SizedBox(height: 24),
            OrderCancelSection(orderId: order.id),
          ],
        ],
      ),
    );
  }
}
